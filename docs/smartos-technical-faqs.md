# SmartOS Technical FAQs

<!-- markdownlint-disable no-trailing-punctuation -->

## What's the default username and password?

When the SmartOS Live Image is booted for the first time you will be
prompted to set a root password.  In the event that you boot SmartOS
without importing your Zpool, you will require the default root
password.  When using the noimport=true option, the login is root/root.
Otherwise, the randomly generated root password for each build and can
be found in the "SINGLE\_USER\_ROOT\_PASSWORD.(BUILD\_DATE).txt" file
found in the [standard SmartOS download
location](https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/latest.html).

## Where's top?

SmartOS uses 'prstat' instead of top; it understands SmartOS better and
has lower overhead. 'prstat -Z' is a popular invocation, although there
are many other command-line options; see the [prstat man
page](http://www.illumos.org/man/1m/prstat) for more details.

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

## Where's &lt;common tool&gt;?

The current SmartOS release is fairly stripped down. You can add more
goodies using [pkgsrc/pkgin](working-with-packages.md).

## What about AMD support?

You can use SmartOS with zones on AMD Hardware. KVM on AMD is currently
not supported. Bhyve on AMD is supported, but not well tested.

We at Joyent have no plans to add this (for sheer lack of time), but
it's being worked on in the community.

There are [eait-images](http://imgapi.uqcloud.net/builds) with AMD KVM
support.

## If I use a USB Key to boot, how can I upgrade SmartOS safely lat er?

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

## Is it possible to use Joyent's KVM datasets without SmartDataCenter (SDC)?

It is,  but you're likely better off making your own dataset by
following these
[instructions](how-to-create-an-hvm-zone.md)
Without SDC you'll need to restart the vm and login into the guest in
single user mode via grub in order to set the root ssh keys. SDC uses
some 'magic' to setup these ssh keys for its customers.

Once you're happy with this guest VM, halt it, take a zfs snapshot. This
snapshot can then be used as the dataset for future VMs without having
to install the guest OS again. Detailed instructions are
[here](managing-images.md)

(For some newer Joyent-distributed KVM images, you can set root's SSH
authorized keys using `customer_metadata` - see "Passing SSH Keys to the
VM" on [How to create an HVM VM in SmartOS](how-to-create-an-hvm-zone.md).

<!-- markdownlint-disable line-length -->
## How do I automate setting up hostnames/static networking at deploy-time for Linux datasets?
<!-- markdownlint-enable line-length -->

There's no need. Qemu handles this for you via dhcp. Just set the IP in
the VM json spec.

## Where can I get more questions answered?

\#illumos and \#joyent on irc.freenode.net.

email: smartos \[at\] joyent \[dot\] com

Other communications tools coming soon.
