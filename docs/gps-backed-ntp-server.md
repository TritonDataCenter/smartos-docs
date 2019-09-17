# GPS backed NTP server

## Running a NTP server on SmartOS

### Background Information

I recently migrated my gateway to run ontop of SmartOS (OpenBSD in KVM
zone), I used to feed it my serial GPS to get a better fix. This won't
work with KVM.

So I decided to remove the GPS at first. That also did not work too
great, I noticed a lot of drift! Mostly due to the kvm clock not
updating the actual hardware clock!

My solution was to run ntpd inside a base zone. I had to give it some
extra privilages, I also had to disable ntp in the global zone. In the
end I even got my GPS to work, although not as wel as on OpenBSD.

### Disabling NTP in the global zone

To disable ntp in the global zone I added a custom SMF. You'll see some
commented lines to get my GPS to work too.
If you also want to use a GPS in the zone, uncomment those lines.

<!-- markdownlint-disable line-length -->

`opt/custom/smf/time-helper.xml`

    <?xml version="1.0"?>
    <!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.d
    td.1">

    <service_bundle type='manifest' name='acheron:time-helper'>
    <service name='acheron/time-helper' type='service' version='1'>
            <create_default_instance enabled='true' />
            <single_instance />
            <dependency name='filesystem' grouping='require_all' restart_on='none' type='service'>
                <service_fmri value='svc:/system/filesystem/local'/>
            </dependency>

            <dependency name='system-log' grouping='optional_all' restart_on='none' type='service'>
                <service_fmri value='svc:/network/ntp' />
            </dependency>

            <exec_method type='method' name='start' exec='/opt/custom/bin/time-helper' timeout_seconds='0' />
            <exec_method type='method' name='stop' exec=':true' timeout_seconds='0' />

            <property_group name='startd' type='framework'>
                    <propval name='duration' type='astring' value='transient' />
            </property_group>

            <stability value='Unstable' />
    </service>
    </service_bundle>

`opt/custom/bin/time-helper`

    #!/usr/bin/sh

    . /lib/svc/share/smf_include.sh

    ## alias my gps device to /dev/gps0 to make ntpd happy
    #/usr/bin/ln -sf /dev/cua/0 /dev/gps0
    ## disable global zone ntp
    /usr/sbin/svcadm disable svc:/network/ntp:default

    exit $SMF_EXIT_OK

### Creating The Zone

    {
      "brand": "joyent",
      "image_uuid": "c02a2044-c1bd-11e4-bd8c-dfc1db8b0182",
      "hostname": "ntp.acheron.be",
      "alias": "ntp",
      "autoboot": false,
      "nowait": false,
      "limit_priv": "default,+sys_time,+proc_priocntl,+proc_clock_highres",
      "cpu_shares": 100,
      "cpu_cap": 100,
      "max_physical_memory": 128,
      "quota": 2,
      "delegate_dataset": true,
      "zfs_io_priority": 100,
      "zfs_root_compression": "lz4",
      "nics": [
        {
          "nic_tag": "trunk",
          "mtu": 1500,
          "vlan_id": 30,
          "mac": "00:15:00:xx:xx:xx",
          "ip": "172.16.xx.2",
          "netmask": "255.255.255.0",
          "allow_ip_spoofing": true
        }
      ]
    }

The `limit_priv` line is important, it allows for: higher resolution
timers to be used, ntpd to change its niceness, ntpd to change the hw
clock.

If you want to use a gps device you need to include it in the zone,
there is no way to do this through vmadm.

Run `zonecfg -z UUID` and add the following:

    add device
      set match=/dev/cua/0
      end
    add device
      set match=/dev/gps0
      end
    exit

### Configuring NTPD

