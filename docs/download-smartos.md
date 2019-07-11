# Download SmartOS

* [Download SmartOS ISO][download-iso] - For running in Virtual Box or VMware
* [Download SmartOS USB Image][download-usb] - For booting on real hardware
* [Download SmartOS VMWare VM][download-vmx] - Ready-made image for VMware.
  (Note: Do not use the first disk presented during disk selection (`c0t0d0`).
  This is the boot media and overwriting it will make the machine not boot
  anymore.

[download-iso]: https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest.iso
[download-usb]: https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest-USB.img.gz
[download-vmx]: https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest.vmwarevm.tar.gz

## Additional Downloads

* [Download SmartOS (Platform Archive)][platform] - Extract this to an
  existing USB to ["upgrade"][upgrade].

[platform]: https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/platform-latest.tgz
[upgrade]: remotely-upgrading-a-usb-key-based-deployment.md

## Helpful Links

* [All "latest" Downloads including MD5 Sums][latest]
* [All Releases, with Changelogs][changelog]

[latest]: https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/latest.html
[changelog]: http://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos.html

## Using These Images

Once you've downloaded an image, please read the [Getting Started with
SmartOS][getting-started] guide for information on getting up to speed
quickly and refer to one of the following pages applicable to your
preferred installation type:

[getting-started]: getting-started

* [Creating a SmartOS Bootable USB Key][create-usb]
* [SmartOS as a VMware Guest][vmware-guest]
* [SmartOS as a VirtualBox Guest][vbox-guest]
* [PXE Booting SmartOS][pxe]

[create-usb]: creating-a-smartos-bootable-usb-key.md
[vmware-guest]: smartos-as-a-vmware-guest.md
[vbox-guest]: smartos-as-a-virtualbox-guest.md
[pxe]: pxe-booting-smartos.md

### Understanding SmartOS Builds

There is a new build, on average, every 2 weeks. SmartOS builds do not
have a version number, rather they have a timestamp in the form:
20120809T221258Z (in this example, the date is: 08/09/2012 at 22:12:58
UTC)

For any given build, there will be 5 files available:

* **platform-*(timestamp)*.tgz**: The raw kernel and boot\_archive;
  this is most commonly used for PXE booting
* **smartos-*(timestamp)*.iso**: Live Image ISO
* **smartos-*(timestamp)*-usb.img.bz2**: Live Image USB image for booting
  real hardware. This is the preferred installation method for production
* **smartos-*(timestamp)*.vmwarevm.tar.bz2**: VMware Image (VMX Format)
  *Note: Make sure nested virtualization is enabled if you want to use
  KVM or BHYVE.*
* **SINGLE\_USER\_ROOT\_PASSWORD.*(timestamp)*.txt**: Contains the
  default root password for the live image (needed only when booting
  without mounting the zpool)

For a full list of changes in each build, please refer to the
[SmartOS Change Log][changelog].

## Accessing the Source

SmartOS source is freely available and can be accessed on [Github][github].

[github]: https://github.com/joyent/smartos-live

For more information on SmartOS Development, please refer to the
[SmartOS Developers Guide][dev-guide]

[dev-guide]: smartos-developers-guide.md
