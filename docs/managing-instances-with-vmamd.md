# Managing Instances with `vmadm`

This page describes some common tasks, and some tips & trics for using
[vmadm(1M)][vmadm-man] to manage instances.

[vmadm-man]: https://smartos.org/man/1m/vmadm

## Listing instances

Default fields and sorting:

    [root@headnode (bh1-kvm1:0) ~]# vmadm list
    UUID                                  TYPE  RAM      STATE             ALIAS
    1e6ea123-dca0-44e6-8c0c-34c7f543fe82  OS    128      running           zone55
    20de2bfc-56de-4cd9-8e25-80b017615788  OS    128      running           billapi0
    2508eead-dc8f-4df5-baf9-4ce6341f08ed  OS    128      running           zone56
    29bdabe1-ff9e-4387-9316-39961d5dbe5c  OS    128      running           adminui0
    384de5e9-c9d9-4382-9dd3-949ab410be45  OS    128      running           redis0
    56a47549-bceb-48d7-b67e-fd390d083f09  OS    128      running           portal0
    5c12a3ef-e60c-479a-a6be-ba93712a3893  OS    128      running           amon0
    a7a4cb02-210a-4ccf-9744-99e3982148b0  OS    128      running           cloudapi0
    2811071a-5edc-438a-9b7b-e3b81e8829c5  OS    256      running           ufds0
    8d01d99b-2b18-41c6-8fec-7209e2a9eef3  OS    512      running           riak0
    c3a03fac-dc2c-42ba-aff7-d6fd7a36967a  OS    1024     running           ca0
    d104e56e-43df-4d0f-b5ce-43f39d0fef46  KVM   1024     running           ubuntu1
    2b99a408-7dfb-445e-cfa1-bed4e14a2509  OS    32768    running           assets0
    a4212873-e04a-ef84-b85c-c5aea32ce5f8  OS    32768    running           dhcpd0
    ad170576-3ad3-e201-cd89-ad4260c3a3ce  OS    32768    running           rabbitmq0
    c843e9b9-b937-c55f-c8dd-a4f6d1bb2ec0  OS    32768    running           mapi0

