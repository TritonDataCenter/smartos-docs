# SmartOS Command Line Tips

<!-- markdownlint-disable line-length -->

<!--
    A lot of the content of this page is command output, which is sometimes
    quite wide.
-->

This topic contains helpful commands with examples of each command that
will help you manage SmartOS. These tips were derived from a blog post
by community member Mark Slatem. You can follow Mark and his adventures
with the Illumos family of technology at:

## Disk

These commands are specifically related to disks and ZFS pools.

### Checking the health of disks and ZFS pool

`zpool status`

    [root@smartosn2 ~]# zpool status
    pool: zones
    state: ONLINE
    scan: none requested
    config:

    NAME STATE READ WRITE CKSUM
    zones ONLINE 0 0 0
    raidz1-0 ONLINE 0 0 0
    c0t10d0 ONLINE 0 0 0
    c0t11d0 ONLINE 0 0 0
    c0t9d0 ONLINE 0 0 0
    errors: No known data errors

### Checking the status of RAW space on a zpool

`zpool list`

    [root@smartosn2 ~]# zpool list
    NAME    SIZE  ALLOC   FREE  EXPANDSZ    CAP  DEDUP  HEALTH  ALTROOT
    zones   832G  67.9G   764G         -     8%  1.00x  ONLINE  -

### Checking the status of usable space on a ZFS volume

`zfs list zones`

    [root@smartosn2 ~]# zfs list zones
    NAME    USED  AVAIL  REFER  MOUNTPOINT
    zones  60.9G   485G   518K  /zones

### Turning on ZFS compression for an entire SmartOS system and confirm its enabled

`zfs set compression=on zones && zfs get compression zones`

    [root@smartosn2 ~]# zfs set compression=on zones && zfs get compression
    zones
    NAME   PROPERTY     VALUE     SOURCE
    zones  compression  on        local

### Checking the status of the data compression ratio for zones

`zfs get compressratio zones`

    [root@smartosn2 ~]# zfs get compressratio zones
    NAME   PROPERTY       VALUE  SOURCE
    zones  compressratio  1.46x  -

### Checking the current ZFS ARC size

`kstat -p zfs:0:arcstats:size | cut -f2`

    [root@smartosn2 ~]# kstat -p zfs:0:arcstats:size | cut -f2
    6000901680

### Watching ARC statistics in real-time

`arcstat 1 10`

    [root@smartos-node-1 ~]# arcstat 1 10
        time  read  miss  miss%  dmis  dm%  pmis  pm%  mmis  mm%  arcsz     c
    06:34:59     0     0      0     0    0     0    0     0    0    13G   13G
    06:35:00   966    45      4    45    4     0    0     3   42    13G   13G
    06:35:01  1.3K     8      0     8    0     0    0     0    0    13G   13G
    06:35:02  1.1K    18      1    18    1     0    0     0    0    13G   13G
    06:35:03   993    28      2    28    2     0    0     1    8    13G   13G
    06:35:04  1.9K    22      1    22    1     0    0     0    0    13G   13G
    06:35:05  1.2K    19      1    19    1     0    0     1  100    13G   13G
    06:35:06  1.1K    22      2    22    2     0    0     1   20    13G   13G
    06:35:07  1.3K     7      0     7    0     0    0     0    0    13G   13G
    06:35:08   677     4      0     4    0     0    0     0    0    13G   13G

Checking the amount of space used by snapshots on a specific virtual machine

`zfs list -o space zones/UUID-disk0`

    [root@smartosn2 ~]# zfs list -o space zones/0577f50a-f8ac-42fa-b68e-154ff58506b3-disk0
    NAME                                              AVAIL   USED  USEDSNAP USEDDS
    zones/0577f50a-f8ac-42fa-b68e-154ff58506b3-disk0   485G  1.61G      285M 1.33G

### Watching individual disk read and write operations

`zpool iostat -v zones 10`

    [root@smartos-node-1 ~]# zpool iostat -v zones 10
                    capacity     operations    bandwidth
    pool         alloc   free   read  write   read  write
    -----------  -----  -----  -----  -----  -----  -----
    zones         303G  2.95T     36    501   118K  9.41M
      raidz1      303G  2.95T     36    501   118K  9.41M
        c0t16d0      -      -     22    137  27.0K  1.92M
        c0t17d0      -      -     20    136  24.3K  1.91M
        c0t18d0      -      -     22    137  27.0K  1.92M
        c0t19d0      -      -     20    136  24.4K  1.91M
        c0t20d0      -      -     22    137  27.0K  1.92M
        c0t21d0      -      -     20    136  24.3K  1.91M
    cache            -      -      -      -      -      -
      c2d0        112G     8M     17      4   287K   502K
    -----------  -----  -----  -----  -----  -----  -----

