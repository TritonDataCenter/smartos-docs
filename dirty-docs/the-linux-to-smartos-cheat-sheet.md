+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : The Linux-to-SmartOS
Cheat Sheet </span>

</div>

<div class="pagesubheading">

This page last changed on Feb 11, 2016 by
<font color="#0050B2">tpaul</font>.

</div>

+--------------------------------------+--------------------------------
------+
| The things that make a SmartMachine  |
      |
| different from other Unix-like       |
      |
| systems generally fall in two        |
      |
| categories:                          |
      |
|                                      |
      |
| -   Similar commands with different  |
      |
|     names in SmartOS.                |
      |
| -   Different procedures for         |
      |
|     accomplishing similar things     |
      |
|     in SmartOS.                      |
      |
|                                      |
      |
| The following is a list of commands  |
      |
| to help Linux users find equivalent  |
      |
| commands in SmartOS and              |
      |
| SmartMachines.  Note that some of    |
      |
| these are not available within       |
      |
| SmartMachines due to permission      |
      |
| restrictions, and some commands,     |
      |
| when run in a SmartMachine, return a |
      |
| subset of the output on the global   |
      |
| zone in SmartOS.  Also note that     |
      |
| many commands available on Linux are |
      |
| also available on SmartMachines.     |
      |
|  For instance, you can use "pkgin    |
      |
| install top" to install top(1).      |
      |
+--------------------------------------+--------------------------------
------+

<div class="panelMacro">

  ---------------------------------------------------------------------
-----------------------------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
This list is derived from <http://bhami.com/rosetta.html>
  ---------------------------------------------------------------------
-----------------------------------------------------------

</div>

Linux and SmartOS Commands
==============================

<div class="table-wrap">

