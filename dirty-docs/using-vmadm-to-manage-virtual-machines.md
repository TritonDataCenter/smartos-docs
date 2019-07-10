+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Using vmadm to manage
virtual machines </span>

</div>

<div class="pagesubheading">

This page last changed on Apr 18, 2016 by
<font color="#0050B2">tpaul</font>.

</div>

<div>

<ul>
<li>
[Listing VMs](#Usingvmadmtomanagevirtualmachines-ListingVMs)
</li>
<li>
[Creating a new VM](#Usingvmadmtomanagevirtualmachines-CreatinganewVM)
</li>
<li>
[Getting a VMs
properties](#Usingvmadmtomanagevirtualmachines-GettingaVMsproperties)
</li>
<li>
[Lookup a VM by IP](#Usingvmadmtomanagevirtualmachines-LookupaVMbyIP)
</li>
<li>
[Looking up all 128M VMs with an alias that starts with 'a' or
'b':](#Usingvmadmtomanagevirtualmachines-Lookingupall128MVMswithanaliast
hatstartswith%27a%27or%27b%27%3A)
</li>
<li>
[Updating a VM](#Usingvmadmtomanagevirtualmachines-UpdatingaVM)
</li>
<li>
[Add a NIC to a VM then remove
it](#Usingvmadmtomanagevirtualmachines-AddaNICtoaVMthenremoveit)
</li>
<li>
[Add a disk to a VM then remove
it](#Usingvmadmtomanagevirtualmachines-AddadisktoaVMthenremoveit)
</li>
<li>
[Add a CDROM](#Usingvmadmtomanagevirtualmachines-AddaCDROM)
</li>
<li>
[Stopping a VM](#Usingvmadmtomanagevirtualmachines-StoppingaVM)
</li>
<li>
[Starting a VM](#Usingvmadmtomanagevirtualmachines-StartingaVM)
</li>
<li>
[Rebooting a VM](#Usingvmadmtomanagevirtualmachines-RebootingaVM)
</li>
<li>
[Deleting a VM](#Usingvmadmtomanagevirtualmachines-DeletingaVM)
</li>
<li>
[Moving a VM Between
Servers](#Usingvmadmtomanagevirtualmachines-MovingaVMBetweenServers)
</li>
- [Preserving
    snapshots](#Usingvmadmtomanagevirtualmachines-Preservingsnapshots)

<li>
[Changing the Virtual Hardware of a KVM
Zone](#Usingvmadmtomanagevirtualmachines-ChangingtheVirtualHardwareofaKV
MZone)
</li>
<li>
[See also](#Usingvmadmtomanagevirtualmachines-Seealso)
</li>
</ul>

</div>

How to use the vmadm command in the [latest (Dec 13, 2011) release of
SmartOS](http://wiki.smartos.org/display/DOC/Download+SmartOS).

Listing VMs
===============

Default fields + sort:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list
UUID                                  TYPE  RAM      STATE             A
LIAS
1e6ea123-dca0-44e6-8c0c-34c7f543fe82  OS    128      running           z
one55
20de2bfc-56de-4cd9-8e25-80b017615788  OS    128      running           b
illapi0
2508eead-dc8f-4df5-baf9-4ce6341f08ed  OS    128      running           z
one56
29bdabe1-ff9e-4387-9316-39961d5dbe5c  OS    128      running           a
dminui0
384de5e9-c9d9-4382-9dd3-949ab410be45  OS    128      running           r
edis0
56a47549-bceb-48d7-b67e-fd390d083f09  OS    128      running           p
ortal0
5c12a3ef-e60c-479a-a6be-ba93712a3893  OS    128      running           a
mon0
a7a4cb02-210a-4ccf-9744-99e3982148b0  OS    128      running           c
loudapi0
2811071a-5edc-438a-9b7b-e3b81e8829c5  OS    256      running           u
fds0
8d01d99b-2b18-41c6-8fec-7209e2a9eef3  OS    512      running           r
iak0
c3a03fac-dc2c-42ba-aff7-d6fd7a36967a  OS    1024     running           c
a0
d104e56e-43df-4d0f-b5ce-43f39d0fef46  KVM   1024     running           u
buntu1
2b99a408-7dfb-445e-cfa1-bed4e14a2509  OS    32768    running           a
ssets0
a4212873-e04a-ef84-b85c-c5aea32ce5f8  OS    32768    running           d
hcpd0
ad170576-3ad3-e201-cd89-ad4260c3a3ce  OS    32768    running           r
abbitmq0
c843e9b9-b937-c55f-c8dd-a4f6d1bb2ec0  OS    32768    running           m
api0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Same, but change the field order and add some more:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_sh
ares,zfs_io_priority
UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  I
O_PRIORITY
1e6ea123-dca0-44e6-8c0c-34c7f543fe82  OS    128      20     100        3
0
20de2bfc-56de-4cd9-8e25-80b017615788  OS    128      5      50         1
2508eead-dc8f-4df5-baf9-4ce6341f08ed  OS    128      20     100        3
0
29bdabe1-ff9e-4387-9316-39961d5dbe5c  OS    128      5      50         1
384de5e9-c9d9-4382-9dd3-949ab410be45  OS    128      5      50         1
56a47549-bceb-48d7-b67e-fd390d083f09  OS    128      5      50         1
5c12a3ef-e60c-479a-a6be-ba93712a3893  OS    128      5      50         1
a7a4cb02-210a-4ccf-9744-99e3982148b0  OS    128      5      50         1
2811071a-5edc-438a-9b7b-e3b81e8829c5  OS    256      5      100        1
8d01d99b-2b18-41c6-8fec-7209e2a9eef3  OS    512      10     50         4
c3a03fac-dc2c-42ba-aff7-d6fd7a36967a  OS    1024     15     100        8
d104e56e-43df-4d0f-b5ce-43f39d0fef46  KVM   1024     -      100        1
00
2b99a408-7dfb-445e-cfa1-bed4e14a2509  OS    32768    10     50         -
a4212873-e04a-ef84-b85c-c5aea32ce5f8  OS    32768    10     50         -
ad170576-3ad3-e201-cd89-ad4260c3a3ce  OS    32768    10     50         -
c843e9b9-b937-c55f-c8dd-a4f6d1bb2ec0  OS    32768    10     50         -
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Same, but sort by ram in DESCENDING order then by CPU shares in
ascending order:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_sh
ares,zfs_io_priority -s -ram,cpu_shares
UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  I
O_PRIORITY
ad170576-3ad3-e201-cd89-ad4260c3a3ce  OS    32768    10     50         -
c843e9b9-b937-c55f-c8dd-a4f6d1bb2ec0  OS    32768    10     50         -
a4212873-e04a-ef84-b85c-c5aea32ce5f8  OS    32768    10     50         -
2b99a408-7dfb-445e-cfa1-bed4e14a2509  OS    32768    10     50         -
d104e56e-43df-4d0f-b5ce-43f39d0fef46  KVM   1024     -      100        1
00
c3a03fac-dc2c-42ba-aff7-d6fd7a36967a  OS    1024     15     100        8
8d01d99b-2b18-41c6-8fec-7209e2a9eef3  OS    512      10     50         4
2811071a-5edc-438a-9b7b-e3b81e8829c5  OS    256      5      100        1
5c12a3ef-e60c-479a-a6be-ba93712a3893  OS    128      5      50         1
384de5e9-c9d9-4382-9dd3-949ab410be45  OS    128      5      50         1
20de2bfc-56de-4cd9-8e25-80b017615788  OS    128      5      50         1
29bdabe1-ff9e-4387-9316-39961d5dbe5c  OS    128      5      50         1
a7a4cb02-210a-4ccf-9744-99e3982148b0  OS    128      5      50         1
56a47549-bceb-48d7-b67e-fd390d083f09  OS    128      5      50         1
1e6ea123-dca0-44e6-8c0c-34c7f543fe82  OS    128      20     100        3
0
2508eead-dc8f-4df5-baf9-4ce6341f08ed  OS    128      20     100        3
0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Same but only list those with type=OS and ram=1\* (1024 or 128 in this
example):

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_sh
ares,zfs_io_priority -s -ram,cpu_shares type=OS ram=~^1
UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  I
O_PRIORITY
c3a03fac-dc2c-42ba-aff7-d6fd7a36967a  OS    1024     15     100        8
56a47549-bceb-48d7-b67e-fd390d083f09  OS    128      5      50         1
a7a4cb02-210a-4ccf-9744-99e3982148b0  OS    128      5      50         1
5c12a3ef-e60c-479a-a6be-ba93712a3893  OS    128      5      50         1
29bdabe1-ff9e-4387-9316-39961d5dbe5c  OS    128      5      50         1
20de2bfc-56de-4cd9-8e25-80b017615788  OS    128      5      50         1
384de5e9-c9d9-4382-9dd3-949ab410be45  OS    128      5      50         1
2508eead-dc8f-4df5-baf9-4ce6341f08ed  OS    128      20     100        3
0
1e6ea123-dca0-44e6-8c0c-34c7f543fe82  OS    128      20     100        3
0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Creating a new VM
=====================

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# cat zone.json
{
  "brand": "joyent",
  "zfs_io_priority": 30,
  "quota": 20,
  "nowait": true,
  "image_uuid": "47e6af92-daf0-11e0-ac11-473ca1173ab0",
  "max_physical_memory": 256,
  "alias": "zone70",
  "nics": [
    {
      "nic_tag": "external",
      "ip": "10.2.121.70",
      "netmask": "255.255.0.0",
      "gateway": "10.2.121.1",
      "primary": 1
    }
  ]
}
[root@headnode (bh1-kvm1:0) ~]# vmadm create < zone.json
Successfully created 1cdae426-b5ac-4098-b5ec-f765b3bc96b3
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

alternatively, with the same file we could just use:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm create -f zone.json
Successfully created 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Getting a VMs properties
============================

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0
{
  "zonename": "54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
  "zonepath": "/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
  "brand": "joyent",
  "limitpriv": "default,dtrace_proc,dtrace_user",
  "cpu_shares": 100,
  "zfs_io_priority": 30,
  "max_lwps": 2000,
  "max_physical_memory": 256,
  "max_locked_memory": 256,
  "max_swap": 256,
  "creation_timestamp": "2011-11-07T05:57:25.677Z",
  "billing_id": "47e6af92-daf0-11e0-ac11-473ca1173ab0",
  "owner_uuid": "00000000-0000-0000-0000-000000000000",
  "tmpfs": 256,
  "dns_domain": "local",
  "alias": "zone70",
  "nics": [
    {
      "nic_tag": "external",
      "mac": "b2:1e:ba:a5:6e:70",
      "physical": "net0",
      "index": 0,
      "ip": "10.2.121.70",
      "netmask": "255.255.0.0",
      "gateway": "10.2.121.1"
    }
  ],
  "zfs_storage_pool_name": "zones",
  "autoboot": true,
  "uuid": "54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
  "zoneid": "39",
  "state": "running",
  "quota": 20,
  "customer_metadata": {},
  "tags": {}
}
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Lookup a VM by IP
=====================

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm lookup nics.*.ip=10.2.121.70
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

same thing, but get an array of json as results:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm lookup -j nics.*.ip=10.2.121.70
[
  {
    "zonename": "54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
    "zonepath": "/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
    "brand": "joyent",
    "limitpriv": "default,dtrace_proc,dtrace_user",
    "cpu_shares": 100,
    "zfs_io_priority": 30,
    "max_lwps": 2000,
    "max_physical_memory": 256,
    "max_locked_memory": 256,
    "max_swap": 256,
    "creation_timestamp": "2011-11-07T05:57:25.677Z",
    "billing_id": "47e6af92-daf0-11e0-ac11-473ca1173ab0",
    "owner_uuid": "00000000-0000-0000-0000-000000000000",
    "tmpfs": 256,
    "dns_domain": "local",
    "alias": "zone70",
    "nics": [
      {
        "nic_tag": "external",
        "mac": "b2:1e:ba:a5:6e:70",
        "physical": "net0",
        "index": 0,
        "ip": "10.2.121.70",
        "netmask": "255.255.0.0",
        "gateway": "10.2.121.1"
      }
    ],
    "zfs_storage_pool_name": "zones",
    "autoboot": true,
    "uuid": "54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
    "zoneid": "39",
    "state": "running",
    "quota": 20,
    "customer_metadata": {},
    "tags": {},
    "ram": 256,
    "type": "OS"
  }
]
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Looking up all 128M VMs with an alias that starts with 'a' or 'b':
======================================================================

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm lookup ram=128 alias=~^[ab]
5c12a3ef-e60c-479a-a6be-ba93712a3893
29bdabe1-ff9e-4387-9316-39961d5dbe5c
20de2bfc-56de-4cd9-8e25-80b017615788
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

same thing, but json array output:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm lookup -j 128 alias=~^[ab]
[
  {
    "zonename": "20de2bfc-56de-4cd9-8e25-80b017615788",
    "zonepath": "/zones/20de2bfc-56de-4cd9-8e25-80b017615788",
    "brand": "joyent",
    "limitpriv": "default,dtrace_proc,dtrace_user",
    "cpu_shares": 50,
    "zfs_io_priority": 1,
    "max_lwps": 1000,
    "max_physical_memory": 128,
    "max_locked_memory": 128,
    "max_swap": 256,
    "cpu_cap": 350,
    "billing_id": "47e6af92-daf0-11e0-ac11-473ca1173ab0",
    "owner_uuid": "930896af-bf8c-48d4-885c-6573a94b1853",
    "package_name": "regular_128",
    "package_version": "1.0.0",
    "alias": "billapi0",
    "tmpfs": 128,
    "hostname": "20de2bfc-56de-4cd9-8e25-80b017615788",
    "dns_domain": "local",
    "resolvers": [
      "8.8.8.8",
      "8.8.4.4"
    ],
    "default-gateway": "10.2.201.1",
    "nics": [
      {
        "nic_tag": "admin",
        "mac": "90:b8:d0:fc:06:50",
        "physical": "net0",
        "vlan_id": 0,
        "index": 0,
        "ip": "10.2.201.40",
        "netmask": "255.255.255.0",
        "gateway": "10.2.201.1"
      },
      {
        "nic_tag": "external",
        "mac": "90:b8:d0:38:e9:61",
        "physical": "net1",
        "vlan_id": 121,
        "index": 1,
        "ip": "10.2.121.10",
        "netmask": "255.255.255.0",
        "gateway": "10.2.121.1"
      }
    ],
    "zfs_storage_pool_name": "zones",
    "autoboot": true,
    "uuid": "20de2bfc-56de-4cd9-8e25-80b017615788",
    "zoneid": "22",
    "state": "running",
    "quota": 5,
    "customer_metadata": {
      "user-script": "curl -k -o /var/svc/setup -s 10.2.201.9:/extra/bil
lapi/setup;export CONFIG_assets_ip=10.2.201.9;bash /var/svc/setup >/var/
svc/setup.log 2>&1 &",
      "package_name": "regular_128",
      "package_version": "1.0.0",
      "sdc:instance_image": "sdc:sdc:smartos:1.3.18 47e6af92-daf0-11e0-a
c11-473ca1173ab0",
      "sdc:instance_uuid": "20de2bfc-56de-4cd9-8e25-80b017615788"
    },
    "tags": {},
    "ram": 128,
    "type": "OS"
  },
  {
    "zonename": "5c12a3ef-e60c-479a-a6be-ba93712a3893",
    "zonepath": "/zones/5c12a3ef-e60c-479a-a6be-ba93712a3893",
    "brand": "joyent",
    "limitpriv": "default,dtrace_proc,dtrace_user",
    "cpu_shares": 50,
    "zfs_io_priority": 1,
    "max_lwps": 1000,
    "max_physical_memory": 128,
    "max_locked_memory": 128,
    "max_swap": 256,
    "cpu_cap": 350,
    "billing_id": "47e6af92-daf0-11e0-ac11-473ca1173ab0",
    "owner_uuid": "930896af-bf8c-48d4-885c-6573a94b1853",
    "package_name": "regular_128",
    "package_version": "1.0.0",
    "alias": "amon0",
    "tmpfs": 128,
    "hostname": "5c12a3ef-e60c-479a-a6be-ba93712a3893",
    "dns_domain": "local",
    "resolvers": [
      "8.8.8.8",
      "8.8.4.4"
    ],
    "default-gateway": "10.2.201.1",
    "nics": [
      {
        "nic_tag": "admin",
        "mac": "90:b8:d0:c8:d2:3d",
        "physical": "net0",
        "vlan_id": 0,
        "index": 0,
        "ip": "10.2.201.37",
        "netmask": "255.255.255.0",
        "gateway": "10.2.201.1"
      }
    ],
    "zfs_storage_pool_name": "zones",
    "autoboot": true,
    "uuid": "5c12a3ef-e60c-479a-a6be-ba93712a3893",
    "zoneid": "16",
    "state": "running",
    "quota": 5,
    "customer_metadata": {
      "user-script": "curl -k -o /var/svc/setup -s 10.2.201.9:/extra/amo
n/setup;export CONFIG_assets_ip=10.2.201.9;bash /var/svc/setup >/var/svc
/setup.log 2>&1 &",
      "package_name": "regular_128",
      "package_version": "1.0.0",
      "sdc:instance_image": "sdc:sdc:smartos:1.3.18 47e6af92-daf0-11e0-a
c11-473ca1173ab0",
      "sdc:instance_uuid": "5c12a3ef-e60c-479a-a6be-ba93712a3893"
    },
    "tags": {},
    "ram": 128,
    "type": "OS"
  },
  {
    "zonename": "29bdabe1-ff9e-4387-9316-39961d5dbe5c",
    "zonepath": "/zones/29bdabe1-ff9e-4387-9316-39961d5dbe5c",
    "brand": "joyent",
    "limitpriv": "default,dtrace_proc,dtrace_user",
    "cpu_shares": 50,
    "zfs_io_priority": 1,
    "max_lwps": 1000,
    "max_physical_memory": 128,
    "max_locked_memory": 128,
    "max_swap": 256,
    "cpu_cap": 350,
    "billing_id": "47e6af92-daf0-11e0-ac11-473ca1173ab0",
    "owner_uuid": "930896af-bf8c-48d4-885c-6573a94b1853",
    "package_name": "regular_128",
    "package_version": "1.0.0",
    "alias": "adminui0",
    "tmpfs": 128,
    "hostname": "29bdabe1-ff9e-4387-9316-39961d5dbe5c",
    "dns_domain": "local",
    "resolvers": [
      "8.8.8.8",
      "8.8.4.4"
    ],
    "default-gateway": "10.2.201.1",
    "nics": [
      {
        "nic_tag": "admin",
        "mac": "90:b8:d0:fe:47:c5",
        "physical": "net0",
        "vlan_id": 0,
        "index": 0,
        "ip": "10.2.201.39",
        "netmask": "255.255.255.0",
        "gateway": "10.2.201.1"
      },
      {
        "nic_tag": "external",
        "mac": "90:b8:d0:c5:ed:02",
        "physical": "net1",
        "vlan_id": 121,
        "index": 1,
        "ip": "10.2.121.9",
        "netmask": "255.255.255.0",
        "gateway": "10.2.121.1"
      }
    ],
    "zfs_storage_pool_name": "zones",
    "autoboot": true,
    "uuid": "29bdabe1-ff9e-4387-9316-39961d5dbe5c",
    "zoneid": "20",
    "state": "running",
    "quota": 5,
    "customer_metadata": {
      "user-script": "curl -k -o /var/svc/setup -s 10.2.201.9:/extra/adm
inui/setup;export CONFIG_assets_ip=10.2.201.9;bash /var/svc/setup >/var/
svc/setup.log 2>&1 &",
      "package_name": "regular_128",
      "package_version": "1.0.0",
      "sdc:instance_image": "sdc:sdc:smartos:1.3.18 47e6af92-daf0-11e0-a
c11-473ca1173ab0",
      "sdc:instance_uuid": "29bdabe1-ff9e-4387-9316-39961d5dbe5c"
    },
    "tags": {},
    "ram": 128,
    "type": "OS"
  }
]
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Updating a VM
=================

Quota for OS VMs updates live without needing a restart:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0 | json quota
20
[root@headnode (bh1-kvm1:0) ~]# zfs get quota zones/54f1cc77-68f1-42ab-a
cac-5c4f64f5d6e0
NAME                                        PROPERTY  VALUE  SOURCE
zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  quota     20G    local
[root@headnode (bh1-kvm1:0) ~]# vmadm update 54f1cc77-68f1-42ab-acac-5c4
f64f5d6e0 quota=40
Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0 | json quota
40
[root@headnode (bh1-kvm1:0) ~]# zfs get quota zones/54f1cc77-68f1-42ab-a
cac-5c4f64f5d6e0
NAME                                        PROPERTY  VALUE  SOURCE
zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  quota     40G    local
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Set the quota back and adjust the cpu\_shares:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_sh
ares,state,alias alias=zone70
UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  S
TATE             ALIAS
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      40     100        r
unning           zone70
[root@headnode (bh1-kvm1:0) ~]# vmadm update 54f1cc77-68f1-42ab-acac-5c4
f64f5d6e0 quota=20 cpu_shares=200
Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_sh
ares,state,alias alias=zone70
UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  S
TATE             ALIAS
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      20     200        r
unning           zone70
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

You can also do an update from JSON:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# echo '{"cpu_shares": 100}' | vmadm updat
e 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_sh
ares,state,alias alias=zone70
UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  S
TATE             ALIAS
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      20     100        r
unning           zone70
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Add a NIC to a VM then remove it
====================================

First list the nics so you can see what we start with:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0  | json nics
[
  {
    "nic_tag": "external",
    "mac": "b2:1e:ba:a5:6e:70",
    "physical": "net0",
    "index": 0,
    "ip": "10.2.121.70",
    "netmask": "255.255.0.0",
    "gateway": "10.2.121.1"
  }
]
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Then add a nic:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# cat add_nic.json
{
    "add_nics": [
        {
            "physical": "net1",
            "index": 1,
            "nic_tag": "external",
            "mac": "b2:1e:ba:a5:6e:71",
            "ip": "10.2.121.71",
            "netmask": "255.255.0.0",
            "gateway": "10.2.121.1"
        }
    ]
}
[root@headnode (bh1-kvm1:0) ~]# cat add_nic.json | vmadm update 54f1cc77
-68f1-42ab-acac-5c4f64f5d6e0
Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Show it's there (we'd need to reboot the VM to actually use it though):

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0  | json nics
[
  {
    "nic_tag": "external",
    "mac": "b2:1e:ba:a5:6e:70",
    "physical": "net0",
    "index": 0,
    "ip": "10.2.121.70",
    "netmask": "255.255.0.0",
    "gateway": "10.2.121.1"
  },
  {
    "nic_tag": "external",
    "mac": "b2:1e:ba:a5:6e:71",
    "physical": "net1",
    "index": 1,
    "ip": "10.2.121.71",
    "netmask": "255.255.0.0",
    "gateway": "10.2.121.1"
  }
]
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

change the IP:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# cat update_nic.json
{
    "update_nics": [
        {
            "mac": "b2:1e:ba:a5:6e:71",
            "ip": "10.2.121.72"
        }
    ]
}
[root@headnode (bh1-kvm1:0) ~]# cat update_nic.json | vmadm update 54f1c
c77-68f1-42ab-acac-5c4f64f5d6e0
Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

list again:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0  | json nics
[
  {
    "nic_tag": "external",
    "mac": "b2:1e:ba:a5:6e:70",
    "physical": "net0",
    "index": 0,
    "ip": "10.2.121.70",
    "netmask": "255.255.0.0",
    "gateway": "10.2.121.1"
  },
  {
    "nic_tag": "external",
    "mac": "b2:1e:ba:a5:6e:71",
    "physical": "net1",
    "index": 1,
    "ip": "10.2.121.72",
    "netmask": "255.255.0.0",
    "gateway": "10.2.121.1"
  }
]
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Remove the new NIC:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# echo '{"remove_nics": ["b2:1e:ba:a5:6e:7
1"]}' | vmadm update 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Back where we started:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0  | json nics
[
  {
    "nic_tag": "external",
    "mac": "b2:1e:ba:a5:6e:70",
    "physical": "net0",
    "index": 0,
    "ip": "10.2.121.70",
    "netmask": "255.255.0.0",
    "gateway": "10.2.121.1"
  }
]
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Add a disk to a VM then remove it
=====================================

First list the disks so you can see what we start with:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0-disk0|json disks
[
  {
    "path": "/dev/zvol/rdsk/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-d
isk0",
    "boot": true,
    "model": "virtio",
    "media": "disk",
    "size": 40960,
    "zfs_filesystem": "zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk0"
,
    "zpool": "zones",
    "compression": "lz4",
    "block_size": 8192
  }
]
```

</div>

</div>

</div>

Then add a disk:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# cat add_disk.json

{
  "add_disks": [
    {
      "boot": false,
      "model": "virtio",
      "block_size": 8192,
      "size": 40960
   }
 ]
}

[root@headnode (bh1-kvm1:0) ~]# vmadm update 54f1cc77-68f1-42ab-acac-5c4
f64f5d6e0 -f add_disk.json
Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Show it's there (we'd need to reboot the VM to actually use it though):

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0  | json disks
[
  {
    "path": "/dev/zvol/rdsk/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-d
isk0",
    "boot": true,
    "model": "virtio",
    "media": "disk",
    "size": 40960,
    "zfs_filesystem": "zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk0"
,
    "zpool": "zones",
    "compression": "lz4",
    "block_size": 8192
  },
  {
    "path": "/dev/zvol/rdsk/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-d
isk1",
    "boot": false,
    "model": "virtio",
    "size": 40960,
    "zfs_filesystem": "zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk1"
,
    "zpool": "zones",
    "compression": "lz4",
    "block_size": 8192
  }
]
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Remove the new disk:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# echo '{"remove_disks": ["/dev/zvol/rdsk/
zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk1"]}' | vmadm update 54f1
cc77-68f1-42ab-acac-5c4f64f5d6e0
Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Back where we started:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
f5d6e0  | json disks
[
  {
    "path": "/dev/zvol/rdsk/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-d
isk0",
    "boot": true,
    "model": "virtio",
    "media": "disk",
    "size": 40960,
    "zfs_filesystem": "zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk0"
,
    "zpool": "zones",
    "compression": "lz4",
    "block_size": 8192
  }
]
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Add a CDROM
===============

You can do the same thing with CD-ROMs:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .javascript; .gutter: .false}
{
  "add_disks": [
        {
        "boot": false,
        "model": "ide",
          "media": "cdrom",
          "path": "/en_sql_server_2012_standard_edition_with_sp1_x64_dvd
_1228198.iso"
        }
      ]
}

```

</div>

</div>

</div>

Stopping a VM
=================

before:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list uuid=54f1cc77-68f1-42ab-acac-
5c4f64f5d6e0
UUID                                  TYPE  RAM      STATE             A
LIAS
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      running           z
one70
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

then:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm stop 54f1cc77-68f1-42ab-acac-5c4f6
4f5d6e0
Succesfully completed stop for 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

after:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list uuid=54f1cc77-68f1-42ab-acac-
5c4f64f5d6e0
UUID                                  TYPE  RAM      STATE             A
LIAS
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      stopped           z
one70
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Starting a VM
=================

(see above for before)

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm start 54f1cc77-68f1-42ab-acac-5c4f
64f5d6e0
Successfully started 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

after:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list uuid=54f1cc77-68f1-42ab-acac-
5c4f64f5d6e0
UUID                                  TYPE  RAM      STATE             A
LIAS
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      running           z
one70
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Rebooting a VM
==================

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm reboot 54f1cc77-68f1-42ab-acac-5c4
f64f5d6e0
Succesfully completed reboot for 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Deleting a VM
=================

before:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list ram=256
UUID                                  TYPE  RAM      STATE             A
LIAS
2811071a-5edc-438a-9b7b-e3b81e8829c5  OS    256      running           u
fds0
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      running           z
one70
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

delete, then list again:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm delete 54f1cc77-68f1-42ab-acac-5c4
f64f5d6e0
Successfully deleted 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]# vmadm list ram=256
UUID                                  TYPE  RAM      STATE             A
LIAS
2811071a-5edc-438a-9b7b-e3b81e8829c5  OS    256      running           u
fds0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Moving a VM Between Servers
===============================

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
**experimental**\

vmadm send and vmadm receive are currently experimental, undocumented-in
-the-manpage features. Use at your own risk. They'll be documented once
they are considered production-ready.
  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---------------------------------------

</div>

Migrate a VM to a new server (10.0.1.4)

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm send 54f1cc77-68f1-42ab-acac-5c4f6
4f5d6e0 |ssh 10.0.1.4 vmadm receive
Password:
Succesfully sent VM 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
Succesfully received VM 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Verify VM was transferred to the new server

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm list
UUID                                  TYPE  RAM      STATE             A
LIAS
54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      stopped           z
one70
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Remove VM from original server

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm delete 54f1cc77-68f1-42ab-acac-5c4
f64f5d6e0
Successfully deleted 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

If the migration fails, you may need to manually destroy the ZFS dataset
for the zone on the destination machine before you can try sending the
VM again. The below error is a symptom of this:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@headnode (bh1-kvm1:0) ~]# vmadm send 54f1cc77-68f1-42ab-acac-5c4f6
4f5d6e0 |ssh 10.0.1.4 vmadm receive
Password:
vmunbundle exited with code 1
Successfully sent 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@headnode (bh1-kvm1:0) ~]#
```

</div>

</div>

</div>

Check to see if the ZFS dataset exists on the destination, then remove
if it exists

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@destinationNode ~]# zfs list
NAME                                           USED  AVAIL  REFER  MOUNT
POINT
zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0     651K  10.0G   651K  /zone
s/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
[root@destinationNode ~]# zfs destroy zones/54f1cc77-68f1-42ab-acac-5c4f
64f5d6e0
[root@destinationNode ~]#
```

</div>

</div>

</div>

### Preserving snapshots

If you want to keep the snapshots for a VM when migrating, you may find
this process useful.\
First move the zfs datasets to the new server, where *@last-snapshot* is
the last snapshot you want to keep. Every snapshot before
*@last-snapshot* will be migrated. You will need to repeat this step for
every disk.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@source-host ~]# zfs send -R zones/$UUID-disk0@last-snapshot | ssh
destination-host zfs receive zones/$UUID-disk0
```

</div>

</div>

</div>

Then you need to send the VM's metadata and create the VM. The JSON
command updates the metadata so that vmadm doesn't attempt to create the
ZFS datasets.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@source-host ~]# vmadm get $UUID | json -e "for(i in this.disks){th
is.disks[i].nocreate=true;}this.i=undefined;" | ssh destination-host vma
dm create
```

</div>

</div>

</div>

Changing the Virtual Hardware of a KVM Zone
===============================================

- [Changing virtual hardware of KVM
    zones](Changing%20virtual%20hardware%20of%20KVM%20zones.html "Changi
ng virtual hardware of KVM zones")

See also
============

- [Man page for
    vmadm](https://github.com/joyent/smartos-live/blob/master/src/vm/man
/vmadm.1m.md)
- [Man page for
    vmadmd](https://github.com/joyent/smartos-live/blob/master/src/vm/ma
n/vmadmd.1m.md)

<div class="tabletitle">


Comments:
---------

</a>

</div>

+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I failed to change the ip of the vm, which is the only nic of my
   |
| vm.Although the ip is updated shown in the "vmadm get &lt;uuid&gt;", b
ut |
| the new ip can not be used.   \
   |
| Shall I reboot the vm? Or whether take reboot by fifo or vmadm or the
vm |
| console.
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
| tx\_seu@hotmail.com at Jan 04, 2013 02:35
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| How do you vmadm update a zone's resolvers attribute?  Can't seem to
   |
| find in the documentation how to update an array type.
   |
|
   |
| <div class="preformatted panel" style="border-width: 1px;">
   |
|
   |
| <div class="preformattedContent panelContent">
   |
|
   |
|     # vmadm update 1df8074b-661a-45e4-b590-f2ac4de2aeeb resolvers="192
.1 |
| 68.1.1"
   |
|     UNCAUGHT EXCEPTION: a7e75f91 <a TypeError>
   |
|     EXCEPTION MESSAGE: Object 192.168.1.1 has no method 'join'
   |
|     FROM:
   |
|     buildZonecfgUpdate (/usr/vm/node_modules/VM.js:6519:61)
   |
|     exports.update.async.series.VM.load.log (/usr/vm/node_modules/VM.j
s: |
| 11368:20)
   |
|     async.series.results (/usr/node/0.8/node_modules/async.js:540:21)
   |
|     _asyncMap (/usr/node/0.8/node_modules/async.js:225:13)
   |
|     async.eachSeries.iterate (/usr/node/0.8/node_modules/async.js:126:
13 |
| )
   |
|     async.eachSeries.sync (/usr/node/0.8/node_modules/async.js:141:29)
   |
|     _asyncMap (/usr/node/0.8/node_modules/async.js:227:17)
   |
|     async.series.results (/usr/node/0.8/node_modules/async.js:545:34)
   |
|     exports.update.async.series.log.error.err (/usr/vm/node_modules/VM
.j |
| s:11362:17)
   |
|     /usr/vm/node_modules/VM.js:4285:17
   |
|     Object.oncomplete (fs.js:297:15)
   |
|     Abort (core dumped)
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
| lsgroup at Jul 04, 2013 22:33
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Hi LS:
   |
|
   |
| I used full JSON form to update resolvers and it said it was successfu
l, |
| but didn't actually work:
   |
|
   |
| <div class="preformatted panel" style="border-width: 1px;">
   |
|
   |
| <div class="preformattedContent panelContent">
   |
|
   |
|     vmadm update 1df8074b-661a-45e4-b590-f2ac4de2aeeb '{resolvers:["19
2. |
| 168.1.1"]}'
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
| Not sure what to do here since this leads the zone to overwrite
   |
| resolv.conf on reboot.
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
| alainodea at Aug 19, 2013 03:56
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Hey LS and Alain:
   |
|
   |
| I've been in that situation and eventually I decided to hack the
   |
| resolvers into /etc/zones/&lt;uuid&gt;.xml to make it persistent.
   |
|
   |
| &lt;attr name="resolvers" type="string"
   |
| value="192.168.3.1,194.109.6.66,194.109.9.99"/&gt;
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
| scarcry at Oct 02, 2013 22:04
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


