# Joining SmartOS to an Active Directory domain

Why would you want to join SmartOS to an AD domain?

I am using SmartOS as both a file server for Windows clients and as a
virtual machine host (hypervisor) running Windows Server and Linux VMs.
The CIFS feature allows SmartOS to serve files to Windows clients from
the GZ using just kernel code – no extra software required.  But SmartOS
does not support the definition of users, groups, etc., in the GZ, so
how can we implement any sort of security?  So it makes sense to utilize
an Active Directory for this.  If you join the SmartOS GZ to an AD
domain, CIFS can use the AD to authenticate users and check access
control lists.

The AD doesn't have to be a Windows Server: it can be Samba4 running in
a VM.

(By the way, an alternative approach for serving files to Windows
clients is to install Samba3, in the GZ or in a OS zone.  While that
involves another layer of software, it supports the SMB2 protocol \[CIFS
does not\], so it's not clear how that would affect performance – it
might improve it.  It also supports shared printers.  That approach is
not documented here.)

Only the GZ can be joined to a domain.  And changes made to the GZ are
not persistent.  So that complicates things a little.  Here is how to do
it.

In the following examples...

- My domain name is allenlan.net
- My AD server is hostname samba-ad (samba-ad.allenlan.net), IP
    address 192.168.0.13
- My SmartOS GZ is hostname smartos, IP address 192.168.0.94

First we will do everything interactively.

Edit `/etc/hosts` – insert your AD host (this step is helpful but not
essential). Example:

    127.0.0.1       localhost loghost
    192.168.0.94    smartos  smartos.allenlan.net   # my SmartOS GZ
    192.168.0.13    samba-ad  samba-ad.allenlan.net # my AD server

Edit `/etc/resolv.conf` – insert a `domain` line with your domain name,
and a `nameserver` line pointing to your AD server. If your AD server is
a VM, you may want a secondary `nameserver` that is always available.
Example:

    domain allenlan.net
    nameserver 192.168.0.13 # my AD server
    nameserver 192.168.0.1  # my 'always on' DNS

Edit `/etc/krb5/krb5.conf`. Example:

    [libdefaults]
        default_realm = ALLENLAN.NET
    [realms]
        ALLENLAN.NET = {
            kdc = samba-ad.allenlan.net
            admin_server = samba-ad.allenlan.net
            kpasswd_server = samba-ad.allenlan.net
            kpasswd_protocol = SET_CHANGE
        }
    [domain_realm]
        .example.com = ALLENLAN.NET

And then:

    cp /etc/nsswitch.ad /etc/nsswitch.conf

**Important:** Make sure the SmartOS clock is synchronized to your AD
server. This should be done by setting `ntp_hosts` in `/usbkey/config`.
If you're doing this in a zone, you won't be able to change the clock
since it comes from the global zone.

Then substitute your AD IP address or hostname in the first command, and
your domain or OU administrator username in the last command:

    sharectl set -p ads_site=192.168.0.13 smb
    svcadm enable -r smb/server
    smbadm join -u administrator allenlan.net

The 'smbadm join' command should return at least 5 lines of information
showing that you are joined to the domain.  To further test the join,
substitute a domain username in this command:

    getent passwd domainuser@allenlan.net

This should return information about the user.

Once this is working, we need to make all of the above changes
persistent.  The /etc/ files will be overwritten by the next boot, and
the idmap & smb/server services will start up not joined to a domain.
So copy the modified /etc/ files someplace permanent.  I am saving them
in /opt/custom/domain-join/

    mkdir -p /opt/custom/domain-join
    cd /etc
    cp hosts resolv.conf nsswitch.conf krb5/krb5.conf /opt/custom/domain-join/
    svccfg export -a smb/server > /opt/custom/domain-join/smb-server.exp
    svccfg export -a idmap > /opt/custom/domain-join/idmap.exp

Let's make sure everything is still working.  Reboot the system, then
perform the following commands:

    svcadm disable idmap smb/server
    cd /opt/custom/domain-join
    cp hosts resolv.conf nsswitch.conf /etc/
    cp krb5.conf /etc/krb5/
    svccfg import idmap.exp
    svccfg import smb-server.exp
    svcadm enable idmap smb/server
    smbadm list

Does it show the system is joined to the domain?  If so, good so far.

Finally we need an SMF service that will perform these steps for us on
each boot.  The SMF XML itself is very basic, here is what the script
looks like:

    #!/bin/bash
    #
    # domain-join.sh - refresh the status of the domain join upon boot
    set -o xtrace
    . /lib/svc/share/smf_include.sh
    cd /
    #PATH=/usr/sbin:/usr/bin; export PATH
    case "$1" in
    'start')
     /usr/sbin/svcadm disable idmap smb/server
     cp /opt/custom/domain-join/hosts /etc/
     cp /opt/custom/domain-join/resolv.conf /etc/
     cp /opt/custom/domain-join/krb5.conf /etc/krb5/
     cp /opt/custom/domain-join/nsswitch.conf /etc/
     /usr/sbin/svccfg import /opt/custom/domain-join/idmap.exp
     /usr/sbin/svccfg import /opt/custom/domain-join/smb-server.exp
     /usr/sbin/svcadm enable idmap smb/server ;;
    'stop')
     ;;
    *)
     echo "Usage: $0 start"
     exit $SMF_EXIT_ERR_FATAL
     ;;
    esac
    exit $SMF_EXIT_OK

If your AD is a VM running on this SmartOS, it's probably a good idea to
wait for that VM to be fully up & running before performing the `svccfg
import` command which restarts the smb/server service.