### Listing specific virtual machine attributes including disk quotas

`vmadm list -o uuid,type,ram,nics.0.ip,quota,alias | grep -v KVM`

    [root@smartosn2 ~]# vmadm list -o uuid,type,ram,nics.0.ip,quota,alias |
    grep -v KVM
    UUID                                  TYPE  RAM      NICS.0.IP  QUOTA  ALIAS
    43c2f02a-711d-4284-a7e5-f0e61b2b02f3  OS    512      10.1.1.125 20     dnsmasq
    4dfccd80-ed37-4906-8957-061d19125219  OS    512      10.1.1.86  10     standard64
    6dd16a1c-0bd7-4243-a1d7-7184032be567  OS    2048     10.1.1.240 40     fifo
    17510b88-b8fe-44fc-ad72-4a6f011d3ee4  OS    3072     10.1.1.130 20     confl-jira-dev

### Increasing the disk space for a Joyent branded virtual machine on the fly

`vmadm update UUID quota=X`

    [root@smartosn2 ~]# vmadm update 43c2f02a-711d-4284-a7e5-f0e61b2b02f3 quota=150
    Successfully updated 43c2f02a-711d-4284-a7e5-f0e61b2b02f3

### Determining if any virtual machines are being ZFS IO throttled

`d/s` and `del_t` are very important

`vfsstat -M -Z 5`

    [root@smartos-node-1 ~]# vfsstat -M -Z 5
      r/s   w/s  Mr/s  Mw/s ractv wactv read_t writ_t  %r  %w   d/s  del_t zone
    542.3   4.2   0.8   0.0   0.0   0.0    0.0    0.7   0   0   0.0    0.0 global (0)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 3b45ecfa (1)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 a04a5894 (2)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 befb49f3 (3)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 4c0ce8c9 (5)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 b90c54cd (6)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0  90.0  100.0 a07ba0ca (7)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 25f82695 (9)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 d4e5b942 (10)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0  29.3    9.7 633df8db (11)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   1.8    5.0 41a69306 (15)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 fifo (28)
      0.0   0.0   0.0   0.0   0.0   0.0    0.0    0.0   0   0   0.0    0.0 3de9cab6 (29)

### Determining how busy disks are with activity

`%w` and `%b` are very important

`iostat -xzn 5`

    [root@smartos-node-1 ~]# iostat -xzn 5
                        extended device statistics
        r/s    w/s   kr/s   kw/s wait actv wsvc_t asvc_t  %w  %b device
      212.2   13.0 3609.6 1228.8  0.1  0.1    0.4    0.4   3   6 c2d0
      132.6  352.6  368.3 5035.9  0.0  2.0    0.0    4.1   0  53 c0t16d0
      130.6  351.8  367.2 5040.3  0.0  2.1    0.0    4.3   0  55 c0t17d0
      129.2  356.0  356.3 5038.1  0.0  2.3    0.0    4.8   0  57 c0t18d0
      126.4  356.0  355.9 5031.0  0.0  2.2    0.0    4.6   0  55 c0t19d0
      130.6  352.8  377.6 5043.4  0.0  2.0    0.0    4.2   0  54 c0t20d0
      134.4  353.2  372.7 5033.1  0.0  2.1    0.0    4.3   0  56 c0t21d0

### Seeing raw page allocations for ZFS file data

`echo ::memstat | mdb -k`

    [root@smartosn2 ~]# echo ::memstat | mdb -k
    Page Summary                Pages                MB  %Tot
    ------------     ----------------  ----------------  ----
    Kernel                     692333              2704   19%
    ZFS File Data             1125020              4394   30%
    Anon                      1624164              6344   44%
    Exec and libs                4558                17    0%
    Page cache                  15350                59    0%
    Free (cachelist)            12484                48    0%
    Free (freelist)            217036               847    6%

    Total                     3690945             14417
    Physical                  3690944             14417

### Determining if disk I/O is the source of application latency for a virtual machine