<table class="confluenceTable">
<tbody>
<tr>
<th class="confluenceTh">
**TASK / OS**
</th>
<th class="confluenceTh">
**Linux**
</th>
<th class="confluenceTh">
**SmartOS**
</th>
<th class="confluenceTh">
SmartOS Virtual Instance (zone)
</th>
</tr>
<tr>
<td class="confluenceTd">
*table key*
</td>
<td class="confluenceTd">
*(rh)* = Red Hat, Mandrake, SUSE,...\
*(deb)* = Debian, Libranet,...\
*(fed)* = Fedora \
*(gen)* = Gentoo \
*(md)* = Mandrake/Mandriva\
*(SUSE)* = SUSE
</td>
<td class="confluenceTd">
Joyent SmartOS\
\
You can find an open source version at <http://smartos.org>
</td>
<td class="confluenceTd">
Joyent SmartOS zone
</td>
</tr>
<tr>
<td class="confluenceTd">
**managing users**
</td>
<td class="confluenceTd">
useradd\
usermod\
userdel\
adduser\
chage \
getent
</td>
<td class="confluenceTd">
useradd\
userdel\
usermod\
getent\
logins\
groupadd
</td>
<td class="confluenceTd">
useradd \
userdel \
usermod \
getent \
logins \
groupadd
</td>
</tr>
<tr>
<td class="confluenceTd">
**list hardware configuration**\
</td>
<td class="confluenceTd">
arch\
uname\
dmesg *(if you're lucky)*\
cat /var/log/dmesg\
/proc/\*\
lshw\
dmidecode\
lspci\
lspnp\
lsscsi\
lsusb\
lsmod\
*(SUSE)* hwinfo\
/sys/devices/\*
</td>
<td class="confluenceTd">
arch\
prtconf \[-v\]\
prtpicl \[-v\]\
uname\
psrinfo \[-v\] \
isainfo \[-v\]\
dmesg\
iostat -En\
cfgadm -l\
/etc/path\_to\_inst
</td>
<td class="confluenceTd">
arch\
uname\
psrinfo \[-v\]\
isainfo \[-v\]\
dmesg\
iostat -En
</td>
</tr>
<tr>
<td class="confluenceTd">
**read a disk label**
</td>
<td class="confluenceTd">
fdisk -l
</td>
<td class="confluenceTd">
fdisk\
prtvtoc
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**label a disk**
</td>
<td class="confluenceTd">
cfdisk\
fdisk\
e2label
</td>
<td class="confluenceTd">
format\
prtvtoc\
fdisk
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**partition a disk**
</td>
<td class="confluenceTd">
parted *(if you have it)*\
cfdisk\
fdisk\
pdisk *(on a Mac)*\
*(deb)* *mac-fdisk *(on a Mac)\_\
*(md)* \_diskdrake
</td>
<td class="confluenceTd">
format\
fmthard\
rmformat
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**kernel**
</td>
<td class="confluenceTd">
/boot/vmlinuz\*\
/boot/bootlx\
(see /etc/lilo.conf or /boot/grub/menu.lst)
</td>
<td class="confluenceTd">
/kernel/genunix\
/platform/\`uname -m\`/\
 kernel/unix\
kernel modules are in /kernel, /usr/kernel, and /platform/\`uname
-m\`/kernel
</td>
<td class="confluenceTd">
Kernel module files not visible within a zone
</td>
</tr>
<tr>
<td class="confluenceTd">
**show/set kernel parameters**
</td>
<td class="confluenceTd">
/proc/\*\
/proc/sys/\*\
sysctl\
/etc/sysctl.conf
</td>
<td class="confluenceTd">
sysdef\
getconf \
cat /etc/system\
ndd\
mdb -k\[w\]
</td>
<td class="confluenceTd">
sysdef\
getconf\
ndd
</td>
</tr>
<tr>
<td class="confluenceTd">
**loaded kernel modules**
</td>
<td class="confluenceTd">
lsmod
</td>
<td class="confluenceTd">
modinfo
</td>
<td class="confluenceTd">
modinfo
</td>
</tr>
<tr>
<td class="confluenceTd">
**load module**
</td>
<td class="confluenceTd">
modprobe\
insmod
</td>
<td class="confluenceTd">
modload\
add\_drv\
devfsadm
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**unload module**
</td>
<td class="confluenceTd">
rmmod\
modprobe -r
</td>
<td class="confluenceTd">
modunload
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**startup scripts**
</td>
<td class="confluenceTd">
/etc/rc\* (but may vary)\
/etc/init.d/
</td>
<td class="confluenceTd">
SMF(5)\
/etc/rc\*\
/etc/init.d/\
 svcadm\
svcs\
</td>
<td class="confluenceTd">
SMF(5)\
/etc/rc\*\
/etc/init.d\
svcadm\
svcs\
</td>
</tr>
<tr>
<td class="confluenceTd">
**start/ stop/ config services**
</td>
<td class="confluenceTd">
*(rh)* \_service\
*(rh)* \_chkconfig\
*(deb)* \_sysv-rc-conf
</td>
<td class="confluenceTd">
svcs\
svcadm \
svccfg
</td>
<td class="confluenceTd">
svcs\
svcadm\
svccfg
</td>
</tr>
<tr>
<td class="confluenceTd">
**shutdown (& power off if possible)**
</td>
<td class="confluenceTd">
shutdown -Ph now \
shutdown -y -g0 -i0\
halt\
poweroff
</td>
<td class="confluenceTd">
shutdown -y -g0 -i5\
halt
</td>
<td class="confluenceTd">
shutdown -y -g0 -i5\
halt
</td>
</tr>
<tr>
<td class="confluenceTd">
**run levels**\
**\*=normal states **\
*for more detail*\
*see*\
[www.phildev.net/runlevels.html](http://www.phildev.net/runlevels.html)
</td>
<td class="confluenceTd">
(set in /etc/inittab)\
0: halt\
s,S,1: *vendor-dependent*\
1: single-user\
2-5\*: multiuser\
6: reboot
</td>
<td class="confluenceTd">
0: firmware monitor\
s,S: single-user\
1: sys admin\
2: multiuser\
3\*: share NFS\
4\*: user-defined\
5: power-down if possible\
6: reboot
</td>
<td class="confluenceTd">
s,S: single-user \
1: sys admin \
2: multiuser \
3\*: share NFS \
4\*: user-defined \
5: power-down if possible \
6: reboot\
</td>
</tr>
<tr>
<td class="confluenceTd">
**show runlevel **
</td>
<td class="confluenceTd">
/sbin/runlevel
</td>
<td class="confluenceTd">
who -r
</td>
<td class="confluenceTd">
who -r
</td>
</tr>
<tr>
<td class="confluenceTd">
**time zone info**
</td>
<td class="confluenceTd">
/usr/share/zoneinfo/\
/etc/localtime
</td>
<td class="confluenceTd">
/usr/share/lib/zoneinfo/
</td>
<td class="confluenceTd">
/usr/share/lib/zoneinfo
</td>
</tr>
<tr>
<td class="confluenceTd">
**check swap space**
</td>
<td class="confluenceTd">
swapon -s\
cat /proc/meminfo\
cat /proc/swaps\
free
</td>
<td class="confluenceTd">
swap -s\[h\]\
swap -l\[h\]
</td>
<td class="confluenceTd">
*Note: in a zone, swap is virtual*\
*memory size*\
swap -s\[h\]\
swap -l\[h\]
</td>
</tr>
<tr>
<td class="confluenceTd">
**bind process to CPU**
</td>
<td class="confluenceTd">
taskset (sched-utils)
</td>
<td class="confluenceTd">
pbind\
psrset
</td>
<td class="confluenceTd">
pbind\
psrset
</td>
</tr>
<tr>
<td class="confluenceTd">
**killing processes**
</td>
<td class="confluenceTd">
kill\
killall
</td>
<td class="confluenceTd">
kill\
pkill\
killall *&lt;- tries to kill everything, DO NOT USE THIS*
</td>
<td class="confluenceTd">
kill\
pkill\
killall *&lt;- tries to kill everything, DO NOT USE THIS*\
</td>
</tr>
<tr>
<td class="confluenceTd">
**show CPU info**
</td>
<td class="confluenceTd">
cat /proc/cpuinfo\
lscpu
</td>
<td class="confluenceTd">
psrinfo -pv\
</td>
<td class="confluenceTd">
psrinfo -pv\
</td>
</tr>
<tr>
<td class="confluenceTd">
**memory**
</td>
<td class="confluenceTd">
freemem
</td>
<td class="confluenceTd">
prtconf | head\
zonememstat
</td>
<td class="confluenceTd">
prtconf | head\
zonememstat
</td>
</tr>
<tr>
<td class="confluenceTd">
**"normal" filesystem**
</td>
<td class="confluenceTd">
ext2\
ext3\
ReiserFS
</td>
<td class="confluenceTd">
zfs
</td>
<td class="confluenceTd">
zfs
</td>
</tr>
<tr>
<td class="confluenceTd">
**file system**\
**description**
</td>
<td class="confluenceTd">
/etc/fstab
</td>
<td class="confluenceTd">
/etc/vfstab
</td>
<td class="confluenceTd">
/etc/vfstab
</td>
</tr>
<tr>
<td class="confluenceTd">
**create filesystem**
</td>
<td class="confluenceTd">
mke2fs\
mkreiserfs\
mkdosfs\
mkfs
</td>
<td class="confluenceTd">
zfs \
zpool
</td>
<td class="confluenceTd">
zfs (if zone has delegated dataset)
</td>
</tr>
<tr>
<td class="confluenceTd">
**file system debugging and recovery**
</td>
<td class="confluenceTd">
fsck\
debugfs\
e2undel
</td>
<td class="confluenceTd">
zdb
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**create non-0-length empty file**
</td>
<td class="confluenceTd">
dd if=/dev/zero of=*filename* \
bs=1024k count=*desired*
</td>
<td class="confluenceTd">
mkfile
</td>
<td class="confluenceTd">
mkfile
</td>
</tr>
<tr>
<td class="confluenceTd">
**create/mount ISO image**
</td>
<td class="confluenceTd">
mkisofs\
mount -o loop *pathToIso*\
*mountPoint*
</td>
<td class="confluenceTd">
mkisofs;DEVICE=\`lofiadm -a /*absolute\_pathname*/*image*.iso\` ; mount
-F hsfs -o ro\
\$DEVICE
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**ACL management**
</td>
<td class="confluenceTd">
getfacl\
setfacl
</td>
<td class="confluenceTd">
getfacl\
setfacl
</td>
<td class="confluenceTd">
getfacl\
setfacl
</td>
</tr>
<tr>
<td class="confluenceTd">
**NFS share definitions**
</td>
<td class="confluenceTd">
/etc/exports
</td>
<td class="confluenceTd">
/etc/dfs/dfstab\
dfshares
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**NFS share command**
</td>
<td class="confluenceTd">
/etc/init.d/nfs-server reload\_(rh)\_\_ \_exportfs -a
</td>
<td class="confluenceTd">
share\
shareall
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**NFS information**
</td>
<td class="confluenceTd">
cat /proc/mounts
</td>
<td class="confluenceTd">
showmount\
nfsstat
</td>
<td class="confluenceTd">
nfsstat
</td>
</tr>
<tr>
<td class="confluenceTd">
**name resolution order**
</td>
<td class="confluenceTd">
/etc/nsswitch.conf\
/etc/resolv.conf
</td>
<td class="confluenceTd">
/etc/nsswitch.conf\
getent
</td>
<td class="confluenceTd">
/etc/nsswitch.conf\
getent
</td>
</tr>
<tr>
<td class="confluenceTd">
**show network interface info**
</td>
<td class="confluenceTd">
ifconfig\
ethtool
</td>
<td class="confluenceTd">
dladm\
ndd\
ifconfig -a\
netstat -in\
</td>
<td class="confluenceTd">
dladm\
ndd\
ifconfig -a\
netstat -in\
</td>
</tr>
<tr>
<td class="confluenceTd">
**change IP**
</td>
<td class="confluenceTd">

</td>
<td class="confluenceTd">
*Joyent Public Cloud IP addresses are set in the* *[Cloud Management
Portal](http://my.joyentcloud.com).*\
ifconfig
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**ping one packet**
</td>
<td class="confluenceTd">
ping -c 1 *hostname*
</td>
<td class="confluenceTd">
ping *hostname* * packetsize 1*
</td>
<td class="confluenceTd">
ping *hostname packetsize* 1
</td>
</tr>
<tr>
<td class="confluenceTd">
**sniff network**
</td>
<td class="confluenceTd">
etherfind\
tcpdump\
wireshark (*formerly* \_ethereal)\
etherape
</td>
<td class="confluenceTd">
snoop
</td>
<td class="confluenceTd">
snoop\
tcpdump available from pkgin
</td>
</tr>
<tr>
<td class="confluenceTd">
**route definitions**
</td>
<td class="confluenceTd">
*route*\
*(rh) */etc/sysconfig/network\
*(rh) */etc/sysconfig/static-routes\
*(deb)* /etc/init.d/network\
*(deb)* /etc/network
</td>
<td class="confluenceTd">
/etc/defaultrouter\
/etc/notrouter\
/etc/gateways\
in.routed\
netstat -r\
route add
</td>
<td class="confluenceTd">
/etc/defaultrouter \
/etc/notrouter \
/etc/gateways \
in.routed \
netstat -r \
route add
</td>
</tr>
<tr>
<td class="confluenceTd">
**telnetd, ftpd banner**
</td>
<td class="confluenceTd">
/etc/issue.net *(telnet)*\
*(ftp varies; can use tcp wrappers)*
</td>
<td class="confluenceTd">
Use nc instead
</td>
<td class="confluenceTd">
Use nc instead
</td>
</tr>
<tr>
<td class="confluenceTd">
**set date/time**\
(from net: ntp or other)
</td>
<td class="confluenceTd">
ntpdate\
rdate\
netdate
</td>
<td class="confluenceTd">
ntpdate\
rdate
</td>
<td class="confluenceTd">
ntpdate\
rdate
</td>
</tr>
<tr>
<td class="confluenceTd">
**auditing**
</td>
<td class="confluenceTd">
auditd\
/var/log/faillog
</td>
<td class="confluenceTd">
audit\
auditd\
auditreduce\
praudit
</td>
<td class="confluenceTd">
audit\
auditd\
auditreduce\
praudit
</td>
</tr>
<tr>
<td class="confluenceTd">
**encrypted passwords in**
</td>
<td class="confluenceTd">
/etc/shadow *(may vary)*
</td>
<td class="confluenceTd">
/etc/shadow
</td>
<td class="confluenceTd">
/etc/shadow
</td>
</tr>
<tr>
<td class="confluenceTd">
**min password length**
</td>
<td class="confluenceTd">
/etc/pam.d/system-auth
</td>
<td class="confluenceTd">
/etc/default/passwd
</td>
<td class="confluenceTd">
/etc/default/passwd
</td>
</tr>
<tr>
<td class="confluenceTd">
**allow/deny root**\
**logins**
</td>
<td class="confluenceTd">
/etc/securetty\
</td>
<td class="confluenceTd">
/etc/default/login
</td>
<td class="confluenceTd">
/etc/default/login
</td>
</tr>
<tr>
<td class="confluenceTd">
**firewall config**
</td>
<td class="confluenceTd">
iptables\
ipchains\
ipfwadm\
*(rh)* redhat-config-\
securitylevel
</td>
<td class="confluenceTd">
/etc/ipf/ipf.conf
</td>
<td class="confluenceTd">
/etc/ipf/ipf.conf
</td>
</tr>
<tr>
<td class="confluenceTd">
**show installed software**
</td>
<td class="confluenceTd">
*(rh)* \_rpm -a -i\
*(rh)* \_rpm -qa \
*(rh)* yum list installed\
*(deb)* dselect\
*(deb)* aptitude\
*(deb)* dpkg -l\
*(gen)* \_ls /var/db/pkg/\*\
*(gen)* \_eix -I
</td>
<td class="confluenceTd">

</td>
<td class="confluenceTd">
pkgin list\
pkgin avail  *&lt;- list available installable software*
</td>
</tr>
<tr>
<td class="confluenceTd">
**add software**
</td>
<td class="confluenceTd">
*(rh)* \_rpm -hiv \
*(rh)* yum install *pkg*\
*(deb)* dselect\
*(deb) \_apt-get install \_pkg*\
*(deb)* dpkg -i\
</td>
<td class="confluenceTd">
\
</td>
<td class="confluenceTd">
pkgin install
</td>
</tr>
<tr>
<td class="confluenceTd">
precompiled binaries\* of GPLware and freeware\*
</td>
<td class="confluenceTd">
[www.linux.org](http://www.linux.org/)\
[linux.tucows.com](http://linux.tucows.com/)\
[sourceforge.net](http://sourceforge.net/)\
[rpmfind.net](http://rpmfind.net/)\
(deb) [ftp.debian.org](http://ftp.debian.org/)\
(deb) [packages.debian.org](http://packages.debian.org/)\
*(gen)* [packages.gentoo.org](http://packages.gentoo.org/)\
*(gen)* [gentoo-portage.com](http://gentoo-portage.com/);\
*(md)* [easyurpmi.zarb.org](http://easyurpmi.zarb.org/)
</td>
<td class="confluenceTd">
[www.sunfreeware.com](http://www.sunfreeware.com/)\
[www.blastwave.org](http://www.blastwave.org/)
</td>
<td class="confluenceTd">
<http://pkgsrc.joyent.com/>\
pkgin
</td>
</tr>
<tr>
<td class="confluenceTd">
**C compiler**
</td>
<td class="confluenceTd">
cc\
gcc
</td>
<td class="confluenceTd">
gcc\
\[https://download.joyent.com/pub/build/SunStudio.tar.bz2\]
</td>
<td class="confluenceTd">
gcc (may need to be installed via pkgin)\
[https://download.joyent.com/pub/build/SunStudio.tar.bz2](https://downlo
ad.joyent.com/pub/build/SunStudio.tar.bz2&nbsp)\
\
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
**configure/show **\
**runtime linking**\
\
</td>
<td class="confluenceTd">
ldconfig\
ldd\
readelf \
lsmod
</td>
<td class="confluenceTd">
crle\
ldd\
elfdump\
dump \
pldd\
modinfo\
LD\_PRELOAD
</td>
<td class="confluenceTd">
crle\
ldd\
elfdump\
dump\
readelf \
pldd\
modinfo\
LD\_PRELOAD
</td>
</tr>
<tr>
<td class="confluenceTd">
**link library path**
</td>
<td class="confluenceTd">
\$LD\_LIBRARY\_PATH\
/etc/ld.so.conf
</td>
<td class="confluenceTd">
\$LD\_LIBRARY\_PATH\
</td>
<td class="confluenceTd">
\$LD\_LIBRARY\_PATH
</td>
</tr>
<tr>
<td class="confluenceTd">
**tracing utility**
</td>
<td class="confluenceTd">
strace\
ltrace
</td>
<td class="confluenceTd">
dtrace\
truss\
sotruss\
</td>
<td class="confluenceTd">
dtrace\
truss\
sotruss
</td>
</tr>
<tr>
<td class="confluenceTd">
**define user defaults**
</td>
<td class="confluenceTd">
/etc/profile\
/etc/security/\
/etc/skel/\
/etc/profile.d/\*
</td>
<td class="confluenceTd">
/etc/default/login\
/etc/profile\
/etc/security/
</td>
<td class="confluenceTd">
/etc/default/login\
/etc/profile\
/etc/security/
</td>
</tr>
<tr>
<td class="confluenceTd">
**csh global .login**
</td>
<td class="confluenceTd">
/etc/csh.login
</td>
<td class="confluenceTd">
/etc/.login
</td>
<td class="confluenceTd">
/etc/.login
</td>
</tr>
<tr>
<td class="confluenceTd">
**default syslog and messages**
</td>
<td class="confluenceTd">
/var/log/syslog\
/var/log/messages\
/usr/adm/messages \
/var/log/maillog
</td>
<td class="confluenceTd">
/var/adm/messages\
/var/log/syslog\
[softpanorama.org/Logs/solaris\_logs.shtml](http://softpanorama.org/Logs
/solaris_logs.shtml)
</td>
<td class="confluenceTd">
/var/adm/messages\
/var/log/syslog
</td>
</tr>
<tr>
<td class="confluenceTd">
**system error reporting tool**
</td>
<td class="confluenceTd">
dmesg\_(deb)\_ reportbug
</td>
<td class="confluenceTd">
fmadm\
fmdump\
prtdiag
</td>
<td class="confluenceTd">
fmadm\
fmdump\
</td>
</tr>
<tr>
<td class="confluenceTd">
**performance monitoring**
</td>
<td class="confluenceTd">
vmstat\
procinfo -D\
top\
htop\
pstree
</td>
<td class="confluenceTd">
dtrace\
prstat\
sar\
ostat\
kstat\
mpstat\
netstat\
nfsstat\
vmstat\
lockstat\
plockstat \
ptree\
vfsstat\
intrstat\
</td>
<td class="confluenceTd">
dtrace\
prstat \
sar \
ostat \
kstat \
mpstat \
netstat \
nfsstat \
vmstat\
plockstat \
ptree \
vfsstat \
</td>
</tr>
<tr>
<td class="confluenceTd">
**match process to file or port**
</td>
<td class="confluenceTd">
lsof\
netstat -atup
</td>
<td class="confluenceTd">
fuser\
pfiles\
</td>
<td class="confluenceTd">
pfiles\
fuser\
lsof
</td>
</tr>
<tr>
<td class="confluenceTd">
**zones/containers**
</td>
<td class="confluenceTd">

</td>
<td class="confluenceTd">
zoneadm\
zonecfg\
zlogin
</td>
<td class="confluenceTd">
zoneadm\
zonename
</td>
</tr>
<tr>
<td class="confluenceTd">
**Virtualization**
</td>
<td class="confluenceTd">
kvm/qemu
</td>
<td class="confluenceTd">
kvm/qemu (each instance in a kvm branded zone)\
vmadm\
imgadm
</td>
<td class="confluenceTd">

</td>
</tr>
<tr>
<td class="confluenceTd">
[Wikipedia](http://en.wikipedia.org/wiki/Category:Unix_variants)
</td>
<td class="confluenceTd">
[Linux](http://en.wikipedia.org/wiki/Linux)\
</td>
<td class="confluenceTd">
[SmartOS](http://en.wikipedia.org/wiki/SmartOS)\
\
[Illumos](http://en.wikipedia.org/wiki/Illumos)
</td>
<td class="confluenceTd">
[SmartOS](http://en.wikipedia.org/wiki/SmartOS)\
[Illumos](http://en.wikipedia.org/wiki/Illumos)
</td>
</tr>
</tbody>
</table>

</div>

Examples of Different Use Context
=====================================

For example, here are some common Linux commands that work differently.

<div class="table-wrap">

  ----------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------
  Command   What's different on a Smart Machine
  --------- ------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------
  `df`      On most SmartOS image this is set up to use the GNU version.
 Use `/usr/bin/df` for the native version.

  `lsof`    SmartMachines use a different collection of tools to examine
 processes. See <span class="error">\[Examining processes and memory|\#p
rocmem||||||||||||\\||\]</span> later in this topic.

  `ping`    Returns whether a host responds or not. \
            Use `ping -s` to get a continuous response.

  `top`     `top` is available in `/opt/local/bin`, but `prstat -Z` prov
ides more zone aware (and more accurate) information than `top`.
  ----------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------

</div>

The [Rosetta Stone for Unix](http://bhami.com/rosetta.html) is a useful
resource to help you see how commands from the version of UNIX you
usually work with map to other versions of UNIX.

[]()Examining processes and memory
--------------------------------------

\
In older SmartOS images, these commands provide information about ports
and resources. Run these commands as root or with sudo.

Later images use the SmartMachine Tools Package.

<div class="table-wrap">

  ----------------------------------------------------------------------
------------------------------------------------------------------------
-------------------
  Command   Description
               Example
  --------- ------------------------------------------------------------
-------------- ---------------------------------------------------------
-------------------
  `pcp`     Displays the ports used by a process, or the processes that
use a port.    `/root/bin/pcp -p 80` displays all the processes that use
 port 80. \

               `/root/bin/pcp -P 28068` displays all the ports that proc
ess 28068 uses. \

               `/root/bin/pcp -a` displays port and process information
for all ports.

  `jinf`    Displays information about how your SmartMachine is using it
s resources.   `/root/bin/jinf -c` displays CPU usage information. \

               `/root/bin/jinf -m` displays memory usage information. \

               `/root/bin/jinf -s` displays swap usage information.
  ----------------------------------------------------------------------
------------------------------------------------------------------------
-------------------

</div>

SmartOS provides a suite of tools to examine processes. You can learn
more about them by looking at the `proc` man page.

<div class="table-wrap">

  ----------------------------------------------------------------------
-------------------------------------------
  Tool         Description
  ------------ ---------------------------------------------------------
-------------------------------------------
  `prstat`     This tool displays the active processes like `top` does o
n Linux systems. \
               `prstat -Z` will provide you with a summary of your Smart
Machine's status.

  `pgrep`      Returns a list of process IDs (PIDs) of processes that ma
tch a pattern or meet certain conditions.

  `pkill`      Kills the processes that match a pattern or meet certain
conditions.

  `pfiles`     Returns a list of all the open files that belong to a pro
cess.

  `pstack`     Displays a stack trace of the specified process

  `ptree`      Displays a process tree for all processes or a given proc
ess

  `ls /proc`   Lists the process IDs of all running processes.
  ----------------------------------------------------------------------
-------------------------------------------

</div>

You can combine the results of `pgrep` with the other proc tools. To
list all the files associated with http processes, use this command
instead of `lsof`:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .plain; .gutter: .false}
$ sudo pfiles $(pgrep http)
```

</div>

</div>

</div>

To limit the `prstat` display to http processes, use this command:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .plain; .gutter: .false}
$ prstat $(pgrep -d , http)
```

</div>

</div>

</div>

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
-------------------------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   If t
he `prstat` display changes your terminal settings, use the `reset` comm
and to return them to normal.
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
-------------------------------

</div>

The `vmstat`, `mpstat`, and `psrinfo` commands display processor and
memory statistics for the physical machine. Their output is not
generally useful to you as a SmartMachine operator.

Starting and stopping services
----------------------------------

On other systems, you may be used to starting and stopping servers by
using commands in `/etc/init.d`. SmartMachines use the Service
Management Facility (SMF) to do this. The `svcs` and `svcadm` commands
are the ones you will use most often. Some commands take a service
identifier called an FMRI. You can use the `svcs` command to list all of
the identifiers for a service.

<div class="table-wrap">

  Command                   Description
  ------------------------- --------------------------------------------
-------------------------
  `svcs`                    Lists all the enabled services
  `svcs -a`                 Lists all of the services, even those that a
re disabled or off line
  `svcadm enable apache`    Enable all of the processes with an `apache`
 FMRI
  `svcadm disable apache`   Disable all of the processes with an `apache
` FMRI
  `svcadm restart apache`   Restart all of the processes with an `apache
` FMRI

</div>

For example, if you make changes to `/etc/ssh/sshd_config`, restart SSH
like this:\

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .plain; .gutter: .false}
$ sudo svcadm restart ssh
```

</div>

</div>

</div>

</p>
<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
--------------------------------------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
For more information on SMF, see [this topic](Using%20the%20Service%20Ma
nagement%20Facility.html "Using the Service Management Facility").
  ---------------------------------------------------------------------
------------------------------------------------------------------------
--------------------------------------------------------------------

</div>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


