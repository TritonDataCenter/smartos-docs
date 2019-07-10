+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Questions from SmartOS
the Modern OS Webinar </span>

</div>

<div class="pagesubheading">

This page last changed on Jan 28, 2012 by
<font color="#0050B2">benr@joyent.com</font>.

</div>

Q&A from the webinar [SmartOS: The Modern Operating
System](http://smartos.org/2011/08/24/video-smartos-the-modern-operating
-system/)
with Bryan Cantrill, August 23, 2011.

<div>

<ul>
<li>
[History](#QuestionsfromSmartOStheModernOSWebinar-History)
</li>
- [Q: What made you decide to port KVM to SmartOS instead of using the
    Xen code that had been previously integrated into
    Solaris?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AWhatmadeyoudec
idetoportKVMtoSmartOSinsteadofusingtheXencodethathadbeenpreviouslyintegr
atedintoSolaris%3F)

<li>
[Current
Capabilities](#QuestionsfromSmartOStheModernOSWebinar-CurrentCapabilitie
s)
</li>
- [Q: Are you running the KVM instances within zones? Is this a new
    type of container, or a standard full-root or sparse
    zone?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AAreyourunningtheK
VMinstanceswithinzones%3FIsthisanewtypeofcontainer%2Corastandardfullroot
orsparsezone%3F)
- [Q: Will customers be limited in their use of DTrace within SmartOS
    zones, and will they have some interface to use DTrace to observe
    KVM
    instances?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AWillcustomer
sbelimitedintheiruseofDTracewithinSmartOSzones%2Candwilltheyhavesomeinte
rfacetouseDTracetoobserveKVMinstances%3F)
- [Q: Do you have any metering built in for resource-based
    billing?](#QuestionsfromSmartOStheModernOSWebinar-Q%3ADoyouhaveanyme
teringbuiltinforresourcebasedbilling%3F)
- [Q: Just wondering about how SmartOS would address GPU's and
    passthrough to
    virtualized instances.](#QuestionsfromSmartOStheModernOSWebinar-Q%3A
JustwonderingabouthowSmartOSwouldaddressGPU%27sandpassthroughtovirtualiz
edinstances.)
- [Q: At what level have you seen database virtualization if at all?
    Take Oracle or MySQL. Possible to do those at the OS Virt level or
    do you have to go into the H/W layer? Seems an area not
    optimized yet.](#QuestionsfromSmartOStheModernOSWebinar-Q%3AAtwhatle
velhaveyouseendatabasevirtualizationifatall%3FTakeOracleorMySQL.Possible
todothoseattheOSVirtlevelordoyouhavetogointotheH%2FWlayer%3FSeemsanarean
otoptimizedyet.)
- [Q: How do you solve storage? Is a VM bound to its SmartOS host? Or
    do you distribute VMs via NFS or similar? As far as I know one ZFS
    can only be used by one node at
    a time.](#QuestionsfromSmartOStheModernOSWebinar-Q%3AHowdoyousolvest
orage%3FIsaVMboundtoitsSmartOShost%3FOrdoyoudistributeVMsviaNFSorsimilar
%3FAsfarasIknowoneZFScanonlybeusedbyonenodeatatime.)
- [Q: What is the maximum VM size under SmartOS KVM? \# of vCPUs and
    GB of
    RAM?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AWhatisthemaximumVM
sizeunderSmartOSKVM%3F%23ofvCPUsandGBofRAM%3F)
- [Q: What about graphical management (VMware, vSphere, vCenter, or
    similar)?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AWhataboutgrap
hicalmanagement%28VMware%2CvSphere%2CvCenter%2Corsimilar%29%3F)
- [Q: Am I correct in understanding that SmartDataCenter is a
    commercial offering aimed at operators of large
    installations?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AAmIcorre
ctinunderstandingthatSmartDataCenterisacommercialofferingaimedatoperator
soflargeinstallations%3F)
- [Q: Could you please talk a bit more about ZFS + KVM? What's the
    performance penalty of ext3 on top of ZFS, vs if you could just use
    ZFS
    directly?](#QuestionsfromSmartOStheModernOSWebinar-Q%3ACouldyoupleas
etalkabitmoreaboutZFSKVM%3FWhat%27stheperformancepenaltyofext3ontopofZFS
%2CvsifyoucouldjustuseZFSdirectly%3F)

<li>
[Roadmap](#QuestionsfromSmartOStheModernOSWebinar-Roadmap)
</li>
- [Q: How closely will the SmartOS public releases mirror what the
    JoyentCloud operates? I find this important for in-house
    dev/qa/staging environments prior to cloud deployment. Will the
    Joyent package repository be directly
    compatible?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AHowcloselyw
illtheSmartOSpublicreleasesmirrorwhattheJoyentCloudoperates%3FIfindthisi
mportantforinhousedev%2Fqa%2Fstagingenvironmentspriortoclouddeployment.W
illtheJoyentpackagerepositorybedirectlycompatible%3F)
- [Q: Do you plan to port SPICE to your QEMU implementation for
    VDI?](#QuestionsfromSmartOStheModernOSWebinar-Q%3ADoyouplantoportSPI
CEtoyourQEMUimplementationforVDI%3F)
- [Q: Given obvious (and proper) Joyent business prioritization, how
    far away are "usability" features of SmartOS like installer,
    updaters or patches, etc. Would like to start doing Proof of Concept
    type work for enterprise but need some
    of that.](#QuestionsfromSmartOStheModernOSWebinar-Q%3AGivenobvious%2
8andproper%29Joyentbusinessprioritization%2Chowfarawayare%22usability%22
featuresofSmartOSlikeinstaller%2Cupdatersorpatches%2Cetc.Wouldliketostar
tdoingProofofConcepttypeworkforenterprisebutneedsomeofthat.)
- [Q: Are you planning to include a package manager in future SmartOS
    builds?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AAreyouplanningt
oincludeapackagemanagerinfutureSmartOSbuilds%3F)
- [Q: Any chances we'll see a free but limited functionality edition
    of
    SmartDataCenter?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AAnycha
nceswe%27llseeafreebutlimitedfunctionalityeditionofSmartDataCenter%3F)
- [Q: What about cloud orchestration layers on top of SmartOS -
    e.g. OpenStack. Anything jointly in the
    works?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AWhataboutcloudor
chestrationlayersontopofSmartOSe.g.OpenStack.Anythingjointlyintheworks%3
F)
- [Q: I'm a node.js developer using XenServer on some dev servers I've
    built myself (hacked support for software RAID). How can I get
    started experimenting with SmartOS as a replacement for
    XenServer?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AI%27manode.j
sdeveloperusingXenServeronsomedevserversI%27vebuiltmyself%28hackedsuppor
tforsoftwareRAID%29.HowcanIgetstartedexperimentingwithSmartOSasareplacem
entforXenServer%3F)
- [Q: How about high availability? Is it possible to move a VM from
    one host to another. Preferably while it is
    running?](#QuestionsfromSmartOStheModernOSWebinar-Q%3AHowabouthighav
ailability%3FIsitpossibletomoveaVMfromonehosttoanother.Preferablywhileit
isrunning%3F)

</ul>

</div>

History
===========

### Q: What made you decide to port KVM to SmartOS instead of using
the Xen code that had been previously integrated into Solaris?

Xen required guest modification but did not improve performance, today
it's using hardware virtualization rather than paravirtualization. It's
been end-of-lifed by Sun/Oracle, so it just didn't make sense for us.

Current Capabilities
========================

### Q: Are you running the KVM instances within zones? Is this a new
 type of container, or a standard full-root or sparse zone?

It's a [sparse zone](http://en.wikipedia.org/wiki/Solaris_Containers),
we are running the [QEMU](http://en.wikipedia.org/wiki/Qemu) instance
within a container. In SmartOS you can run it in a container or not, but
in SmartDataCenter we always do, because that's our basic unit of
accountability, observability, etc. This also happens to make it very
secure.

### Q: Will customers be limited in their use of DTrace within Smart
OS zones, and will they have some interface to use DTrace to observe KVM
 instances?

You can't see the entire system from within a zone. But we have added a
bunch features to add more capabilities to the local zone, such as tick
probes, to enable better use of DTrace within the local zone.

To use DTrace to observe KVM instances, if you're using SmartOS you can
go to the global zone. The challenge is how you build on DTrace to go up
the stack and into the guest.

### Q: Do you have any metering built in for resource-based billing?

Yes, in SmartDataCenter.

### Q: Just wondering about how SmartOS would address GPU's and pass
through to virtualized instances.

We see limited business applicability for this in the cloud (our main
area of interest), but we'd love for the community to tackle it.

### Q: At what level have you seen database virtualization if at all
? Take Oracle or MySQL. Possible to do those at the OS Virt level or do
you have to go into the H/W layer? Seems an area not optimized yet.

In fact, much of zones uptake by enterprise was around database
virtualization, because it's much easier to virtualize at the OS layer
than in the database itself. We run lots of databases in the [Joyent
cloud](http://www.joyentcloud.com/) for this reason.

### Q: How do you solve storage? Is a VM bound to its SmartOS host?
Or do you distribute VMs via NFS or similar? As far as I know one ZFS ca
n only be used by one node at a time.

On SmartOS, you can run a VM locally on a local zpool or you can run it
via NFS (for example).

### Q: What is the maximum VM size under SmartOS KVM? \# of vCPUs an
d GB of RAM?

Our limits are the same as the KVM limitations: up to 256 vCPUs and up
to 2 TB of virtual memory. We have not actually tested the latter.

### Q: What about graphical management (VMware, vSphere, vCenter, or
 similar)?

That's in
[SmartDataCenter](http://www.joyent.com/products/smartdatacenter/).
SmartOS is just for a single node, SmartDataCenter lets you manage an
entire cloud, with a web user interfaces for operators and users.

### Q: Am I correct in understanding that SmartDataCenter is a comme
rcial offering aimed at operators of large installations?

It's for anyone who wants higher-level features. Though it's designed to
manage thousands of nodes, if you have one node to manage, talk to us
and we'll see what the right path forward is for you.

### Q: Could you please talk a bit more about ZFS + KVM? What's the
performance penalty of ext3 on top of ZFS, vs if you could just use ZFS
directly?

That's an ext3 question and, if you're asking it, you should probably be
running directly on ZFS and using OS-level virtualization.

Roadmap
===========

### Q: How closely will the SmartOS public releases mirror what the
JoyentCloud operates? I find this important for in-house dev/qa/staging
environments prior to cloud deployment. Will the Joyent package reposito
ry be directly compatible?

The objective is to have a smooth path to migrate from a public cloud to
a private cloud and vice-versa, and this is coming soon.

### Q: Do you plan to port SPICE to your QEMU implementation for VDI
?

We don't intend to do that, we see desktop virtualization as more of an
enterprise concern, but we would welcome a community member taking it
on.

### Q: Given obvious (and proper) Joyent business prioritization, ho
w far away are "usability" features of SmartOS like installer, updaters
or patches, etc. Would like to start doing Proof of Concept type work fo
r enterprise but need some of that.

An installer would be tough, because we don't actually install SmartOS
ourselves - we boot out of USB or flash and run from DRAM. Given our
architecture, it wouldn't be too difficult to develop an installer, and
we'd love for someone in the community to do it, but it's not a top
priority for Joyent.

### Q: Are you planning to include a package manager in future Smart
OS builds?

Yes, it's just a matter of integrating bits and pieces. In the meantime,
see [Installing
pkgsrc/pkgin](http://wiki.smartos.org/display/DOC/How+to+Use+the+SmartOS
+ISO+Image#HowtoUsetheSmartOSISOImage-Installingpkgsrc%2Fpkgin).

### Q: Any chances we'll see a free but limited functionality editio
n of SmartDataCenter?

Definitely a non-zero chance, depending on community interest.

### Q: What about cloud orchestration layers on top of SmartOS - e.g
. OpenStack. Anything jointly in the works?

We would love to see OpenStack support SmartOS as a hypervisor. If
there's anything we can do to enable support by OpenStack we would be
happy to do it.

### Q: I'm a node.js developer using XenServer on some dev servers I
've built myself (hacked support for software RAID). How can I get start
ed experimenting with SmartOS as a replacement for XenServer?

For starters, see
[here](Getting%20Started%20with%20SmartOS.html "Getting Started with Sma
rtOS")
- and stay tuned for future developments!

### Q: How about high availability? Is it possible to move a VM from
 one host to another. Preferably while it is running?

Yes, one of the major advantages of hardware virtualization over OS
virtualization is that, in the latter, because the kernel is running on
bare metal, you can't take that state and just move it somewhere. With
hardware-based virtualization, you can do that. QEMU live migration can
be used with SmartOS and we are integrating that into SmartDataCenter,
scheduled for roughly October 1st.
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


