+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Managing Datasets
</span>

</div>

<div class="pagesubheading">

This page last changed on Oct 04, 2012 by
<font color="#0050B2">nahamu</font>.

</div>

<div class="panelMacro">

  ------------------------------------------------------------------- --
------------------------------------------------------------------------
-----------------------------
  ![](images/icons/emoticons/forbidden.gif){width="16" height="16"}   **
Deprecated**\
                                                                      Th
is page has been deprecated. Please see [Managing Images](Managing%20Ima
ges.html "Managing Images")
  ------------------------------------------------------------------- --
------------------------------------------------------------------------
-----------------------------

</div>

<div>

<ul>
<li>
[KVM Datasets](#ManagingDatasets-KVMDatasets)
</li>
- [Creating The Initial
    'Prototype' VM](#ManagingDatasets-CreatingTheInitial%27Prototype%27%
26nbsp%3BVM)
- [Creating A Dataset From an Existing
    VM](#ManagingDatasets-CreatingADatasetFromanExistingVM)
- [Transporting Datasets](#ManagingDatasets-TransportingDatasets)

<li>
[OS Level Virtualization Zone
Images](#ManagingDatasets-OSLevelVirtualizationZoneImages)
</li>
</ul>

</div>

KVM Datasets
================

Creating The Initial 'Prototype' VM
---------------------------------------

Follow the instructions
[here](How%20to%20create%20a%20Virtual%20Machine%20in%20SmartOS.html "Ho
w to create a Virtual Machine in SmartOS").

Creating A Dataset From an Existing VM
------------------------------------------

Once you have a VM you're happy with it can easily be cloned. First,
halt your vm from inside the guest. You can double check it shut down
with the command 'vmadm list -v'.

First, find the name of the zvol being used by your protoype VM:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# zfs list
NAME                                               USED  AVAIL  REFER  M
OUNTPOINT
zones                                             10.6G   136G   681M  /
zones
zones/184adf96-f4f7-4013-99e6-dbf10cbe85ae         681M   136G   681M  /
zones/184adf96-f4f7-4013-99e6-dbf10cbe85ae
zones/184adf96-f4f7-4013-99e6-dbf10cbe85ae-disk0  1.64G   136G  1.63G  -
zones/184adf96-f4f7-4013-99e6-dbf10cbe85ae/cores    31K  2.25G    31K  /
zones/184adf96-f4f7-4013-99e6-dbf10cbe85ae/cores
zones/config                                        68K   136G    68K  l
egacy
zones/cores                                         31K  10.0G    31K  /
zones/global/cores
zones/dump                                        4.00G   136G  4.00G  -
zones/opt                                         68.4M   136G  68.4M  l
egacy
zones/usbkey                                       127K   136G   127K  l
egacy
zones/var                                         6.49M   136G  6.49M  l
egacy
```

</div>

</div>

</div>

This will most likely be the uuid of the form '&lt;uuid&gt;-disk0', in
this case it's '184adf96-f4f7-4013-99e6-dbf10cbe85ae-disk0'.

With the latest versions of SmartOS requiring that all uuid's be real
uuid's, you now need to snapshot and clone your zvol to a new uuid for
use as another VM.

Pick a new uuid with the "uuid" command, then snapshot, clone, and
promote:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# uuid
f97638de-b666-11e1-84ae-5f23bb25050c
# zfs snapshot zones/184adf96-f4f7-4013-99e6-dbf10cbe85ae-disk0@f97638de
-b666-11e1-84ae-5f23bb25050c
# zfs clone zones/184adf96-f4f7-4013-99e6-dbf10cbe85ae-disk0@f97638de-b6
66-11e1-84ae-5f23bb25050c zones/f97638de-b666-11e1-84ae-5f23bb25050c
```

</div>

</div>

</div>

Create a new VM json spec for use with vmadm. The key is to add the new
image\_uuid in the disk section. Be sure to change the hostname, ip, and
anything else you want to be different:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
{
  "brand": "kvm",
  "vcpus": 1,
  "autoboot": false,
  "ram": 1024,
  "hostname": "clone01",
  "default_gateway": "192.168.2.1",
  "resolvers" : ["66.207.192.6", "206.223.173.7" ],
  "disks": [
    {
      "boot": true,
      "model": "virtio",
      "image_uuid": "f97638de-b666-11e1-84ae-5f23bb25050c",
      "size": 40960
    }
  ],
  "nics": [
    {
      "nic_tag": "admin",
      "model": "virtio",
      "ip": "192.168.2.73",
      "netmask": "255.255.255.0",
      "gateway": "192.168.2.1"
    }
  ]
}
```

</div>

</div>

</div>

Create the new VM:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# vmadm create < new_spec.json
```

</div>

</div>

</div>

This takes a snapshot of the prototype zvol and then uses this to form
the basis of a 'zfs clone'. In other words, until your VM differ's
significantly from the snapshot, it won't be taking up very much space!

Transporting Datasets
-------------------------

Note that you can also also use 'zfs send' and 'zfs recv' to transport
your VM prototype to other hosts. Simply send and receive the zvol.

OS Level Virtualization Zone Images
=======================================

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
----------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
**Under Development**\

The full set of features for doing this properly is still under developm
ent.\

For now, a set of instructions from the mailing list has been placed her
e as a place holder and initial guide.
  ---------------------------------------------------------------------
------------------------------------------------------------------------
----------------------------------------

</div>

There are two parts to the process:

First, there is a 'sm-prepare-image' script to be run inside a
SmartMachine that 'prepares' it for snapshotting. You can get this
script as part of the 'smtools' pkgsrc package that's available on the
2012Q1 package set. The best way to install this package is to 1) start
with the base/base64 image just released; or 2) install the package
directly using e.g. 'pkg\_add
<http://pkgsrc.joyent.com/sdc6/2012Q1/i386/All/smtools>'. The script
finishes by shutting down the image.

The second part will soon be encapsulated in a script to be run in the
global zone (still being tested), but it's not a big deal to do it
manually for now:

- snapshot the machine's ZFS filesystem (using 'zfs snapshot
    zones/xxx');
- import the snapshot as a new UUID ('zfs send zones/xxx@snapshot|zfs
    recv zones/new-image');
- optionally, send the snapshot into a ZFS stream file ('zfs send
    zones/xxx@snapshot|bzip2 &gt; image.zfs.tbz2') that you can pass
    around as needed and import on other systems using 'zfs recv';
- provision a machine using the new image.

See Also: <https://gist.github.com/3090799>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


