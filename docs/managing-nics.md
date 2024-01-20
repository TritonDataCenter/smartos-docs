# Managing NICs

## NICs and nic_tags

In order for a NIC to be used in SmartOS it must be given a label called a
`nic_tag`. The default configuration uses only one nic_tag, `admin`. Additional
nic_tags can be created for any purpose. Broadly speaking, a nic_tag is a
label that describes what is reachable over that nic.

Some commonly used nic_tags are described in the table below:

| nic_tag  | Description                          |
| -------- | ------------------------------------ |
| admin    | The control plane for the hypervisor |
| external | Connectivity to the global Internet  |
| internal | Connectivity to an "intranet"        |
| underlay | VXLAN / Software Defined Networking  |

The only required nic tag is `admin` which will be configured by default.
Use the command `nictagadm` to list nic tags.

Because nic_tags are just a text string, it can be anything you want. Nothing
prevents you from having a `dmz` or `private`. If you use Juniper network
hardware, you may prever `trust` and `untrust`.

Interfaces, both for the global zone, and for instances, are configured by
associating them with a nic_tag.

### Configuring NICs in the global zone

Nictags are configured in the node config file (usually `/usbkey/config`), or
for more complex configurations, a JSON file (usually provided during PXE boot,
and will not be described here).

Valid config keys:

| Key Name               | Value                                  |
| ---------------------- | -------------------------------------- |
| `<nic_tag>_nic`        | The MAC address of the physical NIC    |
| `<nic_tag>XX_ip`       | A valid IPv4 address or `dhcp`         |
| `<nic_tag>XX_ip6`      | A valid IPv6 address or `addrconf`     |
| `<nic_tag>XX_mac`      | A persistent vanity MAC address        |
| `<nic_tag>XX_mtu`      | MTU value for this nic_tag (see below) |
| `<nic_tag>XX_netmask`  | A valid dotted decimal subnet mask     |
| `<nic_tag>XX_gateway`  | IPv4 default gateway                   |
| `<nic_tag>XX_gateway6` | IPv6 default gateway                   |
| `<nic_tag>XX_vlan_id`  | VLAN ID number (`2` - `4096`)          |

The `<nic_tag>_nic` key is the only parameter necessary to define a nic_tag. In
general, it is not recomended that the global zone plumb an interface on every
nic_tag.

To configure an interface over a nic_tag, it needs to be assigned an *instance
number*, and additional parameters as necessary. All parameters are optional,
except that `_ip` requires `_netmask`. When using IPv6, even if a static
address is assigned, router-advertisements will still be accepted and
configured. Interfaces are always configured as `vnic`s. Instance numbers can
be `0` to `99`. By default a random MAC is generated for the vnic.

If there are multiple nic_tags assigned to the same physical NIC, the highest
value MTU will be used at the link-layer.

NIC Example:

    storage_nic=00:53:00:ca:b1:e5
    storage0_ip=198.51.100.7
    storage0_netmask=255.255.255.0
    storage0_gateway=198.51.100.1
    storage0_vlan_id=128

In this example, the nic_tag `storage` is defined. One network interface will
be created as a vnic named `storage0`.

#### `admin` and `external`

The `admin` and `external` nic_tags are special cased in the following ways:

* The `admin` interface is not configured using a vnic.
* The `external` vnic does not use an instance number in the config. Instance
  `0` is assumed. E.g., `external_ip` will create vnic `external0`.

### LACP NIC aggregation

Multiple NICs can be aggregated together to form a single virtual data-link.
Linux calls this *bonding*. In order for aggregations to be created, the
port on the network switch must also be configured for LACP.

To create an aggregation, use the following syntax:

    <name>X_aggr=<mac1>,<nic2>

You can then assign nic_tags to the aggregation instead of to a physical NIC.

Example:

    aggr1_aggr=00:53:00:ca:b1:e5,00:53:00:ca:b1:ed
    external_nic=aggr1

In this example, aggregation `aggr1` is created over two physical NICs and
the `external` nic_tag is assigned to the aggregation.

### Configuring NICs in instances

In the instance create payload each nic is assigned a nic_tag. If the specified
nic_tag does not exist creating the instance will fail. See the `vmadm` man
page for additional documentation.

Example configuration:

    "nics": [
        {
          "nic_tag": "external",
          "ip": "198.51.100.21",
          "netmask": "255.255.255.0",
          "gateway": "198.51.100.1"
          "primary": true,
          "vlan_id": 128
        },
        {
          "nic_tag": "internal",
          "ip": "192.0.2.21",
          "netmask": "255.255.255.0",
          "gateway": "192.0.2.1"
          "vlan_id": 200
        }
      ]
    }

## Low Level Networking Commands

In addition to using the config file, networking commands may be run manually
to investigate (or verify) the state of the network configuration or to apply
a temporary state. At boot, networking will reflect the config file.

Networking in illumos, has *data links*, *interfaces*, and *addresses*.

### Data links

A data-link is a physical interface, a vnic, an aggregation, or a VLAN. The
`dladm` command is used to operate on dada links.

Here are some common examples:

    dladm show-phys -m # Show physical interfaces only (with MAC address)
    dladm show-vnic    # Show VNICs only
    dladm show-aggr    # Show link aggregations only
    dladm show-link    # Show all data link devices

See the `dladm` man page for more information.

### Interfaces and Addresses

An *interface* is an abstratction where addresses can be configured. Multiple
addresses can be configured on a single interface. E.g., you can have multiple
IPv4 and/or IPv6 addresses on a single interface.

An interface is created on a data link, and has an instance number. E.g.,
`e1000g0` or `external0`.

An address object is a tag appended to the interface name. E.g., `external0/_a`.
Every address object must be unique. Address objects (or `addrobj`s) that begin
with `_` are assigned by the system.

The `ipadm` utility is used to operate on interfaces and addresses
Here are some common usage patterns:

    ipadm show-addr       # Show configured addresses
    ipadm create-addr ... # Configure a new address on an interface
    ipadm show-if         # Show interface objects without address information

See the `ipadm` man page for more information.

### Other Commands

In addition to the `dladm` and `ipadm` commands, `ifconfig` can also be used,
which some people prefer. See the `ifconfig` man page for more information.

Routing is configured using the `route` command. See the `route` man page for
more information.

## Using VRRP in Zones

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

* `vrrp_primary_ip` must be the IP address of one of the other
  nics in the system, since this address will be used to send
  router advertisements.
* No MAC address is necessary for the VRRP nic, since its MAC address
  will be based on the router ID
* For the time being, the NIC with the `ip` matching the `vrrp_primary_ip`
  needs to have `allow_ip_spoofing` ([smartos-live#136][sl136])
* This does not work with kvm or bhyve zones
* VRRP in zones is not well tested

[sl136]: https://github.com/TritonDataCenter/smartos-live/issues/136

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

## Running a DHCP Server in a Zone

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

* [NAT using Etherstubs](nat-using-etherstubs.md)
* [Gist about NAT](https://gist.github.com/2639064)
* [Gist about etherstubs](https://gist.github.com/e18d343cde4509afaa51)