`etc/inet/ntp.conf`

    ## general
    driftfile /var/ntp/ntp.drift
    logfile /var/log/ntp.log

    ## security
    # default restrictions
    restrict -4 default limited kod notrap nomodify nopeer noquery
    restrict -6 default limited kod notrap nomodify nopeer noquery

    # allow localhost to manage ntpd
    restrict 127.0.0.1
    restrict -6 ::1


    # allow servers to reply to our queries
    restrict source nomodify noquery notrap

    ## time sources
    # local gps direct (mode 0 -> RMC, mode 2 -> GGA)
    #server 127.127.20.0 mode 2 minpoll 4 maxpoll 4 prefer
    #fudge 127.127.20.0 time2 0.7 refid GPS

    # gpsd shared memory
    #server 127.127.28.0 minpoll 4 maxpoll 4
    #fudge 127.127.28.0 time1 -0.245 refid GPS stratum 15
    #server 127.127.28.1 minpoll 4 maxpoll 4 prefer
    #fudge 127.127.28.1 refid PPS

    # remote time servers
    pool 0.europe.pool.ntp.org burst iburst minpoll 4 maxpoll 4

Comment out `local gps direct` when using a gps device

The last step is to get ntpd to run inside the zone, I hacked up the
global zone's ntp smf manifest.

`srv/ntpd/smf/ntp.xml`

    <?xml version='1.0'?>
    <!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.d
    td.1'>
    <service_bundle type='manifest' name='export'>
      <service name='network/ntp' type='service' version='0'>
        <single_instance/>
        <dependency name='network' grouping='require_any' restart_on='error'type='service'>
          <service_fmri value='svc:/network/service'/>
        </dependency>
        <dependency name='routing' grouping='require_all' restart_on='none'type='service'>
          <service_fmri value='svc:/network/routing-setup'/>
        </dependency>
        <exec_method name='start' type='method' exec='/srv/ntpd/smf/svc-ntp %m' timeout_seconds='600'>
          <method_context>
            <method_credential user='root' group='root' privileges='basic,!file_link_any,!proc_info,!proc_session,net_privaddr,proc_lock_memory,sys_time'/>
          </method_context>
        </exec_method>
        <exec_method name='restart' type='method' exec='/srv/ntpd/smf/svc-ntp %m' timeout_seconds='1800'>
          <method_context>
            <method_credential user='root' group='root' privileges='basic,!file_link_any,!proc_info,!proc_session,net_privaddr,proc_lock_memory,sys_time'/>
          </method_context>
        </exec_method>
        <exec_method name='stop' type='method' exec=':kill' timeout_seconds='60'/>
        <property_group name='general' type='framework'>
          <propval name='action_authorization' type='astring' value='solaris.smf.manage.ntp'/>
          <propval name='value_authorization' type='astring' value='solaris.smf.value.ntp'/>
        </property_group>
        <instance name='default' enabled='true'>
          <property_group name='config' type='application'>
            <propval name='always_allow_large_step' type='boolean' value='true'/>
            <propval name='debuglevel' type='integer' value='0'/>
            <propval name='logfile' type='astring' value='/var/ntp/ntp.log'/>
            <propval name='mdnsregister' type='boolean' value='false'/>
            <propval name='no_auth_required' type='boolean' value='false'/>
            <propval name='slew_always' type='boolean' value='false'/>
            <propval name='value_authorization' type='astring' value='solaris.smf.value.ntp'/>
            <propval name='verbose_logging' type='boolean' value='false'/>
            <propval name='wait_for_sync' type='boolean' value='false'/>
          </property_group>
        </instance>
        <stability value='Unstable'/>
        <template>
          <common_name>
            <loctext xml:lang='C'>Network Time Protocol (NTP) Version 4</loctext>
          </common_name>
          <documentation>
            <manpage title='ntpd' section='1M'/>
            <manpage title='ntp.conf' section='4'/>
            <manpage title='ntpq' section='1M'/>
          </documentation>
        </template>
      </service>
    </service_bundle>

