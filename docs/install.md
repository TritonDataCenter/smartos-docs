# Installing SmartOS

The SmartOS install process is very straighforward, with only a few questions
that need to be answered.

1. Networking
2. DNS/NTP servers
3. Zpool Layout
4. Root password
5. Hostname
6. Boot Media
7. Packages

Here's a basic example of this process. Note, this example uses the serial
console, so the `loader` screen looks less fancy than you would see with an
attached display.

<!-- markdownlint-disable no-inline-html -->
<script id="asciicast-bqSpbAEbcdGhCs3FiO55WtZbr"
  src="https://asciinema.org/a/bqSpbAEbcdGhCs3FiO55WtZbr.js" async></script>
<!-- markdownlint-enable no-inline-html -->

## Networking

Choose `dhcp` or enter an IP address. If you enter an IP you will also be
prompted for a subnet mask.

You will be prompted for a default gateway. If you chose `dhcp`, select
`none` for the gateway, otherwise enter the IP.

## DNS/NTP Servers

By default, DNS servers will be `8.8.8.8` and `8.8.4.4`. You may change this if
you have closer DNS servers, but the default should work fine for most
installations. You will also need to provide a dns search domain. There is no
default. This doesn't really matter, so you can put `local` or `example.com` if
you don't have another preferred search domain.

By default NTP will be configured to use `0.smartos.pool.ntp.org`. If you're
going to use `ntp.org`, you should leave the default. Only change this if you
don't want to use ntp.org at all.

## Zpool Layout

SmartOS will intelligently pick a default layout. In most cases, the default
layout will be best. You may also choose to select `raidz2` or `mirror`
automatic layouts, or choose `manual` to drop to a shell and create the `zones`
pool yourself. The only requirement is that the pool is named `zones`.

Note: if you don't manually create the pool, the pool doesn't get created until
all setup choices are selected and confirmed at the end.

## Root Password

Pretty much like everywhere else, type in the same password twice. You will not
see the password on the screen.

## Hostname

You can use any valid hostname you like.

## Boot Media

By default SmartOS boots from read-only media, usually an ISO or USB drive.
You may instead choose to boot from the zpool.

* Choose `none` to boot using removable media.
* Choose `zones` to boot using the zpool.

If you choose `none` you can later switch to booting from the zpool using
the [`piadm(8)`][man-piadm] command.

[man-piadm]: https://smartos.org/man/8/piadm

## Packages

SmartOS uses the `pkgsrc` package management system that is also use by
NetBSD. You may decline to install pkgsrc, but it is almost always preferred.
If you decide not to install pkgsrc at this time, you can install it at any
later time by running `pkgsrc-setup` in the global zone.

## Finishing setup

A summary of your choices will be displayed. If you need to make changes setup
will start over with your previous choises now set as the default.

Once you confirm your choices, the zpool will be created, config file written
and the system will reboot.
