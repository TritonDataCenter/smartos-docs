# Tuning the IO Throttle

A drawback of multi-tenancy in classic Solaris is that, where storage is
shared, a single application on a system can monopolize access to local
storage by a stream of synchronous I/O requests, effectively blocking
the system from servicing I/O requests from other zones and
applications, and causing performance slowdowns for other tenants.

In SmartOS, we've added a feature to track I/O, and throttle it from
misbehaving zones by adding a small delay to each read or write, thus
ensuring that other zones also get a turn at reading/writing to disk.
This is an operator-configurable setting, see below.

Disk I/O throttling only comes into effect when a system is under load
from multiple tenants. When a system is relatively quiet, a single
tenant can enjoy faster I/O without bothering the neighbors.

A detailed overview of the I/O throttle is available
[here](http://dtrace.org/blogs/wdp/2011/03/our-zfs-io-throttle/).

## I/O priority

Each zone has an I/O priority which determines its priority relative to
other zones. Unlike RAM and CPU shares, which correspond to a finite
resource, the I/O priorities are all relative, so three zones with
priorities (200, 200, 100) will elicit the same behavior as three zones
with priorities (100, 100, 50).

If priority is not explicitly set for a zone, it gets the default
priority (1).

It can be set via zonecfg:

    [root@bh1-live ~]# zonecfg -z wdpzone
    wdpzone: No such zone configured
    Use 'create' to begin configuring a new zone.
    zonecfg:wdpzone> create
    zonecfg:wdpzone> set zfs-io-priority=100
    zonecfg:wdpzone> info zfs-io-priority
    [zfs-io-priority: 100]
    zonecfg:wdpzone>

or get/set using `prctl`:

    [root@bh1-live ~]# prctl -n zone.zfs-io-priority  -i zone  z01
    zone: 1: z01
    NAME    PRIVILEGE       VALUE    FLAG   ACTION                    RECIPIENT
    zone.zfs-io-priority
            usage             100
            privileged        100       -   none                      -
            system          1.02K     max   none                      -
    [root@bh1-live ~]# prctl -n zone.zfs-io-priority -v 200 -r -i zone  z01
    [root@bh1-live ~]# prctl -n zone.zfs-io-priority  -i zone  z01
    zone: 1: z01
    NAME    PRIVILEGE       VALUE    FLAG   ACTION                    RECIPIENT
    zone.zfs-io-priority
            usage             200
            privileged        200       -   none                      -
            system          1.02K     max   none                      -
