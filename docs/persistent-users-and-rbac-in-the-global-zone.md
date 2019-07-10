+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Persistent Users and
RBAC in the Global Zone </span>

</div>

<div class="pagesubheading">

This page last changed on Mar 23, 2014 by
<font color="#0050B2">alainodea</font>.

</div>

Source: hugo on \#freenode (posted by AlainODea as a favor)

To make modifications that would change the files listed in save\_us
(e.g: users, groups, roles, rights profiles, etc), do the following:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
svcadm disable svc:/system/name-service-cache:default
svcadm disable svc:/site/persist-syscfg:default
```

</div>

</div>

</div>

When you're done, re-enable the service:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
svcadm enable svc:/site/persist-syscfg:default
svcadm enable svc:/system/name-service-cache:default
```

</div>

</div>

</div>

Example:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# id roletest
id: invalid user name: "roletest"
NOTE: role doesn't yet exist

# roleadd roletest
UX: roleadd: ERROR: Cannot update system files - login cannot be created
.
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
```

</div>

</div>

</div>

Possible uses:

Since /etc/security/policy.conf is now persistent, you may want to
consider applying
<http://wiki.smartos.org/display/DOC/Hide+processes+and+connections+from
+unprivileged+users+on+the+system>

You could turn root into a role in the following way:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# usermod -K type=role root
# usermod -R root user
```

</div>

</div>

</div>

This way, root cannot login directly (except in single user mode) and
only users to whom you give the root role (usermod -R root) will be
allowed to su root, increasing the security of the system.

WARNING: Keep in mind that after you make root into a role, you won't be
able to login directly as root through ssh. Be absolutely sure that you
can access the system as the user\
to whom you attributed the role immediately after doing so.

/opt/custom/smf/persist-syscfg.xml:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
<?xml version='1.0'?>
<!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.d
td.1'>
<service_bundle type='manifest' name='export'>
  <service name='site/persist-syscfg' type='service' version='0'>
    <create_default_instance enabled='true'/>
    <single_instance/>
    <dependency name='filesystem' grouping='require_all' restart_on='err
or' type='service'>
      <service_fmri value='svc:/system/filesystem/local'/>
    </dependency>
    <method_context/>
    <exec_method name='start' type='method' exec='/opt/custom/share/svc/
persist-syscfg.sh start' timeout_seconds='60'/>
    <exec_method name='stop' type='method' exec='/opt/custom/share/svc/p
ersist-syscfg.sh stop' timeout_seconds='60'/>
    <property_group name='startd' type='framework'>
      <propval name='duration' type='astring' value='transient'/>
      <propval name='ignore_error' type='astring' value='core,signal'/>
    </property_group>
    <property_group name='application' type='application'/>
    <stability value='Evolving'/>
    <template>
      <common_name>
        <loctext xml:lang='C'>Apply user and RBAC configuration from /us
bkey, making it persistent</loctext>
      </common_name>
    </template>
  </service>
</service_bundle>
```

</div>

</div>

</div>

/opt/custom/share/svc/persist-syscfg.sh:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
#!/usr/bin/bash

# Originally based on http://wiki.smartos.org/display/DOC/Allowing+user+
CRUD+in+the+global+zone
# Author: hugo@freenode

save_us=( /etc/passwd /etc/shadow /etc/group /etc/ouser_attr /etc/user_a
ttr \
          /etc/security/policy.conf /etc/security/auth_attr /etc/securit
y/exec_attr \
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
```

</div>

</div>

</div>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


