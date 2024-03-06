# SmartOS Technical FAQs

<!-- markdownlint-disable no-trailing-punctuation -->

## What's the default username and password?

When the SmartOS Live Image is booted for the first time you will be
prompted to set a root password.  In the event that you boot SmartOS
without importing your Zpool, you will require the default root
password.  When using the noimport=true option, the login is root/root.
Otherwise, the randomly generated root password for each build and can
be found in the `SINGLE_USER_ROOT_PASSWORD.(BUILD_DATE).txt` file
found in the
[standard SmartOS download location](https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/latest.html).

## Where's top?

SmartOS uses `prstat` instead of top; it understands SmartOS better and
has lower overhead. 'prstat -Z' is a popular invocation, although there
are many other command-line options; see the [prstat man
page](http://smartos.org/man/8/prstat) for more details.

## How do I start or stop system services?

SmartOS uses SMF, which has some similarities with OSX's launchd or
Ubuntu's Upstart: it tracks dependencies between services, can
initialize them in parallel, provides logging, and so forth. Here are
some common commands:

- `svcs`: lists enabled services, even if they're not running. To see all
  services use `svcs -a`
- `svcs -vx`: lists services that have failed for some reason, as well as
  the location of their logfiles
- `svcs -Z`: lists services in zones as well
- `svcadm enable <foo>`: start the service named `foo`
- `svcadm disable <foo>`: stop the service named `foo`
- `svcadm restart <foo>`: restart the service named `foo`
- `svcadm clear <foo>`: if a service is in maintenance mode, this clears
  it so it can be enabled
- `svccfg export <foo>`: shows the service manifest in case you're curious
  about what binary is being run and how

## How do I create my own zones or VMs?

[How to create a zone ( OS virtualized machine ) in SmartOS](how-to-create-a-zone.md)

[How to create a KVM VM ( Hypervisor virtualized machine ) in SmartOS](how-to-create-an-hvm-zone.md)

## If I use a USB Key to boot, how can I upgrade SmartOS safely later?

The USB key is just a FAT32 filesystem with grub installed on it. It's a
simple delivery mechanism to get the kernel & boot archive in to memory,
which is why it doesn't matter if you netboot, drop the platform
directory in to your linux partition and add a smartos entry to grub, or
some other third option.

You can just mount the USB key, move platform to platform.old, then drop
in the new platform directory from another build. You can also just drop
in a new platform directory to platform.new ( or platform.date or
whatever ), edit boot/grub/menu.list to point at the right place ( you
can even add new menu entries ) and boot.

<!-- markdownlint-disable line-length -->
## How do I automate setting up hostnames/static networking at deploy-time for Linux datasets?
<!-- markdownlint-enable line-length -->

When using a Linux instance with cloud-init this is handled automatically.

For FreeBSD KVM instances, Qemu handles this for via dhcp. Just set the IP in
the VM json spec.

## Where can I get more questions answered?

`#illumos` and `#smartos` on `irc.libera.chat`.

email: `smartos [at] tritondatacenter [dot] com`
