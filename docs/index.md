# Home

## Search All Things SmartOS

Useful information about SmartOS, illumos et al is scattered among
a number of sources. You can now search them all at once with
[SmartOS Search][smartos-search] (a Google custom search). On the
results page, you'll be able to narrow down by source (list of
current sources [here][smartos-sources] - suggestions for others welcome!).

[smartos-search]: http://smartos.org/search/
[smartos-sources]: http://smartos.org/2013/02/04/smartos-news-feb-4-2013/

## VIDEO: [Introduction to SmartOS][intro-video]

[intro-video]: http://smartos.org/2012/08/21/introduction-to-smartos/

Welcome to the SmartOS Documentation. Here you'll find everything
you need to get started using SmartOS and participating in the
community. Information about what's new in recent releases can be
found in the [SmartOS Changelog][smartos-changelog].

[smartos-changelog]: https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos.html

## Quick Start

Not sure where to begin? Try the
[SmartOS Quick Start Guide][smartos-qs]!

[smartos-qs]: smartos-quick-start-guide.md

## SmartOS In a Nutshell

SmartOS is a specialized [Type 1 Hypervisor][type1-vmm] platform
based on [illumos][illumos].  It supports two types of virtualization:

[type1-vmm]: http://en.wikipedia.org/wiki/Hypervisor
[illumos]: https://illumos.org

- **OS Virtual Machines** (Zones): A light-weight virtualization
  solution offering a complete and secure userland environment
  on a single global kernel, offering true bare metal performance
  and all the features illumos has, namely dynamic introspection
  via DTrace
- **Hardware Virtual Machines** (KVM, Bhyve): A full virtualization
  solution for running a variety of guest OS's including Linux,
  Windows, \*BSD, Plan9 and more

SmartOS is a "live OS", it is always booted via PXE, ISO, or USB
Key and runs entirely from memory, allowing the local disks to be
used entirely for hosting virtual machines without wasting disks
for the root OS.  This architecture has a variety of advantages
including increased security, no need for patching, fast upgrades
and recovery.

Virtualization in SmartOS builds on top of the foundational illumos
technologies inherited from OpenSolaris, namely:

- [ZFS][zfs] for storage virtualization
- Crossbow (`dladm`) for [network virtualization][networking]
- [Zones][zones] for virtualization and containment
- [DTrace][dtrace] for introspection
- [SMF][smf] for servicemanagement
- RBAC/BSM for auditing and role based security
- And more

[zfs]: zfs.md
[networking]: networking-and-network-virtualization.md
[zones]: smartos-virtualization.md
[dtrace]: dtrace.md
[smf]: basic-smf-commands.md

SmartOS is typically "installed" by downloading and copying the OS
image onto a USB key and then booting that key.  On the first boot
a configuration utility will configure your base networking, allow
you to set the root password, and allow you to select which disks
to use to create the ZFS Zpool which will provide persistent storage.

When you log into SmartOS you will enter the "global zone".  From
here you can download VM Images using the *imgadm* tool, which are
pre-configured OS and KVM virtual machines.  You can then use the
*vmadm* tool to create and manage both OS and hardware virtual
machines.

An important aspect of SmartOS is that both OS (Zones) and hardware
virtual machines are both built on Zones technology.  In the case
of OS virtualization, the guest virtual machine is provided with a
complete userland environment on which to run applications directly.
In the case of HVM virtualization, the `qemu` or `bhyve`  process
will run within a stripped down Zone.  This offers a variety of
advantages for administration, including a common method for managing
resource controls, network interfaces, and administration.  It also
provides HVM guests with an additional layer of security and isolation
not offered by other virtualization platforms.

Finally, instances are described in JSON.  Both administrative
tools, `imgadm` and `vmadm`, accept and return all data in JSON
format.  This provides a simple, consistent, and programmatic
interface for creating and managing VM's.

## How to Use this Site

This documentation can provide you with a variety of resources for users at
all levels.  To get started, [download SmartOS now](download-smartos.md),
and be sure to review the [Hardware Requirements](hardware-requirements.md).
Once installed, refer to our [Users Guide](smartos-users-guide.md) to help
you learn your way around SmartOS.

When you have questions, refer to the
[SmartOS Community section](mailing-lists-and-irc.md) for pointers to
our IRC chat rooms and mailing lists.  When you're ready to start
improving and adding your own customizations to SmartOS please refer to our
[Developers Guide](smartos-developers-guide.md).

SmartOS is a community effort, as you explore and experiment with
SmartOS please feel free to [edit and contribute][src] to this site to
improve the documentation for other users in the community.

[src]: https://github.com/joyent/smartos-docs/

## About Triton &amp; Joyent

SmartOS is a fundamental component of the [Joyent Triton Data
Center](http://www.joyent.com/triton/) (Triton) product. Triton
source and images are available for at no cost and powers several
public and private clouds around the globe, namely the[Joyent Public
Cloud](http://www.joyentcloud.com) (JPC).  As you use SmartOS you
will come across hooks that are used by Triton, such as file systems
and services named "smartdc".

If you are interested in evaluating the full Triton Data Center
product, please contact <sales@joyent.com>.
