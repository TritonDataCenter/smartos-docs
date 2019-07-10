# SmartOS Virtualization

## Virtualization: How SmartOS Does it Differently

### A Non-Virtualized Computer

![A non-virtualized computer](assets/images/smartos-virtualization-non-virtualized-computer.png)

This is a diagram of a basic computer, such as your laptop.

The bottom layer shows the system's hardware resources: CPU, memory,
storage, NIC.

The operating system runs directly on the hardware, and has two
components:

- kernel: manages system resources and communications between those
  resources and applications running (in userland) on the system.
- userland: the software layer where user applications and software
  libraries run.

Note that, although this diagram shows all the applications as the same
"size", some applications need more resources than others, and an
application's resource needs may vary depending on the work it is
performing.

The operating system manages (schedules) competing demands for system
resources.

## Virtualization in the Client-Server Context

Datacenters used to commonly run one application per server, for the
following reasons:

- Application-specific requirements: Many applications are certified
  to run only on specific versions of an OS with a specific
  patch level. They might also require a specific software stack or
  specific configuration with its own particular version and
  patch-level requirements. This can prevent applications from sharing
  an environment with other applications.
- Application conflict: Similarly, some applications are incompatible
  with each other.
- Resource contention: A heavily-used application cannot crowd out
  other applications if they are on separate machines.
- Security: Isolation prevents attacks against one system from
  compromising another.
- Resilience: Application crashes won't bring down other applications.
- Maintenance: You can upgrade and reboot one system without
  affecting others.
- Business needs: Many enterprise IT projects involve launching a
  specific application; for budget and management reasons, each
  project might get its own server and application.

The one-app-per-server model worked well in the 1980s and 1990s, when a
single application placed heavy demand on a server's resources.

However, Moore's Law meant that more powerful servers were soon being
severely under-utilized: utilization of only 8-15% was common.

Obviously, this was a very inefficient use of equipment, facilities,
power and IT management resources. Virtualization came to the fore as a
solution.

### Hosted Virtualization

![Hosted Virtualization](assets/images/smartos-virtualization-hosted-virt.png)

In hosted virtualization, a hypervisor running on top of a standard
operating system **emulates** real hardware to create and manage one or
many virtual machines.

It is called "hosted virtualization", because the hypervisor sits on a
Host OS, and above this are the Guest OSes.

It is also known as "application-level virtualization", because the
hypervisor runs as an application on a Host OS.

Hosted virtualization was used to consolidate servers, making it
possible to put multiple servers on a single physical machine, while
maintaining isolation.

Any "guest" operating system running this virtual machine believes
itself to be running on its own separate, real computer, but it actually
only has access to a limited set of hardware resources (as defined by
the administrator).

An operating system is also known as a "supervisor". Thus we use the
term "hypervisor" for a supervisor of supervisors.

The hypervisor modifies the operating system at runtime through a
process known as "binary translation". Operating system calls to
hardware are intercepted ("trapped") and redirected.

Hosted virtualization introduced other infrastructure management
benefits:

- Load balancing
- Backups, migration, cloning
- Disaster recovery

This approach increased utilization, but still had huge inefficiencies:

- In order to perform work on the physical hardware, an application
  has to go through two operating systems and two sets of hardware.
- One of those sets of hardware is "emulated hardware": a software
  program acting like hardware, which is much slower than
  real hardware.

### Bare-Metal Hardware Virtualization

![Bare-metal hardware virtualization](assets/images/smartos-virtualization-bare-metal.png)

