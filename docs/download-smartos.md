# Download SmartOS

## Latest Release

* [ISO Image][download-iso] - For running in Virtual Box, VMware,
  or booting hardware from read-only media.
* [USB Image][download-usb] - For booting on real hardware
  using read/write media.
* [VMware VM Image][download-vmx] - Ready-made image for VMware.
  (Note: Do not use the first disk presented during disk selection (`c0t0d0`).
  This is the boot media and overwriting it will make the machine not boot
  anymore).
* [Platform Archive][download-pi] - Platform image only. This
  is not a bootable media, but can be extracted to existing bootable
  media such as a USB drive or a PXE server.
* [View a list of all objects for the latest release][latest] - This includes
  everything above, plus things like the build environment, build log,
  default root password, etc.

If you already have SmartOS installed, see [Upgrading SmartOS][upgrade].

[download-iso]: https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/smartos-latest.iso
[download-usb]: https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/smartos-latest-USB.img.gz
[download-vmx]: https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/smartos-latest.vmwarevm.tar.gz
[download-pi]: https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/platform-latest.tgz
[upgrade]: remotely-upgrading-a-usb-key-based-deployment.md
[latest]: https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/latest.html

## Additional Downloads

* [All SmartOS releases][releases]

[releases]: https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/smartos.html

## Using These Images

Once you've downloaded an image, please read the [Quick Start][qs] and
[Getting Started][getting-started] guides for information on getting up to speed
quickly and refer to one of the following pages applicable to your preferred
installation type:

[getting-started]: getting-started-with-smartos.md
[qs]: smartos-quick-start-guide.md

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

* `platform-*(timestamp)*.tgz`: The raw kernel and boot\_archive;
  this is most commonly used for PXE booting
* `smartos-*(timestamp)*.iso`: Live Image ISO
* `smartos-*(timestamp)*-usb.img.bz2`: Live Image USB image for booting
  real hardware. This is the preferred installation method for production
* `smartos-*(timestamp)*.vmwarevm.tar.bz2`: VMware Image (VMX Format)
  *Note: Make sure nested virtualization is enabled if you want to use
  KVM or BHYVE.*
* `SINGLE_USER_ROOT_PASSWORD.*(timestamp)*.txt`: Contains the
  default root password for the live image (needed only when booting
  without mounting the zpool)

For a full list of changes in each build, please refer to the
[SmartOS Change Log][changelog].

[changelog]: https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/smartos.html

## Accessing the Source

SmartOS source is freely available and can be accessed on [Github][github].

[github]: https://github.com/TritonDataCenter/smartos-live

For more information on SmartOS Development, please refer to the
[SmartOS Developers Guide][dev-guide]

[dev-guide]: smartos-developers-guide.md
