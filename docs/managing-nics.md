# Managing NICs

## Exposing Additional NICs in the Global Zone

Additional vnics can be added in the global zone. To create a vnic named
`storage0`:

    # dladm create-vnic -l e1000g0 -v 128 storage0

The `v 128` above creates the vnic on VLAN ID 128. For a vnic not on
a VLAN, omit the -v option.

Now plumb and bring up the interface as you would any interface:

    ifconfig storage0 plumb
    ifconfig storage0 inet 10.77.77.7 netmask 255.255.255.0 up

Or with a DHCP IP:

    ifconfig storage0 plumb
    ifconfig storage0 dhcp

### Persisting vnics across reboots

First determine the mac address of the physical nic:

    # dladm show-phys -m
    LINK         SLOT     ADDRESS            INUSE CLIENT
    e1000g0      primary  0:c:29:18:ec:10    yes  e1000g0

Now add the config options for storage0 to `usbkey/config`

NOTE: the omission of the `0` in `storage\_nic` below is NOT a typo.
That line defines a `nic_tag`. The other lines define an instance (instance 0)
of a vnic on the hardware referenced by that `nic_tag`.

    storage_nic=0:c:29:18:ec:10
    storage0_ip=10.77.77.7
    storage0_netmask=255.255.255.0
    storage0_gateway=10.77.77.1
    storage0_vlan_id=128

You can omit the `storage0\_vlan\_id` option if you don't want
storage0 on a VLAN. For a DHCP IP with no VLAN:

    storage0_ip=dhcp
    storage0_netmask=...

If you would like to make the changes in `usbkey/config` active
without a reboot, you will need to make them visible to "sysinfo" by
running the following command:

    sysinfo -u

Exposing Additional NICs in VMs

Additional physical NICs can be exposed to the VMs, via VNICs, running
under your SmartOS hypervisor.

First determine the mac address of the physical nic:

    # dladm show-phys -m
    LINK         SLOT     ADDRESS            INUSE CLIENT
    e1000g1      primary  8:0:27:19:64:7d    no   --
    e1000g0      primary  8:0:27:ac:2:fc     yes  e1000g0

In this example the mac address for the nic I want to expose is
`8:0:27:19:64:7d` and is associated with link `e1000g1`.

Next, modify `/usbkey/config` which holds the persistent network
configuration for your hypervisor. Add the following line:

    # this line is of the form '<nic_tag>_nic=<mac_address>'
    external_nic=8:0:27:19:64:7d

Finally in the JSON spec for your VM, reference this new tag under the
'nics' section:

    "nics": [
        {
          "nic_tag": "admin",
          "ip": "192.168.0.20",
          "netmask": "255.255.255.0",
          "gateway": "192.168.0.1"
        },
          {
          "nic_tag": "external",
          "ip": "192.168.0.21",
          "netmask": "255.255.255.0",
          "gateway": "192.168.0.1"
          "primary": true,
          "vlan_id": 128
        }
      ]
    }

This updated JSON spec will create a VM with multiple NICS, exposing the
physical NIC tagged with external to the VM/Zone. See managing VMs with
vmadm for more information on updating existing vms.

### Adding VRRP nics to VMs

To provision a VM with a VRRP nic, you must set the `vrrp_vrid`
(router ID) and `vrrp_primary_ip` attributes in that nic:

    "nics": [
        {
          "nic_tag": "external",
          "ip": "10.2.59.8",
          "vlan_id": 1059,
          "vrrp_vrid": 100,
          "vrrp_primary_ip": "10.2.59.9",
          "netmask": "255.255.255.0",
          "gateway": "10.2.59.1"
        },
        {
          "nic_tag": "external",
          "ip": "10.2.59.9",
          "vlan_id": 1059,
          "netmask": "255.255.255.0",
          "gateway": "10.2.59.1",
          "primary": true,
          "allow_ip_spoofing": true
        }
      ]

Notes:

- `vrrp\_primary\_ip` must be the IP address of one of the other
    nics in the system, since this address will be used to send
    router advertisements.
- No MAC address is necessary for the VRRP nic, since its MAC address
    will be based on the router ID
