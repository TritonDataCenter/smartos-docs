# Configuring SMB in SmartOS

This guide configures a non-global zone to use kernel based SMB server. The
nice part of this is it takes very little work to get SMB up and running, and
config files needed. This How-To uses delegate datasets to make things
easier to manage within the zone. From the ZFS Admin Guide concerning delegate
datasets:

> The zone administrator can set file system properties, as well as
> create children. In addition, the zone administrator can take
> snapshots, create clones, and otherwise control the entire file system
> hierarchy.

Downside to delegated datasets is if the zone is deleted the datasets
are also deleted.

## Basic Config

1. Create joyent brand zone json using a base image (base-64, base-64-lts,
   base-64-trunk are all ok).

        {
          "brand": "joyent",
          "alias": "yourAlias",
          "hostname": "yourHostName",
          "image_uuid": "842e6fa6-6e9b-11e5-8402-1b490459e334",
          "autoboot": true,
          "max_physical_memory": 1024,
          "max_swap": 1024,
          "quota": 10,
          "delegate_dataset": true,
          "zfs_data_compression": "on",
          "zfs_root_compression": "on",
          "dns_domain": "yourDomainName",
          "resolvers": [
            "yourDNS",
            "8.8.8.8"
          ],
          "nics": [
            {
              "nic_tag": "admin",
              "ip": "yourIPAddress",
              "netmask": "yourNetMask",
              "gateway": "yourGateWay",
              "primary": true
            }
          ]
        }

2. Create Joyent zone from the json file

        vmadm create -f yourName.json

3. Log into zone

        zlogin zoneUUID

4. Add entry to `/etc/pam.conf` for `pam_smb_passwd`

        # Used when service name is not explicitly mentioned for password management
        other   password required       pam_dhkeys.so.1
        other   password requisite      pam_authtok_get.so.1
        other   password requisite      pam_authtok_check.so.1
        other   password required       pam_authtok_store.so.1
        other   password required       pam_smb_passwd.so.1     nowarn

    **Important:** `pam.conf` requires tabs between columns. The inserted
    line should include tabs as follows:

        other<tab>password required<tab>pam_smb_passwd.so.1<tab>nowarn

    Even though this enables SMB authentication, this does not
    initialize the SMB password database. The SMB password database by
    default will be empty at this point, and all accounts will fail SMB
    authentication until their password is set, for example by using the
    command line `passwd` utility, as mentioned below.

5. Enable the SMB services. `smb/client` is optional.

        svcadm enable smb/server
        svcadm enable smb/client
        svcadm enable rpc/bind
        svcadm enable idmap

6. Verify services have started

        $ svcs -a |grep smb
        online         18:36:54 svc:/network/smb/client:default
        online         18:36:54 svc:/network/smb/server:default
        online         18:36:55 svc:/network/shares/group:smb

        $ svcs -H rpc/bind
        online         18:36:53 svc:/network/rpc/bind:default

        $ svcs -H idmap
        online         18:36:54 svc:/system/idmap:default

7. Create a mount point dataset

         zfs create zones/$(zonename)/data/share1

8. Set a quota for the dataset, optionally with a specified mountpoint.

        zfs set quota=100M -o mountpoint=/share1 zones/$(zonename)/data/share1

9. Change file ownership. This example uses `admin:staff`, but can be anything.
   Regular UNIX file permissions apply and will reflect the user that
   authenticates over SMB.

        sudo chown admin:staff /share1

10. Change admin’s password so SMB password will be updated. You'll need to do
    this for each user that will be accessing shares over SMB.

        passwd admin xxxx

11. Share the filesystem

        sharemgr add-share -r testSMB -s /share1 smb

    **Important:** `-r` is the displayed resource name, `-s` is the share
    location, `smb` is the file system export type. See
    [`sharemgr(1M)`][sharemgr-1m] for additional options.

12. Test with a CIFS client

[sharemgr-8]: https://smartos.org/man/8/sharemgr

## Advertising SMB Services via Bonjour

You can optionally advertise services using DNS Service Discovery and Multicast
DNS (aka *Bonjour* on macOS). This helps if you have macOS clients, especially
if you want to use your SMB share as a Time Machine target. This comes in two
parts:

