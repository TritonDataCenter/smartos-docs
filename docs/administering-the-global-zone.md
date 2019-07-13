# Administering the Global Zone

SmartOS is a 100% Live OS. Whether you boot it from an ISO image, USB
Key, or netboot (PXE) image, you are essentially loading the OS into
memory and running it off a ramdisk. During initial setup, the OS
creates a Zpool for persistent storage, but not all of the OS is
persistent.

In this topic, you will learn about the advantages of a "diskless"
architecture, what is and is not persistent in SmartOS, and how to
manage the global zone.

See [this topic](zones.md) for a breakdown of the global zone
and non-global zones in SmartOS.

## Why Diskless Booting is Good

This video explains why and how SmartOS boots from a USB thumb drive.

This video was originally produced for Joyent's SmartDataCenter product.
References to things such as "headnode", "computenode", or authentication
against APIs do not apply.

[VIDEO: Discussion about diskless booting in SmartOS between Bryan Cantrill
and Josh Wilsdon of Joyent](http://www.youtube.com/watch?v=ieGWbo94geE)

## Global Zone Persistence

Diskless booting of a hypervisor provides many advantages but enforces
contraints on customization and management of the global zone. For
example, changes you make in some key root file systems, such as `/etc`
and `/usr`, will not persist across reboots. The default file system
configuration will look like the following (pseudo-filesystems removed
for clarity):

    [root@78-2b-cb-47-af-7d ~]# df -h
    Filesystem             size   used  avail capacity  Mounted on
    /devices/ramdisk:a     264M   217M    48M    82%    /
    /devices/pseudo/lofi@0:1
                           376M   340M    36M    91%    /usr
    zones/var              3.2T    31M   2.7T     1%    /var
    zones/opt              3.2T    55M   2.7T     1%    /opt
    zones/config           3.2T    54K   2.7T     1%    /etc/zones
    zones/usbkey           3.2T   129K   2.7T     1%    /usbkey
    /usbkey/ssh            2.7T   129K   2.7T     1%    /etc/ssh
    /usbkey/shadow         2.7T   129K   2.7T     1%    /etc/shadow

The configuration breaks down in the following way:

- `/`: The root filesystem is a ramdisk which you should write to
  sparingly under normal circumstances. All files written here
  are non-persistant. This includes `/root` (the root user
  home directory) and `/etc` with exception (see below).
- `/usr`: This filesystem is a loopback filesystem (located in
  `/usr.lgz`) mounted read-only. This includes `/usr/local` which is
  commonly used on other OS's such as Linux (see below).
- `/var`, `/opt`: Both these filesystems are persistant and created on
  the zpool during initial setup. Any data written here is safe.

  Contrary to many Linux distros, `/var/run` is tmpfs but `/var/tmp` is not.
  For temp files you want deleted on reboot, use `/tmp` or `/var/run`.

- `/usbkey`: This filesystem is a persistant configuration which is
  applied on boot. It includes a small configuration file (config), a
  shadow file linked to `/etc/shadow`, and SSH directory linked to `/etc/ssh`.

For a good breakdown of changes you can make in the global zone, see this
[blog post](http://www.perkin.org.uk/posts/smartos-and-the-global-zone.html)
by Jonathan Perkin of Joyent.

## Creating Persistent Services Using SMF

On boot, SMF will look for and load any SMF manifests found in
`/opt/custom/smf`. This is the primary way by which you can introduce
persistent customization to SmartOS. While we will not provide a
complete SMF tutorial here, lets review the basics to get you started.

The Service Management Facility (SMF) is an init replacement for
managing userland processes after the OS kernel boots. SMF manages these
processes as **services**, creating **contracts** with them, and will
restart them in the event that they terminate unexpectedly. SMF services
are described in XML **manifests** which describe service dependencies,
metadata, and contain **methods** to start, stop and restart the
service. A method is a program or script which forks long running
processes which will be managed by SMF. Services which do not spawn
long-running processes are known as *transient services*. For instance,
an SMF Service that would set the system hostname would be a "transient
service" which executes a start method script which contains the
"hostname somename.domain.com" command.

### Creating a Transient Service

Transient SMF services are particularly useful on SmartOS as a way to
simplify customization.

The following is an example of a transient SMF manifest that you would
place in `/opt/custom/smf` to do basic customization:

<!-- markdownlint-disable line-length -->

    <?xml version='1.0'?>
    <!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.dtd.1'>
    <service_bundle type='manifest' name='export'>
      <service name='smartos/setup' type='service' version='0'>
        <create_default_instance enabled='true'/>
        <single_instance/>
        <dependency name='net-physical' grouping='require_all' restart_on='none' type='service'>
          <service_fmri value='svc:/network/physical'/>
        </dependency>
        <dependency name='filesystem' grouping='require_all' restart_on='none' type='service'>
          <service_fmri value='svc:/system/filesystem/local'/>
        </dependency>
        <exec_method name='start' type='method' exec='/opt/custom/share/svc/smartos_setup.sh %m' timeout_seconds='0'/>
        <exec_method name='stop' type='method' exec='/opt/custom/share/svc/smartos_setup.sh %m' timeout_seconds='60'/>
        <property_group name='startd' type='framework'>
          <propval name='duration' type='astring' value='transient'/>
        </property_group>
        <stability value='Unstable'/>
        <template>
          <common_name>
            <loctext xml:lang='C'>SmartOS Ad Hoc Setup Script</loctext>
          </common_name>
        </template>
      </service>
    </service_bundle>

<!-- markdownlint-enable line-length -->

Walking briefly through this XML:

1. Starts by defining a service named "smartos/setup". This service is
   dependent on the "network/physical" and "filesystem/local" services.
   This means it will not execute until networking is setup and
   filesystems are mounted.
2. The "start" and "stop" methods are scripts which pass the method
   name "start" or "stop" as an argument.
3. The "transient" duration property is defined indicating that this
   service will execute and terminate and should not
   restart automatically.
4. Finally, the manifest specifies the common name of the service and
   notes its stability as "unstable".
   This has no real meaning, its simply an old convention indicating it
   may change in the future.

The method scripts that would correspond to the above manifest might
look like this:

    #!/bin/bash
    # Simple Ad Hoc SmartOS Setup Service

    set -o xtrace

    . /lib/svc/share/smf_include.sh

    cd /
    PATH=/usr/sbin:/usr/bin:/opt/custom/bin:/opt/custom/sbin; export PATH

    case "$1" in
    'start')
        #### Insert code to execute on startup here.
        hostname "smartos01" && hostname > /etc/nodename
        ;;
    'stop')
        ### Insert code to execute on shutdown here.
        ;;
    *)
        echo "Usage: $0 { start | stop }"
        exit $SMF_EXIT_ERR_FATAL
        ;;
    esac
    exit $SMF_EXIT_OK

You may recognize the above script as very similar to a traditional init
script, it simply includes some SMF conventions.

If you added the above manifest to `/opt/custom/smf`, the method script
would execute on each system boot. Simply adding all customization into
a script like this and executing it on boot through an SMF transient
service is the simplest and most straight forward way to add persistent
configuration to your SmartOS system.

### Creating an SMF Service

A traditional SMF service will execute a **method** which forks long
running processes. A common SmartOS global zone example would be a
monitoring agent. For more detailed information regarding SMF in
general, please refer to the
["Using the Service Management Facility" section][basic-smf].

[basic-smf]: basic-smf-commands.md

## Using Configuration Management

While system configuration can be accomplished by means of several SMF
services, it is recommended that a configuration management (CM) tool,
such as [CFengine](http://cfengine.com/),
[Puppet](http://puppetlabs.com/) or [Chef](http://opscode.com) is
utilized instead. This greatly simplifies system management, as a single
SMF can be added to execute your CM tool which then handles the rest of
the setup itself.

Configuration Management is strongly encouraged! For additional details
on the tool of your choice please refer to the
[Configuration Management on SmartOS][smartos-cfgman] section.

[smartos-cfgman]: configuration-management-on-smartos.md
