# How to create a Virtual Machine in SmartOS

First, it's important to understand how Hardware Virtual Machines work in
SmartOS.

Using Linux (KVM) or FreeBSD (bhyve), commonly `virt-install` is used to
create/install virtual machines. The `qemu` or `bhyve` command run in the same
security context as the rest of the system.

On SmartOS however, virtual machines are run inside a zone. This zone, in many
ways, resembels a native SmartOS zone, with some key differences.

* The zone is granted access to the vmm device, either `/dev/kvm` or
  `/dev/bhyve`, depending on the zone brand
* The zone has severely restricted capabilities. Processes in this zone are
  prevented from:
    * Modifying the filesystem
    * Accessing the network
    * Creating new processes
    * List processes, or get information about other processes
    * Sending signals to processes outside of its session group

The analogue for Linux and FreeBSD would be as though you're running `qemu`
in a container or `bhyve` in a jail (although without the restricted
environment described above). On Linux or FreeBSD you'd create the
container/jail, log into it and then execute `virt-install`. On SmartOS, these
details are abstracted away so that for most purposes the zone containing the
VM is almost invisible.

With that understanding, we can now create an instance capable of booting
from an ISO image.

## Getting Started

You will need

* The latest copy of SmartOS, available from
  <https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/smartos.html>
  (release details [here](download-smartos.md))
* The ISO of your OS of choice
* A VNC client

## The Machine JSON Description

Save the code snippet below to a file called "vmspec.json". You can make
changes to the networks and other variables as appropriate. This is by
no means an exhaustive list of all options. For all options see
[vmadm(8)](https://smartos.org/man/8/vmadm). (Sizes are listed in MiB)

**Note:** Creating images from scratch works best with KVM. KVM instances
provide a DHCP server for the guest, and a VNC endpoint for the operator.
Using Bhyve will work also, but networking must be configured manually and
the guest OS console must be on the first serial port.

When using this method to create new images, as long as the installed guest
can retrieve networking from [`customer_metadata`][mdata] and configure itself
non-interactively, the resulting image can be used with either KVM or bhyve,
regardless of which brand was used to create it.

The rest of this guid will assume KVM.

[mdata]: customer_metadata.md

This is an example JSON payload that can be used to create an empty KVM
instance. The `autoboot` property is set to `false` because this payload
does not yet provide a bootable media. It is important to note that this
instance is *not* cloned from an image.

    {
      "brand": "kvm",
      "vcpus": 1,
      "autoboot": false,
      "ram": 1024,
      "resolvers": ["208.67.222.222", "208.67.220.220"],
      "disks": [
        {
          "boot": true,
          "model": "virtio",
          "size": 40960
        }
      ],
      "nics": [
        {
          "nic_tag": "admin",
          "model": "virtio",
          "ip": "10.88.88.51",
          "netmask": "255.255.255.0",
          "gateway": "10.88.88.1",
          "primary": 1
        }
      ]
    }

**Note:** When installing an operating system that does not ship with `virtio`
support, set `model` to `ide` for disks and `e1000` for nics.

## Create the Empty Virtual Machine

Create the empty virtual machine using `vmadm`. Due to the `"autoboot": false`
setting, the machine will not be running.

Note the UUID printed after creation. This UUID is the ID of the VM and will
be used to reference it for the rest of its lifecycle.

    $ vmadm create < vmspec.json
    Successfully created VM b8ab5fc1-8576-45ef-bb51-9826b52a4651

## Copy your OS ISO to the zone

The path to the ISO image in the json is relative to the root of the zone that
will execute the `qemu` command, so you'll need to place the ISO image in the
root if the VM zone.

    cd /zones/b8ab5fc1-8576-45ef-bb51-9826b52a4651/root/
    curl -O http://mirrors.debian.com/path_to_an_iso/debian.iso

From the global zone perspective, place the file in the directory
`/zones/<instance_uuid>/root/`. From the perspective of the instance the ISO
will be referred to as `/<filename>.iso`.

## Boot the VM from the ISO Image

`vmadm` is the virtual machine administration tool. It is used to manage
the lifecycle of a virtual machine after it already exists. We will boot
the virtual machine we have just created, but tell it to boot off of the
ISO image the first time it comes up.

    vmadm boot b8ab5fc1-8576-45ef-bb51-9826b52a4651 order=cd,once=d cdrom=/image.iso,ide

**Note:** The path for the ISO image will be the relative path of the ISO to
the zone you are in. This is why it starts with the `/`.

If you are booting from an img file rather than an iso, this may not work.  
Instead try:

    vmadm boot b8ab5fc1-8576-45ef-bb51-9826b52a4651 disk=/debian.img,ide

## Use VNC to Connect to the VM

The `vmadm` tool can print out the information on the VM. You can also
append a section to print specificially.

    $ vmadm info b8ab5fc1-8576-45ef-bb51-9826b52a4651 vnc
    {
      "vnc": {
        "display": 39565,
        "port": 45465,
        "host": "10.99.99.7"
      }
    }

The IP printed will be the IP of the SmartOS global zone which brokers the
VNC connection to the VM. You should be able to connect to the reported VNC
port from your workstation.

Your VM is now running. You can shutdown your virtual machine and the ISO
will remain available to the zone. Typically at this point you would perform
the OS installation via the VNC console. When finished, if you are going to
create an image from this instance be sure to remove unique identifiers
such as the hostname, networking, and private keys that should be generated
by hosts as they boot the new image.

If the guest OS is Linux or Windows you will probably want to install the
[Triton VM Guest Tools][vm-tools]. For other operating systems you should be
able to compile the [mdata-client][md-client] for accessing
[`customer_metadata`][mdata].

[vm-tools]: https://github.com/TritonDataCenter/sdc-vmtools
[md-client]: https://github.com/TritonDataCenter/mdata-client
