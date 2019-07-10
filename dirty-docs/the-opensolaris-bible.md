+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : The OpenSolaris Bible
</span>

</div>

<div class="pagesubheading">

This page last changed on Jan 09, 2015 by
<font color="#0050B2">ryan</font>.

</div>

The [OpenSolaris
Bible](http://www.amazon.com/OpenSolaris-Bible-Wiley-Nicholas-Solter/dp/
0470385480/ref=sr_1_1?s=books&ie=UTF8&qid=1318187762&sr=1-1) (2009)
was written by Nick Solter, Jerry Jelinek, and Dave Miner when they all
worked at Sun. Although the title refers to the OpenSolaris distribution
that no longer exists, most of the information of the book is still very
pertinent to SmartOS and its parent kernel,
[illumos](http://wiki.illumos.org/display/illumos/illumos+Home).

Thanks to [Jerry](Jerry%20Jelinek.html "Jerry Jelinek") for this
information.

<div class="table-wrap">

  ----------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---
  Chapter                                                              P
ertinent to SmartOS?
  -------------------------------------------------------------------- -
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---
  **I. Introduction to OpenSolaris.**

  1\. What Is OpenSolaris?                                             P
artially applicable but OpenSolaris as a project and community no longer
 exists. [Download](http://media.wiley.com/product_data/excerpt/80/04703
854/0470385480.pdf) chapter.

  2\. Installing OpenSolaris.                                          N
o.  SmartOS normally runs as a live image and is not installed.  More in
formation about setting up SmartOS is [here](http://wiki.smartos.org/dis
play/DOC/Getting+Started+with+SmartOS).

  3\. OpenSolaris Crash Course.                                        Y
es, except for the discussions about the GUI/Desktop and boot environmen
ts.

  **II. Using OpenSolaris**

  4\. The Desktop.                                                     N
o

  5\. Printers and Peripherals.                                        N
o

  6\. Software Management.                                             N
o.  SmartOS uses the *[pkgin](http://wiki.smartos.org/display/DOC/Workin
g+with+Packages)* software management system.

  **III. OpenSolaris File Systems, Networking, and Security.**

  7\. Disks, Local File Systems, and the Volume Manager.               Y
es, except for the section on the Volume Manager

  8\. ZFS.                                                             Y
es

  9\. Networking.                                                      Y
es, except for the discussion of NWAM

  10\. Network File Systems and Directory Services.                    Y
es

  11\. Security.                                                       Y
es

  **IV. OpenSolaris Reliability, Availability, and Serviceability.**

  12\. Fault Management.                                               Y
es

  13\. Service Management.                                             Y
es

  14\. Monitoring and Observability.                                   Y
es, except for the discussion of SNMP

  15\. DTrace.                                                         Y
es

  16\. Clustering for High Availability.                               N
o

  **V. OpenSolaris Virtualization.**

  17\. Virtualization Overview.                                        Y
es, but KVM is not covered and the discussion of the xVM hypervisor is n
ot applicable.

  18\. Resource Management.                                            Y
es

  19\. Zones.                                                          Y
es, but the discussion of the *ipkg* and *lx* branded zones is not appli
cable.  SmartOS uses *joyent* branded zones.  Recent work to resurrect t
he LX brand is underway, but it exceeds the scope of what was written at
 the time of this book's publishing.  Ipkg zones don't exist in SmartOS.
\


  20\. xVM Hypervisor.                                                 N
o, SmartOS uses [KVM](http://wiki.smartos.org/display/DOC/KVM).

  21\. Logical Domains (LDoms).                                        N
o

  22\. VirtualBox.                                                     P
artially applicable.  SmartOS can be run in a VirtualBox but KVM is the
preferred option for hosting another OS on SmartOS.

  **VI. Developing and Deploying on OpenSolaris.**

  23\. Deploying a Web Stack on OpenSolaris.                           Y
es

  24\. Developing on OpenSolaris.                                      Y
es
  ----------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---

</div>

Much more on
OpenSolaris [here](http://hub.opensolaris.org/bin/view/Main/).
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


