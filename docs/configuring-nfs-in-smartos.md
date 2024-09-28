# Configuring NFS in SmartOS

<!-- markdownlint-disable line-length -->

NFS (network file system) provides access to remote filesystems which
appear similar to local resources on client hosts.

The following focuses on NFS server and client configurations in SmartOS.
Our host details are:

    HOST (server):                  cn112 (172.25.0.49)
    HOST (CN (compute node):        cn110 (----)
    HOST (SmartMachine VM):         vm100 (172.25.0.100)
    PROMPT:                         HOST [0]
    OS:                             SmartOS 20130321T213641Z
    SmartMachine IMAGE:             smartos-base64-1.9.1
    NOTE:                           The following should apply
                                    equally well to previous
                                    versions of SmartOS.

Before explaining any logic or reasoning, below is only command we
really need for our SmartOS NFS server node (cn112) and the two
commands for our SmartMachine client VM (vm100):

    cn112 [0] /usr/sbin/zfs create -p -o quota=1.5g -o
    > sharenfs='rw=@172.25.0.0/24:@172.25.1.0/25,ro=@172.25.1.128/25,root=172.25.0.100'
    > zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff vm100 [0] /usr/sbin/mount -Fnfs -o rw,intr
    > 172.25.0.49:/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff /mnt/nfs-pool
    vm100 [0] /opt/local/bin/grep nfs-pool /etc/vfstab
    172.25.0.49:/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff - /mnt/nfs-pool nfs - yes -

In the following setup, I include necessary network configuration
details since neither the server nor the client are currently
configured for our internal NFS segment. Without further ado, on
our NFS server we have no VMs, either SmartMachines or KVM instances,
since we are not using this host as a traditional CN. Also, we
have 2 network interfaces, though only one (the admin NIC) is
currently plumbed and addressed:

    cn112 [0] /usr/sbin/vmadm list
    UUID                                  TYPE  RAM      STATE ALIAS
    cn112 [0] /usr/sbin/ifconfig -a
    lo0: flags=2001000849<UP,LOOPBACK,RUNNING,MULTICAST,IPv4,VIRTUAL> mtu 8232 index 1
            inet 127.0.0.1 netmask ff000000
    e1000g0: flags=1100943<UP,BROADCAST,RUNNING,PROMISC,MULTICAST,ROUTER,IPv4> mtu 1500 index 2
            inet 192.168.56.112 netmask ffffff00 broadcast 192.168.56.255
            ether 8:0:27:24:cf:6a
    lo0: flags=2002000849<UP,LOOPBACK,RUNNING,MULTICAST,IPv6,VIRTUAL> mtu 8252 index 1
            inet6 ::1/128
    cn112 [0] /usr/sbin/dladm show-phys -m
    LINK         SLOT     ADDRESS            INUSE CLIENT
    e1000g0      primary  8:0:27:24:cf:6a    yes  e1000g0
    e1000g1      primary  8:0:27:77:c1:cc    yes  e1000g1
    cn112 [0] /usr/bin/sysinfo | /usr/bin/json "Network Interfaces"
    {
      "e1000g0": {
        "MAC Address": "08:00:27:24:cf:6a",
        "ip4addr": "192.168.56.112",
        "Link Status": "up",
        "NIC Names": [
          "admin"
        ]
      },
      "e1000g1": {
        "MAC Address": "08:00:27:77:c1:cc",
        "ip4addr": "",
        "Link Status": "up",
        "NIC Names": [
          "nfs"
        ]
      }
    }
    cn112 [0]

Our second NIC, "e1000g1" is on the same LAN segment presented to
VMs by our other CNs. Below, I've configured the interface and
updated our configuration for retention through reboot:

    cn112 [0] /usr/bin/ifconfig e1000g1 plumb 172.25.0.49 netmask 255.255.255.0 broadcast + up
    cn112 [0] /usr/bin/grep nfs /usbkey/config
    nfs_nic=8:0:27:77:c1:cc
    nfs0_ip=172.25.0.49
    nfs0_netmask=255.255.255.0
    nfs0_network=...
    nfs0_gateway=172.25.0.49
    cn112 [0]

Over on our CN (cn110), we can see that we have 3 VMs configured,
2 of which are currently running. (The one we care about is "vm100".)
We can also see that only one interface is plumbed in the global
zone (GZ), that we have 3 NICs (admin, world, and vmint), and only
the "world" NIC (e1000g1) is currently in use by VMs:

    cn110 [0] /usr/sbin/vmadm list
    UUID                                  TYPE  RAM      STATE ALIAS
    56800183-ab62-4db4-9d39-1fdc9a7e607a  OS    256      stopped vm102
    c9fd4db6-5da0-4b0d-8c7a-87c55b10caff  OS    256      running vm100
    e669fd30-7c81-463d-99bc-7989f9e8af78  OS    256      running vm101
    cn110 [0] ifconfig -a
    lo0: flags=2001000849<UP,LOOPBACK,RUNNING,MULTICAST,IPv4,VIRTUAL> mtu 8232 index 1
            inet 127.0.0.1 netmask ff000000
    e1000g0: flags=1100943<UP,BROADCAST,RUNNING,PROMISC,MULTICAST,ROUTER,IPv4> mtu 1500 index 2
            inet 192.168.56.110 netmask ffffff00 broadcast 192.168.56.255
            ether 8:0:27:20:64:b9
    lo0: flags=2002000849<UP,LOOPBACK,RUNNING,MULTICAST,IPv6,VIRTUAL> mtu 8252 index 1
            inet6 ::1/128
    cn110 [0] /usr/sbin/dladm show-phys -m
    LINK         SLOT     ADDRESS            INUSE CLIENT
    e1000g0      primary  8:0:27:20:64:b9    yes  e1000g0
    e1000g1      primary  8:0:27:67:1e:93    yes  e1000g1
    e1000g2      primary  8:0:27:16:b9:c4    no   --
    cn110 [0] /usr/sbin/dladm show-vnic
    LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
    net0         e1000g1    0     72:53:2c:7d:77:17 fixed       0    e669fd30-7c81-463d-99bc-7989f9e8af78
    net0         e1000g1    0     e2:c9:ae:f6:82:1a fixed       0    c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    cn110 [0] /usr/sbin/sysinfo | /usr/bin/json "Network Interfaces"
    {
      "e1000g0": {
        "MAC Address": "08:00:27:20:64:b9",
        "ip4addr": "192.168.56.110",
        "Link Status": "up",
        "NIC Names": [
          "admin"
        ]
      },
      "e1000g1": {
        "MAC Address": "08:00:27:67:1e:93",
        "ip4addr": "",
        "Link Status": "up",
        "NIC Names": [
          "world"
        ]
      },
      "e1000g2": {
        "MAC Address": "08:00:27:16:b9:c4",
        "ip4addr": "",
        "Link Status": "unknown",
        "NIC Names": [
          "vmint"
        ]
      }
    }
    cn110 [0]

NIC e1000g2 (tagged as "vmint") on "cn110" resides on the same LAN
segment as e1000g1 (nfs) on "cn112". Also, verifying the above
regarding "vm100", we can see only one configured virtual NIC (vNIC),
which is attached to our "world" interface:

    cn110 [0] /usr/sbin/vmadm get c9fd4db6-5da0-4b0d-8c7a-87c55b10caff | /usr/bin/json nics
    [
      {
        "interface": "net0",
        "mac": "e2:c9:ae:f6:82:1a",
        "nic_tag": "world",
        "gateway": "10.0.22.254",
        "primary": true,
        "ip": "10.0.22.100",
        "netmask": "255.255.255.0"
      }
    ]
    cn110 [0]

In order to use the NFS services to be shared out from "cn112",
we'll need to add a new vNIC to "vm100". Below, we add the new
vNIC to "vm100", and verify it was configured:

    cn110 [0] /usr/bin/cat /var/tmp/vm100.addnic
    {
            "add_nics": [
                    {
                            "physical": "net1",
                            "index": 1,
                            "nic_tag": "vmint",
                            "ip": "172.25.0.100",
                            "netmask": 255.255.255.0"
                    }
            ]
    }
    cn110 [0] /usr/sbin/vmadm update c9fd4db6-5da0-4b0d-8c7a-87c55b10caff < /var/tmp/vm100.addnic
    Successfully updated c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    cn110 [0] /usr/sbin/vmadm get c9fd4db6-5da0-4b0d-8c7a-87c55b10caff | /usr/bin/json nics
    [
      {
        "interface": "net0",
        "mac": "e2:c9:ae:f6:82:1a",
        "nic_tag": "world",
        "gateway": "10.0.22.254",
        "primary": true,
        "ip": "10.0.22.100",
        "netmask": "255.255.255.0"
      },
      {
        "interface": "net1",
        "mac": "c2:9c:ab:c3:de:4d",
        "nic_tag": "vmint",
        "ip": "172.25.0.100",
        "netmask": "255.255.255.0"
      }
    ]
    cn110 [0]

As seen below, while the configuration for "vm100's" vNIC is in
place, the vNIC is not yet created or usable until after the "vm100"
SmartMachine is rebooted:

    cn110 [0] /usr/sbin/dladm show-vnic
    LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
    net0         e1000g1    0     72:53:2c:7d:77:17 fixed       0    e669fd30-7c81-463d-99bc-7989f9e8af78
    net0         e1000g1    0     e2:c9:ae:f6:82:1a fixed       0    c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    cn110 [0] /usr/sbin/vmadm reboot c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    Successfully completed reboot for c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    cn110 [0] /usr/sbin/vmadm list -v
    UUID                                  TYPE  RAM      STATE ALIAS
    56800183-ab62-4db4-9d39-1fdc9a7e607a  OS    256      stopped vm102
    c9fd4db6-5da0-4b0d-8c7a-87c55b10caff  OS    256      running vm100
    e669fd30-7c81-463d-99bc-7989f9e8af78  OS    256      running vm101
    cn110 [0] /usr/sbin/vmadm get c9fd4db6-5da0-4b0d-8c7a-87c55b10caff | /usr/bin/json nics
    [
      {
        "interface": "net0",
        "mac": "e2:c9:ae:f6:82:1a",
        "nic_tag": "world",
        "gateway": "10.0.22.254",
        "primary": true,
        "ip": "10.0.22.100",
        "netmask": "255.255.255.0"
      },
      {
        "interface": "net1",
        "mac": "c2:9c:ab:c3:de:4d",
        "nic_tag": "vmint",
        "ip": "172.25.0.100",
        "netmask": "255.255.255.0"
      }
    ]
    cn110 [0] /usr/sbin/dladm show-vnic
    LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
    net0         e1000g1    0     72:53:2c:7d:77:17 fixed       0    e669fd30-7c81-463d-99bc-7989f9e8af78
    net0         e1000g1    0     e2:c9:ae:f6:82:1a fixed       0    c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    net1         e1000g2    0     c2:9c:ab:c3:de:4d fixed       0    c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    cn110 [0]

Back on our NFS server (cn112), we check our zpool "zones" to
determine how much space we have before setting up an NFS share:

    cn112 [0] /usr/sbin/zfs list -r zones
    NAME                                         USED  AVAIL  REFER  MOUNTPOINT
    zones                                       4.32G  11.3G   654K  /zones
    zones/cf7e2f40-9276-11e2-af9a-0bad2233fb0b   323M  11.3G   323M  /zones/cf7e2f40-9276-11e2-af9a-0bad2233fb0b
    zones/config                                  38K  11.3G    38K  legacy
    zones/cores                                   31K  10.0G    31K  /zones/global/cores
    zones/dump                                   838M  11.3G   838M  -
    zones/opt                                    957K  11.3G   957K  legacy
    zones/swap                                  3.11G  14.4G    16K  -
    zones/usbkey                                 127K  11.3G   127K  legacy
    zones/var                                   73.3M  11.3G  73.3M  legacy
    cn112 [0] /usr/sbin/imgadm list
    UUID                                  NAME    VERSION  OS       PUBLISHED
    cf7e2f40-9276-11e2-af9a-0bad2233fb0b  base64  1.9.1    smartos  2013-03-22T17:11:29Z
    cn112 [0]

(Of note above, we see ZFS dataset
"zones/cf7e2f40-9276-11e2-af9a-0bad2233fb0b" already exists and is
related to image "smartos-base64-1.9.1". Given the function of
this node, that dataset is currently irrelevant.) We now get to
set up our first NFS share. By default, SmartOS gives us a "zones"
zpool consisting of all disk space and within this zpool, I've
created our NFS share dataset:

    cn112 [0] /usr/sbin/zfs create -p -o quota=1.5g -o
    > sharenfs='rw=@172.25.0.0/24:@172.25.1.0/25,ro=@172.25.1.128/25,root=172.25.0.100'
    > zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    cn112 [0] /usr/sbin/zfs get sharenfs zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    NAME                                            PROPERTY VALUE SOURCE
    zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff  sharenfs rw=@172.25.0.0/24:@172.25.1.0/25,ro=@172.25.1.128/25,root=172.25.0.100  local
    cn112 [0]

The shared dataset, `zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff`,
is so named as its intended usage is by "vm100" on "cn110", thus
the end portion is "vm100's" UUID. (You can name your's however
you'd like.) Since "/etc" on "cn112" is transient in nature, we
didn't bother with files under "/etc/dfs" like we could otherwise
do under Solaris. With this being SmartOS, we instead can use ZFS'
native NFS handling via "sharenfs", which adheres to the same
nomenclature and conventions as the traditional "share_nfs" command.
Our SmartMachine, vm100, will have full root access to the share
given the options set above. Also, we've set a quota to restrict
the share to no more than 1.5 GB in size. After executing the above
'zfs create' command, our NFS share is immediately available as
seen below:

    cn112 [0] /usr/sbin/share
    -@zones/nfs/c9  /zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    > sec=sys,rw=@172.25.0.0/24:@172.25.1.0/25,ro=@172.25.1.128/25,root=172.25.0.100   ""
    cn112 [0] /usr/sbin/zpool history zones | /usr/bin/grep create | tail -1
    2013-05-06.01:17:56 zfs create -p -o quota=1.5g -o
    > sharenfs=rw=@172.25.0.0/24:@172.25.1.0/25,ro=@172.25.1.128/25,root=172.25.0.100
    > zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    cn112 [0] /usr/bin/head -3 /var/svc/log/network-nfs-server:default.log
    [ May  6 01:17:51 Enabled. ]
    [ May  6 01:17:52 Executing start method ("/lib/svc/method/nfs-server start"). ]
    [ May  6 01:17:52 Method "start" exited with status 0. ]
    cn112 [0]

Notably, we can see in our SMF log for our NFS server service that
method "nfs-server" started just seconds before the 'zfs create'
command was executed. This wasn't due to any errant command that
I didn't show; it was handled for us due to the "sharenfs" option
we passed to 'zfs create'.

Back on our CN (cn110), I've logged into "vm100", created a mountpoint
for our new share to be mounted to, and mounted the share to the
system:

    cn110 [0] /usr/sbin/zlogin -l root c9fd4db6-5da0-4b0d-8c7a-87c55b10c aff
    [Connected to zone 'c9fd4db6-5da0-4b0d-8c7a-87c55b10caff' pts/4]
    Last login: Mon May  6 00:39:27 on pts/3
       __        .                   .
     _|  |_      | .-. .  . .-. :--. |-
    |_    _|     ;|   ||  |(.-' |  | |
      |__|   `--'  `-' `;-| `-' '  ' `-'
                       /  ; SmartMachine (base64 1.9.1)
                       `-'  http://wiki.joyent.com/jpc2/SmartMachine+Base

    vm100 [0] /opt/local/bin/mkdir /mnt/nfs-pool
    vm100 [0] /usr/sbin/mount -Fnfs -o rw,intr \
    > 172.25.0.49:/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff /mnt/nfs-pool
    vm100 [0] /opt/local/bin/df -h /mnt/nfs-pool
    Filesystem                                                   Size  Used Avail Use% Mounted on
    172.25.0.49:/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff  1.5G 31K  1.5G   1% /mnt/nfs-pool
    vm100 [0] /opt/local/bin/whoami
    root
    vm100 [0] /opt/local/bin/touch /mnt/nfs-pool/myfile
    vm100 [0] /usr/bin/truss -vlstat -tlstat ls -l /mnt/nfs-pool/myfile
    lstat("/mnt/nfs-pool/myfile", 0x0045F020)       = 0
        d=0x0000022200000003 i=8     m=0100644 l=1  u=0     g=0     sz=0
            at = May  6 01:57:52 UTC 2013  [ 1367805472.207230095 ]
            mt = May  6 01:57:52 UTC 2013  [ 1367805472.207230266 ]
            ct = May  6 01:57:52 UTC 2013  [ 1367805472.207246365 ]
        bsz=8192  blks=1     fs=nfs
    -rw-r--r-- 1 root root 0 May  6 01:57 /mnt/nfs-pool/myfile
    vm100 [0]

    cn112 [0] /usr/bin/truss -vlstat -tlstat ls -l /zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    lstat64("/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff/myfile", 0x08047660) = 0
        d=0x0169000A i=8     m=0100644 l=1  u=0     g=0     sz=0
            at = May  6 01:57:52 UTC 2013  [ 1367805472.207230095 ]
            mt = May  6 01:57:52 UTC 2013  [ 1367805472.207230266 ]
            ct = May  6 01:57:52 UTC 2013  [ 1367805472.207246365 ]
        bsz=131072 blks=1     fs=zfs
    -rw-r--r--   1 root     root           0 May  6 01:57 /zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff/myfile
    cn112 [0]

A quick test above via 'touch' also details that we can create files
on the new share from our VM as root. To further validate, I've
also checked the same file from the server side. Now, on to test
our configuration retention on the server side. Below, I've unmounted
the share from "vm100" and rebooted our NFS server. Post reboot,
I've checked our configured NICs and verified that our NFS share
is again presented for client access via 'share':

    vm100 [0] /usr/sbin/umount /mnt/nfs-pool
    vm100 [0]

    cn112 [0] /usr/sbin/init 6
    troy@glados [0] ssh -l root cn112
    Password:
    Last login: Mon May  6 00:13:28 2013 from 192.168.56.1
    - SmartOS Live Image v0.147+ build: 20130321T213641Z
    cn112 [0] /usr/sbin/ifconfig -a
    lo0: flags=2001000849<UP,LOOPBACK,RUNNING,MULTICAST,IPv4,VIRTUAL> mtu 8232 index 1
            inet 127.0.0.1 netmask ff000000
    e1000g0: flags=1100943<UP,BROADCAST,RUNNING,PROMISC,MULTICAST,ROUTER,IPv4> mtu 1500 index 2
            inet 192.168.56.112 netmask ffffff00 broadcast 192.168.56.255
            ether 8:0:27:24:cf:6a
    nfs0: flags=1100843<UP,BROADCAST,RUNNING,MULTICAST,ROUTER,IPv4> mtu1500 index 3
            inet 172.25.0.49 netmask ffffff00 broadcast 172.25.0.255
            ether 2:8:20:a6:87:71
    lo0: flags=2002000849<UP,LOOPBACK,RUNNING,MULTICAST,IPv6,VIRTUAL> mtu 8252 index 1
            inet6 ::1/128
    cn112 [0] /usr/sbin/dladm show-phys -m
    LINK         SLOT     ADDRESS            INUSE CLIENT
    e1000g0      primary  8:0:27:24:cf:6a    yes  e1000g0
    e1000g1      primary  8:0:27:77:c1:cc    yes  e1000g1
    cn112 [0] /usr/sbin/dladm show-link nfs0
    LINK        CLASS     MTU    STATE    BRIDGE     OVER
    nfs0        vnic      1500   up       --         e1000g1
    cn112 [0] /usr/sbin/dladm show-vnic
    LINK         OVER       SPEED MACADDRESS        MACADDRTYPE VID  ZONE
    nfs0         e1000g1    1000  2:8:20:a6:87:71   random      0    --
    cn112 [0] /usr/sbin/sysinfo | /usr/bin/json "Network Interfaces"
    {
      "e1000g0": {
        "MAC Address": "08:00:27:24:cf:6a",
        "ip4addr": "192.168.56.112",
        "Link Status": "up",
        "NIC Names": [
          "admin"
        ]
      },
      "e1000g1": {
        "MAC Address": "08:00:27:77:c1:cc",
        "ip4addr": "",
        "Link Status": "up",
        "NIC Names": [
          "nfs"
        ]
      }
    }
    cn112 [0] /usr/sbin/share-@zones/nfs/c9  /zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff   \
    > sec=sys,rw=@172.25.0.0/24:@172.25.1.0/25,ro=@172.25.1.128/25,root=172.25.0.100   ""
    cn112 [0]

As seen below, we can immediately again mount up the NFS share and\
see no data has been lost:

    vm100 [0] /usr/sbin/mount -Fnfs -o rw,intr \
    > 172.25.0.49:/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff /mnt/nfs-pool
    vm100 [0] /opt/local/bin/df -h /mnt/nfs-pool
    Filesystem                                                   Size  Used Avail Use% Mounted on
    172.25.0.49:/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff  1.5G 31K  1.5G   1% /mnt/nfs-pool
    vm100 [0] /opt/local/bin/ls /mnt/nfs-pool
    myfile
    vm100 [0]

Now let's retain the share mount point by updating "/etc/vfstab"\
on "vm100". To test configuration retention here, also below, I've\
logged out, rebooted the SmartMachine via 'vmadm' and logged back\
in:

    vm100 [0] /opt/local/bin/grep nfs-pool /etc/vfstab
    172.25.0.49:/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff - /mnt/nfs-pool nfs - yes rw,intr
    vm100 [0] exit
    [Connection to zone 'c9fd4db6-5da0-4b0d-8c7a-87c55b10caff' pts/4 closed]
    cn110 [0] /usr/sbin/vmadm reboot c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    Successfully completed reboot for c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    cn110 [0] /usr/sbin/zlogin -l root c9fd4db6-5da0-4b0d-8c7a-87c55b10caff
    [Connected to zone 'c9fd4db6-5da0-4b0d-8c7a-87c55b10caff' pts/4]
    Last login: Mon May  6 01:31:09 on pts/5
       __        .                   .
     _|  |_      | .-. .  . .-. :--. |-
    |_    _|     ;|   ||  |(.-' |  | |
      |__|   `--'  `-' `;-| `-' '  ' `-'
                       /  ; SmartMachine (base64 1.9.1)
                       `-'  http://wiki.joyent.com/jpc2/SmartMachine+Base

    vm100 [0] /opt/local/bin/df -h /mnt/nfs-pool
    Filesystem                                                   Size  Used Avail Use% Mounted on
    172.25.0.49:/zones/nfs/c9fd4db6-5da0-4b0d-8c7a-87c55b10caff  1.5G 31K  1.5G   1% /mnt/nfs-pool
    vm100 [0]

For our verification, I've simply ran 'df' against our share mount\
point. At this point, our work is now complete.
