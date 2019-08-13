# PXE Booting SmartOS

While USB and DVD installation are useful for small or non-production
deployments, SmartOS is fundamentally designed as a netboot operating
system. Advantages of netbooting include:

- **Scalability**: Media (USB or CD/DVD) is not required for each node
- **Speed**: Boot times on a 1Gb/s network (100MB/s) are much faster
    than USB 2.0 (10-30MB/s depending on USB key) or optical media
- **Versatility & Safety**: Clients can be upgraded easily by simply
    changing the boot target to the new image and rebooting at your
    leasure into the new image, rather than re-flashing a USB key in
    place which could leave you stranded on a bad upgrade. This applies
    equally to upgrades and downgrades.

## The NetBoot Environment

### Adding SmartOS Images to an Existing PXE Environment

If you already have a DHCP/TFTP environment in place for netbooting, you
can simply download the latest platform release and unpack it into your
TFTP directory.

There are 2 files of importance, the kernel (`unix`) and the boot
archive (`boot_archive`). The paths to these files are significant and
should not be omitted. They should be:

- *(prefix)*/platform/i86pc/kernel/amd64/unix
- *(prefix)*/platform/i86pc/amd64/boot\_archive

The prefix may be anything you wish (a common prefix would be
"/tftpboot/smartos/20121004T212912Z/") but the path after the prefix
must be in the form above. If you do not the OS will fail to boot with
an error saying "krtld: error during initial load/link phase"; in this
case the image make sure your path is in the proper form. The important
point being, don't just untar the latest platform image into your TFTP
directory and boot it, you'll have problems unless you change the
typical "platform\_20121004T212912Z/" to simply "platform/".

For details on the boot parameters you may wish to pass to the kernel,
see below.

### Building an iPXE Boot Infrastructure

