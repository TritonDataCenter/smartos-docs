# Persistent Users and RBAC in the Global Zone

Source: `hugo` on `#freenode` (posted by AlainODea as a favor)

To make modifications that would change the files listed in the `save_us`
array variable in the `persist-syscfg.sh` script shown below
(e.g: users, groups, roles, rights profiles, etc), do the following:

    svcadm disable svc:/system/name-service-cache:default
    svcadm disable svc:/site/persist-syscfg:default

When you're done, re-enable the service:

    svcadm enable svc:/site/persist-syscfg:default
    svcadm enable svc:/system/name-service-cache:default

Example:

    # id roletest
    id: invalid user name: "roletest"
    NOTE: role doesn't yet exist
    
    # roleadd roletest
    UX: roleadd: ERROR: Cannot update system files - login cannot be created.
    NOTE: fails as we have not disabled the service yet
    
    # svcadm disable svc:/site/persist-syscfg:default
    
    # roleadd roletest
    NOTE: no output, role was added successfully
    
    # svcadm enable svc:/site/persist-syscfg:default
    NOTE: saves changes to persistent storage
    
    # id roletest
    uid=101(roletest) gid=1(other)
    NOTE: confirm role exists
    
    # roledel roletest
    UX: roledel: ERROR: Cannot update system files - login cannot be deleted
    .
    NOTE: fails again, should we want to delete it, we'd need to disable the
     service again:
    
    # svcadm disable svc:/site/persist-syscfg:default
    # roledel roletest
    # svcadm enable svc:/site/persist-syscfg:default

Possible uses:

Since `/etc/security/policy.conf` is now persistent, you may want to
consider applying [this](http://wiki.smartos.org/display/DOC/Hide+processes+and+connections+from+unprivileged+users+on+the+system)

You could turn root into a role in the following way:

    # usermod -K type=role root
    # usermod -R root user

This way, root cannot login directly (except in single user mode) and
only users to whom you give the root role (usermod -R root) will be
allowed to su root, increasing the security of the system.

WARNING: Keep in mind that after you make root into a role, you won't be
able to login directly as root through ssh. Be absolutely sure that you
can access the system as the user
to whom you attributed the role immediately after doing so.

`/opt/custom/smf/persist-syscfg.xml`:
<!-- markdownlint-disable line-length -->

    <?xml version='1.0'?>
    <!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.dtd.1'>
    <service_bundle type='manifest' name='export'>
      <service name='site/persist-syscfg' type='service' version='0'>
        <create_default_instance enabled='true'/>
        <single_instance/>
        <dependency name='filesystem' grouping='require_all' restart_on='error' type='service'>
          <service_fmri value='svc:/system/filesystem/local'/>
        </dependency>
        <method_context/>
        <exec_method name='start' type='method' exec='/opt/custom/share/svc/persist-syscfg.sh start' timeout_seconds='60'/>
        <exec_method name='stop' type='method' exec='/opt/custom/share/svc/persist-syscfg.sh stop' timeout_seconds='60'/>
        <property_group name='startd' type='framework'>
          <propval name='duration' type='astring' value='transient'/>
          <propval name='ignore_error' type='astring' value='core,signal'/>
        </property_group>
        <property_group name='application' type='application'/>
        <stability value='Evolving'/>
        <template>
          <common_name>
            <loctext xml:lang='C'>Apply user and RBAC configuration from /usbkey, making it persistent</loctext>
          </common_name>
        </template>
      </service>
    </service_bundle>

<!-- markdownlint-enable line-length -->

`/opt/custom/share/svc/persist-syscfg.sh`:
<!-- markdownlint-disable line-length -->

    #!/usr/bin/bash
    
    # Originally based on http://wiki.smartos.org/display/DOC/Allowing+user+CRUD+in+the+global+zone
    # Author: hugo@freenode
    
    save_us=( /etc/passwd /etc/shadow /etc/group /etc/ouser_attr /etc/user_attr \
              /etc/security/policy.conf /etc/security/auth_attr /etc/security/exec_attr \
              /etc/security/prof_attr )
    
    ukeystor="/usbkey/cn-persist"
    
    # this script needs rsync
    if [ ! -f /usr/bin/rsync ]; then
        echo please install rsync
        exit 1
    fi
    
    case "$1" in
        'start')
        if [[ -n $(/bin/bootparams | grep '^smartos=true') ]]; then
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
        fi
        ;;
        'stop')
            for file in ${save_us[*]}
            do
                if [[ -n $(/usr/sbin/mount -p | grep $file) ]]; then
                    umount $file && touch $file
                fi
            done
        ;;
    esac

<!-- markdownlint-enable line-length -->
