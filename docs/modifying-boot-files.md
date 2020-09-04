# Modifying Boot Files

It is sometimes the case that you may need to make a modification to files used
by the kernel very early in the boot process that needs to be present before
[SMF][1]. This is usually
used for driver config changes that need to be present at boot time, but are
also not appropriate to be the default for all users of SmartOS.

[1]: administering-the-global-zone/#creating-a-transient-service

This guide will demonstrate how to persistently override files on every boot.
This requires booting from a USB or the zpool.

## USB vs Zpool boot

Booting from a USB, all file locations discussed below will be relative to the
usb root, usually `/mnt/usbkey` when mounted in a running SmartOS system. Use
`diskinfo` to identify your USB drive, then mount it.

    /sbin/mount -F pcfs /dev/dsk/c1t0d0s2 /mnt/usbkey

Or, if you're using Triton, you can just run `sdc-usbkey mount`.

When booting directly from a zpool, all file locations will be relative to
`${BOOTPOOL}/boot`, usually `/zones/boot` or `/standalone/boot`. You can check
which bootable locations you have with `piadm list`, which will also tell you
where the bootable location is for that pool.

## Setting up the Modules Directory

Because everything is relative to the `boot` directory, first cd to it. Either
`/mnt/usbkey/boot` or `${BOOTPOOL}/boot`. The rest of the commands will be run
from that working directory.

In this example, we'll update `/etc/system`, but it's by no means limited to
just that.

    cd <boot root>
    mkdir -p bootfs/etc/
    cp /etc/system bootfs/etc/system
    echo "set kmem_flags=0xf" >> bootfs/etc/system

## Configuring loader

Now we want loader to prepare this file as a bootfs module.

    cat << EOF >> boot/loader.rc.local
    etc_system_load=YES
    etc_system_type=file
    etc_system_name=/bootfs/etc/system
    etc_system_flags="name=/etc/system"
    EOF

The prefix (`etc_system_*`) is arbitrary, though often named after the module.
For each file you want, you’d want a `*_load`, `*_type`, `*_name` and `*_flag`
line specified. The `*_name` parameter is the path to the file for loader to
use; the name *flag* is the `/system/boot/...` path you want the modified file
to be available at after booting.

## Booting With Supplemental Modules

If this all worked, then we should see something like this during boot. The
message displayed will be dependent on the change you're making, or may not even
emit a message at all. Messages that are emitted go to the system console, which
may not be the serial console.

    Loading /os/20190207T125627Z/platform/i86pc/kernel/amd64/unix...
    Loading /os/20190207T125627Z/platform/i86pc/amd64/boot_archive...
    Loading /os/20190207T125627Z/platform/i86pc/amd64/boot_archive.hash...
    Loading /bootfs/etc/system...
    Booting...
    SunOS Release 5.11 Version joyent_20190207T125627Z 64-bit
    Copyright (c) 2010-2019, Joyent Inc. All rights reserved.
    WARNING: High-overhead kmem debugging features enabled (kmem_flags = 0xf)...

And we should find a copy of our modified file here:

    # tail -1 /system/boot/etc/system
    set kmem_flags=0xf

The kernel has a search path such that it will load from `/system/boot` prior to
`/`. So the above is our active file, although `/etc/system` is still unmodified
as provided by the platform image, the one in `/system/boot` will override it.
