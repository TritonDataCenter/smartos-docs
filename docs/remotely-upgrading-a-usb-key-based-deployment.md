# Upgrading SmartOS

SmartOS is upgraded by simply booting to a new platform image. How you select
a new platform image depends on how you have chosen to boot SmartOS.

## Using `piadm` with a bootable pool

Using a bootable pool is by far the easiest way to manage the platform image
for SmartOS. If you chose to create a bootable pool at setup time, you can use
`piadm` to install and activate new images. `piadm` will also manage boot
loader images.

If you do not have a bootable pool, see the `piadm(8)` man page for help
creating one.

To list bootable pools

    piadm bootable

To list currently installed platform images

    piadm list

To list available newer verions

    piadm avail

To install a newer version image.

* `<platform>` can be just the platform stamp (e.g., `20200701T231659Z`) or a
  full URL. You can also use `latest` to get the latest version.
* `<zpool>` can be any valid bootable pool. By default, the default boot pool
  is used.

<!-- -->

    piadm install <platform> <pool>

To select any installed platform image

    piadm activate <stamp>

Here's an exmaple, with output.

    [root@smartos ~]# piadm list
    PI STAMP           BOOTABLE FILESYSTEM            BOOT IMAGE   NOW   NEXT
    20200714T195617Z   zones/boot                     next         yes   yes
    [root@smartos ~]# piadm -v install 20200715T192200Z
    Installing https://example.com/PIs/platform-20200715T192200Z.tgz
            (downloaded to /tmp/tmp.Bba0Ac)
    Installing PI 20200715T192200Z
    [root@smartos ~]# piadm list
    PI STAMP           BOOTABLE FILESYSTEM            BOOT IMAGE   NOW   NEXT
    20200714T195617Z   zones/boot                     next         yes   yes
    20200715T192200Z   zones/boot                     none         no    no
    [root@smartos ~]# piadm -v activate 20200715T192200Z
    Platform Image 20200715T192200Z will be loaded on next boot,
        WARNING:  20200715T192200Z has no matching boot image, using
        boot image  20200714T195617Z
    [root@smartos ~]# piadm list
    PI STAMP           BOOTABLE FILESYSTEM            BOOT IMAGE   NOW   NEXT
    20200714T195617Z   zones/boot                     next         yes   no
    20200715T192200Z   zones/boot                     none         no    yes
    [root@smartos ~]#

## Upgrading a USB Image

As with any operating system upgrade, there's risk involved with this
procedure. In the event that you downloaded a bad platform tarball, or
your USB key decides to malfunction, you could be left in a state where
your host doesn't come back online. You might want to perform the first
upgrade locally to test the build.

### Download And Verify the Platform Tarball

Either download directly as shown below, or copy the platform tarball
from another location onto the machine you want to upgrade.

    # cd /var/tmp
    # curl -O --insecure https://us-central.manta.mnx.io/Joyent_Dev/public/
    SmartOS/platform-latest.tgz
    # digest -a md5 platform-latest.tgz
    b4d64f93dc51d58adb72fcdcfa27ec37
    # curl -O --insecure https://us-central.manta.mnx.io//Joyent_Dev/public
    /SmartOS/20140111T020931Z/md5sums.txt
    # grep platform md5sums.txt
    b4d64f93dc51d58adb72fcdcfa27ec37 platform-20140111T020931Z.tgz

The URLs and MD5 sum shown above are for example purposes only. Please see
[this](https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/latest.html)
document for the correct link and expected MD5 sums.

#### Find and Mount the USB Key

