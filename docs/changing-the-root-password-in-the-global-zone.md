# Changing the Root Password in the Global Zone

Because the Global Zone boots into a ramdisk, it's not obvious how to
make the most common change requested in that "ephemeral" environment:
changing root's password.

The `/etc/shadow` file is actually a file from the `/usbkey` filesystem
on the persistent zpool, which is "lofs-mounted" over the file in the
ramdisk-backed `/etc` filesystem. That mountpoint isn't writable by
normal means (see below for details), so to change that, you'll want to
make this change:

    umount /etc/shadow
    cp /usbkey/shadow /etc/shadow
    passwd root
    cp /etc/shadow /usbkey/shadow

This change will persist after reboots, because you've copied it back to
the `/usbkey/shadow` location. After a reboot, `/etc/shadow` will again
be an un-writable lofs mountpoint.

Alternately, you can (carefully) edit the hash in the `/usbkey/shadow`
file with a new one. The program `/usr/lib/cryptpass` will generate a
valid hash:

    # /usr/lib/cryptpass somepassword
    $5$7sz.bSyn$HDwvuZjfc/86EIXrfLOz2rwKMwYJkO859i/u5nrI9EA

... this method will require a reboot to take effect.
