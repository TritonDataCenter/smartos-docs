# Enlarging a Windows 7 VM Disk

Let's say you setup a Windows 7 virtual machine, then by the time you've
installed all the software on it, you're running low on disk space
inside the virtual machine. ZFS makes it easy to increase the size of
disk allocated to the Windows vm.

Caution: this action might cause Windows to require activation again.

1. Shut down the virtual machine from within the Windows guest
2. Find the name of the zvol that is being used as the root disk
   This will be `zones/uuid-diskN` for KVM or `zones/uuid/diskN` for bhyve.
3. Check the current size with 'zfs get volsize'

        [root@00-19-99-b6-fa-12 ~]# zfs get volsize zones/708c73e3-48f2-4da5-a0a6-e161215a4215-disk0
        NAME                                              PROPERTY  VALUE   SOURCE
        zones/708c73e3-48f2-4da5-a0a6-e161215a4215-disk0  volsize   60G     local
        [root@00-19-99-b6-fa-12 ~]#

   In this case we can see that the disk is setup with a volume size of
   60 gigabytes, which Windows takes as the size of the disk.
4. Set the volsize to some larger value (in this case 65 gigabytes):

        zfs set volsize=65g zones/708c73e3-48f2-4da5-a0a6-e161215a4215-disk0

<!-- -->

1. Start the virtual machine using vmadm

        vmadm start 708c73e3-48f2-4da5-a0a6-e161215a4215

2. Connect to the virtual machine using either vnc or rdp (if you have
   already configured Windows for remote access).
3. Login to the Windows guest using an account that has
   administrative privileges.
4. Find the "Computer" icon in the start menu, right-click on it, and
   select **Manage**
5. In the left-hand panel, click on **Disk Management**. In the lower
   right panel, you should see a partition table for "Disk0", showing
   your additional space as "Unallocated".
6. Right-click on the "C:" volume (either in the upper or lower panel)
   and select **Extend Volume**.
7. The 'Extend Volume' wizard will appear. Click **Next**.
8. The default action is to add all the new space to your
   'C:' partition. This is likely what you want, so click **Next**, and
   then click **Finish**.
9. Close the 'Computer Management' window by clicking on the 'x'.

You should now see that your hard drive has expanded.
