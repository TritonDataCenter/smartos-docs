# Getting Started with SmartOS

**In this section:**

- [Creating a SmartOS Bootable USB Key](Creating%20a%20SmartOS%20Bootable%20USB%20Key.html "Creating a SmartOS Bootable USB Key")
- [PXE Booting SmartOS](PXE%20Booting%20SmartOS.html "PXE Booting SmartOS")
- [SmartOS as a VMware Guest](SmartOS%20as%20a%20VMware%20Guest.html "SmartOS as a VMware G uest")
- [SmartOS Clean Re-install](SmartOS%20Clean%20Re-install.html "SmartOS Clean Re-inst all")
- [SmartOS as a Sandboxed VirtualBox Guest](SmartOS%20as%20a%20Sandboxed%20VirtualBox%20Guest.html "Smart OS as a Sandboxed VirtualBox Guest")

SmartOS is a
[live image](smartos-users-guide.md) distribution of
[Illumos](https://www.illumos.org/),
designed specifically for the purpose of running virtual environments.
The features of SmartOS that make it an attractive option for running
virtual environments lends itself to the way it was designed.
Specifically, you do not install SmartOS in the traditional sense.
Instead, the running system is contained entirely within memory although
you can store some data persistently on disk. Generally, the design of
SmartOS and the benefits it provides breakdown in the following way:

- **Upgrades are trivial:** This means no unnecessary complications
    working with patches. To upgrade a SmartOS release, you just reboot
    into a new image.
- **Increased disk space** No need to use disk space on an OS install.
    All disk space is dedicated to virtual machines and user data.
- **Increased disk performance:** Typically with other systems, you
    install the OS to a pair of mirrored disks and then pool the
    remaining disks for data. With SmartOS, you contain all your disks
    in the same RAIDZ pool, increasing performance.
- **Additional security:** Most of the system files are read-only. In
    addition, `/etc` is re-created on each boot, making it much harder
    to exploit.
- **Increased stability:** With other OSes, system commands become
    dysfunctional once root disks start to fail. This does not happen
    with SmartOS.
- **Purpose built:** Much simpler to install and provision, especially
    when you have a large number of machines.

For details on the benefit of running SmartOS as a live image,
[watch th is video](https://www.youtube.com/watch?v=ieGWbo94geE).

The SmartOS ISO is a bootable CD image containing GRUB, the Illumos
kernel, and the SmartOS boot archive. You can copy the image to any
medium and load it on boot through any multiboot bootloader. This makes
it easy to convert the image into a bootable USB thumbdrive or PXE boot
image. You can even copy `/platform` to your Linux system, add an entry
to the GRUB `menu.lst` file, and dual boot without needing to
repartition.

You ca n find the default single user mode root password for a given release
on the boot media in `/platform/root.password`. The default single user
mode root password changes from release to release. Otherwise the root pas
sword is simply "root".

## System Requirements

The more memory you can dedicate to SmartOS the better due to it running
as a live image:

- A minimum of 1GB of RAM
- 64-bit x86 CPU only

To take advantage of KVM features, SmartOS requires an Intel CPU with
[VT-x extensions](http://en.wikipedia.org/wiki/VT-x#Intel_virtualization_.28VT-x.29)
in the following microarchitectures:

- Nehalem
- Westmere
- Sandy Bridge
- Ivy Bridge

...or later.

SmartOS will run in a virtual machine. However, if nested virtualization is
unavailable, some HVM features will not function.

## Creating a Persistent zpool

Everything on SmartOS is transient due to the nature of it's design.
That is, it does not persist across reboots and any changes made on the
running system are destroyed as soon as the system is no longer running.
This really is not a problem as you typically want changes to your data
to persist, not changes to the running operating system or filesystem
hierarchy.

For this reason, SmartOS includes a dataset setup script that runs
automatically on boot. If you run SmartOS from an alternate form of
media and want the dataset setup script to run on boot, ensure the
following kernel command line option is set:

    smartos=true

If you want to disable the dataset setup script:

    noimport=true

This is not an installer and does not install the live image. The script is
simply for data setup. You will still need to boot from live media.

As a distribution of the Illumos kernel, SmartOS uses
[ZFS](zfs.md) as the filesystem and takes full advantage of all
the inherent features of ZFS including data integrity preservation,
support for snapshots and copy-on-write clones, support for high
capacities, and RAID-Z support.

## Further Reading

[How to create a zone](how-to-create-a-zone.md)
and [How to create an HVM Virtual Machine](how-to-create-an-hvm-vm.md)
give more detail about `vmadm create`.

For detailed information on ZFS and ZFS features, see the
[ZFS Administration Guide](http://download.oracle.com/docs/cd/E19253-01/819-5461/index.html).

### Discussion List

The smartos-discuss list is a forum for useful questions and answers -
see the searchable archives
[here](https://www.listbox.com/member/archive/184463/); sign up
[here](http://smartos.org/smartos-mailing-list/).
