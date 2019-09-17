# Running SmartOS on OmniOS KVM

<!-- markdownlint-disable no-trailing-punctuation -->
## Why would you do that?
<!-- markdownlint-enable no-trailing-punctuation -->

In all honestly, if you have the choice, don't! VMware Fusion /
Workstation / ESXi is a far better platform to run a SmartOS VM on.

In my case, I am away from home a lot and I do not have access to my
normal workstation. I do have a NAS running OmniOS which is on all the
time. I tried it before but always abandoned the idea. But I recently
got it to work with a few caveats.

## Caveats

- no complex cpu topology
  - passing `-smp 4` works
  - passing `-smp 4,sockets=1,cores=2,threads=2` makes illumos kernel barf
- no vioif
  - we're stuck with e1000 nic emulation which is not the fastest

## Setup

### Prerequisites

- OmniOS r151012
  - other versions should work too, but untested by me
- kvmadm
  - available in [obd](http://omnios.blackdot.be/en/index.shtml)
    repository (mostly to make things easier to manage)

### Adding the additional repository

    pfexec pkg set-publisher -g http://omnios.blackdot.be omnios.blackdot.be
    pfexec pkg refresh --full

### Installing required packages

    pfexec pkg install -nv system/kvm obd/system/kvmadm obd/system/kvmcon
    pfexec pkg install -v system/kvm obd/system/kvmadm obd/system/kvmcon

### Creating the VM with kvmadm

Substitude your own pool and paths below (my VM is called **muon**)

    pfexec create -o quota=25G core/vms/hosts/muon
    pfexec create -V 20G -o compression=lz4 core/vms/hosts/muon/disk0

`muon.json`

    {
       "muon" : {
          "nics" : [
             {
                "index" : "0",
                "over" : "trunk0",
                "nic_name" : "vmuon0",
                "model" : "e1000",
                "vlan_id" : "0"
             }
          ],
          "cpu_type" : "qemu64,+aes,+sse4.2,+sse4.1,+ssse3",
          "vnc" : "sock",
          "hpet" : "true",
          "disks" : [
             {
                "index" : "0",
                "disk_path" : "/vms/hosts/muon/smartos-latest.iso",
                "media": "cdrom",
                "model" : "ide"
             },
             {
                "index" : "1",
                "disk_path" : "core/vms/hosts/muon/disk0",
                "model" : "virtio"
             }
          ],
          "boot_order" : "dc",
          "shutdown" : "kill",
          "vcpus" : "4",
          "serials" : [
             {
                "index" : "0",
                "serial_name" : "console"
             }
          ],
          "cleanup" : "true",
          "ram" : "4096",
          "time_base" : "utc"
       }
    }

Import it

    pfexec kvmadm import /vms/hosts/muon/muon.json

### Getting networking to work in your zones

This is the real critical part, if you simple boot the VM as is, you
will have networking in SmartOS's Global Zone but networking in zones will
not work.

This is because a vnic only allows traffic form its MAC to make it up
the stack.

### Retrieve the mac from your recently created zone

If you have more than one NIC in a zone, make sure to get all the MACs.

#### SmartOS Global Zone

    vmadm get UUID | json nics | json -a mac

### Updating secondary-macs link property for your SmartOS VM

Make sure to include all MACs here.

#### OmniOS Global Zone

<!-- markdownlint-disable line-length -->

    pfexec dladm set-linkprop -p secondary-macs=aa:bb:cc:dd:ee:01,aa:bb:cc:dd:ee:02,aa:bb:cc:dd:ee:03,aa:bb:cc:dd:ee:04 vmuon0

<!-- markdownlint-enable line-length -->

Your zones should now have network connectivity.

### Managing the VM

Starting the VM

    pfexec svcadm enable svc:/system/kvm:muon

Stopping the VM

    pfexec svcadm disable svc:/system/kvm:muon

Connecting to the VGA console

    pfexec kvmcon vnc muon

Connecting to the Serial console

    pfexec kvmcon console muon

Connecting to the monitor console. Norm al there is no need to view this,
but it can be handy for debugging.

    pfexec kvmcon monitor muon