`srv/ntpd/smf/svc-ntp`

    #!/sbin/sh
    #
    # CDDL HEADER START
    #
    # The contents of this file are subject to the terms of the
    # Common Development and Distribution License (the "License").
    # You may not use this file except in compliance with the License.
    #
    # You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
    # or http://www.opensolaris.org/os/licensing.
    # See the License for the specific language governing permissions
    # and limitations under the License.
    #
    # When distributing Covered Code, include this CDDL HEADER in each
    # file and include the License file at usr/src/OPENSOLARIS.LICENSE.
    # If applicable, add the following below this CDDL HEADER, with the
    # fields enclosed by brackets "[]" replaced with your own identifying
    # information: Portions Copyright [yyyy] [name of copyright owner]
    #
    # CDDL HEADER END
    #

    #
    # Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
    # Use is subject to license terms.
    #

    #
    # Copyright (c) 2013 Joyent, Inc.  All rights reserved.
    #

    # Standard prolog
    #
    . /lib/svc/share/smf_include.sh

    NTPD_OPTIONS="-N"

    if [ -z $SMF_FMRI ]; then
            echo "SMF framework variables are not initialized."
            exit $SMF_EXIT_ERR
    fi

    #
    # Is NTP configured?
    #
    if [ ! -f /etc/inet/ntp.conf ]; then
            echo "Error: Configuration file '/etc/inet/ntp.conf' not found." \
                "  See ntpd(1M)."
            exit $SMF_EXIT_ERR_CONFIG
    fi

    # Disable globbing to prevent privilege escalations by users authorized
    # to set property values for the NTP service.
    set -f

    #
    # Build the command line flags
    #
    shift $#
    set -- -p /var/run/ntp.pid
    # We allow a step large than the panic value of 17 minutes only
    # once when ntpd starts up. If always_all_large_step is true,
    # then we allow this each time ntpd starts. Otherwise, we allow
    # it only the very first time ntpd starts after a boot. We
    # check that by making ntpd write its pid to a file in /var/run.

    val=`svcprop -c -p config/always_allow_large_step $SMF_FMRI`
    if [ "$val" = "true" ]; then
        NTPD_OPTIONS="${NTPD_OPTIONS} -g"
    fi

    # Auth was off by default in xntpd now the default is on. Better have a way
    # to turn it off again. Also check for the obsolete "authenitcation" key word.
    val=`svcprop -c -p config/no_auth_required $SMF_FMRI`
    if [ ! "$val" = "true" ]; then
            val=`/usr/bin/nawk '/^[ \t]*#/{next}
                /^[ \t]*authentication[ \t]+no/ {
                    printf("true", $2)
                    next } ' /etc/inet/ntp.conf`
    fi
    [ "$val" = "true" ] && set -- "$@" --authnoreq

    # Set up logging if requested.
    logfile=`svcprop -c -p config/logfile $SMF_FMRI`
    val=`svcprop -c -p config/verbose_logging $SMF_FMRI`
    [ "$val" = "true" ] && [ -n "$logfile" ]  && set -- "$@" -l $logfile

    # Register with mDNS.
    val=`svcprop -c -p config/mdnsregister $SMF_FMRI`
    mdns=`svcprop -c -p general/enabled svc:/network/dns/multicast:default`
    [ "$val" = "true" ] && [ "$mdns" = "true" ] && set -- "$@" -m

    # We used to support the slewalways keyword, but that was a Sun thing
    # and not in V4. Look for "slewalways yes" and set the new slew option.
    val=`svcprop -c -p config/slew_always $SMF_FMRI`
    if [ ! "$val" = "true" ]; then
            val=`/usr/bin/nawk '/^[ \t]*#/{next}
                /^[ \t]*slewalways[ \t]+yes/ {
                    printf("true", $2)
                    next } ' /etc/inet/ntp.conf`
    fi
    [ "$val" = "true" ] && set -- "$@" --slew

    # Set up debugging.
    deb=`svcprop -c -p config/debuglevel $SMF_FMRI`

    # Start the daemon. If debugging is requested, put it in the background,
    # since it won't do it on its own.
    if [ "$deb" -gt 0 ]; then
            /usr/sbin/ntpd ${NTPD_OPTIONS} "$@" --set-debug-level=$deb >/var
    /ntp/ntp.debug &
    else
            /usr/sbin/ntpd ${NTPD_OPTIONS} "$@"
    fi

    # Now, wait for the first sync, if requested.
    val=`svcprop -c -p config/wait_for_sync $SMF_FMRI`
    [ "$val" = "true" ] && /usr/sbin/ntp-wait

    exit $SMF_EXIT_OK
