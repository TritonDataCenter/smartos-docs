# Why SmartOS - ZFS, KVM, DTrace, Zones and More

For an overview, see this
[excellent talk at SCALE10x](http://smartos.org/2012/01/24/using-smartos-as-a-hypervisor/)
by Joyent software engineer Robert Mustacchi.

On August 15th, 2011, Joyent
[announced](http://www.marketwire.com/press-release/joyent-announces-smartos-with-kvm-an-open-source-modern-operating-system-1549602.htm)
that it had
[ported KVM](http://smartos.org/2011/09/23/video-experiences-porting-kvm-to-smartos/)
to its operating system, SmartOS, and was
[open sourcing](https://github.com/TritonDataCenter/smartos-live)
the entire OS. You might be wondering why the world needs another
operating system, and what's so great about this one. Well, let me explain...

## A Little History

In 2005, [Sun
Microsystems](http://en.wikipedia.org/wiki/Sun_microsystems) open
sourced [Solaris](http://en.wikipedia.org/wiki/Solaris), its renowned
Unix operating system, eventually to be released as a distribution
called [OpenSolaris](http://en.wikipedia.org/wiki/Opensolaris). Among
the earliest adopters and most effective advocates of OpenSolaris was
[Ben Rockwood](http://cuddletech.com/blog/), who wrote [The Cuddletech
Guide to Building
OpenSolaris](http://www.cuddletech.com/opensolaris/ONbuild.pdf) in June,
2005 - the first of his many important contributions to the nascent
OpenSolaris community. Meanwhile, Joyent's CTO Jason Hoffman was
frustrated by the inability of most operating systems to answer
seemingly-simple questions like: "Why is the server down? When will it
be back up? ... Now that it's back up, why is my database still slow?"

Jason knew that these questions would be a lot easier to answer on
Solaris-based systems, and recognized Sun's open-sourcing initiative as
a huge opportunity. He hired Ben, and Joyent became one of the most
innovative users of the open sourced Solaris kernel ("Solaris 11 Nevada
builds"), over the years amassing a great deal of know-how in tweaking
and tuning it for Joyent's cloud computing needs.

After acquiring Sun Microsystems in 2010, Oracle Corp.
[closed OpenSolaris](http://sstallion.blogspot.com/2010/08/opensolaris-is-dead.html).
Fortunately, an alternative --
[Illumos](http://en.wikipedia.org/wiki/Illumos), a new fork of Solaris -
was [already in the works](http://wiki.illumos.org/display/illumos/History),
and many Solaris engineers had left Oracle and were free to contribute to it.
Unsurprisingly, some of those engineers
[ended up at Joyent](http://www.joyentcloud.com/2010/07/joyent-names-bryan-cantrill-vice-president-of-engineering/),
as part of a talented team that now contributes very substantially to
Illumos, extending it in key areas like
[KVM](http://en.wikipedia.org/wiki/K_virtual_machine) (kernel virtual
machines), as well as enhancing the Illumos kernel specifically for
cloud use.

### The Real Cloud OS

What does it mean for an operating system to be designed "for" cloud
computing? The fundamental challenge for a cloud computing OS is to
present a single server to many (and varied) customers, while making
each customer feel as if they are the only one using that machine. From
the user's perspective, a cloud OS has to be:

- fast: minimizing latency (the time it takes for an operation
  to complete)
- flexible: with automatic bursting and easy scaling
- secure: I should never have to worry about what my neighbors are
  doing

For the cloud datacenter operator, the OS additionally must provide:

- ultra-fast provisioning and de-provisioning (i.e., the creation and
  destruction of [virtual
  machines](http://en.wikipedia.org/wiki/Virtual_machine))
- efficient and fair resource sharing
- multi-thread and multiprocessor support
- easy/automated operation
- reliability
- observability: when something doesn't behave as it should, we need
  to be able to find out quickly what is wrong and why

### Inherited Features

From Illumos, SmartOS inherits powerful features that address these
needs. We'll give a brief overview here; some of these topics will be
covered in depth in future posts.

### Operating System Virtualization

> Thanks to the Solaris/Illumos heritage, SmartOS already had
> [Containers and Zones](http://en.wikipedia.org/wiki/Solaris_Zones) --
> container-based virtualization (containers is supposed to mean zones +
> resource controls) that allowed users to run multiple applications sets
> on one server isolated from one another. With KVM on SmartOS, Joyent can
> now address workloads that require running a full operating system for
> those customers who need Linux, Windows, or other operating systems to
> run in full, hardware-assisted virtualization. Unlike any other
> "hypervisor", Joyent's KVM images run as a process inside of a zone:
> turns out to be a very secure way to run Windows. And, unlike Linux,
> SmartOS will also give customers access to Solaris technologies that
> many users find compelling - like DTrace and ZFS.

[ReadWriteEnterprise](http://www.readwriteweb.com/enterprise/2011/08/joyent-brings-kvm-to-smartos-f.php)

> "Brendan Gregg, Lead Performance Engineer at Joyent, has done
> [an extensive analysis comparing the performance of Zones, KVM and Xen](http://dtrace.org/blogs/brendan/2013/01/11/virtualization-performance-zones-kvm-xen/).
> In a post on the DTrace blog, he summarizes their performance in four
> ways: Characteristics, block diagrams, internals and results. Through
> looking at the I/O path (network, disk) and its overhead, he provides
> some minimum config results comparing performance between OS
> virtualization (Zones) and the hardware virtualization of Xen and KVM
> varieties. Brendan's full post offers deeper insight into how each of
> these technologies work, how each criterion for performance is evaluated
> and the code path for performing network I/O with each technology. Read
> the full analysis on the [DTrace blog](http://dtrace.org/blogs/brendan/2013/01/11/virtualization-performance-zones-kvm-xen/).

[Joyent](http://tritondatacenter.com/blog/brendan-gregg-on-virtualization-performance-comparing-zones-kvm-and-xen)

### ZFS

This [future proof file system](http://en.wikipedia.org/wiki/Zfs),
which is also a
[logical volume manager](http://en.wikipedia.org/wiki/Logical_volume_manager),
gives us:

- Fast file system creation: The creation and startup of additional
  zones ("SmartMachines" in Joyent terminology) - in other words,
  adding new paying customers - is nearly instantaneous.
- Data integrity is guaranteed, with particular emphasis on preventing
  silent data corruption.
- [Storage pools](http://en.wikipedia.org/wiki/ZFS#Storage_pools):
  "virtualized storage" makes administrative tasks and scaling
  far easier. To expand storage capacity, all you need to do is add
  new disks (hard disks, flash memory, and whatever may come along in
  the future) to a zpool.
- Snapshots: ZFS'
  [copy-on-write](http://en.wikipedia.org/wiki/Copy-on-write)
  transactional model makes it possible to capture a snapshot of an
  entire file system at any time, storing only the differences between
  that and the working file system as it continues to change. This
  creates a backup point that the administrator can easily roll
  back to.
- Clones: Snapshots of volumes and filesystems can be cloned, creating
  an identical copy. Cloning is nearly instantaneous and initially
  consumes no additional disk space. This facilitates the rapid
  creation of new, nearly identical, VMs.\
  \* The ARC (Adaptive Replacement Cache) improves file system and
  disk performance, driving down overall system latency.

### Scalability

[wikipedia](http://en.wikipedia.org/wiki/Scalability) defines
scalability as "...the ability of a system, network, or process, to
handle growing amounts of work in a graceful manner, or its ability to
be enlarged to accommodate that growth."

Solaris has been the OS of choice for major enterprise computing for
decades. ['nuff said!](http://en.wikipedia.org/wiki/Stan_Lee)

### Resource Controls

SmartOS offers two methods for controlling CPU consumption:

- Fair share scheduler lets the operator set a *minimum* guaranteed
  share of CPU. It takes effect when the system is busy with demand
  from more than one zone, to ensure that each gets its fair share.
  When the system is not otherwise busy, a zone can "burst" beyond its
  usual limit, consuming more than the minimum as needed, up to the
  CPU cap set for it.
- CPU cap is a *maximum* , e.g. an amount of CPU time that a user has
  paid for. This can also be used to set user expectations about
  system performance, even when the overall system is not yet
  populated and load is still light.

### Network Virtualization

Virtualization is also used to create the illusion of things that aren't
actually on the real system, such as virtual network interfaces (VNICs).
Joyent was one of the first users of [Project
Crossbow](http://hub.opensolaris.org/bin/view/Project+crossbow/), which
added network virtualization to OpenSolaris. Using this technology, each
Joyent SmartMachine gets up to 32 VNICs, each with its own TCP/IP stack.
This helps maximize another scarce resource, IPv4 addresses, through the
use of network pools.

### Observability

Users of Illumos,
[Mac OS X](http://dtrace.org/blogs/brendan/2011/10/10/top-10-dtrace-scripts-for-mac-os-x/)
and FreeBSD know that [DTrace](dtrace.md) gives you an
unprecedented view of what's going on throughout the software stack. In
SmartOS, this allows operators to observe and troubleshoot across all
the zones and nodes in an entire data center. In
[Triton](http://www.tritondatacenter.com/triton/), the Joyent team have harnessed
the power of DTrace in a more user-friendly form with
[Cloud Analytics](https://www.tritondatacenter.com/blog/cloud-analytics-basic-visualization),
which is available to both cloud operators and their customers.

### Security

Solaris has long been the operating system of choice in highly secure
data centers, thanks to several features which SmartOS inherits. SmartOS
zones, though they share system resources such as CPU and disk space,
simply cannot see each other. Users in a multi-tenant environment are
thus protected from each other; your neighbor's security lapse will not
affect your zone. Data security is also ensured: no byte of data from
one customer is shared with any other customer, now or later, because:

- A zone can only see its own network traffic.
- Disk storage is accessed only via ZFS file systems, never
  raw devices. Each SmartMachine has its own file system and does not
  even know of the *existence* of any other.
- A user has no access to raw memory devices, so can't scan
  system memory.

Upon deletion of a SmartMachine, the file system is destroyed and there
is no device path by which a future customer could access any data left
over in that file system. A SmartMachine is protected from DDOS attacks
by some of the same features that guarantee that it gets a fair share of
system resources: fair share scheduler, caps, process limits, rcapd,
swap cap, disk file system limits, quota limits. By capping each zone's
resource usage, SmartOS ensures that, even under heavy attack, a zone
will not bring down its neighbors.

### Reliability

SmartOS is made more reliable by:

- [Fault management](http://hub.opensolaris.org/bin/view/Community+Group+fm/WebHome)
  (FMA): "fine-grained fault isolation and restart where possible of
  any component - hardware or software - that experiences a problem.
  To do so, the system must include intelligent, automated, proactive
  diagnoses of errors that are observed on the system. The diagnosis
  system is used to trigger targeted automated responses or guided
  human intervention that mitigates a specific problem or at least
  prevents it from getting worse."
- The [Service Management Facility](http://en.wikipedia.org/wiki/Service_Management_Facility)
  (SMF)
  is "a feature of the [Solaris operating
  system](http://en.wikipedia.org/wiki/Solaris_(operating_system))
  that creates a supported, unified model for services and [service
  management](http://en.wikipedia.org/wiki/Operating_system_service_management)
  on each Solaris system".

### Joyent-Added Features in SmartOS

Above and beyond what we inherited from Solaris, Joyent has extended
SmartOS with some features of particular interest to cloud operators,
including [disk I/O
Throttling](http://www.youtube.com/watch?v=a6AJxAYmP-M). A drawback of
multi-tenancy in classic Solaris is that, where storage is shared, a
single application on a system can monopolize access to local storage by
a stream of synchronous I/O requests, effectively blocking the system
from servicing I/O requests from other zones and applications, and
causing performance slowdowns for other tenants. This new
operator-configurable setting throttles I/O from misbehaving zones (by
adding a small delay to each read or write), thus ensuring that other
zones also get a turn at reading/writing to disk. As with CPU caps, disk
I/O throttling only comes into effect when a system is under load from
multiple tenants. When a system is relatively quiet, a single tenant can
enjoy faster I/O without bothering the neighbors.

The following is a list of the major features added by Joyent to SmartOS

<!-- markdownlint-disable ul-indent -->
<!--
    For some reason if I don't use 4 space indent then mkdocs renders
    everything at the top level.
-->

- Support to run as a live image
- Joyent branded zone
    - uses a "sparse root" model similar to Solaris 10
- LX branded zone
    - Use a Linux distribution in a zone with no virtual machine
    - Joyent provides images for popular distros
- KVM
    - also added `kvmstat` command
    - enhanced `isainfo` for vmx/svm
    - KVM runs in a branded zone for even more security
- BHYVE
    - Ported from FreeBSD
    - BHYVE also runs in a branded zone for added security
- Scalable zone memory capping
    - does not use `rcapd` - each zone is managed independently
    - doesn't use the expensive RSS calculation, unless necessary
    - new `zonememstat` command to use instead of `rcapstat`
    - memory cap is an `rctl` now, can be managed with `prctl` command
- per-zone ZFS I/O throttle
    - also added new `vfsstat` command
    - also added new `ziostat` command
    - also added zone priority
- ZFS dump to a RAID-Z pool
- dynamic VNICs which are created/destroyed as zones boot/halt
    - enhanced friendly names (in other words, each zone can have a
      VNIC created by the global zone which is named "net0")
    - enhanced `dladm` , `dlstat` and `flowadm` commands with zone
    support
- zone `svcs` command enhancements
    - `-z` to look at a zone
    - `-Z` to look at all zones
    - `-L` to look at log files
    - also added `-z` to `svcadm` and `svcprop`
- CPU bursting
    - can define a base level of CPU usage and an upper bound
    - can limit how much time a zone can burst
- zone reliability - many kernel fixes for handling error cases
  preventing zone shutdown
- Better observability - lots of new `kstats` for zones, CPU bursting,
  ZFS I/O, etc.
- `wall(1)` zone support
- FSS fixes to prevent process starvation
- `coreadm`
    - support to limit the number of core dumps
    - add %Z corefile name pattern for zonepath
- support for SMF restart rate
- DTrace enhancements
    - `llquantize`
    - `vmregs[]`
    - enablings on defunct providers prevent providers from
    unregistering
    - `tracemem()` action takes a dynamic size argument
    - `toupper()` and `tolower()` subroutines
    - `lltostr()` D subroutine should take an optional base
    - sdt probes for `zvol_read` and `zvol_write`
    - bump `dtrace_helper_actions_max` to 1024
- improved disassembler support
- new persistent zoneid to improve DTracing across zone reboot
- system-wide crontab support
- per-zone load average
- driver and module updates
    - ixgbe updated
    - igb updated
    - incorporate latest acpica code from Intel
    - port open IPMI driver from FreeBSD
- improved mdb support
    - mdb api function for iterating object symbols
    - `::ugrep` and `::kgrep` do not work for sizes less than 4
    - `::scalehrtime dcmd`
    - `::printf`
    - `::findjsobjects`
    - `mdb_v8`
    - `::walk jsframe` and `jstack`
    - tab completion
- libumem support for an allocator
- critical IP DCE fixes for systems under heavy IP load
- significantly reduced SMF RSS - important with lots of zones
- perturbable VNICs for testing real-world networking
- `vmadm` command and metadata support for zone boot-time
  customization
- lots of misc. bug fixes

<!-- markdownlint-enable ul-indent -->

### Orchestrating the Cloud

SmartOS allows a cloud hosting provider to put more customers on the
physical server (each in their own SmartMachine), while still giving
them all phenomenal performance. Joyent's servers typically run at 70%
CPU capacity, against an industry standard of 15%. Joyent SmartMachines
also [run faster](http://www.joyentcloud.com/resources/benchmarks/).
SmartOS provides the underlying features;
[Triton](http://www.tritondatacenter.com/triton/) adds the orchestration layer
that abstracts these concepts and operations to a GUI and/or [API
layer](https://github.com/TritonDataCenter/triton/blob/master/docs/reference.md).

### Beyond the Cloud

We should add that SmartOS potentially has applications well beyond the
cloud and large datacenters. Here's an idea from [Stacy Higginbotham of
Gigaom](http://gigaom.com/cloud/joyent-launches-a-new-os-for-the-cloud/)
:
SmartOS requires a relatively small memory footprint, and boots to a
ram-only environment for performance. This means it could be used for a
variety of smaller computing platforms such as digital signs, set-top
boxes and even high-end sensors. Looking ahead, having an OS that can
work at both the data-center level and on sensors in the field enables a
sensor-rich network.

<!-- markdownlint-disable no-trailing-punctuation -->
### Now What?
<!-- markdownlint-enable no-trailing-punctuation -->

To learn more, [download SmartOS](download-smartos.md) to try for yourself!
