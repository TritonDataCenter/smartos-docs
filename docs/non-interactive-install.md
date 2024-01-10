# Non-interactive Installation of SmartOS

SmartOS installation can be automated either fully or partially non-interactive.
This is similar to kickstart, jumpstart, installerconfig, or other unattended
installation methods used by many operating systems.

On SmartOS this is done with an `answers.json` file. The answer file must be
placed at `private/answers.json` of the installation media and be valid JSON.

An example `answers.json` file looks like this:

```json
{
  "config_console": true,
  "skip_instructions": true,
  "simple_headers": true,
  "admin_mac": "52:54:00:2f:61:34",
  "admin_ip": "dhcp",
  "headnode_default_gateway": "none",
  "dns_resolver1": "8.8.8.8",
  "dns_resolver2": "8.8.4.4",
  "dns_search": "example.com",
  "ntp_host": "0.smartos.pool.ntp.org",
  "skip_ntp_check": true,
  "zpool_layout": "default",
  "zpool_confirm_layout": "yes",
  "bootpool": "none",
  "install_pkgsrc": "no",
  "root_password": "secret",
  "hostname": "brainiac",
  "skip_final_confirm": true
}
```

## Supported Keys

The following keys are meaningful in an answer file on SmartOS. Keys other than
the ones listed will be ignored. If a key is missing, setup will prompt for
an answer.

After setup is finished the system will automatically reboot.

Valid config keys not listed here (e.g., additional NIC tags, VLANs, IPv6,
etc.) must be done post-setup in `/usbkey/config`.

### config_console

This key must be present to indicate non-interactive install is desired. If
this key is missing, setup will silently block waiting for the user to press
Enter. This can be useful if you want the system to boot up and be ready to
install, but wait for an operator

### skip_instructions

If set to `true` setup will not display instructional text for each section of
setup. If this key is not set `true` setup will block waiting for user input.

### simple_headers

If set to `true` setup will display a brief header and will not clear the
display between setup sections.

### admin_mac

This must be a valid MAC address of a NIC that is attached to the system. If
an invalid value is supplied the setup will fail.

### admin_ip

This must be either `dhcp` or a valid IP address in dotted decimal form
(e.g., `198.51.100.10`)

### admin_netmask

If `admin_ip` is set to `dhcp`, this key is not needed.

This must be a valid subnet mask in dotted decimal form (e.g., `255.255.255.0`),
not a prefix length (e.g., `/24`).

### headnode_default_gateway

This key is required, even if `admin_ip` is set to `dhcp`.

If `admin_ip` is set to `dhcp` then this should be set to `none`.

If `admin_ip` is set to an IP address then this must be set to an IP address.

### dns_resolver1, dns_resolver2

This must be valid IP addresses that will act as recursive resolvers. DNS
resolvers will be checked for connectivity.

### dns_search

This should be a valid domain name.

### ntp_host

This is either an IP address or hostname of an NTP server. The NTP server will
be checked for connectivity with `ntpdate`. Failure to contact the NTP server
will not fail setup.

### skip_ntp_check

If this is set to `true` then the NTP server check will be skipped. The
ntp.org pool is run by volunteers, and sometimes individual IPs will be
non-responsive. Skipping this check will avoid a delay in those cases.

### zpool_layout

This determines the zpool layout using the `disklayout` tool. You can use
`disklaout` on a running SmartOS system to preview the layout that will be
generated for various disk configurations.

With each layout, the systemw ill attempt to intelligently assign storage,
spare, log, and cache devices automatically. See [`disklayout(8)`][1] for more
information.

[1]: https://smartos.org/man/8/disklayout

Not all values supported by `disklayout` are valid during setup. The only valid
values recognizd by setup are:

**default**: The default layout suggested by SmartOS will be used.

**mirror**: Requires a minimum of two disks. SmartOS will do its best to pair
up devices into an array of mirrors. E.g., if there are four disks then there
will be two, two-way mirrors. If there are six disks there will be three,
two-way mirrors. If there is an odd number of disks then one disk will be a
spare.

**raidz2**: Requires a minimum of five disks. SmartOS will do its best to create
an array of raidz2 vdevs. If there are sufficient disks, multiple raidz2 vdevs
will be created.

**manual**: While technically a valid value, this will cause the installer
to drop to a shell for the operator to create the pool using `zpool create`.

### zpool_confirm_layout

This must be set to `yes` or setup will block waiting for the user to confirm
the layout.

### bootpool

This can be either `none`, or `zones`. Other values are legal, but a boot pool
other than `zones` must be created manually.

### install_pkgsrc

If set to `true` or `yes`, the pkgsrc-setup command will be run and pkgsrc
will be installed during setup.

### root_password

This string will be used to generate a password hash added to the `shadow`
file for the `root` user.

**Note:** Leaving the `answer.json` file on the USB with the `root_password`
will expose the password to anyone who has access to the file.

### hostname

The system hostname.

### skip_final_confirm

If set to `true`, setpu will skip the final confirmation. If missing or set to
any other value setup will display a summary and prompt for confirmation before
anything is applied.
