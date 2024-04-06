# How to create an HVM zone

SmartOS has two different virtual machine monitors: [KVM](kvm.md) and
[Bhyve](bhyve.md), collectively referred to as **HVM**
(**H**ardware **V**irtual **M**achine) instances. There are differences with
the implementation, and each has its advantages, but for the most part,
operators manage them in almost exactly the same way. In most cases, Bhyve is
preferred.

## Creating HVM VMs

Before creating a new VM, an image must be imported.
VM images are ZFS zvol snapshots with a (typically)
freely-distributable operating system such as a Linux variant
pre-installed. Images are available through the imgadm tool. In most cases
VM images may be used with either Bhyve or KVM.

You will then be able to create instances using `vmadm`.

To list all available VM images:

    imgadm avail type=zvol

VM images will report the OS as "linux" or "bsd" and the TYPE as "zvol".
For most distributions there will be both HVM (zvol) and LX (lx-dataset) images
available.

"SmartOS" (zone-dataset) and LX (lx-dataset) images aren't appropriate for the
process being described here. These images cannot be used to create HVM's.

To list all local images installed in on your SmartOS host:

    imgadm list

To import an image, use the UUID of the image (from `imgadm avail`):

    imgadm import UUID

The image is now downloaded and installed at zones/UUID.

`vmadm` is a tool for fast provisioning all instance types. It
takes a json payload and clones an image into a working virtual machine.

To use `vmadm create` you must first start by creating your VM/zone
definition file, for instance copying this in to /tmp/myvmspec
(substituting the `image_uuid`, network information, and machine
dimensions that are appropriate):

This example sets the brand to `bhyve`, to create a Bhyve zone. To use
KVM, set the brand to `kvm`.

The first disk is always 10GB and comes from the image properties. Additional
disks should be used if more space is needed. In this example, a 25GB disk
is included. The second disk will usually be mounted at `/data`.

    {
      "brand": "bhyve",
      "resolvers": [
        "8.8.8.8",
        "8.8.4.4"
      ],
      "ram": "512",
      "vcpus": "1",
      "nics": [
        {
          "nic_tag": "admin",
          "ip": "10.33.33.33",
          "netmask": "255.255.255.0",
          "gateway": "10.33.33.1",
          "model": "virtio",
          "primary": true
        }
      ],
      "disks": [
        {
          "image_uuid": "3162a91e-8b5d-11e2-a78f-9780813f9142",
          "boot": true,
          "model": "virtio"
        },
        {
          "model": "virtio",
          "size": 25600
        }
      ]
    }

First, ensure you've imported the image you've specified in the vmspec
file. In the above example, you'd

    imgadm import 3162a91e-8b5d-11e2-a78f-9780813f9142

then simply

    vmadm create -f /tmp/myvmspec

and `vmadm` will respond with a status and your VM will be created and
booted.

Once you have created the VM with `vmadm create`, you can see your VM's
console.

    vmadm console <UUID>

<!--
For KVM, there is also a vnc server port available for each zone.

    # vmadm info <UUID> vnc
    {
      "vnc": {
        "host": "10.0.1.152",
        "port": 52922,
        "display": 47022
      }
    }

Connect to that VNC service with your local workstation's VNC viewer.
![VNC Session](attachments/755505/1146943.png)

Be aware that the VNC console service is NOT authenticated, and is intended
to run on a private network. Typically, your SmartOS machine won't have
its primary interface on the internet. Please be aware of what services
you're exposing, and apply firewall rules as necessary.

RealVNC VNC Viewer will crash when connecting unless you set FullColour to
True in the options.  On Windows make sure to go to Options, click Advanced,
go to the Expert tab and set FullColour to True.
-->

### Passing cloud-init data to the VM

SmartOS provides the ability to inject cloud-init data into a zone/VM.
This is useful for automating the menial tasks one would need to perform
manually like setting up users, installing packages, or pulling down a
git repo. Basically, anything you can stuff into cloud-init user-data is
at your disposal.

Since SmartOS zone definitions are in JSON and cloud-init data is in
yaml, it’s not immediately obvious how to supply this information.
Maintaining proper yaml indentation, escape all double-quotes (“) and
line-feeds.

Here’s an example cloud-init yaml file that creates a new user and
imports their ssh key from launchpad.net.

    #cloud-config

    users:
      - default
      - name: shaner
        ssh_import_id: shaner
        lock_passwd: false
        sudo: "ALL=(ALL) NOPASSWD:ALL"
        shell: /bin/bash

Here's what it would look like in our zone definition.

    "customer_metadata": {
        "cloud-init:user-data": "#cloud-config\n\nusers:\n  - default\n  - n
    ame: shaner\n    ssh_import_id: shaner\n    lock_passwd: false\n    sudo
    : \"ALL=(ALL) NOPASSWD:ALL\"\n    shell: /bin/bash"
      }

You can find more on cloud-init at
<https://cloudinit.readthedocs.io/en/latest/topics/examples.html>

### Passing SSH keys to the VM

If you don't want to deal with `cloud-init`, you can pass an SSH
public key to validate your connection with. Adjust your config to
contain a `customer_metadata` block:

<!-- markdownlint-disable line-length -->

    "customer_metadata": {
        "root_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8aQRt2JAgq6jpQOT5nukO8gI0Vst+EmBtwBz6gnRjQ4Jw8pERLlMAsa7jxmr5yzRA7Ji8M/kxGLbMHJnINdw/TBP1mCBJ49TjDpobzztGO9icro3337oyvXo5unyPTXIv5pal4hfvl6oZrMW9ghjG3MbIFphAUztzqx8BdwCG31BHUWNBdefRgP7TykD+KyhKrBEa427kAi8VpHU0+M9VBd212mhh8Dcqurq1kC/jLtf6VZDO8tu+XalWAIJcMxN3F3002nFmMLj5qi9EwgRzicndJ3U4PtZrD43GocxlT9M5XKcIXO/rYG4zfrnzXbLKEfabctxPMezGK7iwaOY7w== wooyay@houpla"
      }

<!-- markdownlint-enable line-length -->

### Granting the VM access to an entire physical disk

In general, using zvols and not dedicated disks for instance is almost always
preferred, however there are some circumstances where it may be useful to
access an entire raw disk from a VM. This will pass through a physical disk
to the HVM guest. In the `"disks"` section of your
[VM definition file](#creating-hvm-vms), add an object like this:

    {
      "boot": false,
      "nocreate": true,
      "model": "virtio",
      "media": "disk",
      "size": 5725225,
      "path": "/dev/dsk/c2t0d0"
    }

Note: The `"size"` value is in megabytes.
