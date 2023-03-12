# Setting up IPv6 in a Zone

Assigning IPv6 addresses work very similarly to IPv4 addresses. There are,
however, a few things to be aware of.

* The `ip` and `netmask` parameters only supports IPv4 addresses.
* The `ips` property is an array that supports both IPv4 and IPv6 addresses
  in CIDR notation.
* For SLAAC or DHCPv6 use the `addrconf` keyword.
* Static addresses must still receive a default route via router-advertisements.

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
        "ip": "198.51.100.37",
        "ips": [
          "198.51.100.37/24",
          "addrconf"
        ],
        "netmask": "255.255.255.0",
        "primary": true
      }
    ]

See `vmadm(8)` for more information.