Bare-metal virtualization addresses some of these inefficiencies by
consolidating the hypervisor and the Host OS. The Host OS is stripped
down to a Virtual Machine Monitor - only what it needs to run a
hypervisor. It is optimized for that purpose, and the hypervisor
embedded in it. (The userland is stripped down to only the
virtualization vendor's tools.)

Drawbacks:

- Still uses hardware emulation (= slow).
- The hypervisor may need its own hardware drivers; you can't be sure
  these will be as easily available as with a standard OS.

### Paravirtualization

![Paravirtualization](assets/images/smartos-virtualization-paravirt.png)

Paravirtualization is similar to bare-metal virtualization, but it
removes the virtual machine hardware emulation.

The hypervisor directly coordinates a "privileged guest" operating
system which has access to the underlying hardware. The hypervisor
manages the OSes like OSes manage apps: allowing one OS to access
underlying hardware resources, while preventing any other OS from
accessing the same resources at the same time.

However, to accomplish this, the OS must be modified to be "aware" that
it is basically running on an "OS for OSes". In the case of hardware
virtualization, the OS is fooled (at runtime, by binary translation)
into believing it is running directly on hardware, as it was designed to
do.

The privileged guest coordinates access to hardware resources (drivers):

- Hardware drivers reside in the privileged guest.
- The privileged guest accesses hardware drivers directly; the Guest
  OSes do it through the Privileged Guest. They do this using shared
  memory (memory that can be accessed by two different applications),
  which speeds up performance.

Advantages:

- Very efficient – no Host OS, no hardware emulation (which means no
  runtime binary translation of OS calls).
- Like hosted virtualization, bare-metal virtualization can use any
  device drivers that the privileged guest has installed; the
  hypervisor does not contain any device drivers.

Disadvantages:

- Requires the guest OS to be modified so that it is "aware" it is
  running in a paravirtualized environment.
- These modifications are done in the kernel when possible (with
  access to the source code), or by installing system tools in the
  operating system.

In addition, with the release in 2006 of virtualization-enabled CPUs
(Intel VT and AMD-V), paravirtualization has lost some of its edge over
the other forms of virtualization:

- Virtualization-enabled CPUs eliminate some of the binary translation
  that virtual machines had to perform. More of the instructions are
  run directly on the hardware without emulation.
- Silicon is faster than software, so moving some of the
  virtualization functions to the chip gives better performance.

### Operating System Virtualization

![Operating System Virtualization](assets/images/smartos-virtualization-os-virt.png)

The most efficient method is to tackle virtualization at the operating
system level.

Benefits:

- Very efficient – no duplication of resources.
- Only one copy of the kernel on a server (all other forms of
  virtualization, including paravirtualization, require each
  application to go through multiple OS kernels)
- Each zone has its own userland (file system, system libraries,
  network configurations, process table (which contains the processes
  for individual applications), and its own approved user population.
- No hardware emulation.
- Utilize the OS scheduler: applications can "burst" across system
  resources when needed, just as applications on a single operating
  system can. They are not handcuffed by arbitrary virtual machine
  resource settings (even in the paravirtualization, OSes are assigned
  a certain amount of resources and cannot "burst" beyond them).
- Patches and upgrades automatically propagate to all containers; no
  need to manage and upgrade the various OSes individually.

Drawbacks:

- All operating environments are identical; you cannot run different
  OSs with different versions and patch levels. (However, for web
  applications this is not a problem: Apache, MySQL and PHP can all
  run on Windows, Linux or SmartOS.)

## Joyent SmartMachines are Based on Solaris Zones

Which gives us:

- CPU scheduling
- network virtualization
- security

Zones virtualization was added to Solaris 10 in 2005.

## HVM and OS Virtual Machines

![HVM and OS Virtualization](assets/images/smartos-virtualization-hvm+os.png)

OS virtualization is great for applications that can run natively in
SmartOS, but many of us have legacy apps that must run in Windows or
Linux, eg for Windows, Active Directory, Windows video encoding.\
What can we do for them?\
Joyent uses hosted virtualization for its virtual machine solution.

Remember that when you lose the Host OS, you lose any valuable
capabilities it provided. In the case of Vmware, this came down to
device drivers. Since they could embed these in the hypervisor,
bare-metal HW virtualization made more sense.

SmartOS provides two types of hardware virtualization: KVM and Bhyve.
Each provides hardware emulation and is a VMM (virtual machine
monitor). Notice that it is not a strict hypervisor layer. Each HVM is
independent -- there is one per Guest OS instead of one supporting
several VMs. This is because it has combined both the VM and the VMM.
