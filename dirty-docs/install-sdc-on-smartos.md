+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Install SDC on SmartOS
</span>

</div>

<div class="pagesubheading">

This page last changed on Dec 30, 2015 by
<font color="#0050B2">sigxcpu</font>.

</div>

SDC on SmartOS Installation (work in progress)
==================================================

### What We'll Achieve

A complete SDC installation with one **Head Node** and one **Compute
Node** in a (home) lab setup.

### Prerequisites

- a working *SmartOS* installation
- Internet connectivity
- a CPU with **VT-x** and **EPT** support (for KVM)

### Setup

##### Network setup

We will isolate the **admin** network of SDC because that has its own
DHCP server and we don't want interference in our current network.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
nictagadm add -l sdc_admin0
```

</div>

</div>

</div>

##### Headnode Descriptor

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-----------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
Pay attention to **vlan\_id** set on **300** on the 2nd NIC. I already h
ave a working DHCP installation at home and I didn't want SDC to conflic
t with my current setup. Its *external* network will have packets tagged
 with VLAN ID 300 and the same VLAN ID is configured on my border router
 for routing and NAT.
  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-----------------------

</div>

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
--
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
The 4GB virtual disk will be the boot disk (i.e. USB stick in real SDC).
  ---------------------------------------------------------------------
------------------------------------------------------------------------
--

</div>

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
{
  "alias": "sdc-headnode",
  "brand": "kvm",
  "ram": 8192,
  "vcpus": 8,
  "autoboot": false,
  "nics": [
    {
      "nic_tag": "sdc_admin0",
      "model": "virtio",
      "ip": "dhcp",
      "allow_dhcp_spoofing": true,
      "allow_ip_spoofing": true,
      "allow_mac_spoofing": true,
      "allow_restricted_traffic": true,
      "allow_unfiltered_promisc": true,
      "dhcp_server": true
    },
    {
      "nic_tag": "admin",
      "vlan_id": 300,
      "model": "virtio",
      "ip": "dhcp",
      "allow_dhcp_spoofing": true,
      "allow_ip_spoofing": true,
      "allow_mac_spoofing": true,
      "allow_restricted_traffic": true,
      "allow_unfiltered_promisc": true,
      "dhcp_server": true
    }
  ],
  "disks": [
    {
      "size": 4096,
      "model": "virtio"
    },
    {
      "size": 61440,
      "model": "virtio"
    }
  ]
}
```

</div>

</div>

</div>

##### Compute Node Descriptor

<div class="panelMacro">

  ---------------------------------------------------------------------
----------------------------------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
This is optional. I've wanted a CN to get the full experience.
  ---------------------------------------------------------------------
----------------------------------------------------------------

</div>

<div class="panelMacro">

  ---------------------------------------------------------------------
---------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
It boots over the network
  ---------------------------------------------------------------------
---------------------------

</div>

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
{
  "alias": "sdc-compute",
  "autoboot": false,
  "brand": "kvm",
  "boot": "order=n",
  "ram": 8192,
  "vcpus": 8,
  "autoboot": false,
  "nics": [
    {
      "nic_tag": "sdc_admin0",
      "model": "virtio",
      "ip": "dhcp",
      "allow_dhcp_spoofing": true,
      "allow_ip_spoofing": true,
      "allow_mac_spoofing": true,
      "allow_restricted_traffic": true,
      "allow_unfiltered_promisc": true
    },
    {
      "nic_tag": "admin",
      "vlan_id": 300,
      "model": "virtio",
      "ip": "dhcp",
      "allow_dhcp_spoofing": true,
      "allow_ip_spoofing": true,
      "allow_mac_spoofing": true,
      "allow_restricted_traffic": true,
      "allow_unfiltered_promisc": true
    }
  ],
  "disks": [
    {
      "size": 61440,
      "model": "virtio"
    }
  ]
}
```

</div>

</div>

</div>

##### SDC download and copy

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
--------------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
You need to adapt the usb image file name in *dd* command to your downlo
aded release. This is for 20151211T065814Z
  ---------------------------------------------------------------------
------------------------------------------------------------------------
--------------------------------------------

</div>

Place the above two files in */tmp* as *sdc-headnode.json* and
*sdc-compute.json*.

Run the following in SmartOS GZ (global zone).

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# cd /tmp
# curl -k -C - -O https://us-east.manta.joyent.com/Joyent_Dev/public/Sma
rtDataCenter/usb-latest.tgz
# tar xzvf usb-latest.tgz
# vmadm create -f sdc-headnode.json
# HNUUID=$(vmadm lookup alias="sdc-headnode")
# dd if=usb-release-20151210-20151211T065814Z-g2a31a50-4gb.img of=/dev/z
vol/rdsk/zones/${HNUUID}-disk0 bs=1024k
# mount -F pcfs /dev/zvol/dsk/zones/${HNUUID}-disk0:c /mnt
# sed -e 's/ttyb/ttya/;s/1,0,2,3/0,1,2,3/;s/default 0/default 1/' -i.sma
rtosbak /mnt/boot/grub/menu.lst*
# umount /mnt
# zfs snapshot zones/${HNUUID}-disk0@sdc-fixed
# vmadm start ${HNUUID}
# vmadm console ${HNUUID}
```

</div>

</div>

</div>

Proceed with install as described here:
<https://docs.joyent.com/private-cloud/install>

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---------------------------------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
Pay attention to assigned MAC addresses on the VM networks. The *admin*
network of SDC is the one tagged with *sdc\_admin0* in SmartOS. The *ext
ernal* SDC network is the one tagged with *admin* in SmartOS.
  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---------------------------------------------------------------

</div>

##### Compute Node setup

When the headnode is up and running you can proceed with compute node
installation.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# cd /tmp
# vmadm create -f sdc-compute.json
# CNUUID=$(vmadm lookup alias="sdc-compute")
# vmadm start ${CNUUID}
```

</div>

</div>

</div>

The CN setup is done through the **AdminUI** of SDC.

### Miscellaneous

You may want to disable UHCI controller because of repeated warnings
like

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
2015-12-30T09:52:35.452663+00:00 compute1 usba: [ID 691482 kern.warning]
 WARNING: /pci@0,0/pci1af4,1100@1,2 (uhci0): No SOF interrupts have been
 received, this USB UHCI host controller is unusable
```

</div>

</div>

</div>

This is done by running the below command on both HN and CN

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
rem_drv uhci
```

</div>

</div>

</div>

### Optional stuff

- make HN provisionable <https://github.com/joyent/sdc/wiki/FAQ>
- enable HTTP booting for CNs <https://github.com/joyent/sdc-booter>
    (you will also need to run *svcadm enable nginx* inside the dhcpd0
    zone in the HN)
- install and configure **sdc-docker**
    <https://github.com/joyent/sdc-docker>

### Sources

- <http://blog.shalman.org/running-sdc-coal-on-smartos/>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


