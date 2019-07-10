# Allowing user CRUD in the global zone

Note: This does not seem to work properly anymore.

## Introduction

This script manifest and method extend the lofs mounts that are included
in Joyent's svc:/system/filesystem/smartdc SMF service
(`/lib/svc/manifest/system/filesystem/joyent-fs.xml`) to include
`/etc/passwd` and `/etc/group`, along with logic to keep the analogs in
`/usbkey/` in sync with the active system variants in `/etc/`.

Place both files in `/opt/custom/smf`, and when you would like to
add/modify/delete system users in the global zone, run `svcadm
disable mount_usbkey_userfiles` and make your changes. When you are
finished, run `svcadm enable mount_usbkey_userfiles` to bring the
system back into 'normal' working mode.

### Manifest

`mount_usbkey_userfiles.xml`

<!-- markdownlint-disable line-length -->

    <?xml version='1.0'?>
    <!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.dtd.1'>
    <service_bundle type='manifest' name='export'>
      <service name='site/mount_usbkey_userfiles' type='service' version='0'>
        <create_default_instance enabled='true'/>
        <single_instance/>
        <dependency name='filesystem' grouping='require_all' restart_on='error' type='service'>
          <service_fmri value='svc:/system/filesystem/local'/>
        </dependency>
        <method_context/>
        <exec_method name='start' type='method' exec='/opt/custom/smf/mount_usbkey_userfiles start' timeout_seconds='60'/>
        <exec_method name='stop' type='method' exec='/opt/custom/smf/mount_usbkey_userfiles stop' timeout_seconds='60'/>
        <property_group name='startd' type='framework'>
          <propval name='duration' type='astring' value='transient'/>
          <propval name='ignore_error' type='astring' value='core,signal'/>
        </property_group>
        <property_group name='application' type='application'/>
        <stability value='Evolving'/>
        <template>
          <common_name>
            <loctext xml:lang='C'>Mount /etc/passwd, /etc/shadow, and /etc/group from /usbkey</loctext>
          </common_name>
        </template>
      </service>
    </service_bundle>

### Method

`mount\_usbkey\_userfiles` (must be executable)

    #!/usr/bin/bash

    case "$1" in
    'start')
      if [[ -n $(/bin/bootparams | grep '^smartos=true') ]]; then
        if [[ -z $(/usr/sbin/mount -p | grep '/etc/passwd') ]]; then
          if [[ /etc/passwd -ot /usbkey/passwd ]]; then
            cp /usbkey/passwd /etc/passwd
          else
            cp /etc/passwd /usbkey/passwd
          fi
          touch /etc/passwd /usbkey/passwd
          mount -F lofs /usbkey/passwd /etc/passwd
        fi
        if [[ -z $(/usr/sbin/mount -p | grep '/etc/group') ]]; then
          if [[ /etc/group -ot /usbkey/group ]]; then
            cp /usbkey/group /etc/group
          else
            cp /etc/group /usbkey/group
          fi
          touch /etc/group /usbkey/group
          mount -F lofs /usbkey/group /etc/group
        fi
        if [[ -z $(/usr/sbin/mount -p | grep '/etc/shadow') ]]; then
          if [[ /etc/shadow -ot /usbkey/shadow ]]; then
            cp /usbkey/shadow /etc/shadow
          else
            cp /etc/shadow /usbkey/shadow
          fi
          touch /etc/shadow /usbkey/shadow
          mount -F lofs /usbkey/shadow /etc/shadow
        fi
      fi
      ;;
    'stop')
      if [[ -n $(/usr/sbin/mount -p | grep 'group') ]]; then umount /etc/gro
    up; touch /etc/group; fi
      if [[ -n $(/usr/sbin/mount -p | grep 'passwd') ]]; then umount /etc/pa
    sswd; touch /etc/passwd; fi
      if [[ -n $(/usr/sbin/mount -p | grep 'shadow') ]]; then umount /etc/sh
    adow; touch /etc/shadow; fi
      ;;
    *)
      echo "Usage: $0 { start | stop }"
      exit 1
      ;;
    esac
