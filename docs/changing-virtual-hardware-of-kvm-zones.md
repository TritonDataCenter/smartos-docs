# Changing virtual hardware of KVM zones

The method for updating things like ram and vcpus using vmadm is
different for KVM zones than for SmartOS zones. The json input is not
required and will fail silently. Instead use vmadm directly:

## Updating vcpus

    vmadm update <zone id> vcpus=4

## Updating ram

    vmadm update <zone id> ram=4096

(where the units of the RAM argument are megabytes)
