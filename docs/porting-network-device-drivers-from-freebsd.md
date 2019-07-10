# Porting Network Device Drivers from FreeBSD

**This is a work in progress from my attempt to port FreeBSD's BXE driver
to SmartOS.**

Please feel free to add missing pieces or correct anything.

## Correlations between FreeBSD to Illumos

| Purpose                                    | FreeBSD      | Illumos
| ------------------------------------------ | ------------ | --------------
| Standard Interface for loading/unloading   | device_if   | modctl
| Bus Interface                              | bus_if      | ddi / devops
| PCI Interface                              | pci_if      | pci/pcie

## On FreeBSD

* bus\_space\_read\_N (write N **Bytes**) -&gt; ddi\_getB (B in **Bits**)
* bus\_space\_write\_N (write N **Bytes**) -&gt; ddi\_putB (B in **Bits**)
  ie. bus\_space\_read\_4 -&gt; ddi\_get32\
* struct ifnet -&gt; ?

## Structures you need for Illumos GLDv3 Driver

* `cb_ops_t` (`ddi.h` - entry points for character device)
* `dev_ops_t` (`devops.h` - entry points for probe, attach, detach, reset,
  etc...)
* `mac_callbacks_t` (from `mac_provider.h`)
* `mac_register_t` (from `mac_provider.h`)

## Important types

* `ENUM mac_propid_t` ( `mac.h` included by `mac_provider.h` - MAC properties
  that can be read/set via `dladm` such as `LinkState`)
* `ENUM mac_capab_t` ( `mac_provider.h` - MAC capabilities such as `HCKSUM`,
  `LSO`, etc...)
