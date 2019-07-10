+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : How to create a Virtual
Machine in SmartOS </span>

</div>

<div class="pagesubheading">

This page last changed on Jul 23, 2015 by
<font color="#0050B2">tpaul</font>.

</div>

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
**New!**\

March 26, 2012: [VM Guest tools](https://github.com/joyent/smartos-vmtoo
ls) contains scripts and drivers that are used to create virtualized mac
hine images in SmartOS.
  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------

</div>

In SmartOS, virtual machines are created using the `vmadm create` tool.
This tool takes a JSON payload and creates either a 'kvm' or 'joyent'
brand zone with the properties specified in the input JSON. Normal
output is a series of single-line JSON objects with type set to one of:

- success
- failure
- update
- notice

each object having at least the 'type' and 'message' fields. A message
of type 'success' or 'failure' will be followed by the process exiting
with the exit status 0 indicating success and all other exits indicating
failure.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
vmadm create -f <filename.json>
```

</div>

</div>

</div>

Getting Started
===================

You will need

- The latest copy of SmartOS, available from
    <http://download.joyent.com> (release details
    [here](Download%20SmartOS.html "Download SmartOS"))
- The ISO of your OS of choice
- A VNC client

The Machine JSON Description
================================

Save the code snippet below to a file called "vmspec.json". You can make
changes to the networks and other variables as appropriate. This is by
no means an exhaustive list of all options. For all options see
[vmadm(1m)](https://smartos.org/man/1m/vmadm). (Sizes are listed in MiB)

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
{
  "brand": "kvm",
  "vcpus": 1,
  "autoboot": false,
  "ram": 1024,
  "resolvers": ["208.67.222.222", "208.67.220.220"],
  "disks": [
    {
      "boot": true,
      "model": "virtio",
      "size": 40960
    }
  ],
  "nics": [
    {
      "nic_tag": "admin",
      "model": "virtio",
      "ip": "10.88.88.51",
      "netmask": "255.255.255.0",
      "gateway": "10.88.88.1",
      "primary": 1
    }
  ]
}
```

</div>

</div>

</div>

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
----------------------------------------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   For
releases before December 15, 2011, you will need to include the `default
_gateway` attribute in the root:
                                                                    <div
 class="code panel" style="border-width: 1px;">

                                                                    <div
 class="codeContent panelContent">

                                                                    <div
 id="root">

                                                                    ```
{.theme: .Confluence; .brush: .java; .gutter: .false}
                                                                    "def
ault_gateway": "10.88.88.1",
                                                                    ```

                                                                    </di
v>

                                                                    </di
v>

                                                                    </di
v>

                                                                    This
 must match the gateway of one of the nics so that the default gateway a
nd resolvers will be set via DHCP in the VM.
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
----------------------------------------------

</div>

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
----------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   When
 installing OS's that do not ship with `virtio` support instead of using
 `virtio` on the disk for the model use `ide` and `e1000` for the networ
k model.
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
----------

</div>

Create the Empty Virtual Machine
====================================

Create the empty virtual machine using the create-machine tool. Please
note that the virtual machine will not be running.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
$ vmadm create
```

</div>

</div>

</div>

Note the UUID in the last step. This UUID is the ID of the VM and will
be used to reference it for the rest of its lifecycle.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
$ vmadm create < vmspec.json

{"percent":1,"type":"update","message":"checking and applying defaults t
o payload"}
{"percent":2,"type":"update","message":"checking required datasets"}
{"percent":28,"type":"update","message":"we have all necessary datasets"
}
{"percent":29,"type":"update","message":"creating volumes"}
{"percent":51,"type":"update","message":"creating zone container"}
{"percent":94,"type":"update","message":"storing zone metadata"}
{"uuid":"b8ab5fc1-8576-45ef-bb51-9826b52a4651","type":"success","message
":"created VM"}
```

</div>

</div>

</div>

Copy your OS ISO to the zone
================================

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
$ cd /zones/b8ab5fc1-8576-45ef-bb51-9826b52a4651/root/
$ wget http://mirrors.debian.com/path_to_an_iso/debian.iso
```

</div>

</div>

</div>

Ensure permissions are correct on the ISO
=============================================

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
$ chown root debian.iso
$ chmod u+r debian.iso
```

</div>

</div>

</div>

Boot the VM from the ISO Image
==================================

`vmadm` is the virtual machine administration tool. It is used to manage
the lifecycle of a virtual machine after it already exists. We will boot
the virtual machine we have just created, but tell it to boot off of the
ISO image the first time it comes up.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
vmadm boot b8ab5fc1-8576-45ef-bb51-9826b52a4651 order=cd,once=d cdrom=/d
ebian.iso,ide
```

</div>

</div>

</div>

Please note that the path for the ISO image will be the relative path of
the ISO to the zone you are in. This is why it starts with the '/'

Use VNC to Connect to the VM
================================

The `vmadm` tool can print out the information on the VM. You can also
append a section to print specificially.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
$ vmadm info b8ab5fc1-8576-45ef-bb51-9826b52a4651 vnc

{
  "vnc": {
    "display": 39565,
    "port": 45465,
    "host": "10.99.99.7"
  }
}
```

