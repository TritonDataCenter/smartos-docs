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

"SmartOS/Triton" Specific Known issues

- SmartOS depends upon the hardware bios serial number in order to
  generate a UUID on boot; which is then assigned to a given compute
  node. (As displayed by the `sysinfo` command) In some rare cases,
  such as with the "Dell PowerEdge c6100" blade-type line of servers,
  the chassis sometimes incorrectly assigns the same serial number
  across all of the blades installed in the same unit. This can cause
  issues for some software such as "Triton Datacenter", "VMware ESXi",
  as well as others that directly rely on the chassis serial number to
  be entirely unique.

  In the case of "Triton Data Center" and the "Dell c6100", 1 compute
  node, will be properly detected by "cnapi" and consequently, the
  "Operator Portal", while the others will quietly PXE boot and never
  be detected by Triton. To determine if this is the cause of your
  issue, simply ssh into each of the compute nodes in question, and
  run: `sysinfo | json UUID`. If more than 1 compute node share the
  same UUID then this is probably the cause of the issue. You can
  also verify the serial number matches on each node with:

      `ipmitool fru print 0`

  you should receive output like the following:

   `Chassis Type          : Rack Mount Chassis
    Chassis Part Number   :    
    Chassis Serial        :          
    Board Mfg Date        : Wed Nov  7 02:43:00 2012
    Board Mfg             : Dell Inc.
    Board Product         : PowerEdge
    Board Serial          : CN0D61XP747512B60255A08
    Board Part Number     : 282BNP0616
    Product Manufacturer  : Dell Inc.
    Product Name          : C6100
    Product Part Number   :    
    Product Version       :    
    Product Serial        : DB3KYV1  
    Product Asset Tag`


  To work around the issue, you must set a unique serial number for
  each compute node using `ipmitool`. SmartOS compute nodes come with
  `ipmitool` preinstalled so this is as easy as:

  1. SSH to the affected compute node
  2. On your local machine, randomly generate, as unicast as possible,
  a new serial number. In my scenario I simply used `pwgen` on my Mac
  to generate a 7 digit, random, alpha-numeric string.
      `pwgen -sB 7 1`
  3. On each node run the following three commands:
      `ipmitool fru edit 0 field c 1 <NEW_SERIAL>`
      `ipmitool fru edit 0 field b 2 <NEW_SERIAL>`
      `ipmitool fru edit 0 field p 4 <NEW_SERIAL>`
  4. Double check that the new serial number has been set:
      `ipmitool fru print 0`
  5. Reboot the compute node, it should now be detected by Triton.