Want to create a netboot environment from scratch? No problem! Which OS
you use isn't very important, you can use SmartOS is you really want to,
but any Linux distro will do, we might even suggest considering
[OmniOS](http://omnios.omniti.com/) as a general purpose server to
supply your networks various needs. What is important is that your boot
server have the following:

- A DHCP Server. We recommend ISC DHCP.
- A TFTP Server.
- iPXE. (If you wish to use PXEGRUB directly see the appropriate
  section below.)

We will not discuss each of these indepth, nor how to install them on
your selected platform. We'll focus on the important points of using
each for booting SmartOS.

Before we get into the guts, lets just recap for those new to
netbooting. Remove bootp and all those other protocols you won't notice. 
When you boot your server and
tell it to PXE/Network boot, it will send a DHCP request which the
server will answer and it will include two special things: a
"next-server" and filename. The "next-server" is your TFTP server and
filename is the file your server will download and run. That
file is usually a bootloader such as Syslinux or GRUB (more correctly,
the PXE variations of them: pxelinux or pxegrub). In our case the file
will be the iPXE program named "undionly.kpxe". iPXE can execute scripts
and do other net things your normal PXE client on your network card
can't. We will use it to actually boot SmartOS which will involve
downloading and booting the SmartOS kernel and archive from the TFTP/HTTP
server.

#### ISC DHCP

There are many tutorials on the net about configuring ISC DHCP, but the
important part is allowing it to execute iPXE correctly. You'll want to
create a DHCP pool that looks similar to the following:

    subnet 10.99.99.0 netmask 255.255.255.0 {
     pool {
      range 10.99.99.210 10.99.99.219;
      next-server 10.99.99.250;
      if exists user-class and option user-class = "iPXE" {
            filename "menu.ipxe";
      } else {
            filename "undionly.kpxe";
      }
     }
    }

The above example we're giving out addresses on the 10.99.99.0/24
subnet. The TFTP server is also located on the same host as our DHCP
server so we specify it as the "next-server". The conditional here is to
ensure that the client first boots iPXE. Once iPXE is running it will
DHCP again and this time the user-class will be set as "iPXE", in which
case we instead set our filename to an IPXE script which will take over.

DHCP support requires special NIC configuration as documented
in [Managing NICs - DHCPSupport](managing-nics.md#ManagingNICs-DHCPSupport).

#### TFTP

Again, there are many TFTP tutorials on the net for various platforms.
We'll assume that your TFTP root directory is **/tftpboot**. Within that
directory, install iPXE and create a "smartos/" directory.

You can download a binary distribution of iPXE here:
[undionly.kpxe](http://boot.ipxe.org/undionly.kpxe).
To use it, copy to `/tftpboot`.

To install a SmartOS release:

1. Download the latest "platform-\*" build
2. Unpack it in `/tftboot/smartos/`
3. Rename the "platform-(buildnumber)" directory to just the build
   number
4. Enter the build directory from the previous step, *mkdir platform*
   and *mv i86pc platform*.

When the above is done properly your kernel will be in (for example)
`/tftpboot/smartos/20121004T212912Z/platform/i86pc/kernel/amd64/unix`
and your boot archive will be in
`/tftpboot/smartos/20121004T212912Z/platform/i86pc/amd64/boot_archive`.
This is very important; the kernel and archive must contain the path
"/platform/i86pc/kernel/amd64/unix", if you don't the PXE boot will fail
with an ugly error message saying "krtld: error during initial load/link
phase"

#### iPXE

[iPXE](http://ipxe.org) is the all powerful open source PXE client. It
can download images from HTTP as well as TFTP, it can boot from iSCSI,
FCoE, and AoE, over wireless, WAN, and infiniband networks, but most
importantly it can execute scripts and act as its own bootloader which
is what we'll use it for. If you've never heard of iPXE before, it began
life as the Etherboot project, then became gPXE and after a squabble it
was forked to become iPXE. The idea of using PXE to load a PXE client
might seem odd at first, but the PXE client burned into your NIC is
small and dumb, iPXE is very smart. It can be burned into your NIC's
ROM, loaded from USB or ISO, etc, but we'll use our servers native PXE
to load iPXE and then let it do the heavy lifting.

In previous steps we put iPXE ("undionly.kpxe") in our /tftpboot
directory, added a SmartOS image and configured DHCP to use it. Now we
simply create the iPXE script we referenced earlier to actually boot it.

The simplest possible iPXE script would look like this:

    #!ipxe

    kernel /smartos/20121004T212912Z/platform/i86pc/kernel/amd64/unix -B smartos=true
    initrd /smartos/20121004T212912Z/platform/i86pc/amd64/boot_archive
    boot

... but this is iPXE and SmartOS, so lets make it more interesting by
using a boot menu!

    #!ipxe

    set smartos-build 20121004T212912Z

    ######## MAIN MENU ###################
    :start
    menu Welcome to iPXE's Boot Menu
    item
    item --gap -- ------------------------- Operating systems ------------------------------
    item smartos    Boot SmartOS (${smartos-build})
    item --gap -- ------------------------------ Utilities ---------------------------------
    item shell      Enter iPXE shell
    item reboot     Reboot
    item
    item exit       Exit (boot local disk)
    choose --default smartos --timeout 30000 target && goto ${target}


    ########## UTILITY ITEMS ####################
    :shell
    echo Type exit to get the back to the menu
    shell
    set menu-timeout 0
    goto start

    :reboot
    reboot

    :exit
    exit

    ########## MENU ITEMS #######################
    # SmartOS Root shadow is "root"
    :smartos
    kernel /smartos/${smartos-build}/platform/i86pc/kernel/amd64/unix -B smartos=true,root_shadow='$5$2HOHRnK3$NvLlm.1KQBbB0WjoP7xcIwGnllhzp2HnT.mDO7DpxYA'
    initrd /smartos/${smartos-build}/platform/i86pc/amd64/boot_archive
    boot
    goto start

The configuration above is just a taste of what you can do here. You
could add variations of SmartOS that use ttya or ttyb for serial
redirection, load KMDB, etc. Learn more about iPXE menus in the
[iPXE Command Documentation](http://ipxe.org/cmd/menu), and learn about the
various kernel options below.

As a side benefit, you now have an excellent platform for netbooting a
variety of OS's in a variety of configurations. If you want maximum l337
points, use iPXE SAN Boot to boot a SmartOS ISO on iSCSI served up by a
COMSTAR iSCSI target on ZFS!

## Kernel Boot Options

Several parameters can and should be passed to the "unix" kernel. These
would be comma-delimited following "-B", as seen in examples above.

- `smartos=`: If set true and `/usbkey/shadow` is present, it will
  use the root password within `/usbkey/shadow`
- `root_shadow=`: A root password hash as would be found
  in /etc/shadow. If present, and "smartos=" is not present, this will
  override the default platform password in `/usbkey/shadow`
- `hostname=`: Set the hostname
- `noimport=true`: Don't import the Zpool
- `standalone=true`: *Used only by Smart Data Center*
- `headnode=true`: *Used only by Smart Data Center*

Other options to know about are:

- `console=ttya,ttya-mode="115200,8,n,1,-"`: Console redirection to
  ttya (COM1)
- `console=ttyb,ttyb-mode="115200,8,n,1,-"`: Console redirection to
  ttyb (COM2)
- `console=text`: Console is directed to local keyboard
  and monitoring. This is the default behavior.
- `-kd`: Enable the Kernel Debugger (KMDB); this is typically only
  used for debugging drivers
- `-v`: Verbose boot

## Alternatives

### Stripped down dnsmasq, tftp-hpa, pxegrub

The example code in this section uses a very old image and hasn't been tes
ted in a while. If you end up using this section as a guide, try using a
 modern image. If you succeed, please update the `image_uuid`.

### Motivation

So you have a machine running SmartOS from a USB stick or CD.
Wouldn't it be nice to be able to use that machine to PXE boot a whole
additional rack of machines?
Here's how to set up a simple PXE server in a SmartOS zone that will
serve up... SmartOS!

This section assumes some basics covered in other wiki pages.

### Zone Configuration

    {
      "alias": "pxe-server",
      "hostname": "pxe-server",
      "brand": "joyent",
      "max_physical_memory": 64,
      "quota": 2,
      "image_uuid": "f9e4be48-9466-11e1-bc41-9f993f5dff36",
      "nics": [
        {
          "nic_tag": "admin",
          "ip": "172.16.0.2",
          "netmask": "255.255.255.0",
          "gateway": "172.16.0.1",
          "dhcp_server": "1"
        }
      ]
    }

It's up to you to get the networking right, and not to run multiple DHCP s
ervers on your network in a way that breaks things. BE CAREFUL!

### Setting up TFTP

Use zlogin to log into the zone:

    zlogin <uuid>

In the zone:

    pkgin -y install tftp-hpa
    mkdir /tftpboot
    echo "tftp dgram udp wait root /opt/local/sbin/in.tftpd in.tftpd -s /tft
    pboot" > /tmp/tftp.inetd
    svcadm enable inetd
    inetconv -i /tmp/tftp.inetd -o /tmp
    svccfg import /tmp/tftp-udp.xml
    svcadm restart tftp/udp

The last two commands are probably extraneous.

### Setting up DHCP (using Dnsmasq)

    pkgin -y install dnsmasq

Hereis an example `/opt/local/etc/dnsmasq.conf`.  It's up to you to get
the networking right, and not to run multiple DHCP servers on your network
in a way that breaks things. BE CAREFUL!

    #Lease File to track leases
    dhcp-leasefile=/etc/dnsmasq.leases
    # Give out addresses in the 172.16.0.1/24 subnet
    dhcp-range=172.16.0.10,172.16.0.50,2h
    # The name of the boot file is pxegrub
    dhcp-boot=pxegrub

Then enable the service.

    svcadm enable dnsmasq

### Setting up the tftpboot directory

(Use the pkgsrc wget which can actually validate certificates)

    pkgin -y install wget
    hash -r
    cd /tftpboot
    wget https://download.joyent.com/pub/iso/latest.iso
    LOFI=$(lofiadm -a latest.iso)
    mount -F hsfs $LOFI /mnt
    rsync -av /mnt/ .
    umount /mnt
    lofiadm -d $LOFI
    wget -O pxegrub http://aszeszo.googlepages.com/pxegrub

### Integrating SmartOS into an existing PXELINUX environment

The critical detail to know about booting SmartOS from PXELINUX (or
SYSLINUX) is that you must use `mboot.c32` to get them to load the
kernel and `boot_archive` using the multiboot specification.
See [here](http://syslinux.zytor.com/wiki/index.php/Mboot.c32) for further
details about that.

Recent versions of SYSLINUX require `libcom32.c32` and `ldlinux.c32`
to be present to use `mboot.c32`

Instructions:

1. [Download the image](download-smartos.md)
1. Extract the entire `platform` subtree from the ISO.
1. Download a tarball of
   [syslinux](http://syslinux.zytor.com/wiki/index.php/Download) and get
   the `mboot.c32`, `libcom32.c32`, and `ldlinux.c32` files out of it.
1. In the tftp root directory, create a directory named `smartos`
1. Copy the `platform` directory you got from the ISO into the
   `smartos` directory
1. Copy the the `mboot.c32`, `libcom32.c32`, and `ldlinux.c32`
   files into the `smartos` directory
1. Update your `pxelinux.cfg/default` file with this content:

<!-- markdownlint-disable line-length -->

        default smartos
        prompt 1
        timeout 50

        label smartos
        kernel smartos/mboot.c32
        append smartos/platform/i86pc/kernel/amd64/unix -B smartos=true,console=text,root_shadow='$5$2HOHRnK3$NvLlm.1KQBbB0WjoP7xcIwGnllhzp2HnT.mDO7DpxYA' --- smartos/platform/i86pc/amd64/boot_archive

        label smartosrescue
        kernel smartos/mboot.c32
        append smartos/platform/i86pc/kernel/amd64/unix -B smartos=true,console=text,standalone=true,noimport=true,root_shadow='$5$2HOHRnK3$NvLlm.1KQBbB0WjoP7xcIwGnllhzp2HnT.mDO7DpxYA' --- smartos/platform/i86pc/amd64/boot_archive

<!-- markdownlint-enable line-length -->
