# Zones

Inspired by [FreeBSD jails](http://en.wikipedia.org/wiki/FreeBSD_jail),
the fundamental technology behind a SmartMachine is the concept of
zones. A zone is a virtualized instance of SmartOS that behaves like an
isolated system even when functioning along side other zones on the same
machine. Each zone on a system shares a pool of resources and the single
operating system kernel. However, zones are never aware of other zones
on the system and are process secure. A zone is similar to a virtual
machine, but is distinct in that it shares the base system kernel,
whereas each virtual machine runs its own OS kernel. Zones are an
inherent part of the operating system and impose no additional overhead.
Each process that runs includes the zone ID as an attribute. Thus, zones
scale and perform better than virtual machines since there no additional
kernel or layering involved.

## About the Global Zone

In SmartOS, the global zone is distinct from all other zones.  The
global zone is the parent to all other zones and serves as the
management layer of SmartOS from which you
[administer](administering-the-global-zone.md)
to other zones. You use the global zone to monitor and manage the system
health, capacity, and throughput of non-global zones. A single
administrator is in charge of the global zone and manages properties of
all other zones, such as resource allocation and resource management. As
the global zone administrator, you control and instantiate zones through
three basic steps:

- **Configure:** Defines the networking and privilege sets for
    the zone.
- **Install packages:** Constructs, installs, and initializes packages
    for the zone.
- **Run:** Boots the zone and starts services.

The global zone is what you boot into when you boot up and log into
SmartOS. You can think of the global zone as the "base OS". Non-global
zones are the various OS and KVM instances that you manage through the
global zone. The terms "global zone" and "non-global zone" help
distinguish between references to the virtual machines contained by the
global zone and references to things inside a virtual machine.

The key to working in a SmartOS environment is understanding how to
administer and work with the global zone. The global zone is effectively
a read-only hypervisor because SmartOS is not installed locally. It
boots directly from either USB, CD-ROM, or PXE into a mostly read-only
environment. When you boot to SmartOS, you essentially load it into
memory and run it off of a ramdisk. This means that most changes you
would want to typically make in the global zone will not persist or are
simply not allowed. For example:

- You cannot add users.
- You cannot write anywhere under `/usr`.
- You cannot permanently store or change files under `/etc`, `/root`,
    `..`
- Any changes you make to SMF services are reset with each reboot.

SmartOS is specifically designed as an OS for running virtual machines,
not as a general purpose OS. As a global zone administrator, you should
only use the global zone for creating and managing non-global zones. All
other work should take place directly in non-global zones. However,
there are some changes you can make directly in the global zone.

For a good breakdown of changes you can make, see this
[blog post](http://www.perkin.org.uk/posts/smartos-and-the-global-zone.html)
by Jonathan Perkin of Joyent.

## Process Security

One of the reasons a SmartMachine is so secure is because of process
encapsulation. Zones provide for separation of processes, their data and
the namespace.

- Processes cannot escape from zones.
- Processes cannot observe other zones.
- Processes cannot signal other zones.
- Naming (such as user IDs or opening a port on an IP address) does
    not conflict with other zones

This isolation means that zones provide a a container without fear of
processes in one zone interfering with another. Conversely, a process in
the global zone can view anything that is happening in any other zone if
it has the relevant privilege.

Zone processes have a privilege limit and no process in a zone ever has
as much privilege as the global zone. For example, the root user in a
zone is limited by the privilege limit set for the zone. In
addition, all OS services are managed through SMF, providing service
isolation and encapsulation. This encapsulation in a zone provides the
security necessary to run multiple zones on the same system.

## Resource Security

Zones also provide the following resource security benefits:

**Control over the filesystem:** Zones are mounted from the global zone
and the global zone administrator can mount a zone filesystem as
read/write or read-only. Processes in a zone cannot re-mount a
filesystem unless the global zone administrator allows it.

**Control over the network stack:** The global zone administrator can
control the IP behavior of zones in one of two ways: through a shared IP
stack or exclusive IP stack. By default, on SmartOS each zone has its
own IP stack. An administrator in that zone will have a limited set of
privileges to perform some administrative functions, such as picking IP
addresses and configuring routes.

**Namespace separation:** Zones provide for system and network
configuration name space separation, keeping namespaces unique to each
zone. All the resources managed by the kernel are maintained through
polyinstantiation, meaning the same resources are managed as different
instances in each zone, eliminating namespace collision. For example,
each zone maintains a unique instance of `/tmp`.

**Virtualized hardware:** On SmartOS zones do not have access to any
physical devices. All hardware components in a zone
are completely virtualized, including networking.

## Security and Solaris Containers

This video provides a brief but informative description of the zone
implementation in SmartOS. With the exception of Trusted Extension, the
concepts presented here by Glen Faden on OpenSolaris also apply to
SmartOS.

[Video: Security and Solaris
Containers](http://www.youtube.com/watch?v=-4ZIhX2stEs)
