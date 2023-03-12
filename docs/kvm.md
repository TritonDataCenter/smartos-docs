# KVM

SmartOS includes the KVM kernel virtual machine manager, originally ported
from [Linux](https://www.linux-kvm.org/page/Main_Page). KVM supports most Intel
and AMD processors for running hardware based virtual machines.

In general, [Bhyve](bhyve) is preferred, but KVM has wider compatibility with
operating systems and is somewhat easier to use when building HVM images that
can run in either KVM or Bhyve.

## SmartOS: Virtualization with ZFS and KVM

[Article](http://lwn.net/SubscriberLink/459754/373db2317a9783b7/) from
LWN.net, an excellent deep dive for Linux users by Koen Vervloesem
concludes that: "For Linux users who were interested in these Solaris
technologies but wouldn't want to lose their favorite hypervisor KVM,
SmartOS and OpenIndiana are now able offer the best of both worlds."
