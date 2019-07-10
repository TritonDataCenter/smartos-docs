# Spice on SmartOS

<!-- markdownlint-disable no-trailing-punctuation -->

## Not Supported by Joyent

This is an experimental feature. It i s **not** supported by Joyent, or
anyone else for that matter. Also note that work on this project has mostly
stopped.  If anything bad happens to you from following any of the
instructions on this page, it is your own fault.

## What is Spice?

The best reference is the [spice project website](http://spice-space.org),
but the easy way to think about it is like this: Spice is like VNC, but
with better performance (like streaming video) and with sound.

## How do I get it?

To run spice enabled VMs you need to be running the SmartOS release from
20120504 or later (using the latest release is generally recommended.)\
You can either download the sample dataset, or build your own.

### Where to download

QEMU images are available in the <http://datasets.shalman.org/datasets>
repository.

The latest QEMU image was uploaded on May 26, 2014. It can be imported
like so:

    imgadm sources -a http://datasets.shalman.org/datasets -t dsapi
    imgadm avail | grep QEMU
    UUID=3ff5a554-e4ed-11e3-820d-33b5e236480b
    imgadm import $UUID
    echo "Use $UUID as the image_uuid for your KVM VMs"

### How to build

Build last tested on the base64-13.3.0 image.

1. [Automatic build tools](https://github.com/nshalman/qemu-smartos-build)
   (with some instructions)
   1. Import base64-13.3.0 dataset
   2. Create a zone with the base64-13.3.0 dataset with `delegate_dataset` set
      to true
   3. zlogin into the zone
   4. Run the installer

zone json

    {
      "alias": "spice-build",
      "hostname": "spice-build",
      "zonename": "spice-build",
      "brand": "joyent",
      "max_physical_memory": 2048,
      "image_uuid": "87b9f4ac-5385-11e3-a304-fb868b82fe10",
      "delegate_dataset": true,
      "zfs_data_compression" : "on",
      "resolvers": ["8.8.8.8","8.8.4.4"],
      "nics": [
        {
          "nic_tag": "admin",
          "ip": "dhcp"
        }
      ]
    }

login and install

<!-- markdownlint-disable line-length -->

    zlogin spice-build
    curl -k https://raw.github.com/nshalman/qemu-smartos-build/master/full-build | bash

<!-- markdownlint-enable line-length -->

From the global zone you can then install your freshly built image for
use:

    cd /zones/spice-build/root/qemu-smartos-build/<uuid of built image>/
    imgadm install -m spice*.manifest -f spice*.zfs.bz2

## How do I use it?

### Client Software

Linux and Windows client software can be found in the "Client" section
of this page: [SPICE - Download](http://spice-space.org/download.html)

There is a new alpha/beta quality build for Mac OS available as well.
There is
[documentation for the MacOS client](http://spice-space.org/page/OSX_Client)
and a place to
[download the latest version](http://people.freedesktop.org/~teuf/spice-gtk-osx/dmg/)
of it.

I've heard that it's decent on recent versions of MacOS (it won't run on
my old snow leopard machine).

### VM Configuration

#### A word about `spice_port`s

Make sure to use a different port for each VM. Otherwise vmadmd will crash.

Note the `image_uuid`, `spice_port`, `vga`, and `qemu_extra_opts`
properties:

    {
      "alias": "myspicevm",
      "hostname": "myspicevm",
      "brand": "kvm",
      "ram": 4096,
      "image_uuid": "3ff5a554-e4ed-11e3-820d-33b5e236480b",
      "spice_port": 5930,
      "vga": "qxl",
      "vcpus": 2,
      "qemu_extra_opts": "-soundhw ac97 -device virtio-serial-pci -device vi
    rtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spic
    evmc,id=spicechannel0,name=vdagent",
      "disks": [
        {
          "boot": true,
          "model": "virtio",
          "size": 30720
        }
      ],
      "nics": [
        {
          "nic_tag": "admin",
          "model": "virtio",
          "ip": "dhcp",
          "primary": 1
        }
      ]
    }

#### Windows

For Windows you'll need to refer back to the Spice website for spice
drivers.

#### Fedora

For Fedora you'll need to make sure that your vm has the
"xorg-x11-drv-qxl" and "spice-vdagent" packages installed.

##### Sample VM

1  Create the VM as above
2  vmadm stop &lt;uuid&gt;
3  cd /zones/&lt;uuid&gt;/root
4  wget <http://mirror.pnl.gov/fedora/linux/releases/20/Fedora/x86_64/os/images/boot.iso>
5. vmadm boot &lt;uuid&gt; order=cd,once=d cdrom=/boot.iso,ide
6. Use your spice client to connect to the VM
7. When the CD boots, hit tab, and type append (without
   quotation marks) "ks=<http://www.shalman.org/spice/fedora20.ks>"
8. choose your timezone
9. let Fedora install
10. click through the firstboot stuff
11. log in with your user
12. click the Fedora icon and start typing google-chrome so that you can
    launch chrome
13. go to youtube and watch a video on your VM with sound and what is
    currently almost acceptable performance (I'm not sure why there has
    been a degradation lately)

### Client Invocation

Linux:

    remote-viewer spice://<smartos host>:<spice port from vm config>

Windows (and presumably MacOS as well) launch remote viewer and enter the
spice URI:

    spice://<smartos host>:<spice port from vm config>

### Tested Guest OSes

- Windows XP (tested by Nahum)
- Windows 7 (tested by Nahum)
- Fedora 16, 17, 18, 19, 20 (tested by Nahum)

### Tested Client OSes

- Windows 7 (tested by Nahum using Remote Viewer from the
  virt-viewer-x64-0.5.6.msi installer)
- Fedora 18 (tested by Nahum using remote-viewer from
  virt-viewer 0.5.4-3.fc18.x86\_64)

## Roadmap

Current state: Better-than-Beta Quality (running in production by
experts)

- SmartOS has native support in vmadm(d) for spice-enabled VMs.
- Possible to build a version of qemu (currently based on QEMU 1.1.2)
  patched to compile on illumos/smartos
- usbredir support added to the qemu build
- spice dependencies packaged by pkgsrc and integrated into joyent
  pkgsrc tree, and regularly updated.
- QEMU-KVM improvements merged into QEMU tree
- qxl-4 virtual hardware backported from a newer QEMU
  <https://github.com/nshalman/qemu/commit/3c33a8883bb9d870202113afeb43096872a0e1d8>
- bardiche patches applied

Next Steps:

- Rebase to latest QEMU
- When [spice-html5](http://www.spice-space.org/page/Html5) is good
  enough, integrate Spice features into [Project FiFo](https://project-fifo.net)
- When Xorg packages in pkgsrc get good enough, get
  [Xspice](http://www.spice-space.org/page/Features/Xspice) into
  pkgsrc and document usage.

Pie-in-the-sky possibilites:

- Get illumos patches into upstream qemu mainline tree
- SmartOS switches to a stable qemu build (post 1.0) based on upstream
  that includes illumos support
- Add dtrace probes to the spice codebase

## How can I help?

- Test the MacOS client and update this page with your results.

## I have other questions

Please put your questions in this section for now.\
I will try to address them and update this page to answer them.

1. Your Question Here

## Known Bugs:

- If the 3ff5a554-e4ed-11e3-820d-33b5e236480b image is used without
  setting "vga":"qxl", qemu will fail to boot. This is probably a bug
  in some of the assumptions my startvm.zone script makes... (Reported
  on IRC by "GS" and confirmed by Nahum)
