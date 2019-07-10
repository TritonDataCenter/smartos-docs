<!-- markdownlint-disable no-trailing-punctuation line-length -->

# Is SmartOS suitable for a file server ?

People often ask about the suitability of SmartOS as a NAS or file
server.

There are two features of SmartOS that make it attractive for a NAS:

1. The excellent integration of ZFS, which is available on all
   Illumos platforms.
2. The USB boot/root filesystem leaves all of the disk space available
   for data, and it is extremely unlikely the boot/root filesystem will
   ever be corrupted. If it is, just re-flash it, and you are off and
   running again.

But there are a couple of issues that make implementing a NAS
problematic.

First, NFS is available only in the global zone (GZ). It seems this will
be fixed someday. But for now it means we can only NFS share filesystems
out of the GZ. The NFS share information is stored in the ZFS datasets,
so the persistence issue doesn't bite us here. If all you need is NFS
file sharing, SmartOS is an excellent solution. But most people need to
support Windows and/or Apple clients.

Second, the transient nature of the GZ. It is possible to install
packages (such as Samba or Netatalk) in the GZ and work around the
persistence issue, but this contradicts the design and intention of
SmartOS and it is not recommended. The SmartOS way is to keep the GZ
pristine and light -- just ZFS and management of virtual machines -- and
do everything else in the VMs.

For these reasons, someone looking for a straight NAS is probably better
served using another platform, such as OmniOS, perhaps using Napp-it to
simplify management.

But if you also need virtualization, SmartOS starts to become much more
attractive, and it may be worthwhile to workaround the above problems.

Here are some approaches that have been used successfully:

1. Create a zone. To support Windows and Mac clients either run CIFS or
   install Samba in it. To support older Mac clients install Netatalk.
   This approach is compatible with the goal of minimizing changes to
   the GZ. The zone takes up very little disk space or memory, and it
   runs at bare metal speed. If you want Samba to share the same
   dataset that NFS is sharing in the GZ, pipe the dataset into the
   zone using lofs. Implement one of the following for authentication &
   access control:
   - Define users in /etc/passwd and smbpasswd
   - Authenticate to an LDAP server
   - Use winbind to authenticate to an Active Directory server

2. Run CIFS in the GZ to share files with Windows clients. Roughly the
   same mechanisms can be used for access control, but they all must
   cheat on persistence:
   - Restore /etc/passwd after each boot, with entries corresponding
     to smbpasswd
   - Authenticate to an LDAP server
   - Join the system to an AD domain

3. Install Samba in the GZ. Use the same mechanisms as CIFS to
   control access.

## An example configuration from Jorge S:

Copied from <https://gist.github.com/sjorge/57c7694e6a0df6fe2ad4>

`root@smartos`

    mkdir -p /opt/custom/smf/bin
    cd /opt/custom/smf
    vim persist-syscfg.xml
    cd bin
    vim persist-syscfg
    chmod +x persist-syscfg
    <reboot>
    svcadm disable persist-syscfg
    <set nfs/smb config, create/edit groups/user>
    svcadm enable persist-syscfg

| Variable    | Description |
| ------------|- ------------------------------------------ |
| enable_stmf | enable services needed for iSCSI target |
| enable_smb  | enable services needed for CIFS |
| enable_nfs  | enable services needed for NFS |

