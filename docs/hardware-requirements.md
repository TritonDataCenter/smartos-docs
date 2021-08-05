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

### illumos

There are a few known hardware related issues with illumos.

- There have been several issues with Intel CPUs regarding
  their C-States. SmartOS has worked around them, but you should
  consider disabling them in your BIOS.

### SmartOS and Triton Datacenter

- SmartOS depends upon the hardware bios serial number in order to
  generate a system UUID on boot. This UUID can be displayed using the
  `sysinfo` command. In some rare cases, such as with "Dell PowerEdge
  c6100" blade-type servers, the main chassis can incorrectly assign the
  same serial number across all of the blades installed in the same unit.
  This can affect the behavior of some software, such as "Triton
  Datacenter" (SDC). Triton directly relies on the UUID extracted from
  the chassis serial number by SmartOS to be entirely unique in order
  for it to detect a new compute node prior to setup.

### Example Scenario

In the case of "Triton Data Center" and the aforementioned, "Dell
c6100" chassis, 1 compute node (blade/sled), will be properly detected
by "cnapi" and consequently, the "Operator Portal" on boot, while the
other 3 quietly PXE boot without detection by Triton. To determine if
a duplicate server UUID is the cause of your issue, simply ssh into
each of the compute nodes in question, and run: `sysinfo | json UUID`.
If more than 1 compute node share the same UUID, then a duplicate
serial number is likely the cause of the issue. You can also verify
the duplicate serial numbers on each node with the following:

`ipmitool fru print 0`

  You should receive output resembling this:  

    Chassis Type          : Rack Mount Chassis
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
    Product Asset Tag:

  To work around the issue, you must set a unique serial number for
  each compute node using `ipmitool`. SmartOS compute nodes come with
  `ipmitool` preinstalled so this is as easy as:

- SSH to each affected compute node.
- On your local desktop, randomly generate, as unique as possible,
  a new serial number. In my scenario I simply used `pwgen` on my Mac
  to generate a 7 digit, random, alpha-numeric string. But you can
  probably use "/dev/urandom", python, openssl or a myriad of other
  tools to achieve the same result.  
    `pwgen -sB 7 1`
- On each node run the following three commands:  

    ipmitool fru edit 0 field c 1 <NEW_SERIAL>  
    ipmitool fru edit 0 field b 2 <NEW_SERIAL>  
    ipmitool fru edit 0 field p 4 <NEW_SERIAL>

      _Note: To update the serial number, each of the above command's
      must be executed on each compute node using the respective new
      "serial number"._  

- Double check that the new serial number has been set:  
    ipmitool fru print 0  
- Reboot the compute node.  

  The compute node should now be properly detected by Triton.
