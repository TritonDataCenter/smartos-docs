# SmartOS as a UTM Guest on Apple Silicon

## Detailed Guide

Currently installing SmartOS on UTM with Apple Silicon is not stable.
If you are new to SmartOS and want to try in a VM, it would be best to try this
on a host with x86_64 architecture (Intel/AMD).
The instructions here are intended for testing and development use cases.

Issues users have encountered include long boot times and failure to create
zones once installed.
A recent test took approximately 15 minutes from boot menu to install screen
enabling multicore roughly halves the boot time.

1. Download and verify the latest SmartOS iso image from the [downloads page](https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/latest.html)
1. In UTM, click "Create a New Virtual Machine"
1. Select "Emulate"
1. Select "Linux"
1. Under "Boot ISO Image" choose the image you downloaded

### Settings

- Architecture: x86_64
- System: Standard PC (Q35 + ICH, 2009)(alias of pc-q35.72)(q35)
- Memory: 2048(?)+
- CPU: Haswell (others may work)
- CPU Cores: Default
- Drive size: 25 GB
- Shared Directory: leave this disabled
- Name: SmartOS (or your choice)
- Check the box "Open VM Settings"

### System tab

- Check Force Multicore

![UTM Settings Tab](/assets/images/smartos-utm-system-tab.png)

### QEMU tab

- Check Debug Logging (will be useful on diagnosing issues)
- Uncheck UEFI Boot
- Uncheck RNG Device

![UTM QEMU Tab](/assets/images/smartos-utm-qemu-tab.png)

### Input tab

- USB Support: Disabled

![UTM Input Tab](/assets/images/smartos-utm-input-tab.png)

### Network tab

- Network Mode: Bridged (Advanced)
- Emulated Network Card: Intel Gigabit Ethernet (e1000)

![UTM Network Tab](/assets/images/smartos-utm-network-tab.png)

### Installation

Install SmartOS following the [normal installation process](/install/)
