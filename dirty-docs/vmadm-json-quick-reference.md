+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : vmadm JSON Quick
Reference </span>

</div>

<div class="pagesubheading">

This page last changed on Nov 13, 2015 by
<font color="#0050B2">cody.mello@joyent.com</font>.

</div>

Disks
---------

<div class="table-wrap">

<table class="confluenceTable">
<tbody>
<tr>
<th class="confluenceTh">
Property
</th>
<th class="confluenceTh">
Description
</th>
<th class="confluenceTh">
Applies
</th>
<th class="confluenceTh">
Create
</th>
<th class="confluenceTh">
Update
</th>
<th class="confluenceTh">
Default
</th>
</tr>
<tr>
<td class="confluenceTd">
block\_size
</td>
<td class="confluenceTd">
ZVol Block Size
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
No
</td>
<td class="confluenceTd">
8192
</td>
</tr>
<tr>
<td class="confluenceTd">
boot
</td>
<td class="confluenceTd">
Specifies a bootable disk (Boolean)
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
false
</td>
</tr>
<tr>
<td class="confluenceTd">
nocreate
</td>
<td class="confluenceTd">
Don't create disk
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
No
</td>
<td class="confluenceTd">
false
</td>
</tr>
<tr>
<td class="confluenceTd">
image\_name
</td>
<td class="confluenceTd">
Name of dataset from this to clone this disk
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
no
</td>
</tr>
<tr>
<td class="confluenceTd">
image\_size
</td>
<td class="confluenceTd">
Size (MB) of Image being cloned
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
image\_uuid
</td>
<td class="confluenceTd">
UUID of dataset to clone
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
size
</td>
<td class="confluenceTd">
Size (MB) of disk to create
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
media
</td>
<td class="confluenceTd">
"disk" or "cdrom"
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
disk
</td>
</tr>
<tr>
<td class="confluenceTd">
model
</td>
<td class="confluenceTd">
Disk model (virtio, ide, or scsi)
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
(see *disk\_driver*)
</td>
</tr>
<tr>
<td class="confluenceTd">
compression
</td>
<td class="confluenceTd">
Specify compression algorithm for disk ("on,off,lzjb,gzip,gzip-N,zle")
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
off
</td>
</tr>
<tr>
<td class="confluenceTd">
zpool
</td>
<td class="confluenceTd">
Zpool on which to create this zvol
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
zones
</td>
</tr>
</tbody>
</table>

</div>

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
"disks": [
        {
          "boot": true,
          "model": "virtio",
          "image_uuid": "e173ecd7-4809-4429-af12-5d11bcc29fd8",
          "image_name": "ubuntu-10.04.2.7",
          "image_size": 5120
        }
      ]
```

</div>

</div>

</div>

NICs
--------

<div class="table-wrap">

<table class="confluenceTable">
<tbody>
<tr>
<th class="confluenceTh">
Property
</th>
<th class="confluenceTh">
Description
</th>
<th class="confluenceTh">
Applies
</th>
<th class="confluenceTh">
Create
</th>
<th class="confluenceTh">
Update
</th>
<th class="confluenceTh">
Default
</th>
</tr>
<tr>
<td class="confluenceTd">
interface
</td>
<td class="confluenceTd">
Name of the interface within the VM ("net0")
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
No
</td>
<td class="confluenceTd">
-

</td>
</tr>
<tr>
<td class="confluenceTd">
ip
</td>
<td class="confluenceTd">
IPv4 Address for NIC, or "dhcp". Deprecated, see "ips".
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
-

</td>
</tr>
<tr>
<td class="confluenceTd">
ips
</td>
<td class="confluenceTd">
Array of IPv4 & IPv6 addresses (in CIDR format) for the NIC, "dhcp", or
"addrconf".
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
-

</td>
</tr>
<tr>
<td class="confluenceTd">
mac
</td>
<td class="confluenceTd">
MAC Address for virtual NIC
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
No
</td>
<td class="confluenceTd">
Auto-generated
</td>
</tr>
<tr>
<td class="confluenceTd">
model
</td>
<td class="confluenceTd">
Driver for this NIC (virtio, e1000, rtl8139)
</td>
<td class="confluenceTd">
KVM
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Value of 'nic\_driver' property
</td>
</tr>
<tr>
<td class="confluenceTd">
netmask
</td>
<td class="confluenceTd">
Netmask for NIC
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
gateway
</td>
<td class="confluenceTd">
Gateway for NIC. Deprecated, see "gateways".
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
gateways
</td>
<td class="confluenceTd">
Array of gateways for NIC.
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
nic\_tag
</td>
<td class="confluenceTd">
nic\_tag or interface name that the virtual NIC is attached to
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
primary
</td>
<td class="confluenceTd">
Sets this NICs gateway as the default gw
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
-

</td>
</tr>
<tr>
<td class="confluenceTd">
vlan\_id
</td>
<td class="confluenceTd">
VLAN ID for this NIC
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
"0" (None)
</td>
</tr>
<tr>
<td class="confluenceTd">
vrrp\_primary\_ip
</td>
</tr>
<tr>
<td class="confluenceTd">
vrrp\_vrid
</td>
</tr>
<tr>
<td class="confluenceTd">
dhcp\_server
</td>
<td class="confluenceTd">
Allow the VM on this NIC to act as a DHCP Server
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
false
</td>
</tr>
<tr>
<td class="confluenceTd">
allow\_dhcp\_spoofing
</td>
<td class="confluenceTd">
Allow this VM to spoof DHCP packets on this NIC
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
false
</td>
</tr>
<tr>
<td class="confluenceTd">
allow\_ip\_spoofing
</td>
<td class="confluenceTd">
Allow this VM to spoof IP addresses on this NIC
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
false
</td>
</tr>
<tr>
<td class="confluenceTd">
allow\_mac\_spoofing
</td>
<td class="confluenceTd">
Allow this VM to spoof its MAC address
</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
false
</td>
</tr>
<tr>
<td class="confluenceTd">
allow\_restricted\_traffic
</td>
<td class="confluenceTd">

</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
false
</td>
</tr>
<tr>
<td class="confluenceTd">
allow\_unfiltered\_promisc
</td>
<td class="confluenceTd">

</td>
<td class="confluenceTd">
Both
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
Yes
</td>
<td class="confluenceTd">
false
</td>
</tr>
<tr>
<td class="confluenceTd">
blocked\_outgoing\_ports
</td>
</tr>
</tbody>
</table>

</div>

Example:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
"nics": [
        {
          "nic_tag": "external",
          "ip": "10.2.121.70",
          "netmask": "255.255.0.0",
          "gateway": "10.2.121.1",
          "primary": true
        }
      ]
```

</div>

</div>

</div>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


