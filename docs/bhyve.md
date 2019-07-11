# Bhyve

SmartOS includes the Bhyve virtual machine manager, originally ported
from [FreeBSD](https://wiki.freebsd.org/bhyve). Bhyve supports most Intel
and AMD processors for running hardware based virutal machines.

Bhyve offers a number of advantages over KVM, among them:

* Better tracking of, and ingegration wth, upstream FreeBSD
* Higher performance for CPU, and I/O operations (including disk and
  network I/O).
* Lower overhead, resulting in lower host CPU utilization while guests are
  idle.

Bhyve is fully supported and production ready.