`ziostat -Z 5`

    [root@smartos-node-1 ~]# ziostat -Z 5
        r/s   kr/s   actv wsvc_t asvc_t  %b zone
        0.0    0.0    0.0    0.0    0.0   0 global (0)
        0.8    1.9    0.0    0.0    2.5   0 3b45ecfa (1)
        1.0    0.5    0.0    0.0    6.4   0 a04a5894 (2)
        1.2    6.6    0.0    0.0    1.3   0 befb49f3 (3)
        0.0    0.0    0.0    0.0    0.0   0 4c0ce8c9 (5)
        1.0    0.5    0.0    2.1   11.6   0 b90c54cd (6)
        1.2    1.7    0.0    0.0    4.7   0 a07ba0ca (7)
        0.0    0.0    0.0    0.0    0.0   0 25f82695 (9)
        0.0    0.0    0.0    0.0    0.0   0 d4e5b942 (10)
        2.8   16.5    0.0    0.0    1.5   0 633df8db (11)
        0.0    0.0    0.0    0.0    0.0   0 41a69306 (15)
        0.0    0.0    0.0    0.0    0.0   0 fifo (28)
        0.0    0.0    0.0    0.0    0.0   0 3de9cab6 (29)

## CPU and Memory

These commands are specifically related to statistics about CPU and
memory.

### Checking the CPU and core count

`psrinfo -vp`

    [root@smartos-node-1 ~]# psrinfo -vp
    The physical processor has 6 cores and 12 virtual processors (0 2 4 6 8
    10 12 14 16 18 20 22)
      The core has 2 virtual processors (0 12)
      The core has 2 virtual processors (2 14)
      The core has 2 virtual processors (4 16)
      The core has 2 virtual processors (6 18)
      The core has 2 virtual processors (8 20)
      The core has 2 virtual processors (10 22)
        x86 (GenuineIntel 206C2 family 6 model 44 step 2 clock 2400 MHz)
          Intel(r) Xeon(r) CPU           E5645  @ 2.40GHz
    The physical processor has 6 cores and 12 virtual processors (1 3 5 7 9
    11 13 15 17 19 21 23)
      The core has 2 virtual processors (1 13)
      The core has 2 virtual processors (3 15)
      The core has 2 virtual processors (5 17)
      The core has 2 virtual processors (7 19)
      The core has 2 virtual processors (9 21)
      The core has 2 virtual processors (11 23)
        x86 (GenuineIntel 206C2 family 6 model 44 step 2 clock 2400 MHz)
          Intel(r) Xeon(r) CPU           E5645  @ 2.40GHz

### Looking at my CPU statistics and checking the balance for core utilisation

`mpstat 1 5`

    [root@smartos-node-1 ~]# mpstat 1 5
    CPU minf mjf xcal  intr ithr  csw icsw migr smtx  srw syscl  usr sys  wt idl
      0    9   0   23  2663 1122 10297  94  497  913    0 22367    5  14   0 81
      1  491   0   22  2128 1025 2642   10  144  780    0  7103    5  11   0 84
      2    0   0   14  2723 1302 5165   50  310  972    0 10080    2  14   0 84
      3    0   0   32  2687 1291 3921   16  186  803    0  6525    2   9   0 89
      4  253   0    7   190   61 2245   29  141  759    0  6756    3   7   0 90
      5    0   0   19  1419  389 1959   19  127  665    0  2861    1  20   0 79
      6    0   0   37  2740 1329 4803   32  198  833    0 10305    2   9   0 89
      7   61   0   15   277   42 3240    8  145  701    0  8393    2   8   0 90
      8    0   0    5  2626 1223 2577   37  139  669    0  4020    1   9   0 90
      9    9   0  110  4771 4421 4185   45  379 1025    0  7759    2  12   0 86
     10    0   0  280  4538 2182 4362   41  188  894    0  9750    2   9   0 89
     11    1   0   11   150   39 2694    2  114  811    0  4371    2   9   0 89
     12 1309   0   19   577  406 2891   38  147  675    0  9025    3   9   0 88
     13   13   0   16   981  804 3342   12  119  729    0  7746    2   9   0 89
     14    1   0    6   659  277 2100   25  133  798    0  4311    1   7   0 92
     15    0   0    6   890  428 1470    6   94  736    0  2399    1   6   0 93
     16    0   0    5  2452 1191 3792   21  183  922    0  8583    1   7   0 92
     17    0   0   17   585  256 1709   16  145  838    0  3477    1   9   0 90
     18    0   0    5  2300 1115 3212   34  140  696    0  6565    1   7   0 92
     19    0   0   16   122   35  912    8   85  568    0  1873    1   5   0 94
     20    0   0   10  3959 1640 4985   52  190  798    0  6366    1  11   0 88
     21    0   0   20   182   53 3446    8  137  636    0  6862    2   9   0 89
     22    0   0    5    90   17 2609   31  109  670    0  4204    1   6   0 93
     23  160   0   45  5736 2823 4068    9  141  716    0  4063    2  10   0 88

