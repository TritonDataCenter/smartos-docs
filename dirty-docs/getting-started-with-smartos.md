+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Getting Started with
SmartOS </span>

</div>

<div class="pagesubheading">

This page last changed on Jun 22, 2015 by
<font color="#0050B2">cjr</font>.

</div>

**In this topic:**

<div>

<ul>
<li>
[System Requirements](#GettingStartedwithSmartOS-SystemRequirements)
</li>
<li>
[Creating a Persistent
zpool](#GettingStartedwithSmartOS-CreatingaPersistentzpool)
</li>
- [Further Reading](#GettingStartedwithSmartOS-FurtherReading)
- [Discussion List](#GettingStartedwithSmartOS-DiscussionList)

</ul>

</div>

**In this section:**

- [Creating a SmartOS Bootable USB
    Key](Creating%20a%20SmartOS%20Bootable%20USB%20Key.html "Creating a
SmartOS Bootable USB Key")
- [PXE Booting
    SmartOS](PXE%20Booting%20SmartOS.html "PXE Booting SmartOS")
- [SmartOS as a VMware
    Guest](SmartOS%20as%20a%20VMware%20Guest.html "SmartOS as a VMware G
uest")
- [SmartOS Clean
    Re-install](SmartOS%20Clean%20Re-install.html "SmartOS Clean Re-inst
all")
- [SmartOS as a Sandboxed VirtualBox
    Guest](SmartOS%20as%20a%20Sandboxed%20VirtualBox%20Guest.html "Smart
OS as a Sandboxed VirtualBox Guest")

SmartOS is a [live
image](SmartOS%20Users%20Guide.html "SmartOS Users Guide") distribution
of [Illumos](https://www.illumos.org/),
[KVM](http://dtrace.org/blogs/bmc/2011/08/15/kvm-on-illumos/) and extras
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

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
---------------------------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
For details on the benefit of running SmartOS as a live image, [watch th
is video](https://www.youtube.com/watch?v=ieGWbo94geE).
  ---------------------------------------------------------------------
------------------------------------------------------------------------
---------------------------------------------------------

</div>

The SmartOS ISO is a bootable CD image containing GRUB, the Illumos
kernel, and the SmartOS boot archive. You can copy the image to any
medium and load it on boot through any multiboot bootloader. This makes
it easy to convert the image into a bootable USB thumbdrive or PXE boot
image. You can even copy `/platform` to your Linux system, add an entry
to the GRUB `menu.lst` file, and dual boot without needing to
repartition.

<div class="panelMacro">

  --------------------------------------------------------------- ------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------
  ![](images/icons/emoticons/check.gif){width="16" height="16"}   You ca
n find the default single user mode root password for a given release on
 the boot media in `/platform/root.password`. The default single user mo
de root password changes from release to release. Otherwise the root pas
sword is simply "root".
  --------------------------------------------------------------- ------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------

</div>

System Requirements
=======================

The more memory you can dedicate to SmartOS the better due to it running
as a live image:

- A minimum of 1GB of RAM
- 64-bit x86 CPU only

To take advantage of KVM features, SmartOS requires an Intel CPU with
[VT-x
extensions](http://en.wikipedia.org/wiki/VT-x#Intel_virtualization_.28VT
-x.29)
in the following microarchitectures:

- Nehalem
- Westmere
- Sandy Bridge
- Ivy Bridge

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
-----------------------------------------------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   Smar
tOS will run in a virtual machine. However, due to a lack of nested virt
ualization, some features of KVM will not function.
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
-----------------------------------------------------

</div>

Creating a Persistent zpool
===============================

Everything on SmartOS is transient due to the nature of it's design.
That is, it does not persist across reboots and any changes made on the
running system are destroyed as soon as the system is no longer running.
This really is not a problem as you typically want changes to your data
to persist, not changes to the running operating system or filesystem
hierarchy.

For this reason, SmartOS includes a dataset setup script that runs
automatically on boot. If you run SmartOS from an alternate form of
media and want the dataset setup script to run on boot, ensure the
following kernel command line option is set:\

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
smartos=true
```

</div>

</div>

</div>

If you want to disable the dataset setup script:
</p>
<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
noimport=true
```

</div>

</div>

</div>

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
---------------------------------------------------------------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   This
 is not an installer and does not install the live image. The script is
simply for data setup. You will still need to boot from live media.
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
---------------------------------------------------------------------

</div>

As a distribution of the Illumos kernel, SmartOS uses
[ZFS](ZFS.html "ZFS") as the filesystem and takes full advantage of all
the inherent features of ZFS including data integrity preservation,
support for snapshots and copy-on-write clones, support for high
capacities, and RAID-Z support.

Further Reading
-------------------

[How to create a
zone](How%20to%20create%20a%20zone%20(%20OS%20virtualized%20machine%20)%
20in%20SmartOS.html "How to create a zone ( OS virtualized machine ) in
SmartOS")
and [How to create a Virtual Machine in
SmartOS](How%20to%20create%20a%20Virtual%20Machine%20in%20SmartOS.html "
How to create a Virtual Machine in SmartOS")
give more detail about `vmadm create`.

For more information about using a SmartMachine, check out the
[SmartMachine Wiki
Home](http://wiki.joyent.com/display/jpc2/JoyentCloud+Home).

Those versed in JavaScript can learn a lot more by reading [vmadm.js
source](https://github.com/joyent/smartos-live/blob/master/src/vm/sbin/v
madm.js).

For detailed information on ZFS and ZFS features, see the [ZFS
Administration
Guide](http://download.oracle.com/docs/cd/E19253-01/819-5461/index.html)
.

Discussion List
-------------------

The smartos-discuss list is a forum for useful questions and answers -
see the searchable archives
[here](https://www.listbox.com/member/archive/184463/); sign up
[here](http://smartos.org/smartos-mailing-list/).
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


