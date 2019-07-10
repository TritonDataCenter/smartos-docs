+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Home
![](images/icons/home_16.gif){width="16" height="16"} </span>

</div>

<div class="pagesubheading">

This page last changed on Jan 12, 2018 by
<font color="#0050B2">brian.bennett@joyent.com</font>.

</div>

### Search All Things SmartOS

Useful information about SmartOS, illumos et al is scattered among a
number of sources. You can now search them all at once with [SmartOS
Search](http://smartos.org/search/) (a Google custom search). On the
results page, you'll be able to narrow down by source (list of current
sources [here](http://smartos.org/2013/02/04/smartos-news-feb-4-2013/) -
suggestions for others welcome!).

------------------------------------------------------------------------

### VIDEO: [Introduction to SmartOS](http://smartos.org/2012/08/21/i
ntroduction-to-smartos/)

Welcome to the SmartOS Documentation Wiki. Here you'll find everything
you need to get started using SmartOS and participating in the
community. Information about what's new in recent releases can be found
in the [SmartOS
Changelog](https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/sm
artos.html).

Quick Start
---------------

Not sure where to begin? Try the ﻿﻿[SmartOS Quick Start
Guide](SmartOS%20Quick%20Start%20Guide.html "SmartOS Quick Start Guide")
!

SmartOS In a Nutshell
-------------------------

SmartOS is a specialized [Type 1
Hypervisor](http://en.wikipedia.org/wiki/Hypervisor) platform based on
[illumos](http://www.illumos.org/).  It supports two types of
virtualization:

- **OS Virtual Machines** (Zones): A light-weight virtualization
    solution offering a complete and secure userland environment on a
    single global kernel, offering true bare metal performance and all
    the features illumos has, namely dynamic introspection via DTrace
- **KVM Virtual Machines**: A full virtualization solution for running
    a variety of guest OS's including Linux, Windows, \*BSD, Plan9 and
    more

SmartOS is a "live OS", it is always booted via PXE, ISO, or USB Key and
runs entirely from memory, allowing the local disks to be used entirely
for hosting virtual machines without wasting disks for the root OS.
This architecture has a variety of advantages including increased
security, no need for patching, fast upgrades and recovery.

Virtualization in SmartOS builds on top of the foundational illumos
technologies inherited from OpenSolaris, namely:

- [ZFS](ZFS.html "ZFS") for storage virtualization
- Crossbow (dladm) for [network
    virtualization](Networking%20and%20Network%20Virtualization.html "Ne
tworking and Network Virtualization")
- [Zones](SmartOS%20Virtualization.html "SmartOS Virtualization") for
    virtualization and containment
- [DTrace](DTrace.html "DTrace") for introspection
- [SMF](Basic%20SMF%20Commands.html "Basic SMF Commands") for service
    management
- RBAC/BSM for auditing and role based security
- etc.

SmartOS is typically "installed" by downloading and copying the OS image
onto a USB key and then booting that key.  On the first boot a
configuration utility will configure your base networking, allow you to
set the root password, and allow you to select which disks to use to
create the ZFS Zpool which will provide persistent storage.

When you log into SmartOS you will enter the "global zone".  From here
you can download VM Images using the *imgadm* tool, which are
pre-configured OS and KVM virtual machines.  You can then use the
*vmadm* tool to create and manage both OS and KVM virtual machines.

An important aspect of SmartOS is that both OS (Zones) and KVM virtual
machines are both built on Zones technology.  In the case of OS
virtualization, the guest virtual machine is provided with a complete
userland environment on which to run applications directly.  In the case
of KVM virtualization, the KVM qemu process will run within a stripped
down Zone.  This offers a variety of advantages for administration,
including a common method for managing resource controls, network
interfaces, and administration.  It also provides KVM guests with an
additional layer of security and isolation not offered by other KVM
platforms.

Finally, VM's are described in JSON.  Both administrative tools,
*imgadm* and *vmadm*, accept and return all data in JSON format.  This
provides a simple, consistent, and programmatic interface for creating
and managing VM's.

How to Use this Wiki
------------------------

This wiki can provide you with a variety of resources for users at all
levels.  To get started, [download SmartOS
now](Download%20SmartOS.html "Download SmartOS"), and be sure to review
the [Hardware
Requirements](Hardware%20Requirements.html "Hardware Requirements").
Once installed, refer to our [Users
Guide](SmartOS%20Users%20Guide.html "SmartOS Users Guide") to help you
learn your way around SmartOS.  When you have questions, refer to the
[SmartOS Community
section](The%20SmartOS%20Community.html "The SmartOS Community") for
pointers to our IRC chat rooms and mailing lists.  When you're ready to
start improving and adding your own customizations to SmartOS please
refer to our [Developers
Guide](SmartOS%20Developers%20Guide.html "SmartOS Developers Guide").

SmartOS is a community effort, as you explore and experiment with
SmartOS please feel free to edit and contribute to this wiki to improve
the documentation for other users in the community.

About Smart Data Center & Joyent
------------------------------------

SmartOS is a fundamental component of the [Joyent Smart Data
Center](http://www.joyent.com/products/joyent-smartdatacenter/) (SDC)
product.  SDC is available for purchase and powers several public and
private clouds around the globe, namely the[Joyent Public
Cloud](http://www.joyentcloud.com) (JPC).  As you use SmartOS you will
come across hooks that are used by SDC, such as file systems and
services named "smartdc".

If you are interested in evaluating the full Smart Data Center product,
please contact sales@joyent.com .

\
<div class="tabletitle">


Attachments:
------------

</a>

</div>

<div class="greybox" align="left">

![](images/icons/bullet_blue.gif){width="8" height="8"}
[smartos-modernOS.pdf](attachments/753667/1146905.pdf)
(application/pdf)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[KVMForum.pdf](attachments/753667/1146907.pdf) (application/pdf)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[illumos\_logos.zip](attachments/753667/1146940.zip) (application/zip)\
![](images/icons/bullet_blue.gif){width="8" height="8"} [cheatsheet
example.rtf](attachments/753667/1146945.rtf) (text/rtf)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[illumos\_postcard.png](attachments/753667/1146969.png) (image/png)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[smartmug.jpg](attachments/753667/1146979.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[button-free-trial-gift.png](attachments/753667/1769475.png)
(image/png)\

</div>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


