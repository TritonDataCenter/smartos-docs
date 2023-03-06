# Getting Started with SmartOS

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

The SmartOS ISO is a bootable CD image containing, the Illumos
kernel, and the SmartOS boot archive. You can copy the image to any
medium and load it on boot through any multiboot bootloader. This makes
it easy to convert the image into a bootable USB thumbdrive or PXE boot
image.

You can find the default single user mode root password for a given release
on the boot media in `/platform/root.password`. The default single user
mode root password changes from release to release. Otherwise the root
password is simply "root".

## System Requirements

The more memory you can dedicate to SmartOS the better due to it running
as a live image. The SmartOS hypervisor requires:

- A minimum of 1GB of RAM
- 64-bit x86 CPU

All other compute resources available will be used for virtual instances.

To take advantage of hardware virtualization features available in many CPUs,
SmartOS requires an Intel CPU with [VT-x extensions][vtx] or AMD CPU with
[AMD-V extensions][amdv]. This should work with most modern Intel or AMD CPUs.

[vtx]:http://en.wikipedia.org/wiki/VT-x#Intel_virtualization_.28VT-x.29
[amdv]: https://en.wikipedia.org/wiki/X86_virtualization#AMD_virtualization_(AMD-V)

SmartOS can run in a virtual machine. However, if nested virtualization is
unavailable, some HVM features will not function.