### Checking the amount of memory on a system

`sysinfo`

    [root@smartos-node-1 ~]# sysinfo | json 'MiB of Memory'
    47184

### Checking virtual memory statistics

`vmstat`

    [root@smartos-node-1 ~]# vmstat
     kthr      memory            page            disk          faults      cpu
     r b w   swap  free  re  mf pi po fr de sr cd lf rm s0   in   sy   cs us sy id
     0 0 0 26318348 1403084 304 2631 0 0 0 0 0 22  0 -1327 15 43058 171189 7 8397 2 5 93

### Checking process statistics for a system and virtual machine zones

`prstat -Z`

    [root@smartos-node-1 ~]# prstat -Z
       PID USERNAME  SIZE   RSS STATE  PRI NICE      TIME  CPU PROCESS/NLWP
     18934 root     2098M 2086M sleep   58    0 550:06:58 1.1% qemu-system-x86/6
      3095 root      553M  541M cpu12   59    0 297:38:25 0.6% qemu-system-x86/5
      4308 root     8288M 8276M sleep    1    0 294:55:12 0.6% qemu-system-x86/10
      3576 root     1066M 1054M sleep    9    0 202:31:31 0.4% qemu-system-x86/4
      3332 root      554M  542M cpu3    59    0 161:32:02 0.4% qemu-system-x86/5
      3820 root     1838M 1826M cpu3    59    0 177:06:17 0.3% qemu-system-x86/5
      4064 root     4151M 4139M sleep   59    0 173:47:37 0.3% qemu-system-x86/5
      2921 root       60M   42M sleep   57    0 107:22:27 0.3% beam.smp/29
       431 root        0K    0K sleep   99  -20 181:10:13 0.2% zpool-zones/182
      3217 root      553M  541M sleep   59    0  94:06:46 0.2% qemu-system-x86/5
      4186 root     4181M 4170M sleep   59    0  45:10:47 0.1% qemu-system-x86/10
     41370 root       72M   59M sleep   51    0   3:42:33 0.0% beam.smp/29
      3003 root     3780K 1564K sleep   59    0  17:57:04 0.0% inet_gethost/1
      3698 root     1077M 1065M sleep    1    0  16:36:27 0.0% qemu-system-x86/6
     41391 root       50M   32M sleep   44    0   2:00:26 0.0% beam.smp/29
     41414 root       53M   38M sleep   56    0   1:43:15 0.0% beam.smp/29
     36531 root     3924K 1356K sleep   48    0   0:00:02 0.0% inet_gethost/1
     49738 root     1120M 1108M sleep   49    0   1:27:49 0.0% qemu-system-x86/4
    ZONEID    NPROC  SWAP   RSS MEMORY      TIME  CPU ZONE
        15        2 2098M 2086M   4.4% 550:06:58 1.1% 41a69306-0ed6-40e9-a91e-05794421cb5b
         1        2  553M  541M   1.1% 297:38:25 0.6% 3b45ecfa-7c74-459e-8534-00d1f79a07ea
        11        2 8288M 8276M    18% 294:55:12 0.6% 633df8db-46ab-47b0-8c7a-b38f8b90e2d5
         0       88  555M  326M   0.5% 323:12:37 0.6% global
         5        2 1066M 1054M   2.2% 202:31:31 0.4% 4c0ce8c9-432e-48a4-80b3-579e3ff11cf0
         3        2  554M  542M   1.1% 161:32:02 0.4% befb49f3-8f9f-404a-9683-b64b94005423
         7        2 1838M 1826M   3.9% 177:06:17 0.3% a07ba0ca-bc6b-4703-95ba-4b395c68947a
         9        2 4151M 4139M   8.8% 173:47:37 0.3% 25f82695-85d0-446a-b017-5f00789e94e5
    Total: 155 processes, 836 lwps, load averages: 1.58, 1.59, 1.73

### Determining if virtual machines are running out of memory

