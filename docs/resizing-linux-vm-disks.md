# Resizing Linux VM disks

## Introduction

Resizing the primary disk of a Linux VM is actually fairly easy. This is
cut and paste from the Windows 7 instructions for the most part.

## Increasing Disk Size

1. Shut down the virtual machine from within the guest.
2. Find the name of the zvol that is being used as the root disk

        [root@00-19-99-b6-fa-12 ~]# zfs list
        NAME                                               USED  AVAIL REFER  MOUNTPOINT
        zones                                             97.1G   131G 483K  /zones
        zones/1b29b2e7-8741-4bc6-9465-bb0094bb905c        3.90G  6.10G 3.90G  /zones/1b29b2e7-8741-4bc6-9465-bb0094bb905c
        zones/1b29b2e7-8741-4bc6-9465-bb0094bb905c-disk0  4.08G   131G 4.08G  -
        zones/1b29b2e7-8741-4bc6-9465-bb0094bb905c/cores    31K  4.25G 31K  /zones/1b29b2e7-8741-4bc6-9465-bb0094bb905c/cores
        zones/708c73e3-48f2-4da5-a0a6-e161215a4215        2.97G  7.03G 2.97G  /zones/708c73e3-48f2-4da5-a0a6-e161215a4215
        zones/708c73e3-48f2-4da5-a0a6-e161215a4215-disk0  22.7G   131G 22.7G  -
        zones/708c73e3-48f2-4da5-a0a6-e161215a4215/cores    31K  7.03G 31K  /zones/708c73e3-48f2-4da5-a0a6-e161215a4215/cores
        zones/8aedbf84-81e7-49c5-9127-a3b0850e8df9        6.83G  3.17G 6.45G  /zones/8aedbf84-81e7-49c5-9127-a3b0850e8df9
        zones/8aedbf84-81e7-49c5-9127-a3b0850e8df9-disk0  14.4G   131G 14.4G  -
        zones/8aedbf84-81e7-49c5-9127-a3b0850e8df9/cores   394M  3.17G 394M  /zones/8aedbf84-81e7-49c5-9127-a3b0850e8df9/cores
        zones/config                                        57K   131G 57K  legacy
        zones/cores                                         31K  10.0G 31K  /zones/global/cores
        zones/dump                                        4.00G   131G 4.00G  -
        zones/opt                                         25.9G   131G 25.9G  legacy
        zones/swap                                        12.4G   143G 173M  -
        zones/usbkey                                       127K   131G 127K  legacy
        zones/var                                         3.05M   131G 3.05M  legacy

    This probably looks like `*-disk0`, so in this case it might be `zones/708c73e3-48f2-4da5-a0a6-e161215a4215-disk0`.

3. Check the current size with `zfs get volsize`

        [root@00-19-99-b6-fa-12 ~]# zfs get volsize zones/708c73e3-48f2-4da5-a0a6-e161215a4215-disk0
        NAME                                              PROPERTY  VALUE    SOURCE
        zones/708c73e3-48f2-4da5-a0a6-e161215a4215-disk0  volsize   60G      local

    In this case we can see that the disk is setup with a volume size of 60 gigabytes.

4. Set the volsize to some larger value (in this case 65 gigabytes):

        [root@00-19-99-b6-fa-12 ~]# zfs set volsize=65g zones/708c73e3-48f2-4da5-a0a6-e161215a4215-disk0

5. cd into the root directory of the zone and download the GParted Live ISO
 image available [here](http://gparted.sourceforge.net/).

    <!-- markdownlint-disable line-length -->

        [root@00-19-99-b6-fa-12 ~]# cd /zones/708c73e3-48f2-4da5-a0a6-e161215a4215/root
        [root@00-19-99-b6-fa-12 /zones/708c73e3-48f2-4da5-a0a6-e161215a4215/root]# wget <lastest stable>
        [root@00-19-99-b6-fa-12 /zones/708c73e3-48f2-4da5-a0a6-e161215a4215/root]# cd /zones/global

    <!-- markdownlint-enable line-length -->

6. Boot the VM from the GParted Live ISO using vmadm, then use vnc to connect
 to it.  An ssh tunnel works well as long as you specify the host as presented
 in the JSON (not localhost).

    <!-- markdownlint-disable line-length -->

        [root@00-19-99-b6-fa-12 /zones/global]# vmadm start 708c73e3-48f2-4da5-a0a6-e161215a4215 order=cd,once=d cdrom=/gparted-live-0.12.1-1.iso,ide
        [root@00-19-99-b6-fa-12 /zones/global]# vmadm info 708c73e3-48f2-4da5-a0a6-e161215a4215 vnc
        {
            "vnc": {
            "host": "10.0.1.1",
            "port": 51938,
            "display": 46038
            }
        }

    <!-- markdownlint-enable line-length -->

7. Use the GParted GUI to resize your primary partitions. For my VMs I
need to increase the size of logical partition then move the swap to
the end, then resize the logical partition towards the end. This
frees up space for the first (boot/root) partition to be expanded.
Just be sure to double check your swap is still working by logging
into the guest and issuing 'swapon -s'.

8. Exit from GParted desktop and then halt and then reboot the host.
You should now see that your hard drive has expanded.

## Decreasing Disk Size

Decrease the disk size is almost the same as increasing it. The only
difference is that you need to resize your paritions before you reduce
the zfs volsize. I had to delete my swap partition and then create a new
one to avoid a huge gap of unallocated space. Once everything is nice
and compact near the begging, just halt the VM and zfs set volsize away.
