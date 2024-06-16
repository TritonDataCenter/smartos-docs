# Creating a SmartOS Bootable USB Key

Before you begin, [download the image](download-smartos.md).

## macOS

1. Insert your USB key. **All data on the USB key will be replaced.**
2. Find the USB key's disk identifier.

        $ diskutil list
        /dev/disk0
           #:                       TYPE NAME                    SIZE IDENTIFIER
           0:      GUID_partition_scheme                        *500.1 GB   disk0
           1:                        EFI                         209.7 MB   disk0s1
           2:                  Apple_HFS Macintosh HD            499.8 GB   disk0s2
        /dev/disk2
           #:                       TYPE NAME                    SIZE IDENTIFIER
           0:     Apple_partition_scheme                        *998.1 GB   disk2
           1:        Apple_partition_map                          32.3 KB   disk2s1
           2:                 Apple_HFSX Time Machine Backups    998.1 GB   disk2s2
        /dev/disk3
           #:                       TYPE NAME                    SIZE IDENTIFIER
           0:     FDisk_partition_scheme                        *4.0   GB   disk3
           1:             Windows_FAT_32 NONAME                  995.2 MB   disk3s1

   In this case, the USB key disk identifier `/dev/disk3`.
   It's likely that your device location will be different.

3. Unmount the USB key and copy the image to it. Use `/dev/rdiskX`
   instead of `/dev/diskX` with the `dd` command to speed the
    transfer.
    Be sure to double check the disk identifier. **The `dd`command
    will destroy any existing data on the target disk.**

        diskutil unmountDisk /dev/disk3
        gunzip smartos-latest-USB.img.gz
        sudo dd bs=1m if=smartos-latest-USB.img of=/dev/rdiskX

4. Eject the volume

        diskutil eject /dev/disk3

## Linux

1. Insert your USB key. **All data on the USB key will be replaced.**
2. Find the USB key's disk identifier.

        $ fdisk -l
        255 heads, 63 sectors/track, 60801 cylinders
        Units = cylinders of 16065 * 512 = 8225280 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disk identifier: 0x7ecb51e2

           Device Boot      Start         End      Blocks   Id  System
        /dev/sda1   *           1          52      409600   27  Unknown
        Partition 1 does not end on cylinder boundary.
        /dev/sda2              52       18959   151870464    7  HPFS/NTFS
        /dev/sda3           18959       30432    92158977    f  W95 Ext'd (LBA)
        /dev/sda4           30432       60802   243944472    7  HPFS/NTFS
        /dev/sda5           18959       30432    92158976   83  Linux

        Disk /dev/sdb: 7958 MB, 7958691840 bytes
        255 heads, 63 sectors/track, 967 cylinders
        Units = cylinders of 16065 * 512 = 8225280 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disk identifier: 0x00000000

           Device Boot      Start         End      Blocks   Id  System
        /dev/sdb1               1         243     1951866    c  W95 FAT32 (LBA)

   In this case, the USB key disk identifier `/dev/sdb`.
   It's likely that your device location will be different.

3. Copy the image to the USB key.
   Be sure to double check the disk identifier. **The `dd` command will
   destroy any existing data on the target disk.**

        gunzip smartos-$RELEASE-usb.img.gz
        dd if=smartos-$RELEASE-usb.img of=/dev/sdb bs=1024

## Windows

1. Install Zip Utility.
   Joyent provides compressed images in the GZIP file format.
   [7-Zip](http://www.7-zip.org/) is a free open source utility that
   supports .gz files on Windows.
2. Install Disk Imaging Utility.  The open-source utility
   [win32diskimager](https://wiki.ubuntu.com/Win32DiskImager) from the
   Ubuntu project will safely and properly burn the `.img` file.
3. Unzip the .gz file.  Use 7-Zip to extract the `.img` file from the
   .gz file.
4. Insert your USB key. **All data on the USB key will be replaced.**
5. Burn the .img file.  Use win32diskimager to burn the .img file to the
   USB key.

## OpenIndiana

1. Insert your USB key. **All data on the USB key will be replaced.**
2. Find the USB key's disk identifier.

        $ rmformat
        Looking for devices...
             1. Logical Node: /dev/rdsk/c2t0d0p0
                Physical Node: /pci@0,0/pci-ide@1f,1/ide@0/sd@0,0
                Connected Device: QSI      DVD-RAM SDW-086  ES71
                Device Type: CD Reader
            Bus: IDE
            Size: <Unknown>
            Label: <Unknown>
            Access permissions: <Unknown>
             2. Logical Node: /dev/rdsk/c6t0d0p0
                Physical Node: /pci@0,0/pci104d,8212@1d,7/storage@3/disk@0,0
                Connected Device: Kingston DataTravelerMini PMAP
                Device Type: Removable
            Bus: USB
            Size: 984.0 MB
            Label: USBKEY
            Access permissions: Medium is not write protected.

    In this case, the USB key disk identifier `/dev/rdsk/c6t0d0p0`.
    It's likely that your device location will be different.

3. Unmount the USB (if necessary) key and copy the image to it.
   Be sure to double check the disk identifier. **The `dd` command
   will destroy any existing data on the target disk.**

        umount /media/USBKEY
        gunzip smartos-$RELEASE-usb.img.gz
        dd if=smartos-$RELEASE-usb.img of=/dev/rdsk/c6t0d0p0 bs=1024k

## FreeBSD

1. Insert your USB key. **All data on the USB key will be replaced.**
2. Find the USB key's disk identifier using `gpart`.

        # gpart list
        Geom name: ada0
        modified: false
        state: OK
        fwheads: 16
        fwsectors: 63
        last: 468862087
        first: 40
        entries: 152
        scheme: GPT
        Providers:
        1. Name: ada0p1
           Mediasize: 209715200 (200M)
           Sectorsize: 512
           Stripesize: 4096
           Stripeoffset: 0
           Mode: r0w0e0
           efimedia: HD(1,GPT,abb52720-44c0-11ea-a4dc-0025902dffd4,0x28,0x64000)
           rawuuid: abb52720-44c0-11ea-a4dc-0025902dffd4
           rawtype: c12a7328-f81f-11d2-ba4b-00a0c93ec93b
           label: efiboot0
           length: 209715200
           offset: 20480
           type: efi
           index: 1
           end: 409639
           start: 40
        2. Name: ada0p2

        ... skipping

        Geom name: da0
        modified: false
        state: OK
        fwheads: 255
        fwsectors: 63
        last: 15248831
        first: 63
        entries: 4
        scheme: MBR
        Providers:
        1. Name: da0s1
           Mediasize: 1999564800 (1.9G)
           Sectorsize: 512
           Stripesize: 0
           Stripeoffset: 307200
           Mode: r1w1e2
           efimedia: HD(1,MBR,00000000,0x258,0x3b9778)
           attrib: active
           rawtype: 12
           length: 1999564800
           offset: 307200
           type: fat32lba
           index: 1
           end: 3905999
           start: 600
        Consumers:
        1. Name: da0
           Mediasize: 7807401984 (7.3G)
           Sectorsize: 512
           Mode: r1w1e3

The USB device `da0` is our target. In our case it already had a partition.
Don't mount the stick.  Copy img file using dd (may need root depending on
your setup):

        # dd if=smartos-latest-USB.img of=/dev/da0 bs=1024

<!-- markdownlint-disable no-trailing-punctuation -->
## And then...
<!-- markdownlint-enable no-trailing-punctuation -->

Stick the USB key in a port and boot from it!
