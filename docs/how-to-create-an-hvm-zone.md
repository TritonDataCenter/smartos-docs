# How to create a HVM VM

SmartOS has two different virtual machine monitors. [KVM][kvm.md] and
[Bhyve.md], collectively reffered to as **HVM**
(**H**ardware **V**irtual **M**achine)
instances. There are differences with the
implementation, and each has it's advantages, but for the most part,

## Creating HVM VMs

Before creating a new KVM VM, a zone template image must be imported.
KVM templates are ZFS zvol snapshots with a (typically)
freely-distributable operating system such as a Linux variant
pre-installed. Images are available through the imgadm tool.

You will then be able to create and install zones and virtual machines
using `vmadm create`.

To list all available KVM images from Joyent:

    imgadm avail type=zvol

Note that KVM images usually say something like "linux" or "bsd" in the
"OS" column of this output and "zvol" as the "TYPE".

"smartos" images (zone templates) and images with "LX" in their names
(datasets for use with LX-branded zones) aren't appropriate for the
process being described here. These images cannot be used to create KVM VM's.

To list all local images installed in on your SmartOS host:

    imgadm list

To import an image from Joyent, use the UUID of the image (from
`imgadm avail`):

    imgadm import UUID

The image is now downloaded and installed at zones/UUID.

`vmadm create` is a tool for fast provisioning of zones and KVM VMs; it
takes a json payload and clones an image into a working virtual machine.

To use `vmadm create` you must first start by creating your VM/zone
definition file, for instance copying this in to /tmp/myvmspec
(substituting the image\_uuid, network information, and machine
dimensions that are appropriate):

This example sets the brand to `kvm`, to create a KVM zone. To use
Bhyve, set the brand to `bhyve`.

    {
      "brand": "kvm",
      "resolvers": [
        "208.67.222.222",
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

For images provide by Joyent, you can simply use

    zlogin <UUID>

For KVM, there is also a vnc server port available for each zone.

    # vmadm info <UUID> vnc
    {
      "vnc": {
        "host": "10.0.1.152",
        "port": 52922,
        "display": 47022
      }
    }

Connect to that VNC service with your local workstation's VNC
viewer.
![VNC Session](attachments/755505/1146943.png)

Be aware that the VNC console service is NOT authenticated, and is intended
to run on a private network. Typically, your SmartOS machine won't have
it's primary interface on the internet. Please be aware of what services
you're exposing, and apply firewall rules as necessary.

RealVNC VNC Viewer will crash when connecting unless you set FullColour to
True in the options.  On Windows make sure to go to Options, click Adva
nced, go to the Expert tab and set FullColour to True.

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
