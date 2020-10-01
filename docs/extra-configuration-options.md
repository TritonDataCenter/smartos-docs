# Extra Configuration Options

## Caveats

Just a list of available configuration options that can be used inside
`/usbkey/config`

This page is a work-in-progress, and the information here should probably
be refactored onto other pages.  Examples here aren't guaranteed to be
accurate with current builds of SmartOS.

## Additional NICs

    <nic_tag>_nic=00:01:02:03:04:05
    <nic_tag><instance#>_ip=aaa.bbb.ccc.ddd
    <nic_tag><instance#>_netmask=xxx.xxx.xxx.xxx
    <nic_tag><instance#>_network=...
    <nic_tag><instance#>_gateway=aaa.bbb.ccc.ddd
    <nic_tag><instance#>_mac=...

The `nic_tag` can be any short alpha string to name the newly added NIC.
The `_mac` line is optional. If not used, a randomly-generated mac
address will be assigned to the instance on each boot.

There two predefined `nic_tag`'s:

- `admin` - used for the private admin only network or as default
    NIC if only one interface is available
- `external` - used for connecting to the outer world

<!-- markdownlint-disable line-length -->

## Networking

| Key                          | Value                           | Description |
| ---------------------------- | ------------------------------- | ----- |
| `headnode_default_gateway` | aaa.bbb.ccc.ddd                 | The def ault gateway's IP-address If this value is not set the `admin_gateway` is used  |
| `dns_resolvers`             | aaa.bbb.ccc.ddd,aaa.bbb.ccc.ddd | List of one or more nameservers separated by comma  |
| `dns_domain`                | example.com                     | The default search domain. Can be any valid domain name |
| `ntp_hosts`                 | pool.ntp.org                    | List of one or more NTP servers separated by comma. This setting is only used if `ntp_conf_file` is not set |
| `coal`                       | true                            | *Set up the GZ to NAT for Coal*. This se tting depends on two defined nic_tags `admin` and `external` and wi ll use the configured networks to set up NAT for zones on the `external` NIC |

## Console / Login / SSH keys

| Key              | Value                 | Description |
| ---------------- | --------------------- | ---------------------------- |
| `root_shadow`    | &lt;password-hash&gt; | Can be set to a password hash for the root user. This setting is only used if the boot parameter `root_shadow` is not set and the file `/usbkey/shadow` does not exist |
| `default_keymap` | us                    | This sets the default keycap for all local logins. Valid values/filenames can be found here: `/usr/share/lib/keytables/type_6/`. |

## Including files

Files saved under `/usbkey/config.inc/` can be included. Key-value
pairs in `/usbkey/config` are set to the path to the file relative to
`/usbkey/config.inc/`, and do not have default values. (See
[source code](https://github.com/joyent/smartos-overlay/blob/299446b224d04d8e7eecaac892459f32c9553795/lib/svc/method/smartdc-config#L141).)

| Key                       |    Example Value    | Description |
| ------------------------- | ------------------- | ----------------- |
| `root_authorized_keys_file` | `authorized_keys` | This file is copied to `/root/.ssh/authorized_keys` for public key authentication on login. The exact commands to set this up can be found on the [SmartOS global zone tweaks](http://www.perkin.org.uk/posts/smartos-global-zone-tweaks.html) blog post. |
| `ntp_conf_file`             | `ntp.conf`        |  This file is copied to `/etc/inet/ntp.conf` and overrides the `ntp_hosts` variable |

## OS configuration options

| Key                       |    Example Value    | Description |
| ------------------------- | ------------------- | ----------------- |
| `smt_enabled`             | false                | Whether SMT siblings are enabled on the CPU. Defaults to true. |

## Other

| Key                       |    Example Value    | Description |
| ------------------------- | ------------------- | ----------------- |
| `datacenter_name`         | Any string          | Define a name for the datacenter. This will be in `/.dcinfo` and can be sourced in scripts |

## Examples

These are not proved to work everywhere - they "work for me"

### Single NIC with auto configured NAT

The used MAC addresses for `admin_nic` and `external_nic` can
match. So this one physical NIC gets tagged as admin and external.

    #
    # This file was auto-generated and must be source-able by bash.
    #

    # admin_nic is the nic admin_ip will be connected to for headnode zones.
    admin_nic=aa:bb:cc:dd:ee:ff
    admin_ip=10.0.0.1
    admin_netmask=255.255.0.0
    admin_network=...
    admin_gateway=10.0.0.1

    external_nic=aa:bb:cc:dd:ee:ff
    external0_ip=192.168.1.240
    external0_netmask=255.255.255.0
    external0_gateway=192.168.1.1

    coal=true

    headnode_default_gateway=192.168.1.1

    dns_resolvers=8.8.8.8,8.8.4.4
    dns_domain=example.com

    ntp_hosts=pool.ntp.org

    compute_node_ntp_hosts=192.168.1.240

    default_keymap=us
