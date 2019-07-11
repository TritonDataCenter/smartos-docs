# The Linux-to-SmartOS Cheat Sheet

The things that make a SmartMachine different from other Unix-like systems
generally fall in two categories:

- Similar commands with different names in SmartOS.
- Different procedures for accomplishing similar things in SmartOS.

The following is a list of commands to help Linux users find
equivalent commands in SmartOS and SmartMachines.  Note that some
of these are not available within SmartMachines due to permission
restrictions, and some commands, when run in a SmartMachine, return
a subset of the output on the global zone in SmartOS.  Also note
that many commands available on Linux are also available on
SmartMachines.  For instance, you can use `pkgin install top` to
install `top(1)`.

This list is derived from <http://bhami.com/rosetta.html>

## Linux and SmartOS Commands

<!-- markdownlint-disable no-inline-html no-trailing-spaces -->

<table border="1">
<tbody>
<tr>
<th >
TASK / OS
</th>
<th >
Linux
</th>
<th >
SmartOS
</th>
<th >
SmartOS Virtual Instance (zone)
</th>
</tr>
<tr>
<td >
*table key*
</td>
<td >
*(rh)* = Red Hat, Mandrake, SUSE,...
*(deb)* = Debian, Libranet,...
*(fed)* = Fedora 
*(gen)* = Gentoo 
*(md)* = Mandrake/Mandriva
*(SUSE)* = SUSE
</td>
<td >
Joyent SmartOS

