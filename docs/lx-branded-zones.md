# LX Branded Zones

SmartOS can run Linux containers directly, without the need for a virtual
machine. These are known in SmartOS as LX brand zones. LX Brand Zones run using
the illumos kernel, not the Linux kernel, so while almost all user-land programs
behave correctly, some kernel interfaces will not be present. If you need
kernel facilities not present (e.g., nested containers, or iptables control,
etc.) it is recommended that you instead use a [VM](how-to-create-an-hvm-zone)
instead.

If you don't need extra kernel facilities, you may find that LX brand zones
offer benefits not found elsewhere.

LX Brand zones:

* are more secure than running Linux containers on Linux
* execute faster than running Linux Containers in a virtual machine
* have access to SmartOS platform commands

## Creating LX Brand Zones

As with other instance types, before creating a new instance an image must be
imported. LX images are ZFS datasets created from Linux Container images.
Images are available through the `imgadm` tool.

You will then be able to create instances using `vmadm`.

To list all available LX brand images:

    imgadm avail type=lx-dataset

LX Brand images will report the OS as "linux" and the TYPE as "lx-dataset".
For most distributions there will be both LX (lx-dataset) and HVM (zvol) images
available.

"SmartOS" (zone-dataset) and HVM (zvol) images aren't appropriate for the
process being described here. These images cannot be used to create LX
instances.

To list all installed images installed in on your SmartOS host:

    imgadm list

To import an image, use the UUID of the image (from `imgadm avail`):

    imgadm import UUID

The image is now downloaded and installed at zones/UUID.

`vmadm` is a tool for fast provisioning all instance types. It
takes a json payload and clones an image into a working virtual machine.

To use `vmadm create` you must first start by creating your VM/zone
definition file, for instance copying this in to `/tmp/myvmspec`
(substituting the `image_uuid`, network information, and machine
dimensions that are appropriate):

<!-- markdownlint-disable no-inline-html -->
<script src="https://tritondatacenter.github.io/emgithub/embed-v2.js?target=https%3A%2F%2Fgithub.com%2Fbahamat%2Fsmartos-flair%2Fblob%2Fmaster%2Ftemplates%2Fdebian-lx.json&style=default&type=code&showBorder=on&showLineNumbers=on&showFileMeta=on&showCopy=on"></script>
<!-- markdownlint-enable no-inline-html -->

**Note:** The `kernel_version` parameter in the manifest is simply passed to
`uname`. It has no affect on the behavior of the system.

Having already imported the image you can then simply run

    vmadm create -f /tmp/myvmspec

and `vmadm` will respond with a status and your VM will be created and
booted.

Once you have created the VM with `vmadm create`, you log into your instance.
This will spawn a shell as the `root` user in your instance.

    zlogin <uuid>

### Platform Version

As new distro versions are released, they may require a later platform image.
Each lx-dataset image will list a minimum `platform_image`. Platforms older
than the specified image will not be able to run instances using that image.

## Cool Tech Demos

A selection of impressive demonstrations of the LX brand's capabilities.
Please add your favorites here.

### Show your friends

* X11 forwarded [Firefox](http://i.imgur.com/SkHLlxs.png) and
  [Thunderbird](http://i.imgur.com/hd0Spyc.png) in lx32 zone
* Plex Media Server usable on lx32 and lx64
* dtrace a linux binary
<!--
* [Video of docker in Triton](https://www.tritondatacenter.com/developers/videos/docker-and-the-future-of-containers-in-production)
-->

#### Enabling IPv6 SLAAC auto configuration

Add `addrconf` to the `ips` array for the NIC to perform SLAAC and/or
DHCPv6 as appropriate. You may also need to manually run
`/native/usr/lib/inet/in.ndpd`.

## Development

See [LX Brand Devleopment](lx-dev.md) for information about developing and/or
debugging LX support.
