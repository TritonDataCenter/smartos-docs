# Persistent Configuration for the Global Zone

The Global Zone is non-persistent.  It is booted from a ramdisk on each
system boot.  This ramdisk may be loaded from local bootable media (USB
key, CDROM, etc) or from the network (PXE, etc.).

There are some exceptions to the non-persistence.  You can configure
certain persistent settings in /usbkey.  They are applied on reboot.

## Contents of /usbkey

There are a few configuration files and folders in /usbkey.

1. [/usbkey/config - system configuration options](extra-configuration-options.md)
2. /usbkey/config.inc/ - a directory where certain files referenced by
   /usbkey/config will reside (not present by default)
3. /usbkey/shadow - the shadow password file that will be put in
   /etc/shadow (read-only) on system boot
4. /usbkey/ssh/ - a directory containing the SSH client and server
   configuration (deployed to /etc/ssh/ on system boot)
   1. /usbkey/ssh/sshd\_config is in here so if you want to do things
       like require MFA or refuse Password login, you change it here
       and reboot
