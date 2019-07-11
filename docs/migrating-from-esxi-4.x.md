
# Migrating from ESXi 4.x

A simple step-by-step migration guide from a ESXi VMware to a SmartOS
KVM branded vm.

Disclaimer: the steps are developed based on advice from Orlando Vazquez
on the mailing list and refined with some trial and error.

## Getting stuff out of ESXi

This might be the most tricky part since the obvious choice, vCenter
Converter is a surprisingly bad one. Instead the trick is to use a
semi-secret tool:
[ovftool](http://communities.vmware.com/community/vmtn/server/vsphere/automationtools/ovf).
It is a command line tool, sadly it does not work directly on SmartOS,
for my tests I ran it on my laptop and it worked fine. The syntax is
about the following:

    ovftool vi://<your ESXi host>/<vm Name> <outfile>.vmx

## examples

### your host is vsphere.vmware.com and your VM is named wobble

    ovftool vi://vsphere.vmware.com/wobble wobble.vmx

### if wobble were in a pool named swimming

    ovftool vi://vsphere.vmware.com/swimming/wobble wobble.vmx

Now this will take a while, so sit back and relax, upside is it will
only copy the data really used be the VM. Once the program is through
you will get somethig like:

    # ls -l
    wobble.vmx wobble-disk1.vmdk

## And now for something completely different

Now comes the fun part, create the new VM. Look at
[How to create a Virtual Machine in SmartOS][create-vm]
for details. Only addition here: you need to create a disk with the
correct size for each .vmdk you want to import. You can double-check the
size of the virtual disk with qemu-img:

[create-vm]: how-to-create-a-virtual-machine-in-smartos.md

        qemu-img info -f vmdk <file>.vmdk

Once you run vmadm create, if you run `zfs list`  you will see something like
 `e0950735-dae5-481d-911a-80b14844759a` as the UUID of your VM.

   [root@SmartOs /zones]# zfs list
   ...
   zones/e0950735-dae5-481d-911a-80b14844759a        1.49M  10.0G  1.46M  /
   zones/e0950735-dae5-481d-911a-80b14844759a
   zones/e0950735-dae5-481d-911a-80b14844759a-disk0  40.7G   185G  20.1G  -
   ...

So what we must do now is put our vmdk file into the zfs zvol,
fortunately qemu-img comes to our help here, it allows writing our vmdk
directly to the disk we created. (thanks to nahamu for suggesting that).

**This does not work on all types of vmdk images!**

   [root@SmartOs /zones]# qemu-img convert -f vmdk -O host_device wobble-di
   sk1.vmdk /dev/zvol/rdsk/zones/e0950735-dae5-481d-911a-80b14844759a-disk0

You can boot your VM now and should see your migrated data as if it were
never somewhere else.

## Final words

If you have more then one disk just repeat the steps for each disk. Also
be aware that the image will use the full size and not sparse.