</div>

</div>

</div>

Your VM is now running. You can shutdown your virtual machine and it
will still remain on disk. To learn more about managing the lifecycle of
a virtual machine, run `vmadm --help`.

Troubleshooting
-------------------

### Zone Networking Issues

If you are running SmartOS as a guest vm then you might have networking
issues with your zones. In order to fix this we need to create a
bridge.\
If you look
at <https://github.com/joyent/smartos-overlay/blob/master/lib/svc/method
/net-physical#L179>
You can see that the script will create a bridge for vmare products but
if you are using VirtualBox or Parallells then you need to do it
manually.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
$ ifconfig -a
e1000g0: flags=1100943<UP,BROADCAST,RUNNING,PROMISC,MULTICAST,ROUTER,IPv
4> mtu 1500 index 2
        inet 10.216.214.7 netmask ffffff00 broadcast 10.216.214.255
        ether 8:0:27:e1:35:cb

$ dladm create-bridge -l e1000g0 vboxbr
```

</div>

</div>

</div>

Your zones should now be able to access the network. You don't need to
change the nic\_tag for any of the zones, leave them as "admin" or
"external".

There is a way to make this happen on boot with my adding an smf script
to /opt/custom/smf. Here is a nice write up that shows you how it's
done. <http://www.psychicfriends.net/blog/archives/2012/03/21/smartosorg
_run_things_at_boot.html#003979>

Further Reading
===================

Those versed in JavaScript can learn a lot more by reading the [vmadm.js
source](https://github.com/joyent/smartos-live/blob/master/src/vm/sbin/v
madm.js).

<div class="tabletitle">


Comments:
---------

</a>

</div>

+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I am having some issue's setting up multiple VM's on smartos.  The
   |
| problem is that whenever I try to boot up a VM with one already runnin
g  |
| I get the following in my /var/adm/messages:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| Oct 25 03:42:09 00-21-28-6a-c9-44 genunix: [ID 408114 kern.info] /pseu
do |
| /zconsnex@1/zcons@0 (zcons0) online
   |
| Oct 25 03:42:10 00-21-28-6a-c9-44 root: [ID 702911 daemon.error] zone
26 |
| eed86d-e235-4233-8380-41ebf24d1291  undefined VNIC net0 (global NIC ne
t1 |
| )
   |
| Oct 25 03:42:10 00-21-28-6a-c9-44 root: [ID 702911 daemon.error] zone
26 |
| eed86d-e235-4233-8380-41ebf24d1291  error removing flows for net0
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| I have looked high and low for any documentation pertaining to
   |
| networking setup for VM's and haven't been able to find anything as of
   |
| yet.  Is there documentation somewhere where I would be able to find o
ut |
| how to assign VM's virtual nics?  I attempted to add additional vnics
   |
| with:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| dladm create-vnic -l etherstub0 net1
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| This created the vnic, however I cannot figure out how to assign a VM
to |
| use that vnic instead of net0.  Any help is appreciated.
   |
|
   |
| /GC
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
| geoff.cardamone@mlb.com at Oct 25, 2011 03:58
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I was tripped up by this as well.
   |
|
   |
| SmartOs seems to do the vnic wiring automatically if you provide "admi
n" |
| as the physical device.
   |
|
   |
| In the json config for creating the zone use "nic\_tag": "admin"
   |
|
   |
| After the fact I was able to modify my /etc/zones/{guid}.xml by changi
ng |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| <network physical="net0" mac-addr="a2:ad:5f:2d:c6:8d" global-nic="e100
0g |
| 0">
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| to:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| <network physical="net0" mac-addr="a2:ad:5f:2d:c6:8d" global-nic="admi
n" |
| >
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| The end result after a zoneadm boot is
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| [root@00-0c-29-58-7c-ba ~]# dladm show-vnic
   |
|
   |
| LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
   |
| net0         e1000g0    0     a2:ad:5f:2d:c6:8d fixed       0    5010d
34 |
| a-c993-4dd4-892f-c0d4c42c7934
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| I am using smartosplus64 machines. Hope this helps for the KVM ones.
   |
|
   |
| /KP
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
| kevpie at Oct 25, 2011 16:53
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Kevin,
   |
|
   |
| Thanks for taking the time to respond.  I attempted to boot a second v
m  |
| and the following is what I am still seeing:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| ct 25 18:31:15 00-21-28-6a-c9-44 genunix: [ID 408114 kern.info] /pseud
o/ |
| zconsnex@1/zcons@1 (zcons1) online
   |
| Oct 25 18:31:16 00-21-28-6a-c9-44 mac: [ID 469746 kern.info] NOTICE: v
ni |
| c1053 registered
   |
| Oct 25 18:31:17 00-21-28-6a-c9-44 mac: [ID 736570 kern.info] NOTICE: v
ni |
| c1053 unregistered
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| Also:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| [root@00-21-28-6a-c9-44 ~]# dladm show-vnic
   |
| LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
   |
| net0         igb0       0     b2:14:a3:36:28:b  fixed       0    26eed
86 |
| d-e235-4233-8380-41ebf24d1291
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| So it appears that a single KVM is working correctly, however I am
   |
| unable to get a second to boot.  I suppose that I could try some of th
e  |
| Joynet datasets and see if I get a different result.  I also tried to
   |
| set the /etc/zones/57f55e19-253f-4d98-baf8-7ebab4af17c7.xml to:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| <network physical="net1" mac-addr="b2:23:b4:85:c3:6d" global-nic="admi
n" |
| >\
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| EDIT:
   |
| </p>
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| [root@00-21-28-6a-c9-44 /etc/zonedladm show-vnicLINK         OVER
   |
| SPEED MACADDRESS        MACADDRTYPE VID  ZONE
   |
| net0         igb0       0     b2:14:a3:36:28:b  fixed       0    26eed
86 |
| d-e235-4233-8380-41ebf24d1291
   |
| net1         igb0       0     0:21:28:6a:c9:45  fixed       0    57f55
e1 |
| 9-253f-4d98-baf8-7ebab4af17c7
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| and it produced the same output in syslog.  I then tried by creating a
   |
| net1 vnic and it still wouldn't boot.  Is there another log somewhere
   |
| were there may be additional info?  I haven't found anything just yet.
   |
|
   |
| Thanks again,
   |
|
   |
| /GC
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
| geoff.cardamone@mlb.com at Oct 25, 2011 18:41
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| When I have 2 zones booted they both have net0.
   |
|
   |
| Try allowing smartos to use net0 for all of you VMs.
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| [root@00-0c-29-58-7c-ba ~]# dladm show-vnic
   |
|
   |
| LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
   |
| net0         e1000g0    0     a2:ad:5f:2d:c6:8d fixed       0    5010d
34 |
| a-c993-4dd4-892f-c0d4c42c7934
   |
| net0         e1000g0    0     a2:c2:c1:a6:16:82 fixed       0    7eab3
fe |
| 1-e884-4381-a849-da2c0c6cfcde
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| The original documentation published on one of the other pages
   |
| recommended the dladm create-vnic -l &lt;phys&gt; &lt;vnic&gt;. That w
as |
| removed in favour of the "nic\_tag": "admin"
   |
|
   |
| The autoboot started working when I put everything back to **net0** an
d  |
| **admin**.
   |
|
   |
| You may want to try using a pair of new VMs created using the
   |
| create-machine command.
   |
|
   |
| Hope this helps.
   |
|
   |
| /KP
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
| kevpie at Oct 25, 2011 19:21
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Kevin,
   |
|
   |
| Something is still keeping the second VM from booting.  I started two
   |
| fresh VM's up:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| [root@00-21-28-6a-c9-44 /zones]# vmadm boot e8b80104-ab7f-4f6d-b1fc-cf
3e |
| 0e97c518 order=cd,once=d cdrom=/centos6.iso,ide
   |
| [root@00-21-28-6a-c9-44 /zones]# dladm show-vnic
   |
| LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
   |
| net0         igb0       0     b2:24:b9:2e:99:8  fixed       0    de436
c6 |
| 4-19a0-4398-ba18-2ce85f4337f3
   |
| net0         igb0       0     b2:24:b9:4a:31:97 fixed       0    e8b80
10 |
| 4-ab7f-4f6d-b1fc-cf3e0e97c518
   |
| [root@00-21-28-6a-c9-44 /zones]# dladm show-vnic
   |
| LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
   |
| net0         igb0       0     b2:24:b9:2e:99:8  fixed       0    de436
c6 |
| 4-19a0-4398-ba18-2ce85f4337f3
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| I am going to keep looking for some additional info, my logs again onl
y  |
| show the following,
   |
|
   |
| VM boots:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| Oct 25 19:56:11 00-21-28-6a-c9-44 genunix: [ID 408114 kern.info] /pseu
do |
| /zconsnex@1/zcons@0 (zcons0) online
   |
| Oct 25 19:56:12 00-21-28-6a-c9-44 mac: [ID 469746 kern.info] NOTICE: v
ni |
| c1069 registered
   |
| Oct 25 19:56:12 00-21-28-6a-c9-44 root: [ID 702911 daemon.error] zone
e8 |
| b80104-ab7f-4f6d-b1fc-cf3e0e97c518  error setting VNIC allowed-ip  net
0  |
| undefined
   |
| Oct 25 19:56:12 00-21-28-6a-c9-44 kvm: [ID 420667 kern.info] kvm_lapic
_r |
| eset: vcpu=ffffff05174a6000, id=0, base_msr= fee00100 PRIx64 base_addr
es |
| s=fee00000
   |
| Oct 25 19:56:12 00-21-28-6a-c9-44 kvm: [ID 710719 kern.info] vmcs revi
si |
| on_id = e
   |
| Oct 25 19:56:12 00-21-28-6a-c9-44 kvm: [ID 420667 kern.info] kvm_lapic
_r |
| eset: vcpu=ffffff0500b6c000, id=1, base_msr= fee00000 PRIx64 base_addr
es |
| s=fee00000
   |
| Oct 25 19:56:12 00-21-28-6a-c9-44 kvm: [ID 710719 kern.info] vmcs revi
si |
| on_id = e
   |
| Oct 25 19:56:16 00-21-28-6a-c9-44 kvm: [ID 391722 kern.info] unhandled
 w |
| rmsr: 0x0 data 3000000018
   |
| Oct 25 19:56:16 00-21-28-6a-c9-44 last message repeated 1 time
   |
| Oct 25 19:56:16 00-21-28-6a-c9-44 kvm: [ID 391722 kern.info] unhandled
 w |
| rmsr: 0x55171e data 0
   |
| Oct 25 19:56:16 00-21-28-6a-c9-44 kvm: [ID 391722 kern.info] unhandled
 w |
| rmsr: 0x0 data 0
   |
| Oct 25 19:56:16 00-21-28-6a-c9-44 last message repeated 2 times
   |
| Oct 25 19:56:16 00-21-28-6a-c9-44 kvm: [ID 291337 kern.info] vcpu 1 re
ce |
| ived sipi with vector # 10
   |
| Oct 25 19:56:16 00-21-28-6a-c9-44 kvm: [ID 420667 kern.info] kvm_lapic
_r |
| eset: vcpu=ffffff0500b6c000, id=1, base_msr= fee00800 PRIx64 base_addr
es |
| s=fee00000
   |
| Oct 25 19:56:17 00-21-28-6a-c9-44 kvm: [ID 391722 kern.info] unhandled
 w |
| rmsr: 0x0 data 0
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| doesnt boot:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| Oct 25 19:54:56 00-21-28-6a-c9-44 genunix: [ID 408114 kern.info] /pseu
do |
| /zconsnex@1/zcons@1 (zcons1) online
   |
| Oct 25 19:54:56 00-21-28-6a-c9-44 mac: [ID 469746 kern.info] NOTICE: v
ni |
| c1067 registered
   |
| Oct 25 19:54:56 00-21-28-6a-c9-44 root: [ID 702911 daemon.error] zone
e8 |
| b80104-ab7f-4f6d-b1fc-cf3e0e97c518  error setting VNIC allowed-ip  net
0  |
| undefined
   |
| Oct 25 19:54:56 00-21-28-6a-c9-44 kvm: [ID 420667 kern.info] kvm_lapic
_r |
| eset: vcpu=ffffff04ffeca000, id=0, base_msr= fee00100 PRIx64 base_addr
es |
| s=fee00000
   |
| Oct 25 19:54:56 00-21-28-6a-c9-44 kvm: [ID 710719 kern.info] vmcs revi
si |
| on_id = e
   |
| Oct 25 19:54:56 00-21-28-6a-c9-44 kvm: [ID 420667 kern.info] kvm_lapic
_r |
| eset: vcpu=ffffff0509be2000, id=1, base_msr= fee00000 PRIx64 base_addr
es |
| s=fee00000
   |
| Oct 25 19:54:56 00-21-28-6a-c9-44 kvm: [ID 710719 kern.info] vmcs revi
si |
| on_id = e
   |
| Oct 25 19:55:04 00-21-28-6a-c9-44 mac: [ID 736570 kern.info] NOTICE: v
ni |
| c1067 unregistered
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| not sure if maybe its something to do with the amount of RAM I am givi
ng |
| each host, or the number of vcpus
   |
|
   |
| /GC
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
| geoff.cardamone@mlb.com at Oct 25, 2011 19:59
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Just to update;  when i use a joyent dataset for centos6 as a second V
M, |
| the VM does boot.
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
| geoff.cardamone@mlb.com at Oct 25, 2011 21:30
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Is there a current mechanism to clone an existing VM?
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
| michael.smith@usace.army.mil at Oct 30, 2011 18:06
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