1. `mdnsd` - aka, `mDNSResponder`. This responds to network requests from other
   hosts.
2. `dns-sd` - This is used to register services that mdnsd will then serve when
   queried.

First enable mdnsd

    svcadm enable dns/multicast

Which services you register will depend on how you want the system to behave.

### Advertising SMB Only

The minimum necessary, is to advertise the `_smb._tpc` service on port 445.
This will make your server show up in the Mac Finder, with a default icon.

    dns-sd -R "${HOSTNAME}" _smb._tcp local 445

### Enabling Time Machine

Before you begin on this adventure, know that there is no guarantee that this
will work for you. This is not supported by Apple, and while we hope it works,
it's not supported in any way. It's a DIY kit, not a product. It worked for me,
but this probably also carries with it a need for a minimum level of experience
to save your data when all seems hopeless. If you want to depend on this as
your only back up, you need to make sure it works for all uses cases that you
will need. We can't cover every possible edge case here, and there may be
dragons ahead.

To allow Time Machine back ups to this share, advertise `_adisk._tcp`, to
specify capabilities via `TXT` records. There are two parameters, `sys` for
global flags and `dk`, a quasi-array. Each text record is a single contiguous
string of non-witespace.

For `sys` use `waMa=0,adVF=0x100`. I can't find any resources describing the
meaning of `waMa=0` If you know, please tell us! `adVF` is the advertisement
flags. `0x100` specifies to prompt for username and password, and excludes home
directory sharing.

You can also supply additional `dkN` records, where `N` is an integer.`dk`
records support `adVF` for flags, `adVN` for the share name, and `adVU` which
is a UUID.

For `adVF`, you'll want to use `0x82`, which specifies that it's shared via SMB
and can be used as a Time Machine target.

For `adVN`, the string needs to match the share name specified with the `-r`
flag when defining the share with `sharemgr`. If you have multiple shares, this
is the value that matches each txt record with the corresponding share.

For `adVU`, you can generate a random UUID, generate one based on the zfs guid
of the dataset, or use `sharemgr -x smb` and use the UUID provided there (be
sure to exclude the `S-` prefix). Whatever you do, the UUID should be assigned
once and be persistent. The only requirements are that it's a validly formatted
UUID and that it's persistent.

    dns-sd -R "${HOSTNAME}" _adisk._tcp local 445 sys=waMa=0,adVF=0x100 dk0=adVF=0x82,adVN=testSMB,adVU=827f0c37-ef7e-4d61-82a6-ca812aefd86c

If you're advertising multiple shares, just list them all in order in the same
invocation of `dns-sd`.

    sys=... dk0=... dk1=... dk2=...

If you don't want to use Time Machine, then `_adisk` advertisements aren't
necessary.

### Selecting a Custom Icon

Finally, if you're like me you'll want to set a custom icon using a
`_device-info._tcp` advertisement. macOS doesn't actually advertise
`_device-info`, but it does respond to queries for it. `dns-sd` doesn't behave
this way, so we'll advertise it directly, which also works.

Around the Internet, using the `TimeCapsule` icon seems to be quite popular,
but that is by far not the only choice. The supported icons vary by the version
of macOS. You can view them by looking in
`/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources` on a Mac,
and you can query how to specify them.

<!-- markdownlint-disable line-length -->

    plutil -convert json -r -o - - < /System/Library/CoreServices/CoreTypes.bundle/Contents/Info.plist | json UTExportedTypeDeclarations | json -a -c 'this.UTTypeTagSpecification' UTTypeIconFile UTTypeTagSpecification

<!-- markdownlint-enable line-length -->

Each icon file will include a name, and optionally an `ECOLOR` value. The
`ECOLOR` is for a variant of the same model. E.g., a Space Grey vs Rose Gold
MacBook Pro.

For example, the following record will use a Mac Pro 2019 (`MacPro7,1`) rack
mounted (`ecolor=226,226,224`) icon. If you exclude the `ecolor` value, the
icon will be the tower configuration.

    /usr/bin/dns-sd -R "${HOSTNAME}" _device-info._tcp local 9 model=MacPro7,1 ecolor=226,226,224

**Note**: the port number is required for `dns-sd`, but it's not included with TXT
records. Here, we set the port to 9, the discard port, so that the value is
explicitly useless.