`zonememstat`

    [root@smartosn2 ~]# zonememstat
                                     ZONE  RSS(MB)  CAP(MB)    NOVER  POUT(MB)
                                   global      170        -        -  -
     1e0bdc72-3d06-4aaa-819c-062c26621c77     1057     2048        0  0
     dd889ecd-2fdc-4e04-be8c-27acde8c6808      556     1536        0  0
     6a1618dc-586c-4529-96d6-b957a893c52a      538     1536        0  0
     e3c4387c-4d54-4c40-811d-0423668e49c8     1052     2048        0  0
     0577f50a-f8ac-42fa-b68e-154ff58506b3     1089     2048        0  0
     17510b88-b8fe-44fc-ad72-4a6f011d3ee4     2555     3072        0  0

### Seeing what is using SWAP space

`ps -eo pid,comm,vsz | sort -nk3`

    [root@smartosn2 ~]# ps -eo pid,comm,vsz | sort -nk3
        0 sched                                                                               0
        2 pageout                                                                             0
        3 fsflush                                                                             0
        4 kcfpoold                                                                            0
      421 zpool-zones                                                                         0
      PID COMMAND                                                                           VSZ
     3400 zsched                                                                              0
     3428 zsched                                                                              0
     3523 zsched                                                                              0
     3784 zsched                                                                              0
     3845 zsched                                                                              0
     6977 zsched                                                                              0
    17010 zsched                                                                              0
     2630 /usr/lib/utmpd                                                                   1632
     7372 /usr/lib/utmpd                                                                   1632
    17380 /usr/lib/utmpd                                                                   1632
       95 /usr/bin/ctrun                                                                   1772
     2945 /usr/bin/ctrun                                                                   1776
     7363 /usr/lib/pfexecd                                                                 1832
     2698 /usr/lib/vtdaemon                                                                1840
    17367 /usr/sbin/cron                                                                   1852
    . . .

### Determining how system memory is being allocated

`echo ::memstat | mdb -k`

    [root@smartos-node-1 ~]# echo ::memstat | mdb -k
    Page Summary                Pages                MB  %Tot
    ------------     ----------------  ----------------  ----
    Kernel                    4330552             16916   36%
    ZFS File Data              445887              1741    4%
    Anon                      6588558             25736   55%
    Exec and libs                3697                14    0%
    Page cache                 253315               989    2%
    Free (cachelist)           179059               699    1%
    Free (freelist)            275855              1077    2%

    Total                    12076923             47175
    Physical                 12076921             47175

### Examining a specific zone for to determine what process is using RSS / memory

`prstat -s rss -z 12`

    [root@smartosn2 ~]# prstat -s rss -z 12
       PID USERNAME  SIZE   RSS STATE  PRI NICE      TIME  CPU PROCESS/NLWP
      7499 root       49M   39M sleep   59    0   1:21:02 0.2% beam.smp/9
      7562 root       44M   34M sleep   55    0   0:29:32 0.1% beam.smp/9
      7517 root       36M   27M sleep   59    0   0:31:48 0.1% beam.smp/9
      7547 webservd   27M   17M sleep   43    0   0:00:05 0.0% httpd/8
      7548 webservd   27M   17M sleep   43    0   0:00:05 0.0% httpd/8
      7549 webservd   27M   17M sleep   43    0   0:00:05 0.0% httpd/8
      7550 webservd   27M   17M sleep   43    0   0:00:05 0.0% httpd/8
      7551 webservd   27M   17M sleep   43    0   0:00:05 0.0% httpd/8
      7071 root     9408K 8260K sleep   29    0   0:00:06 0.0% svc.configd/13
      7540 root       17M 7232K sleep   59    0   0:00:06 0.0% httpd/1
      7598 webservd   19M 5888K sleep   43    0   0:00:00 0.0% httpd/1
      7594 webservd   19M 5884K sleep   43    0   0:00:00 0.0% httpd/1
      7596 webservd   19M 5884K sleep   43    0   0:00:00 0.0% httpd/1
      7597 webservd   19M 5884K sleep   43    0   0:00:00 0.0% httpd/1
      7595 webservd   19M 5876K sleep   43    0   0:00:00 0.0% httpd/1
      7068 root     7076K 5284K sleep   59    0   0:00:03 0.0% svc.startd/12
      7195 root     6052K 3648K sleep   59    0   0:00:05 0.0% nscd/27
      7365 root     4204K 2704K sleep   59    0   0:00:00 0.0% inetd/3
      7123 netadm   3976K 2696K sleep   59    0   0:00:00 0.0% ipmgmtd/3
      7420 root     4700K 2632K sleep   59    0   0:01:19 0.0% redis-server/3
      7542 webservd   16M 2380K sleep   59    0   0:00:00 0.0% httpd/1
      7373 root     3276K 2356K sleep   30    0   0:00:00 0.0% rsyslogd/5
      7408 root     4020K 1600K sleep   59    0   0:00:00 0.0% sshd/1
      7036 root     2136K 1552K sleep   59    0   0:00:00 0.0% init/1
    Total: 45 processes, 164 lwps, load averages: 0.24, 0.24, 0.23

