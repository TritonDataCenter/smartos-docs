# NAT using Etherstubs

## Introduction

This is a set of instructions to demonstrate how to set up a pair of
zones where one of them is performing NAT for the other.

This could be generalized to a zone that performs NAT for a collection
of zones/VMs, or other configurations as well.

### Configure Etherstub

    nictagadm add -l stub0

### Configure Zones

This example happens to result in double NAT to reach the internet. My
SmartOS machine is on a 192.168.0.1/24 network that is itself NATed to the
Internet. The "firewall" zone is NATing the client zone from a 10.0.0.1/24
network onto that 192.168.0.1/24 network.

Note the `allow_ip_spoofing` setting on the firewall zone NICs

1. Example JSON for "Firewall" Zone

        {
          "alias": "firewall",
          "hostname": "firewall",
          "brand": "joyent",
          "max_physical_memory": 256,
          "image_uuid": "31bc4dbe-5e06-11e1-907c-5bed6b255fd1",
          "default_gateway": "192.168.0.1",
          "nics": [
            {
              "nic_tag": "admin",
              "ip": "192.168.0.100",
              "netmask": "255.255.255.0",
              "allow_ip_spoofing": true,
              "gateway": "192.168.0.1",
              "primary": true
            },
            {
              "nic_tag": "stub0",
              "ip": "10.0.0.1",
              "netmask": "255.255.255.0",
              "allow_ip_spoofing": true,
              "gateway": "10.0.0.1"
            }
          ]
        }

2. Example JSON for "Client" Zone/VM

        {
          "alias": "client",
          "hostname": "client",
          "brand": "joyent",
          "max_physical_memory": 256,
          "image_uuid": "31bc4dbe-5e06-11e1-907c-5bed6b255fd1",
          "nics": [
            {
              "nic_tag": "stub0",
              "ip": "10.0.0.2",
              "netmask": "255.255.255.0",
              "gateway": "10.0.0.1"
            }
          ]
        }

3. Create the zone

        vmadm create -f firewall.json
        vmadm create -f client.json

### Configure NAT

1. Log into the zone

        zlogin <uuid-of-firewall-zone>

2. Example /etc/ipf/ipnat.conf

   <!-- markdownlint-disable line-length -->

        map net0 10.0.0.2/32 -> 0/32
        # Uncomment the following line if you want clients to be able to talk to the firewall at its other IP address
        #rdr net1 192.168.0.100/32 -> 10.0.0.1

   <!-- markdownlint-enable line-length -->

3. Turn on packet forwarding and ipfilter

        routeadm -u -e ipv4-forwarding
        svcadm enable ipfilter
        ipnat -l

## References

- <https://blogs.oracle.com/droux/entry/private_virtual_networks_for_solaris>
- <https://gist.github.com/2639064>
- <https://gist.github.com/e18d343cde4509afaa51>
- <https://www.google.com/?q=etherstub%20ipnat>

### Alternate Instructions for NAT on SmartOS

- <https://docu.blackdot.be/snipets/solaris/smartos-nat>
- <https://gist.github.com/baetheus/5e1e5ab1eb68fae3490d>
