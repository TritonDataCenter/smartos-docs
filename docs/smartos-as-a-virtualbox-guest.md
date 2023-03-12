# SmartOS as a VirtualBox Guest

## Quick Start

The best method for using SmartOS under VirtualBox is to download the
latest ISO image.

In VirtualBox, create a **New** machine. Set the OS as "Solaris 11
64bit". Attach the ISO image to the CD-ROM drive and select it as the
boot volume. Give the VM at least 2GB of RAM, preferably more.

Before booting the machine, go to the "Storage Section" and add another
hard disk (at least 20GB in size, preferably more) named "Zpool", VMDK
type, for your ZFS pool.

Some other recommended configuration changes are:

- Disable Audio
- Disable "Enable absolute pointing device"
- Enable PAE/NX
- Ensure Network is enable on Adapter 1 is of Type "Intel PRO/1000 MT Desktop"

When you boot the machine and do the initial configuration ensure that
you use the secondary disk (likely named "c0t2d0") as your Zpool.

<!-- This stuff is pretty old...is it even relevant anymore?

## Detailed Guide

The following links detail setup, configuration, and runtime of SmartOS
within a sandboxed / self-contained VirtualBox environment.

Your mileage may vary when attempting to use any of these links. Your use of
these links is at your own risk.

### Links

- [Intro SmartOS Setup pt 1][intro-1] - General expectations, layout,
  and router infrastructure VM (IVM) for the SmartOS sandbox environment
- [Intro SmartOS Setup pt2][intro-2] - Configuration of services
  infrastructure VM (IVM), including the image repository
- [Intro SmartOS Setup pt 3][intro-3] - Install and configure a SmartOS
  host (cn40)
- [Intro SmartOS Setup pt 4][intro-4] - Checking out handling and
  management of SmartOS OS VMs

[intro-1]: http://troysunix.blogspot.com/2013/02/intro-smartos-setup-pt-1.html
[intro-2]: http://troysunix.blogspot.com/2013/02/intro-smartos-setup-pt-2.html
[intro-3]: http://troysunix.blogspot.com/2013/02/intro-smartos-setup-pt-3.html
[intro-4]: http://troysunix.blogspot.com/2013/02/intro-smartos-setup-pt-4.html

 -->