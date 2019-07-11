# Setting up IPv6 in a Zone

As of `20150917T235937Z` IPv6 support has been added to vmadm via a
new property `ips`. The ips parameter supports multiple addresses
including IPv4, IPv6, dhcp (for IPv4), and addrconf (for SLAAC or
DHCPv6).

Link local addresses, DHCPv6 and static are implicitly permitted. As
of `20151224T060557Z`, SLAAC addresses are, too. Before that, though,
each SLAAC address needs to be added to `nics.*.allowed_ips`
or `allow_ip_spoofing` needs to be enabled. If an IPv6 address or
addrconf are specified, in.ndpd will be automatically enabled.

In this example, the expected IPv6 address has been derived from the
`mac` field via EUI-64 and added to `allowed_ips`.

    # vmadm get 94ff50ad-ac74-46ac-8b9d-c05ddf55f434 | json -a nics
    [
      {
        "interface": "net0",
        "mac": "72:9c:d5:34:47:59",
        "nic_tag": "external",
        "gateway": "198.51.100.1",
        "gateways": [
          "198.51.100.1"
        ],
        "allowed_ips": [
          "2001:db8::709c:d5ff:fe34:4759"
        ],
        "ip": "198.51.100.37",
        "ips": ["198.51.100.37/24", "addrconf"]
        "netmask": "255.255.255.0",
        "primary": true
      }
    ]

See `vmadm(1)` for more information.