### Checking interrupt statistics

`intrstat`

    [root@smartosn2 ~]# intrstat
          device |      cpu0 %tim      cpu1 %tim      cpu2 %tim      cpu3 %tim
    -------------+------------------------------------------------------------
        e1000g#0 |         0  0.0         1  0.0         0  0.0         0  0.0
          ehci#0 |         0  0.0         0  0.0         0  0.0         0  0.0
          ehci#1 |         0  0.0         0  0.0         0  0.0         0  0.0
           mpt#0 |         0  0.0         0  0.0         0  0.0         0  0.0
           rge#0 |         0  0.0       239  0.2         0  0.0         0  0.0

### Seeing what is using a specific interrupt

`echo ::interrupts | mdb -k`

    [root@smartosn2 ~]# echo ::interrupts | mdb -k
    IRQ  Vect IPL Bus    Trg Type   CPU Share APIC/INT# ISR(s)
    9    0x80 9   PCI    Lvl Fixed  1   1     0x0/0x9   acpi_wrapper_isr
    18   0x81 9   PCI    Lvl Fixed  2   1     0x0/0x12  ehci_intr
    23   0x82 9   PCI    Lvl Fixed  3   1     0x0/0x17  ehci_intr
    24   0x60 6   PCI    Edg MSI    1   1     -         rge_intr
    25   0x40 5   PCI    Edg MSI    3   1     -         mpt_intr
    26   0x61 6   PCI    Edg MSI    1   1     -         e1000g_intr_pciexpre
    ss
    32   0x20 2          Edg IPI    all 1     -         cmi_cmci_trap
    160  0xa0 0          Edg IPI    all 0     -         poke_cpu
    208  0xd0 14         Edg IPI    all 1     -         kcpc_hw_overflow_int
    r
    209  0xd1 14         Edg IPI    all 1     -         cbe_fire
    210  0xd3 14         Edg IPI    all 1     -         cbe_fire
    240  0xe0 15         Edg IPI    all 1     -         xc_serv
    241  0xe1 15         Edg IPI    all 1     -         apic_error_intr

### Generating complete overview of a SmartOS system

