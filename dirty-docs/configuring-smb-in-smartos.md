+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Configuring SMB in
SmartOS </span>

</div>

<div class="pagesubheading">

This page last changed on Oct 15, 2017 by
<font color="#0050B2">cjr</font>.

</div>

This HowTo is based on a patch introduced on Nov 17, 2015 that enables a
non-global zone to use kernel based CIFS. The nice part of this is it
takes very little work to get a CIFS zone up and running, no `smb.conf`
file needed. This How-To uses delegate datasets to make things easier to
manage within the zone. From the ZFS Admin Guide concerning delegate
datasets:

> The zone administrator can set file system properties, as well as
> create children. In addition, the zone administrator can take
> snapshots, create clones, and otherwise control the entire file system
> hierarchy.

Downside to delegated datasets is if the zone is deleted the datasets
are also deleted.

Here is the step by step I came up with.

1.  Import base64 image (tested 15.3.0 and 15.4.1)
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ imgadm avail name=base-64 version=15.3.0
    842e6fa6-6e9b-11e5-8402-1b490459e334  base-64   15.3.0      smartos
 2015-10-09T15:36:32Z
    $ imgadm import 842e6fa6-6e9b-11e5-8402-1b490459e334
    ```

    </div>

    </div>

    </div>

2.  Create joyent zone json
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
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
     "resolvers":[
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
    ```

    </div>

    </div>

    </div>

3.  Create Joyent zone from the json file
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ vmadm create -f yourName.json
    ```

    </div>

    </div>

    </div>

4.  Log into zone
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ zlogin zoneUUID
    ```

    </div>

    </div>

    </div>

5.  Add entry to `/etc/pam.conf` for `pam_smb_passwd`

    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    # Used when service name is not explicitly mentioned for password ma
nagement
      other   password required       pam_dhkeys.so.1
      other   password requisite      pam_authtok_get.so.1
      other   password requisite      pam_authtok_check.so.1
      other   password required       pam_authtok_store.so.1
      other   password required       pam_smb_passwd.so.1     nowarn
    ```

    </div>

    </div>

    </div>

    Note that `pam.conf` requires tabs between columns. The inserted
    line should include tabs as follows:

    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    other<tab>password required<tab>pam_smb_passwd.so.1<tab>nowarn
    ```

    </div>

    </div>

    </div>

    Even though this enables SMB authentication, this does not
    initialize the SMB password database. The SMB password database by
    default will be empty at this point, and all accounts will fail SMB
    authentication until their password is set, for example by using the
    command line `passwd` utility, as mentioned below.

6.  Enable these services
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ svcadm enable smb/server
    $ svcadm enable smb/client
    $ svcadm enable rpc/bind
    $ svcadm enable idmap
    ```

    </div>

    </div>

    </div>

7.  Verify services have started
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ svcs |grep smb
    online         18:36:54 svc:/network/smb/client:default
    online         18:36:54 svc:/network/smb/server:default
    online         18:36:55 svc:/network/shares/group:smb

    $ svcs |grep bind
     online         18:36:53 svc:/network/rpc/bind:default

    $ svcs |grep idmap
     online         18:36:54 svc:/system/idmap:default
    ```

    </div>

    </div>

    </div>

8.  Create a mount point dataset
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ zfs create zones/6ecf3543-1c65-6600-ab32-e05de443026c/data/share1
    ```

    </div>

    </div>

    </div>

9.  Set a quota for the dataset
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ zfs set quota=100M zones/6ecf3543-1c65-6600-ab32-e05de443026c/data
/share1
    ```

    </div>

    </div>

    </div>

10. Create a mount point
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ sudo zfs set mountpoint=/share1 zones/6ecf3543-1c65-6600-ab32-e05d
e443026c/data/share1
    ```

    </div>

    </div>

    </div>

11. Change file ownership. In this case I used `admin:staff`
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ sudo chown admin:staff /share1
    ```

    </div>

    </div>

    </div>

12. Change admin’s password so SMB password will be updated
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ passwd admin xxxx
    ```

    </div>

    </div>

    </div>

13. Share the filesystem

    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    $ sharemgr add-share -r testCifs -s /share1 smb
    ```

    </div>

    </div>

    </div>

    (note: -r is the displayed resource name, -s is the share location,
    smb is the file system export type. see man sharemgr)

14. Test with a CIFS client
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


