+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : SmartOS Technical FAQs
</span>

</div>

<div class="pagesubheading">

This page last changed on May 30, 2014 by
<font color="#0050B2">elizabeth.fee@joyent.com</font>.

</div>

<div>

- [What's the default username and
    password?](#SmartOSTechnicalFAQs-What%27sthedefaultusernameandpasswo
rd%3F)
- [Where's top?](#SmartOSTechnicalFAQs-Where%27stop%3F)
- [How do I start or stop system
    services?](#SmartOSTechnicalFAQs-HowdoIstartorstopsystemservices%3F)
- [How do I create my own zones or
    VMs?](#SmartOSTechnicalFAQs-HowdoIcreatemyownzonesorVMs%3F)
- [Where's &lt;common
    tool&gt;?](#SmartOSTechnicalFAQs-Where%27s%3Ccommontool%3E%3F)
- [What about AMD
    support?](#SmartOSTechnicalFAQs-WhataboutAMDsupport%3F)
- [If I use a USB Key to boot, how can I upgrade SmartOS safely
    later?](#SmartOSTechnicalFAQs-IfIuseaUSBKeytoboot%2ChowcanIupgradeSm
artOSsafelylater%3F)
- [Is it possible to use Joyent's KVM datasets without SmartDataCenter
    (SDC)?](#SmartOSTechnicalFAQs-IsitpossibletouseJoyent%27sKVMdatasets
withoutSmartDataCenter%28SDC%29%3F)
- [How do I automate setting up hostnames/static networking at
    deploy-time for Linux
    datasets?](#SmartOSTechnicalFAQs-HowdoIautomatesettinguphostnames%2F
staticnetworkingatdeploytimeforLinuxdatasets%3F)
- [Where can I get more questions
    answered?](#SmartOSTechnicalFAQs-WherecanIgetmorequestionsanswered%3
F)

</div>

### What's the default username and password?

When the SmartOS Live Image is booted for the first time you will be
prompted to set a root password.  In the event that you boot SmartOS
without importing your Zpool, you will require the default root
password.  When using the noimport=true option, the login is root/root.
Otherwise, the randomly generated root password for each build and can
be found in the "SINGLE\_USER\_ROOT\_PASSWORD.(BUILD\_DATE).txt" file
found in the [standard SmartOS download
location](https://download.joyent.com/pub/iso/).

### Where's top?

SmartOS uses 'prstat' instead of top; it understands SmartOS better and
has lower overhead. 'prstat -Z' is a popular invocation, although there
are many other command-line options; see the [prstat man
page](http://www.illumos.org/man/1m/prstat) for more details.

### How do I start or stop system services?

SmartOS uses SMF, which has some similarities with OSX's launchd or
Ubuntu's Upstart: it tracks dependencies between services, can
initialize them in parallel, provides logging, and so forth. Here are
some common commands:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    svcs: lists enabled services, even if they're not running. To see al
l services use 'svcs -a'
    svcs -vx: lists services that have failed for some reason, as well a
s the location of their logfiles
    svcs -Z: lists services in zones as well
    svcadm enable <foo>: start the service named <foo>
    svcadm disable <foo>: stop the service named <foo>
    svcadm restart <foo>: restart the service named <foo>
    svcadm clear <foo>: if a service is in maintenance mode, this clears
 it so it can be enabled
    svccfg export <foo>: shows the service manifest in case you're curio
us about what binary is being run and how

</div>

</div>

### How do I create my own zones or VMs?

[How to create a zone ( OS virtualized machine ) in
SmartOS](How%20to%20create%20a%20zone%20(%20OS%20virtualized%20machine%2
0)%20in%20SmartOS.html "How to create a zone ( OS virtualized machine )
in SmartOS")

[How to create a KVM VM ( Hypervisor virtualized machine ) in
SmartOS](How%20to%20create%20a%20KVM%20VM%20(%20Hypervisor%20virtualized
%20machine%20)%20in%20SmartOS.html "How to create a KVM VM ( Hypervisor
virtualized machine ) in SmartOS")

### Where's &lt;common tool&gt;?

The current SmartOS release is fairly stripped down. You can add more
goodies using
[pkgsrc/pkgin](Working%20with%20Packages.html "Working with Packages").

### What about AMD support?

You can use SmartOS with zones on AMD Hardware. KVM on AMD is currently
not supported.\
We at Joyent have no plans to add this (for sheer lack of time), but
it's being worked on in the community.\
There are [eait-images](http://imgapi.uqcloud.net/builds) with AMD KVM
support.

### If I use a USB Key to boot, how can I upgrade SmartOS safely lat
er?

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

### Is it possible to use Joyent's KVM datasets without SmartDataCen
ter (SDC)?

It is,  but you're likely better off making your own dataset by
following these
[instructions](How%20to%20create%20a%20Virtual%20Machine%20in%20SmartOS.
html "How to create a Virtual Machine in SmartOS").
Without SDC you'll need to restart the vm and login into the guest in
single user mode via grub in order to set the root ssh keys. SDC uses
some 'magic' to setup these ssh keys for its customers.

Once you're happy with this guest VM, halt it, take a zfs snapshot. This
snapshot can then be used as the dataset for future VMs without having
to install the guest OS again. Detailed instructions are
[here](Managing%20Images.html "Managing Images").

(For some newer Joyent-distributed KVM images, you can set root's SSH
authorized keys using customer\_metadata - see "Passing SSH Keys to the
VM" on ﻿[How to create a KVM VM ( Hypervisor virtualized machine ) in
SmartOS](How%20to%20create%20a%20KVM%20VM%20(%20Hypervisor%20virtualized
%20machine%20)%20in%20SmartOS.html "How to create a KVM VM ( Hypervisor
virtualized machine ) in SmartOS").)

### How do I automate setting up hostnames/static networking at depl
oy-time for Linux datasets?

There's no need. Qemu handles this for you via dhcp. Just set the IP in
the VM json spec.

### Where can I get more questions answered?

\#illumos and \#joyent on irc.freenode.net.

email: smartos \[at\] joyent \[dot\] com

Other communications tools coming soon.

<div class="tabletitle">


Comments:
---------

</a>

</div>

+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Could not login with root/root or admin/admin on the 20120223 build.
   |
|
   |
| Thanks to Tenzer in IRC, default root passwords can be found [next to
   |
| the downloads](https://download.joyent.com/pub/iso/).
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| ingenthr at Mar 18, 2012 20:43
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