- For the time being, the NIC with the `ip` matching the
    `vrrp\_primary\_ip` needs to have
    `allow\_ip\_spoofing` ([joyent-live Issue
    136](https://github.com/joyent/smartos-live/issues/136))
- This does not work with kvm zones

Logging into the VM, you can see that net0 has the VRRP flag set. The
interface isn't up yet - that will be handled by vrrpd, which handles
bringing up and down VRRP vnics.

<!-- markdownlint-disable line-length -->

    # ifconfig net0
    net0: flags=50201000842<BROADCAST,RUNNING,MULTICAST,IPv4,CoS,VRRP,L3PROTECT> mtu 1500 index 2
            inet 10.2.59.8 netmask ffffff00 broadcast 10.2.59.255
            ether 0:0:5e:0:1:64

<!-- markdownlint-enable line-length -->

Now create the router with `vrrpadm`:

    vrrpadm create-router -V 100 -l net1 -A inet router0

`vrrpadm` shows that the router is up, and is the master.

    # vrrpadm show-router
    NAME    VRID LINK    AF   PRIO ADV_INTV MODE  STATE VNIC
    router0 100  net1    IPv4 255  1000     eopa- MASTER net0
    # vrrpadm show-router -x
    NAME    STATE PRV_STAT STAT_LAST VNIC    PRIMARY_IP          VIRTUAL_IPS
    router0 MASTER INIT      14.085s net0    10.2.59.9           10.2.59.8

ifconfig shows that net0 is now UP:

<!-- markdownlint-disable line-length -->

    # ifconfig net0
    net0: flags=50201000843<UP,BROADCAST,RUNNING,MULTICAST,IPv4,CoS,VRRP,L3PROTECT> mtu 1500 index 2
            inet 10.2.59.8 netmask ffffff00 broadcast 10.2.59.255
            ether 0:0:5e:0:1:64

<!-- markdownlint-enable line-length -->

You should now be able to ping this VM on both its primary and virtual
IP.

## Link Aggregations in the Global Zone

First, determine the MAC addresses of the nics you want to include in
the aggregation:

    # dladm show-phys -m
    LINK         SLOT     ADDRESS            INUSE CLIENT
    e1000g0      primary  0:50:56:3d:a7:95   yes  e1000g0
    e1000g1      primary  0:50:56:34:60:4c   yes  e1000g1

Now add a `lt;aggregation name&gt;\_aggr` config key to
`/usbkey/config`. The value of that key is a comma-separated list of the
MAC addresses of the nics in the aggregation:

    aggr0_aggr=00:50:56:34:60:4c,00:50:56:3d:a7:95
    # The following line is optional - the LACP mode will default to "off":
    # This needs to match the switch config
    aggr0_lacp_mode=active

    # VM nics with admin or storage nic_tags will now have their vnics creat
    ed on the aggregation:
    admin_nic=aggr0
    storage_nic=aggr0

    # Configure IPs as you would for regular nics
    admin_ip=...
    storage0_ip=...

Save and reboot. Once the system is back up, you should see the
aggregations with sysinfo:

    # sysinfo | json "Link Aggregations"
    {
      "aggr0": {
        "LACP mode": "active",
        "Interfaces": [
          "e1000g1",
          "e1000g0"
        ]
      }
    }

dladm should also show the aggregation:

    # dladm show-aggr
    LINK            POLICY   ADDRPOLICY           LACPACTIVITY  LACPTIMER
    FLAGS
    aggr0           L4       auto                 active        short

VM nics provisioned on the `admin` and `storage` nic tags will now
be over aggregation `aggr0`

To manually create a link aggregation with the `dladm create-aggr` command
in the Global Zone without rebooting, you will first need to disable
the `lldp/server` service. By default `lldpd` will have a lock on
all otherwise unused devices. After you've created the aggregation,
you can re-enable it.

## Modifying the MTU

By default, all VMs that do not have an explicit MTU requested have
their VNICs match the MTU of the physical nic of their nic tag. In
addition, any VNIC that's created has a valid range of an MTU ranging
from 1500 to the current MTU of the physical NIC. The best way to view
this is by running the dladm command as follows:

    [root@00-0c-29-37-80-28 ~]# dladm show-linkprop -p mtu
    LINK         PROPERTY        PERM VALUE          DEFAULT        POSSIBLE
    e1000g0      mtu             rw   1500           1500           1500-163
    62
    net0         mtu             rw   1500           1500           1500
    etherstub0   mtu             rw   9000           1500           576-9000

The MTU of a physical device or VNIC only impacts the maximum MTU you
can use on an IP interface. Even though the smallest MTU e1000g0 supports
is 1500, the IP stack can use a lower MTU.

A nic tag now has the concept of a MTU. If unset, it defaults to the
default value of the NIC, usually 1500. The nictagadm command can be
used to update an existing nic tag with a MTU or set one when a new one
is created. When the system next boots, it will set the MTU of the
physical nic to the maximum of all of the MTUs specified by the nic tags
for that NIC. See the following examples below:

    [root@headnode (rm-sf0) ~]# nictagadm add -p mtu=5000 mtu_tag0 00:50:56:3d:a7:95
    MTU changes will not take effect until next reboot
    [root@headnode (rm-sf0) ~]# nictagadm update -p mtu=9000 external
    MTU changes will not take effect until next reboot

### Updating the MTU for VMs

vmadm has a new property 'nics.\*.mtu'. If this property is set, it will
always try to set the MTU to the specified value when the VM is booted.
If that MTU cannot be honored, then it will cause the boot process to
fail explicitly rather than come up with a different MTU. If an MTU is
not specified, then it will always default to the current MTU of the
physical device that corresponds to the nic tag.

### Updating the MTU for aggrs and global zone vnics

You can also specify the MTU for an aggregation and a VNIC in the
configuration file. Recall the storage0 and aggr0 example from earlier.
If you wanted to set `storage0`s MTU to 9000, you would add line
`storage0\_mtu=9000`. You also do something similar for an aggregation.
That makes the whole stanza for our aggregation and vnic look like:

    #
    # Create an aggregation whose default MTU is 9000.
    #
    aggr0_aggr=00:50:56:34:60:4c,00:50:56:3d:a7:95
    aggr0_lacp_mode=active
    aggr0_mtu=9000

    #
    # Create a vnic storage0 with an MTU of 9000.
    # We will have to have run nictagdm update to set the mtu on the storage nic_tag.
    #
    storage0_ip=10.77.77.7
    storage0_netmask=255.255.255.0
    storage0_gateway=10.77.77.1
    storage0_vlan_id=128
    storage0_mtu=9000

<!-- markdownlint-disable no-trailing-punctuation -->
## Why don't all my NICs appear in ifconfig?
<!-- markdownlint-enable no-trailing-punctuation -->

All NICs are enabled, but they aren't plumbed up in the global zone.

They can be used in local zones without being plumbed in the global
zone.

NICs that aren't plumbed in the global zone will not appear in ifconfig.

To show all physical NICs from the global zone:

    dladm show-phys

You can also plumb additional NICs in the global zone with ifconfig if
needed, (this will not persist across reboots - see above):

    ifconfig -a plumb

## DHCP Support

Zone NICs will by default have dhcp hosting blocked on them and need to
be opened up before a DHCP server will operate correctly.

You can confirm whether the dhcp protection bit is set with the
following command, in this example net0 has the dhcp-nospoof protection
bit set while net1 has it cleared as is required for serving DHCP on the
net1 interface.

    # dladm show-linkprop -z <ZONE_UUID> -p protection
    LINK         PROPERTY        PERM VALUE          DEFAULT        POSSIBLE
    net0         protection      rw   mac-nospoof,   --             mac-nospoof,
                                      restricted,                   restricted,
                                      dhcp-nospoof                  ip-nospoof,
                                                                    dhcp-nospoof
    net1         protection      rw   mac-nospoof,   --             mac-nospoof,
                                      restricted                    restricted,
                                                                    ip-nospoof,
                                                                    dhcp-nospoof

When creating a new VM the following property will disable the
dhcp-nospoof bit.

    "nics" : [
            {
                "nic_tag" : "admin",
                "allow_dhcp_spoofing": true
                ...
            }
        ]

To update this flag on an already configured zone you can use the vmadm
update functionality as follows (in this case updating interface with
mac `00:53:37:00:db:08`).

    # vmadm update <ZONE_UUID> << EOF
    {
      "update_nics": [
        {
          "mac": "00:53:37:00:db:08",
          "allow_dhcp_spoofing": true
        }
      ]
    }
    EOF

## NAT and other crazy tricks

- [NAT using Etherstubs](nat-using-etherstubs.md)
- [Gist about NAT](https://gist.github.com/2639064)
- [Gist about etherstubs](https://gist.github.com/e18d343cde4509afaa51)