You can find an open source version at <http://smartos.org>
</td>
<td >
Joyent SmartOS zone
</td>
</tr>
<tr>
<td >
managing users
</td>
<td >
useradd
usermod
userdel
adduser
chage 
getent
</td>
<td >
useradd
userdel
usermod
getent
logins
groupadd
</td>
<td >
useradd 
userdel 
usermod 
getent 
logins 
groupadd
</td>
</tr>
<tr>
<td >
list hardware configuration
</td>
<td >
arch
uname
dmesg *(if you're lucky)*
cat /var/log/dmesg
/proc/*
lshw
dmidecode
lspci
lspnp
lsscsi
lsusb
lsmod
*(SUSE)* hwinfo
/sys/devices/*
</td>
<td >
arch
prtconf [-v]
prtpicl [-v]
uname
psrinfo [-v] 
isainfo [-v]
dmesg
iostat -En
cfgadm -l
/etc/path_to_inst
</td>
<td >
arch
uname
psrinfo [-v]
isainfo [-v]
dmesg
iostat -En
</td>
</tr>
<tr>
<td >
read a disk label
</td>
<td >
fdisk -l
</td>
<td >
fdisk
prtvtoc
</td>
<td >

</td>
</tr>
<tr>
<td >
label a disk
</td>
<td >
cfdisk
fdisk
e2label
</td>
<td >
format
prtvtoc
fdisk
</td>
<td >

</td>
</tr>
<tr>
<td >
partition a disk
</td>
<td >
parted *(if you have it)*
cfdisk
fdisk
pdisk *(on a Mac)*
*(deb)* *mac-fdisk *(on a Mac)_
*(md)* _diskdrake
</td>
<td >
format
fmthard
rmformat
</td>
<td >

</td>
</tr>
<tr>
<td >
kernel
</td>
<td >
/boot/vmlinuz*
/boot/bootlx
(see /etc/lilo.conf or /boot/grub/menu.lst)
</td>
<td >
/kernel/genunix
/platform/`uname -m`/
 kernel/unix
kernel modules are in /kernel, /usr/kernel, and /platform/`uname
-m`/kernel
</td>
<td >
Kernel module files not visible within a zone
</td>
</tr>
<tr>
<td >
show/set kernel parameters
</td>
<td >
/proc/*
/proc/sys/*
sysctl
/etc/sysctl.conf
</td>
<td >
sysdef
getconf 
cat /etc/system
ndd
mdb -k[w]
</td>
<td >
sysdef
getconf
ndd
</td>
</tr>
<tr>
<td >
loaded kernel modules
</td>
<td >
lsmod
</td>
<td >
modinfo
</td>
<td >
modinfo
</td>
</tr>
<tr>
<td >
load module
</td>
<td >
modprobe
insmod
</td>
<td >
modload
add_drv
devfsadm
</td>
<td >

</td>
</tr>
<tr>
<td >
unload module
</td>
<td >
rmmod
modprobe -r
</td>
<td >
modunload
</td>
<td >

</td>
</tr>
<tr>
<td >
startup scripts
</td>
<td >
/etc/rc* (but may vary)
/etc/init.d/
</td>
<td >
SMF(5)
/etc/rc*
/etc/init.d/
 svcadm
svcs
</td>
<td >
SMF(5)
/etc/rc*
/etc/init.d
svcadm
svcs
</td>
</tr>
<tr>
<td >
start/ stop/ config services
</td>
<td >
*(rh)* _service
*(rh)* _chkconfig
*(deb)* _sysv-rc-conf
</td>
<td >
svcs
svcadm 
svccfg
</td>
<td >
svcs
svcadm
svccfg
</td>
</tr>
<tr>
<td >
shutdown (& power off if possible)
</td>
<td >
shutdown -Ph now 
shutdown -y -g0 -i0
halt
poweroff
</td>
<td >
shutdown -y -g0 -i5
halt
</td>
<td >
shutdown -y -g0 -i5
halt
</td>
</tr>
<tr>
<td >
run levels
*=normal states 
*for more detail*
*see*
[www.phildev.net/runlevels.html](http://www.phildev.net/runlevels.html)
</td>
<td >
(set in /etc/inittab)
0: halt
s,S,1: *vendor-dependent*
1: single-user
2-5*: multiuser
6: reboot
</td>
<td >
0: firmware monitor
s,S: single-user
1: sys admin
2: multiuser
3*: share NFS
4*: user-defined
5: power-down if possible
6: reboot
</td>
<td >
s,S: single-user 
1: sys admin 
2: multiuser 
3*: share NFS 
4*: user-defined 
5: power-down if possible 
6: reboot
</td>
</tr>
<tr>
<td >
show runlevel 
</td>
<td >
/sbin/runlevel
</td>
<td >
who -r
</td>
<td >
who -r
</td>
</tr>
<tr>
<td >
time zone info
</td>
<td >
/usr/share/zoneinfo/
/etc/localtime
</td>
<td >
/usr/share/lib/zoneinfo/
</td>
<td >
/usr/share/lib/zoneinfo
</td>
</tr>
<tr>
<td >
check swap space
</td>
<td >
swapon -s
cat /proc/meminfo
cat /proc/swaps
free
</td>
<td >
swap -s[h]
swap -l[h]
</td>
<td >
*Note: in a zone, swap is virtual*
*memory size*
swap -s[h]
swap -l[h]
</td>
</tr>
<tr>
<td >
bind process to CPU
</td>
<td >
taskset (sched-utils)
</td>
<td >
pbind
psrset
</td>
<td >
pbind
psrset
</td>
</tr>
<tr>
<td >
killing processes
</td>
<td >
kill
killall
</td>
<td >
kill
pkill
killall *&lt;- tries to kill everything, DO NOT USE THIS*
</td>
<td >
kill
pkill
killall *&lt;- tries to kill everything, DO NOT USE THIS*
</td>
</tr>
<tr>
<td >
show CPU info
</td>
<td >
cat /proc/cpuinfo
lscpu
</td>
<td >
psrinfo -pv
</td>
<td >
psrinfo -pv
</td>
</tr>
<tr>
<td >
memory
</td>
<td >
freemem
</td>
<td >
prtconf | head
zonememstat
</td>
<td >
prtconf | head
zonememstat
</td>
</tr>
<tr>
<td >
"normal" filesystem
</td>
<td >
ext2
ext3
ReiserFS
</td>
<td >
zfs
</td>
<td >
zfs
</td>
</tr>
<tr>
<td >
file system
description
</td>
<td >
/etc/fstab
</td>
<td >
/etc/vfstab
</td>
<td >
/etc/vfstab
</td>
</tr>
<tr>
<td >
create filesystem
</td>
<td >
mke2fs
mkreiserfs
mkdosfs
mkfs
</td>
<td >
zfs 
zpool
</td>
<td >
zfs (if zone has delegated dataset)
</td>
</tr>
<tr>
<td >
file system debugging and recovery
</td>
<td >
fsck
debugfs
e2undel
</td>
<td >
zdb
</td>
<td >

</td>
</tr>
<tr>
<td >
create non-0-length empty file
</td>
<td >
dd if=/dev/zero of=*filename* 
bs=1024k count=*desired*
</td>
<td >
mkfile
</td>
<td >
mkfile
</td>
</tr>
<tr>
<td >
create/mount ISO image
</td>
<td >
mkisofs
mount -o loop *pathToIso*
*mountPoint*
</td>
<td >
mkisofs;DEVICE=`lofiadm -a /*absolute_pathname*/*image*.iso` ; mount
-F hsfs -o ro
$DEVICE
</td>
<td >

</td>
</tr>
<tr>
<td >
ACL management
</td>
<td >
getfacl
setfacl
</td>
<td >
getfacl
setfacl
</td>
<td >
getfacl
setfacl
</td>
</tr>
<tr>
<td >
NFS share definitions
</td>
<td >
/etc/exports
</td>
<td >
/etc/dfs/dfstab
dfshares
</td>
<td >

</td>
</tr>
<tr>
<td >
NFS share command
</td>
<td >
/etc/init.d/nfs-server reload_(rh)__ _exportfs -a
</td>
<td >
share
shareall
</td>
<td >

</td>
</tr>
<tr>
<td >
NFS information
</td>
<td >
cat /proc/mounts
</td>
<td >
showmount
nfsstat
</td>
<td >
nfsstat
</td>
</tr>
<tr>
<td >
name resolution order
</td>
<td >
/etc/nsswitch.conf
/etc/resolv.conf
</td>
<td >
/etc/nsswitch.conf
getent
</td>
<td >
/etc/nsswitch.conf
getent
</td>
</tr>
<tr>
<td >
show network interface info
</td>
<td >
ifconfig
ethtool
</td>
<td >
dladm
ndd
ifconfig -a
netstat -in
</td>
<td >
dladm
ndd
ifconfig -a
netstat -in
</td>
</tr>
<tr>
<td >
change IP
</td>
<td >

</td>
<td >
*Joyent Public Cloud IP addresses are set in the* *[Cloud Management
Portal](http://my.joyentcloud.com).*
ifconfig
</td>
<td >

</td>
</tr>
<tr>
<td >
ping one packet
</td>
<td >
ping -c 1 *hostname*
</td>
<td >
ping *hostname* * packetsize 1*
</td>
<td >
ping *hostname packetsize* 1
</td>
</tr>
<tr>
<td >
sniff network
</td>
<td >
etherfind
tcpdump
wireshark (*formerly* _ethereal)
etherape
</td>
<td >
snoop
</td>
<td >
snoop
tcpdump available from pkgin
</td>
</tr>
<tr>
<td >
route definitions
</td>
<td >
*route*
*(rh) */etc/sysconfig/network
*(rh) */etc/sysconfig/static-routes
*(deb)* /etc/init.d/network
*(deb)* /etc/network
</td>
<td >
/etc/defaultrouter
/etc/notrouter
/etc/gateways
in.routed
netstat -r
route add
</td>
<td >
/etc/defaultrouter 
/etc/notrouter 
/etc/gateways 
in.routed 
netstat -r 
route add
</td>
</tr>
<tr>
<td >
telnetd, ftpd banner
</td>
<td >
/etc/issue.net *(telnet)*
*(ftp varies; can use tcp wrappers)*
</td>
<td >
Use nc instead
</td>
<td >
Use nc instead
</td>
</tr>
<tr>
<td >
set date/time
(from net: ntp or other)
</td>
<td >
ntpdate
rdate
netdate
</td>
<td >
ntpdate
rdate
</td>
<td >
ntpdate
rdate
</td>
</tr>
<tr>
<td >
auditing
</td>
<td >
auditd
/var/log/faillog
</td>
<td >
audit
auditd
auditreduce
praudit
</td>
<td >
audit
auditd
auditreduce
praudit
</td>
</tr>
<tr>
<td >
encrypted passwords in
</td>
<td >
/etc/shadow *(may vary)*
</td>
<td >
/etc/shadow
</td>
<td >
/etc/shadow
</td>
</tr>
<tr>
<td >
min password length
</td>
<td >
/etc/pam.d/system-auth
</td>
<td >
/etc/default/passwd
</td>
<td >
/etc/default/passwd
</td>
</tr>
<tr>
<td >
allow/deny root
logins
</td>
<td >
/etc/securetty
</td>
<td >
/etc/default/login
</td>
<td >
/etc/default/login
</td>
</tr>
<tr>
<td >
firewall config
</td>
<td >
iptables
ipchains
ipfwadm
*(rh)* redhat-config-
securitylevel
</td>
<td >
/etc/ipf/ipf.conf
</td>
<td >
/etc/ipf/ipf.conf
</td>
</tr>
<tr>
<td >
show installed software
</td>
<td >
*(rh)* _rpm -a -i
*(rh)* _rpm -qa 
*(rh)* yum list installed
*(deb)* dselect
*(deb)* aptitude
*(deb)* dpkg -l
*(gen)* _ls /var/db/pkg/*
*(gen)* _eix -I
</td>
<td >

</td>
<td >
pkgin list
pkgin avail  *&lt;- list available installable software*
</td>
</tr>
<tr>
<td >
add software
</td>
<td >
*(rh)* _rpm -hiv 
*(rh)* yum install *pkg*
*(deb)* dselect
*(deb) _apt-get install _pkg*
*(deb)* dpkg -i
</td>
<td >

</td>
<td >
pkgin install
</td>
</tr>
<tr>
<td >
precompiled binaries* of GPLware and freeware*
</td>
<td >
[www.linux.org](http://www.linux.org/)
[linux.tucows.com](http://linux.tucows.com/)
[sourceforge.net](http://sourceforge.net/)
[rpmfind.net](http://rpmfind.net/)
(deb) [ftp.debian.org](http://ftp.debian.org/)
(deb) [packages.debian.org](http://packages.debian.org/)
*(gen)* [packages.gentoo.org](http://packages.gentoo.org/)
*(gen)* [gentoo-portage.com](http://gentoo-portage.com/);
*(md)* [easyurpmi.zarb.org](http://easyurpmi.zarb.org/)
</td>
<td >
[www.sunfreeware.com](http://www.sunfreeware.com/)
[www.blastwave.org](http://www.blastwave.org/)
</td>
<td >
<http://pkgsrc.joyent.com/>
pkgin
</td>
</tr>
<tr>
<td >
C compiler
</td>
<td >
cc
gcc
</td>
<td >
gcc
[https://download.joyent.com/pub/build/SunStudio.tar.bz2]
</td>
<td >
gcc (may need to be installed via pkgin)
[https://download.joyent.com/pub/build/SunStudio.tar.bz2](https://downlo
ad.joyent.com/pub/build/SunStudio.tar.bz2&nbsp)

</td>
</tr>
<tr>
<td >
configure/show 
runtime linking

</td>
<td >
ldconfig
ldd
readelf 
lsmod
</td>
<td >
crle
ldd
elfdump
dump 
pldd
modinfo
LD_PRELOAD
</td>
<td >
crle
ldd
elfdump
dump
readelf 
pldd
modinfo
LD_PRELOAD
</td>
</tr>
<tr>
<td >
link library path
</td>
<td >
$LD_LIBRARY_PATH
/etc/ld.so.conf
</td>
<td >
$LD_LIBRARY_PATH
</td>
<td >
$LD_LIBRARY_PATH
</td>
</tr>
<tr>
<td >
tracing utility
</td>
<td >
strace
ltrace
</td>
<td >
dtrace
truss
sotruss
</td>
<td >
dtrace
truss
sotruss
</td>
</tr>
<tr>
<td >
define user defaults
</td>
<td >
/etc/profile
/etc/security/
/etc/skel/
/etc/profile.d/*
</td>
<td >
/etc/default/login
/etc/profile
/etc/security/
</td>
<td >
/etc/default/login
/etc/profile
/etc/security/
</td>
</tr>
<tr>
<td >
csh global .login
</td>
<td >
/etc/csh.login
</td>
<td >
/etc/.login
</td>
<td >
/etc/.login
</td>
</tr>
<tr>
<td >
default syslog and messages
</td>
<td >
/var/log/syslog
/var/log/messages
/usr/adm/messages 
/var/log/maillog
</td>
<td >
/var/adm/messages
/var/log/syslog
[softpanorama.org/Logs/solaris_logs.shtml](http://softpanorama.org/Logs
/solaris_logs.shtml)
</td>
<td >
/var/adm/messages
/var/log/syslog
</td>
</tr>
<tr>
<td >
system error reporting tool
</td>
<td >
dmesg_(deb)_ reportbug
</td>
<td >
fmadm
fmdump
prtdiag
</td>
<td >
fmadm
fmdump
</td>
</tr>
<tr>
<td >
performance monitoring
</td>
<td >
vmstat
procinfo -D
top
htop
pstree
</td>
<td >
dtrace
prstat
sar
ostat
kstat
mpstat
netstat
nfsstat
vmstat
lockstat
plockstat 
ptree
vfsstat
intrstat
</td>
<td >
dtrace
prstat 
sar 
ostat 
kstat 
mpstat 
netstat 
nfsstat 
vmstat
plockstat 
ptree 
vfsstat 
</td>
</tr>
<tr>
<td >
match process to file or port
</td>
<td >
lsof
netstat -atup
</td>
<td >
fuser
pfiles
</td>
<td >
pfiles
fuser
lsof
</td>
</tr>
<tr>
<td >
zones/containers
</td>
<td >

</td>
<td >
zoneadm
zonecfg
zlogin
</td>
<td >
zoneadm
zonename
</td>
</tr>
<tr>
<td >
Virtualization
</td>
<td >
kvm/qemu
</td>
<td >
kvm/qemu (each instance in a kvm branded zone)
vmadm
imgadm
</td>
<td >

</td>
</tr>
<tr>
<td >
[Wikipedia](http://en.wikipedia.org/wiki/Category:Unix_variants)
</td>
<td >
[Linux](http://en.wikipedia.org/wiki/Linux)
</td>
<td >
[SmartOS](http://en.wikipedia.org/wiki/SmartOS)

[Illumos](http://en.wikipedia.org/wiki/Illumos)
</td>
<td >
[SmartOS](http://en.wikipedia.org/wiki/SmartOS)
[Illumos](http://en.wikipedia.org/wiki/Illumos)
</td>
</tr>
</tbody>
</table>

<!-- markdownlint-enable no-inline-html no-trailing-spaces -->

## Examples of Different Use Context

For example, here are some common Linux commands that work differently.

<!-- markdownlint-disable line-length -->

| Command | What's different on a Smart Machine |
| ------- | ------------------------------------------------------------
| `df`    | On most SmartOS image this is set up to use the GNU version. Use `/usr/bin/df` for the native version. |
| `lsof`  | SmartMachines use a different collection of tools to examine processes. See [Examining processes and memory](#procmem) later in this topic. |
| `ping`  | Returns whether a host responds or not.  Use `ping -s` to get a continuous response.   |
| `top`   | `top` is available in `/opt/local/bin`, but `prstat -Z` provides more zone aware (and more accurate) information than `top`. |

<!-- markdownlint-enable line-length -->

The [Rosetta Stone for Unix](http://bhami.com/rosetta.html) is a useful
resource to help you see how commands from the version of UNIX you
usually work with map to other versions of UNIX.

### Examining processes and memory

SmartOS provides a suite of tools to examine processes. You can learn
more about them by looking at the `proc` man page.

<!-- markdownlint-disable line-length -->

| Tool       | Description |
| ---------- | ---------------------------------------------------------
| `prstat`   | This tool displays the active processes like `top` does on Linux systems. `prstat -Z` will provide you with a summary of your instance's status. |
| `pgrep`    | Returns a list of process IDs (PIDs) of processes that match a pattern or meet certain conditions. |
| `pkill`    | Kills the processes that match a pattern or meet certain conditions. |
| `pfiles`   | Returns a list of all the open files that belong to a process. |
| `pstack`   | Displays a stack trace of the specified process |
| `ptree`    | Displays a process tree for all processes or a given process |
| `ls /proc` | Lists the process IDs of all running processes. |

<!-- markdownlint-enable line-length -->

You can combine the results of `pgrep` with the other proc tools. To
list all the files associated with http processes, use this command
instead of `lsof`:

    sudo pfiles $(pgrep http)

To limit the `prstat` display to http processes, use this command:

    prstat $(pgrep -d , http)

The `vmstat`, `mpstat`, and `psrinfo` commands display processor and
memory statistics for the physical machine. Their output is not
generally useful to you as a SmartMachine operator.

### Starting and stopping services

On other systems, you may be used to starting and stopping servers by
using commands in `/etc/init.d`. SmartMachines use the Service
Management Facility (SMF) to do this. The `svcs` and `svcadm` commands
are the ones you will use most often. Some commands take a service
identifier called an FMRI. You can use the `svcs` command to list all of
the identifiers for a service.

<!-- markdownlint-disable line-length -->

| Command                 | Description |
| ----------------------- | -------------------------------------------- |
| `svcs`                  | Lists all the enabled services |
| `svcs -a`               | Lists all of the services, even those that are disabled or off line |
| `svcadm enable apache`  | Enable all of the processes with an `apache` FMRI |
| `svcadm disable apache` | Disable all of the processes with an `apache` FMRI |
| `svcadm restart apache` | Restart all of the processes with an `apache` FMRI |

<!-- markdownlint-enable line-length -->

For example, if you make changes to `/etc/ssh/sshd_config`, restart SSH
like this:

    sudo svcadm restart ssh

For more information on SMF, see [this topic](basic-smf-commands.md).