The [diskinfo(1M)](https://smartos.org/man/1M/diskinfo) command displays
information about the physical disks (or other storage devices) attached
to the system.  We can use this tool to find the disk device that
represents the USB key. By default, the tool will display a table of all
disks in the system. Let's filter out just the USB disks:

    # diskinfo | awk 'NR == 1 || /^USB/ { print }'
    TYPE    DISK                    VID      PID              SIZE
    RMV SSD
    USB     c2t0d0                  Seagate  Portable          931.51 GiB
    no  no
    USB     c1t0d0                  SanDisk  Cruzer Glide        7.45 GiB
    yes no

There may be more than one USB storage device attached to your system.
In the output above, the USB key is a *SanDisk Cruze Glide* – note that
the **RMV** column lists this as a removable device. The other disk
(listed as non-removable) is a *Seagate Portable* hard disk. If more
disks are listed, you may need to mount the filesystem from each to
determine which one is the correct device.

In order to install the new platform image, we need to mount the root
filesystem on the USB key.

The format of the SmartOS USB image changed with the 20190411 release fr
om a Legacy GRUB-based USB key to a Loader-based USB key. For more details
see the following
[Flag Day Message](https://gist.github.com/jlevon/097f012eea04700657c35210fefd4018/).

If the system is currently using a Legacy GRUB-based USB key, then the
key uses the MBR partitioning scheme and the first primary partition of
the USB key device (`c1t0d0`) contains the pcfs fileystem we're
looking for.  However, if the system is using the newer Loader-based USB
key, then the key uses a hybrid GPT+MBR partition scheme and
the filesystem we're looking for will be on slice 2.

Loader-based USB key example:

    mount -F pcfs -o foldcase /dev/dsk/c1t0d0s2 /mnt

Legacy GRUB-based USB key example:

    mount -F pcfs -o foldcase /dev/dsk/c1t0d0p1 /mnt

Verify that you've mounted the correct partition by examining the
contents of the mounted filesystem:

    # ls /mnt
    boot      platform
    # find /mnt/platform
    /mnt/platform
    /mnt/platform/root.password
    /mnt/platform/i86pc
    /mnt/platform/i86pc/kernel
    /mnt/platform/i86pc/kernel/amd64
    /mnt/platform/i86pc/kernel/amd64/unix
    /mnt/platform/i86pc/amd64
    /mnt/platform/i86pc/amd64/boot_archive.hash
    /mnt/platform/i86pc/amd64/boot_archive.manifest
    /mnt/platform/i86pc/amd64/boot_archive.gitstatus
    /mnt/platform/i86pc/amd64/boot_archive

This looks to be correct for a bootable SmartOS USB key, so we'll
proceed.

#### Unpack the New Platform

The warnings from 'tar' may be safely ignored.

    # cd /mnt
    # tar xzf /var/tmp/platform-latest.tgz
    tar: warning - file permissions have changed for platform-20190424T23383
    4Z/i86pc/kernel/amd64/unix (are 0100777, should be 0755)
    tar: warning - file permissions have changed for platform-20190424T23383
    4Z/i86pc/amd64/boot_archive.gitstatus (are 0100777, should be 0644)
    tar: warning - file permissions have changed for platform-20190424T23383
    4Z/i86pc/amd64/boot_archive.manifest (are 0100777, should be 0644)
    tar: warning - file permissions have changed for platform-20190424T23383
    4Z/i86pc/amd64/boot_archive.hash (are 0100777, should be 0644)
    tar: warning - file permissions have changed for platform-20190424T23383
    4Z/i86pc/amd64/boot_archive (are 0100777, should be 0644)
    tar: warning - file permissions have changed for platform-20190424T23383
    4Z/root.password (are 0100777, should be 0644)
    # cd -
    /var/tmp

We now have two 'platform' directories:

    # ls -l /mnt
    total 24
    drwxrwxrwx   1 root     root        4096 Jan  3  2011 boot
    drwxrwxrwx   1 root     root        4096 Mar  7 23:27 platform
    drwxrwxrwx   1 root     root        4096 Mar 22 15:48 platform-20190424T
    233834Z

#### Indiana Jones Style Swap

Now all that's left is to start using the new platform directory. We do
this as one atomic operation to minimize risk. We'll also save the old
platform directory in an accessible location in case we need to boot
back into it.

    # mkdir /mnt/previous/
    # mv /mnt/platform /mnt/previous/ && mv /mnt/platform{-20190424T233834Z,}
    # ls -l /mnt
    total 24
    drwxrwxrwx   1 root     root        4096 Mar 27 09:30 previous
    drwxrwxrwx   1 root     root        4096 Jan  3  2011 boot
    drwxrwxrwx   1 root     root        4096 Mar 22 15:48 platform

Unmount the USB key and reboot at your convenience:

    # umount /mnt
    # reboot

#### If Something Goes Wrong

If you find that the new platform will not boot on your hardware, you'll
find error messages on the console.

If you see only a 'Starting up ...' and then your machine reboots, it means
you've attached to a serial port instead of the text console.

Using IPMI or a remote keyboard/video system, you'll need to instruct
the bootloader configuration to boot the previous platform image:

### Instructions for Loader-based USB

1. When the Loader menu is displayed, press ESCAPE to enter the Loader
command prompt.

2. Issue the following command to change the default platform to the
previous platform image:

        s" /previous" set-platform

3. Boot the platform

        boot

If you get an error message from 'krtld', it means you didn't follow the
instructions above and decided to rename the 'platform' directory itself;
cf. [PXE Booting SmartOS](pxe-booting-smartos.md).

### Instructions for Legacy GRUB-based USB

1. The first menu entry is highlighted by default, press 'e' to edit
it.
2. Press 'e' again to edit the 'kernel' line.
3. Using Ctrl-A, go to the beginning of the line.
4. Place a slash ('/') and the version string of your previous platform
immediately before the string '/platform', e.g. kernel
/previous/platform/... in our example above.
5. Hit &lt;RET&gt; (the 'Enter' key) to replace the line with your
edits.
6. Using the down arrow, select the next line, beginning with 'module'.
7. Place a slash ('/') and the version string of your previous platform
immediately before the string '/platform', e.g. module
/previous/platform/... in our example above.
8. Hit &lt;RET&gt; (the 'Enter' key) to replace the line with your
edits.
9. Press 'b' to boot into the old platform.

Instead of the procedure above, we could've edited the
boot/grub/menu.lst file on the USB key before unmounting it, and offered
another menu item to boot into the old platform. In the majority of
cases the new platform will boot just fine, so this effort was
considered unnecessary.