`sysinfo`

    [root@smartos-node-1 ~]# sysinfo
    {
      "Live Image": "20120726T184637Z",
      "System Type": "SunOS",
      "Boot Time": "1344477862",
      "Manufacturer": "Intel Corporation",
      "Product": "S5520UR",
      "Serial Number": "............",
      "VM Capable": true,
      "CPU Type": "Intel(R) Xeon(R) CPU E5645 @ 2.40GHz",
      "CPU Virtualization": "vmx",
      "CPU Physical Cores": 2,
      "UUID": "92bc54eb-a652-11e0-a095-001e671d5838",
      "Hostname": "smartos-node-1",
      "CPU Total Cores": 24,
      "MiB of Memory": "47184",
      "Zpool": "zones",
      "Zpool Disks": "c0t16d0,c0t17d0,c0t18d0,c0t19d0,c0t20d0,c0t21d0,c2d0",
      "Zpool Profile": "raidz",
      "Zpool Size in GiB": 2719,
      "Disks": {
        "c0t16d0": {"Size in GB": 600},
        "c0t17d0": {"Size in GB": 600},
        "c0t18d0": {"Size in GB": 600},
        "c0t19d0": {"Size in GB": 600},
        "c0t20d0": {"Size in GB": 600},
        "c0t21d0": {"Size in GB": 600},
        "c2d0": {"Size in GB": 120}
      },
      "Boot Parameters": {
        "console": "text",
        "root_shadow": "$5$2XXXRnK3$NvLlm.1KYYYB0WjoP7xcIwGnllzzzzHnT.mDO7Dp
    xYA",
        "smartos": "true"
      },
      "Network Interfaces": {
        "igb0": {"MAC Address": "00:1e:67:1d:58:38", "ip4addr": "172.16.5.95
    ", "Link Status": "up", "NIC Names": ["admin"]},
        "igb1": {"MAC Address": "00:1e:67:1d:58:39", "ip4addr": "", "Link St
    atus": "unknown", "NIC Names": []}
      },
      "Virtual Network Interfaces": {
      }
    }

## Networking

These commands are specifically related to statistics about networking.

### Seeing the status of Network interfaces

`dladm show-phys`

    [root@smartos-node-1 ~]# dladm show-phys
    LINK         MEDIA                STATE      SPEED  DUPLEX    DEVICE
    igb0         Ethernet             up         1000   full      igb0
    igb1         Ethernet             unknown    0      half      igb1

### Seeing the MAC addresses for Network interfaces

`dladm show-phys -m`

    [root@smartos-node-1 ~]# dladm show-phys -m
    LINK         SLOT     ADDRESS            INUSE CLIENT
    igb0         primary  0:1e:67:1d:58:38   yes  igb0
    igb1         primary  0:1e:67:1d:58:39   no   --

### Listing virtual network interfaces and seeing the zone to which they belong

`dladm show-vnic`

    [root@smartos-node-1 ~]# dladm show-vnic
    LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
    net0         igb0       0     b2:f2:42:c0:5e:15 fixed       0    3b45ecf
    a-7c74-459e-8534-00d1f79a07ea
    net0         igb0       0     b2:56:3f:3:37:d   fixed       0    a04a589
    4-ac82-4b3d-b1b7-2fa1dcc7d0e3
    net0         igb0       0     b2:7d:78:4:83:15  fixed       0    befb49f
    3-8f9f-404a-9683-b64b94005423
    net0         igb0       0     b2:d1:cb:37:e4:6f fixed       0    4c0ce8c
    9-432e-48a4-80b3-579e3ff11cf0
    net0         igb0       0     b2:be:3d:6f:22:e7 fixed       0    b90c54c
    d-bef6-4f2f-8701-e2c2a794dbe4
    net0         igb0       0     b2:7f:9a:b2:85:3f fixed       0    a07ba0c
    a-bc6b-4703-95ba-4b395c68947a
    net0         igb0       0     b2:6c:f1:e5:b9:c8 fixed       0    25f8269
    5-85d0-446a-b017-5f00789e94e5
    net0         igb0       0     b2:94:18:77:4f:b8 fixed       0    d4e5b94
    2-7edd-41bd-8e2c-f11259adfe28
    net0         igb0       0     b2:43:c0:92:82:1  fixed       0    633df8d
    b-46ab-47b0-8c7a-b38f8b90e2d5
    net0         igb0       0     b2:f5:69:fc:8:ca  fixed       0    41a6930
    6-0ed6-40e9-a91e-05794421cb5b
    net0         igb0       0     c2:d3:e4:57:55:ea fixed       0    fifo
    net0         igb0       0     c2:81:e:6d:fb:66  fixed       0    3de9cab
    6-a810-492d-9b1d-836ccdcd7022

### Figuring out where to configure additional Network interfaces or VLANs

**Persisting vnics across reboots** section on
[Managing NICs](managing-nics.md) page shows correct syntax.

Edit `/usbkey/config`

    [root@smartos-node-1 ~]# cat /usbkey/config
    admin_nic=0:1e:67:1d:58:38
    admin_ip=dhcp
    admin_netmask=
    admin_network=...
    admin_gateway=dhcp

    headnode_default_gateway=

    dns_resolvers=8.8.8.8,8.8.4.4
    dns_domain=

    ntp_hosts=pool.ntp.org
    compute_node_ntp_hosts=dhcp

### Watching network interface packet statistics in real-time

The first line entry is total packets

`netstat -I igb0 1 6`

    input   igb0      output    input  (Total)    output
    packets errs  packets errs  colls  packets errs  packets errs  colls
    763052430 0     1751855307 0     0      764740603 0     1753543480 0
     0
    708     0     224     0     0      708     0     224     0     0
    628     0     158     0     0      628     0     158     0     0
    784     0     307     0     0      784     0     307     0     0
    780     0     316     0     0      780     0     316     0     0
    787     0     328     0     0      787     0     328     0     0