Use `-o` to change the output fields or `-s` to change the sort key.

    [root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_shares,zfs_io_priority
    UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  IO_PRIORITY
    1e6ea123-dca0-44e6-8c0c-34c7f543fe82  OS    128      20     100        30
    20de2bfc-56de-4cd9-8e25-80b017615788  OS    128      5      50         1
    2508eead-dc8f-4df5-baf9-4ce6341f08ed  OS    128      20     100        30
    29bdabe1-ff9e-4387-9316-39961d5dbe5c  OS    128      5      50         1
    384de5e9-c9d9-4382-9dd3-949ab410be45  OS    128      5      50         1
    56a47549-bceb-48d7-b67e-fd390d083f09  OS    128      5      50         1
    5c12a3ef-e60c-479a-a6be-ba93712a3893  OS    128      5      50         1
    a7a4cb02-210a-4ccf-9744-99e3982148b0  OS    128      5      50         1
    2811071a-5edc-438a-9b7b-e3b81e8829c5  OS    256      5      100        1
    8d01d99b-2b18-41c6-8fec-7209e2a9eef3  OS    512      10     50         4
    c3a03fac-dc2c-42ba-aff7-d6fd7a36967a  OS    1024     15     100        8
    d104e56e-43df-4d0f-b5ce-43f39d0fef46  KVM   1024     -      100        100
    2b99a408-7dfb-445e-cfa1-bed4e14a2509  OS    32768    10     50         -
    a4212873-e04a-ef84-b85c-c5aea32ce5f8  OS    32768    10     50         -
    ad170576-3ad3-e201-cd89-ad4260c3a3ce  OS    32768    10     50         -
    c843e9b9-b937-c55f-c8dd-a4f6d1bb2ec0  OS    32768    10     50         -
    [root@headnode (bh1-kvm1:0) ~]#

Same as above, but sort by ram in DESCENDING order then by CPU shares in
ascending order. Notice `-s -ram` to denote descending order.

<!-- markdownlint-disable line-length -->

    [root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_shares,zfs_io_priority -s -ram,cpu_shares
    UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  IO_PRIORITY
    ad170576-3ad3-e201-cd89-ad4260c3a3ce  OS    32768    10     50         -
    c843e9b9-b937-c55f-c8dd-a4f6d1bb2ec0  OS    32768    10     50         -
    a4212873-e04a-ef84-b85c-c5aea32ce5f8  OS    32768    10     50         -
    2b99a408-7dfb-445e-cfa1-bed4e14a2509  OS    32768    10     50         -
    d104e56e-43df-4d0f-b5ce-43f39d0fef46  KVM   1024     -      100        100
    c3a03fac-dc2c-42ba-aff7-d6fd7a36967a  OS    1024     15     100        8
    8d01d99b-2b18-41c6-8fec-7209e2a9eef3  OS    512      10     50         4
    2811071a-5edc-438a-9b7b-e3b81e8829c5  OS    256      5      100        1
    5c12a3ef-e60c-479a-a6be-ba93712a3893  OS    128      5      50         1
    384de5e9-c9d9-4382-9dd3-949ab410be45  OS    128      5      50         1
    20de2bfc-56de-4cd9-8e25-80b017615788  OS    128      5      50         1
    29bdabe1-ff9e-4387-9316-39961d5dbe5c  OS    128      5      50         1
    a7a4cb02-210a-4ccf-9744-99e3982148b0  OS    128      5      50         1
    56a47549-bceb-48d7-b67e-fd390d083f09  OS    128      5      50         1
    1e6ea123-dca0-44e6-8c0c-34c7f543fe82  OS    128      20     100        30
    2508eead-dc8f-4df5-baf9-4ce6341f08ed  OS    128      20     100        30

<!-- markdownlint-enable line-length -->

You can also filter by keys. In this example, `TYPE=OS` returns only `joyent`
brand zones.

<!-- markdownlint-disable line-length -->

    [root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_shares,zfs_io_priority -s -ram,cpu_shares type=OS ram=~^1
    UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  I
    O_PRIORITY
    c3a03fac-dc2c-42ba-aff7-d6fd7a36967a  OS    1024     15     100        8
    56a47549-bceb-48d7-b67e-fd390d083f09  OS    128      5      50         1
    a7a4cb02-210a-4ccf-9744-99e3982148b0  OS    128      5      50         1
    5c12a3ef-e60c-479a-a6be-ba93712a3893  OS    128      5      50         1
    29bdabe1-ff9e-4387-9316-39961d5dbe5c  OS    128      5      50         1
    20de2bfc-56de-4cd9-8e25-80b017615788  OS    128      5      50         1
    384de5e9-c9d9-4382-9dd3-949ab410be45  OS    128      5      50         1
    2508eead-dc8f-4df5-baf9-4ce6341f08ed  OS    128      20     100        30
    1e6ea123-dca0-44e6-8c0c-34c7f543fe82  OS    128      20     100        30

<!-- markdownlint-enable line-length -->

Use `-p` to generate parsable output, without header and with fields separated
by `:`. Notice `nics.0.ip` to obtain ip address of first NIC.

<!-- markdownlint-disable line-length -->

    [root@headnode (bh1-kvm1:0) ~]# vmadm list -p -o uuid,nics.0.ip
    ad170576-3ad3-e201-cd89-ad4260c3a3ce:10.0.0.1
    c843e9b9-b937-c55f-c8dd-a4f6d1bb2ec0:10.0.0.2
    a4212873-e04a-ef84-b85c-c5aea32ce5f8:10.0.0.3
    2b99a408-7dfb-445e-cfa1-bed4e14a2509:10.0.0.4
    d104e56e-43df-4d0f-b5ce-43f39d0fef46:10.0.0.5
    c3a03fac-dc2c-42ba-aff7-d6fd7a36967a:10.0.0.6
    8d01d99b-2b18-41c6-8fec-7209e2a9eef3:10.0.0.7
    2811071a-5edc-438a-9b7b-e3b81e8829c5:10.0.0.8
    5c12a3ef-e60c-479a-a6be-ba93712a3893:10.0.0.9
    384de5e9-c9d9-4382-9dd3-949ab410be45:10.0.0.10
    20de2bfc-56de-4cd9-8e25-80b017615788:10.0.0.11
    29bdabe1-ff9e-4387-9316-39961d5dbe5c:10.0.0.12
    a7a4cb02-210a-4ccf-9744-99e3982148b0:10.0.0.13
    56a47549-bceb-48d7-b67e-fd390d083f09:10.0.0.14
    1e6ea123-dca0-44e6-8c0c-34c7f543fe82:10.0.0.15
    2508eead-dc8f-4df5-baf9-4ce6341f08ed:10.0.0.16

<!-- markdownlint-enable line-length -->

## Creating new instances

See:

- [How to Create a Zone](how-to-create-a-zone.md)
- [How to Create an HVM Zone](how-to-create-an-hvm-zone.md)
- [How to create an LX Brand Zone](lx-branded-zones.md)

## Getting an instances properties

    [root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
    f5d6e0
    {
      "zonename": "54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
      "zonepath": "/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
      "brand": "joyent",
      "limitpriv": "default,dtrace_proc,dtrace_user",
      "cpu_shares": 100,
      "zfs_io_priority": 30,
      "max_lwps": 2000,
      "max_physical_memory": 256,
      "max_locked_memory": 256,
      "max_swap": 256,
      "creation_timestamp": "2011-11-07T05:57:25.677Z",
      "billing_id": "47e6af92-daf0-11e0-ac11-473ca1173ab0",
      "owner_uuid": "00000000-0000-0000-0000-000000000000",
      "tmpfs": 256,
      "dns_domain": "local",
      "alias": "zone70",
      "nics": [
        {
          "nic_tag": "external",
          "mac": "b2:1e:ba:a5:6e:70",
          "physical": "net0",
          "index": 0,
          "ip": "10.2.121.70",
          "netmask": "255.255.0.0",
          "gateway": "10.2.121.1"
        }
      ],
      "zfs_storage_pool_name": "zones",
      "autoboot": true,
      "uuid": "54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
      "zoneid": "39",
      "state": "running",
      "quota": 20,
      "customer_metadata": {},
      "tags": {}
    }

## Lookup an instance by key

By default only the UUID will be returned. Note `=~` uses pattern matching.
This will look up all zones with an alias matching `.*zone7.*`.

    [root@headnode (bh1-kvm1:0) ~]# vmadm lookup alias=~zone7
    54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

You can also return the full json. This is like `vmadm get <uuid>`, but
you don't need to know the UUID ahead of time.

    [root@headnode (bh1-kvm1:0) ~]# vmadm lookup -j alias=~zone7
    [
      {
        "zonename": "54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
        "zonepath": "/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
        "brand": "joyent",
        "limitpriv": "default,dtrace_proc,dtrace_user",
        "cpu_shares": 100,
        "zfs_io_priority": 30,
        "max_lwps": 2000,
        "max_physical_memory": 256,
        "max_locked_memory": 256,
        "max_swap": 256,
        "creation_timestamp": "2011-11-07T05:57:25.677Z",
        "billing_id": "47e6af92-daf0-11e0-ac11-473ca1173ab0",
        "owner_uuid": "00000000-0000-0000-0000-000000000000",
        "tmpfs": 256,
        "dns_domain": "local",
        "alias": "zone70",
        "nics": [
          {
            "nic_tag": "external",
            "mac": "b2:1e:ba:a5:6e:70",
            "physical": "net0",
            "index": 0,
            "ip": "10.2.121.70",
            "netmask": "255.255.0.0",
            "gateway": "10.2.121.1"
          }
        ],
        "zfs_storage_pool_name": "zones",
        "autoboot": true,
        "uuid": "54f1cc77-68f1-42ab-acac-5c4f64f5d6e0",
        "zoneid": "39",
        "state": "running",
        "quota": 20,
        "customer_metadata": {},
        "tags": {},
        "ram": 256,
        "type": "OS"
      }
    ]
    [root@headnode (bh1-kvm1:0) ~]#

You can also combine filters. This example looks up all 128M instances
with an alias that starts with 'a' or 'b':

    [root@headnode (bh1-kvm1:0) ~]# vmadm lookup ram=128 alias=~^[ab]
    5c12a3ef-e60c-479a-a6be-ba93712a3893
    29bdabe1-ff9e-4387-9316-39961d5dbe5c
    20de2bfc-56de-4cd9-8e25-80b017615788

## Modifying an instance

Many attributes can be updated live without needing a restart. See
[`vmadm(1M)`][vmadm-man] details.

Here we can see that the quota set on the instance is 20GB. The quota value
returned by `vmadm` is the same value returned by `zfs`.

    [root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
    f5d6e0 | json quota
    20
    [root@headnode (bh1-kvm1:0) ~]# zfs get quota zones/54f1cc77-68f1-42ab-a
    cac-5c4f64f5d6e0
    NAME                                        PROPERTY  VALUE  SOURCE
    zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  quota     20G    local

Updating the quota via `vmadm` will update the instance as well as the
zfs dataset.

    [root@headnode (bh1-kvm1:0) ~]# vmadm update 54f1cc77-68f1-42ab-acac-5c4
    f64f5d6e0 quota=40
    Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    [root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
    f5d6e0 | json quota
    40
    [root@headnode (bh1-kvm1:0) ~]# zfs get quota zones/54f1cc77-68f1-42ab-a
    cac-5c4f64f5d6e0
    NAME                                        PROPERTY  VALUE  SOURCE
    zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  quota     40G    local
    [root@headnode (bh1-kvm1:0) ~]#

You can also do an update using JSON input.

<!-- markdownlint-disable line-length -->

    [root@headnode (bh1-kvm1:0) ~]# echo '{"cpu_shares": 100}' | vmadm update 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    [root@headnode (bh1-kvm1:0) ~]# vmadm list -o uuid,type,ram,quota,cpu_shares,state,alias alias=zone70
    UUID                                  TYPE  RAM      QUOTA  CPU_SHARE  STATE             ALIAS
    54f1cc77-68f1-42ab-acac-5c4f64f5d6e0  OS    256      20     100        running           zone70

<!-- markdownlint-enable line-length -->

### Other modifications

Some fields (such as nics and disks) can't be updated directly. This is often
the case with array fields. They need to have an operation specified.

#### Modifying NICs

This example uses `add_nics` and `remove_nics`.

Here, the zone has one nic currently.

    [root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
    f5d6e0  | json nics
    [
      {
        "nic_tag": "external",
        "mac": "b2:1e:ba:a5:6e:70",
        "physical": "net0",
        "index": 0,
        "ip": "10.2.121.70",
        "netmask": "255.255.0.0",
        "gateway": "10.2.121.1"
      }
    ]

Then add a nic:

    [root@headnode (bh1-kvm1:0) ~]# cat add_nic.json
    {
        "add_nics": [
            {
                "physical": "net1",
                "index": 1,
                "nic_tag": "external",
                "mac": "b2:1e:ba:a5:6e:71",
                "ip": "10.2.121.71",
                "netmask": "255.255.0.0",
                "gateway": "10.2.121.1"
            }
        ]
    }
    [root@headnode (bh1-kvm1:0) ~]# cat add_nic.json | vmadm update 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

The zone now has two nics. Note, the pre-existing nic is now flagged as
primary automaticaly. In order for the zone to make use of this new nic, it
needs to be rebooted.

    [root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
    f5d6e0  | json nics
    [
      {
        "nic_tag": "external",
        "mac": "b2:1e:ba:a5:6e:70",
        "physical": "net0",
        "index": 0,
        "ip": "10.2.121.70",
        "netmask": "255.255.0.0",
        "gateway": "10.2.121.1",
        "primary": true
      },
      {
        "nic_tag": "external",
        "mac": "b2:1e:ba:a5:6e:71",
        "physical": "net1",
        "index": 1,
        "ip": "10.2.121.71",
        "netmask": "255.255.0.0",
        "gateway": "10.2.121.1"
      }
    ]

This example uses `update_nics` to modify the IP of a nic. NICs are identified
by the `mac`.

    [root@headnode (bh1-kvm1:0) ~]# cat update_nic.json
    {
        "update_nics": [
            {
                "mac": "b2:1e:ba:a5:6e:71",
                "ip": "10.2.121.72"
            }
        ]
    }
    [root@headnode (bh1-kvm1:0) ~]# cat update_nic.json | vmadm update 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

And finally, how to remove a nic. Again, the zone must be rebooted before it
will stop being used by the zone.

<!-- markdownlint-disable line-length -->

    [root@headnode (bh1-kvm1:0) ~]# echo '{"remove_nics": ["b2:1e:ba:a5:6e:71"]}' | vmadm update 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

<!-- markdownlint-enable line-length -->

#### Modifying Disks

Add a disk.

    [root@headnode (bh1-kvm1:0) ~]# cat add_disk.json
    {
      "add_disks": [
        {
          "boot": false,
          "model": "virtio",
          "block_size": 8192,
          "size": 40960
       }
     ]
    }
    [root@headnode (bh1-kvm1:0) ~]# vmadm update 54f1cc77-68f1-42ab-acac-5c4
    f64f5d6e0 -f add_disk.json
    Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

Results.

    [root@headnode (bh1-kvm1:0) ~]# vmadm get 54f1cc77-68f1-42ab-acac-5c4f64
    f5d6e0  | json disks
    [
      {
        "path": "/dev/zvol/rdsk/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk0",
        "boot": true,
        "model": "virtio",
        "media": "disk",
        "size": 40960,
        "zfs_filesystem": "zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk0",
        "zpool": "zones",
        "compression": "lz4",
        "block_size": 8192
      },
      {
        "path": "/dev/zvol/rdsk/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk1",
        "boot": false,
        "model": "virtio",
        "size": 40960,
        "zfs_filesystem": "zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk1",
        "zpool": "zones",
        "compression": "lz4",
        "block_size": 8192
      }
    ]

Remove a disk. Note: This will permenantly destroy any data in the removed
volume.

<!-- markdownlint-disable line-length -->

    [root@headnode (bh1-kvm1:0) ~]# echo '{"remove_disks": ["/dev/zvol/rdsk/zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0-disk1"]}' | vmadm update 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Successfully updated 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

<!-- markdownlint-enable line-length -->

#### Add a CDROM

You can do the same thing with CD-ROMs.

    {
      "add_disks": [
            {
            "boot": false,
            "model": "ide",
              "media": "cdrom",
              "path": "/en_sql_server_2012_standard_edition_with_sp1_x64_dvd_1228198.iso"
            }
          ]
    }

## Managing Instances

### Stop an instance

    [root@headnode (bh1-kvm1:0) ~]# vmadm stop 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Succesfully completed stop for 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

### Start an instance

    [root@headnode (bh1-kvm1:0) ~]# vmadm start 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Successfully started 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

### Reboot an instance

    [root@headnode (bh1-kvm1:0) ~]# vmadm reboot 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Succesfully completed reboot for 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

### Delete an instance

Note: This will permenantly delete all data in that zone.

    [root@headnode (bh1-kvm1:0) ~]# vmadm delete 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Successfully deleted 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

## Migrate an Instance to a Different Compute Node

A zone is composed of two components.

- zone config
- zfs datasets

Copying these to a different compute node will make a duplicate on the
destination compute node. You can then delete the original to complete
the migration.

There are two ways to migrate a zone.

- manual migration
- `vmadm send`/`vmadm receive`

Whichever method you choose, you will need to manually create the `cores`
dataset before booting the zone on the desitination. See below.

Before starting, it's a good idea to make sure the origin image for the zone
is installed on the desitation CN.

### Manual Migration

First, export the zone config.

    zonecfg -z <uuid> export > <uuid>.zcfg

On the destination CN, import it.

    zonecfg -z <uuid> -f <uuid>.zcfg

The zone will now be in the `configured` state as reported by `zoneadm`.

Secondly, use `zfs send` to copy the datasets. Note that for KVM instances
the disks are *outside* the zone root and must be sent individually. For
`OS`, `LX`, or `BHYVE` instances you can send just the top level zone
dataset.

You'll need to create a snapshot first.

    zfs snapshot -r zones/<uuid>@migration

When you send, it's preferable to [pre-load the image][managing-images] on the
destination compute node and send an incremental from the zone's image.  That
is, the image the zone was created from (e.g., `base-64`).

[managing-images]: managing-images.md

<!-- markdownlint-disable line-length -->

    zfs send -R -I zones/<image_uuid>@final zones/<uuid>@migration | ssh -c aes128-gcm@openssh.com <ip_address> 'zfs recv -d zones'

If for some reason you're unable to get the image on the destination, you can
do a full send.

    zfs send -R zones/<uuid>@migration | ssh -c aes128-gcm@openssh.com <ip_address> 'zfs recv -d zones'

<!-- markdownlint-enable line-length -->

See [`zfs(1M)`][zfs-man] for information about additional send options. In
particular, read up on resumable transfers. This helps if you have a large
dataset and/or an unreliable network.

[zfs-man]: https://smartos.org/man/1m/zfs

On the destination compute node, attach the zone. This will move the zone from
`configured` to `stopped`. Note: You don't need to explictly copy or create the
cores dataset because it gets created at attach time.

    zoneadm -z <zone_uuid> attach

The zone should be ready to boot up.

Here is a demonstration of a manual migration.

<!-- markdownlint-disable no-inline-html line-length -->
<script id="asciicast-O4WvBHZYgronNoxurbRFud8l8" src="https://asciinema.org/a/O4WvBHZYgronNoxurbRFud8l8.js" async></script>
<!-- markdownlint-enable no-inline-html line-length -->

### Using vmadm send/receive

While `vmadm send` is easier to use, `vmadm send` and `vmadm receive`
are experimental, unsupported, undocumented-in-the-manpage features.
This is not a committed interface. The behavior may be modified or
removed entirely without warning.

Use at your own risk.

    vmadm send <uuid> |ssh -c aes128-gcm@openssh.com 'vmadm receive'

Re-create the cores dataset

As mentioned above, you'll need to manually recreate the `cores` dataset.
See [OS-6789](https://smartos.org/bugview/OS-6789) for more details.

<!-- markdownlint-disable line-length -->

    zfs create -o quota=1000m -o compression=gzip -o mountpoint=/zones/:zone_uuid/cores zones/cores/:zone_uuid

<!-- markdownlint-enable line-length -->

Remove the Instance from the source compute node

    # vmadm delete 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    Successfully deleted 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

Here is a demonstration of using `vmadm send`.

<!-- markdownlint-disable no-inline-html line-length -->

<script id="asciicast-v6dt6tQfWSWZFmEH7G611TS28" src="https://asciinema.org/a/v6dt6tQfWSWZFmEH7G611TS28.js" async></script>

<!-- markdownlint-enable no-inline-html line-length -->

### Troubleshooting Migration Failure

If the migration fails, you may need to manually destroy the ZFS dataset
for the zone on the destination machine before you can try sending the
instance again. The below error is a symptom of this:

<!-- markdownlint-disable line-length -->

    [root@headnode (bh1-kvm1:0) ~]# vmadm send 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0 |ssh 10.0.1.4 vmadm receive
    vmunbundle exited with code 1
    Successfully sent 54f1cc77-68f1-42ab-acac-5c4f64f5d6e0

<!-- markdownlint-enable line-length -->

Check to see if the ZFS dataset exists on the destination, then remove
if it exists

    [root@destinationNode ~]# zfs list
    NAME                                           USED  AVAIL  REFER  MOUNTPOINT
    zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0     651K  10.0G   651K  /zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
    [root@destinationNode ~]# zfs destroy zones/54f1cc77-68f1-42ab-acac-5c4f64f5d6e0
