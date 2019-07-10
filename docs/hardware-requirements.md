# Hardware Requirements

## General Requirements

If you want to run production-grade SmartOS on hardware that we know works, READ[THIS](http://www.listbox.com/member/archive/184463/2013/02/sort/time_rev/page/1/entry/5:161/20130218134633:82C0ABBC-79FB-11E2-B214-A90A0365DAE4/).

### CPU

SmartOS requires a 64-bit capable x86 Intel or AMD CPU. If you would
like to use KVM, please see the section on KVM Requirements.

### DRAM

At a minimum, SmartOS require 512 MB of DRAM. We suggest putting as much
DRAM into the box as possible.

### Networking Cards, Disk controllers, and other Peripherals

SmartOS requires at least one networking interface and a supported disk
controller. For a full list of supported onboard and PCI devices, check
out the [illumos HCL](http://illumos.org/hcl).

### KVM Requirements

KVM is currently supported on Intel processors that have both
Virtualization Technology eXtensions (**VT-x**) and Extended Page Tables
(**EPT** a.k.a. Intel VT-X with Extended Page Tables). EPT was first
introduced with the Nehalem line of processors. As a rule of thumb this
translates out to the following brand names:

- Xeon E3, E5, E7
- Xeon 54XX, 55XX, 56XX, 74XX, 75XX, 76XX
- Some models of the Xeon 34XX, 35XX, and 36XX
- Some Core i3, i5, and i7
- Most newer Sandy Bridge and Ivy Bridge Desktop Pentium and
    Celeron processors.

For a full list of microprocessors that support EPT, please consult the
[Intel list](http://ark.intel.com/Products/VirtualizationTechnology).

### AMD and non-EPT processors

Support for AMD processors and Intel processors without EPT support is
in development for the broader community. Josh Clulow is working on it
[here](https://github.com/jclulow/illumos-kvm/).

This version of the kvm driver is not currently supported.

There are "community" [eait-Images](http://imgapi.uqcloud.net/builds)
built by arekinath that include that code and do have AMD support.\
You can help test these images so that AMD support can eventually be
merged upstream.

### Known Issues

There are a few known hardware related issues with illumos.

- There have been several issues with Intel CPUs regarding
  their C-States. SmartOS has worked around them, but you should
  consider disabling them in your BIOS.