`persist-syscfg`

    #!/usr/bin/bash

    # Originally based on http://wiki.smartos.org/display/DOC/Allowing+user+CRUD+in+the+global+zone
    # Author: hugo@freenode

    enable_stmf=0
    enable_smb=1
    enable_nfs=1
    save_us=( /etc/passwd /etc/shadow /etc/group /etc/ouser_attr /etc/user_attr \
              /etc/security/policy.conf /etc/security/auth_attr /etc/security/exec_attr \
              /etc/security/prof_attr /etc/pam.conf /var/smb/smbpasswd /var/smb/osmbpasswd /var/smb/smbgroup.db )

    ukeystor="/usbkey/cn-persist"

    # this script needs rsync
    if [ ! -f /usr/bin/rsync ]; then
        echo please install rsync
        exit 1
    fi

    case "$1" in
        'start')
        if [[ -n $(/bin/bootparams | grep '^smartos=true') ]]; then
            # file magic
            svcadm disable system/name-service-cache:default
            for file in ${save_us[*]}
            do
                ukf=${ukeystor}${file}

                if [[ -z $(/usr/sbin/mount -p | grep $file) ]]; then
                    if [[ $ukf -ot $file ]]; then
                        rsync -Rrtpogu $file $ukeystor
                        echo "sys->stor: $file"
                    else
                        rsync -rtpog $ukf $file
                        echo "stor->sys: $file"
                    fi

                    touch $file $ukf
                    mount -F lofs $ukf $file
                fi
            done
            svcadm enable system/name-service-cache:default
            mkdir -p ${ukeystor}/svc/
            [ -e /tmp/nfssrv.lock ] && svccfg export -a nfs/server > ${ukeystor}/svc/nfssrv.prop
            [ -e ${ukeystor}/svc/nfssrv.prop ] && svccfg import ${ukeystor}/svc/nfssrv.prop
            touch /tmp/nfssrv.lock

            [ -e /tmp/smbsrv.lock ] && svccfg export -a smb/server > ${ukeystor}/svc/smbsrv.prop
            [ -e ${ukeystor}/svc/smbsrv.prop ] && svccfg import ${ukeystor}/svc/smbsrv.prop
            touch /tmp/smbsrv.lock

            [ -e /tmp/stmf.lock ] && svccfg export -a stmf > ${ukeystor}/svc/stmf.prop
            [ -e ${ukeystor}/svc/stmf.prop ] && svccfg import ${ukeystor}/svc/stmf.prop
            touch /tmp/stmf.lock

            # enable services
            if [ ${enable_stmf} -gt 0 ]; then
                svcadm enable system/stmf
                svcadm enable iscsi/target
            fi
            if [ ${enable_smb} -gt 0 ]; then
                svcadm enable system/idmap
                svcadm enable smb/client
                svcadm enable smb/server
            fi
            if [ ${enable_nfs} -gt 0 ]; then
                svcadm enable nfs/server
            fi
        fi
        ;;
        'stop')
            svcadm disable system/name-service-cache:default
            for file in ${save_us[*]}
            do
                if [[ -n $(/usr/sbin/mount -p | grep $file) ]]; then
                    umount $file && touch $file
                fi
            done
            svcadm enable system/name-service-cache:default
         ;;
    esac

`persist-syscfg.xml`

    <?xml version='1.0'?>
    <!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.d
    td.1'>
    <service_bundle type='manifest' name='export'>
      <service name='site/persist-syscfg' type='service' version='0'>
        <create_default_instance enabled='true'/>
        <single_instance/>
        <dependency name='filesystem' grouping='require_all' restart_on='error' type='service'>
          <service_fmri value='svc:/system/filesystem/local'/>
        </dependency>
        <dependent name='nsc' grouping='require_all' restart_on='refresh'>
          <service_fmri value='svc:/system/name-service-cache' />
        </dependent>
        <method_context/>
        <exec_method name='start' type='method' exec='/opt/custom/smf/bin/persist-syscfg start' timeout_seconds='60'/>
        <exec_method name='stop' type='method' exec='/opt/custom/smf/bin/persist-syscfg stop' timeout_seconds='60'/>
        <property_group name='startd' type='framework'>
          <propval name='duration' type='astring' value='transient'/>
          <propval name='ignore_error' type='astring' value='core,signal'/>
        </property_group>
        <property_group name='application' type='application'/>
        <stability value='Evolving'/>
        <template>
          <common_name>
            <loctext xml:lang='C'>Apply configuration from /usbkey, making it persistent</loctext>
          </common_name>
        </template>
      </service>
    </service_bundle>
