#!/bin/bash
cd /var/tmp
curl -O --insecure https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/platform-latest.tgz
DEST=$(disklist -r)
mount -F pcfs /dev/dsk/${DEST}p1 /mnt
cd /mnt
tar xzf /var/tmp/platform-latest.tgz -C /mnt/
mkdir /mnt/$(uname -v | cut -d_ -f2)
mv /mnt/platform /mnt/$(uname -v | cut -d_ -f2)/
NEWDIR=$(ls /mnt|grep platform-|cut -f 2 -d"-")
mv /mnt/platform{-$NEWDIR,}
rm /var/tmp/platform-latest.tgz
