# Debugging SmartOS

Debugging issues with a system like SmartOS is a complex topic, but here you can
find some useful tips.

## Debugging a boot hang

If you find SmartOS hangs during boot, this could be due to a number of reasons.
If it's during kernel setup, though, you can use an NMI to drop into the kernel
debugger and inspect the state at the time of the hang.

In the boot loader menu, drop into:

```none
    2. [Esc]ape to loader prompt
```

then

```none
boot -kv -m verbose -B nmi=kmdb
```

When it hangs, trigger an NMI. For example, under KVM, this would be `virsh
inject-nmi smartos`. On metal, you can do this via IPMI.

Back on the console, you should have dropped into KMDB, and can get a backtrace:

```none
[0]> $C
fffffffffbc13e70 kmdb_enter+0xb()
fffffffffbc13ea0 debug_enter+0x59(fffffffff794d6d3)
fffffffffbc13ed0 apix`apic_nmi_intr+0x9e(0, fffffffffbc13f10)
fffffffffbc13f00 av_dispatch_nmivect+0x34(fffffffffbc13f10)
fffffffffbc13f10 nmiint+0x152()
...
```

Other commands such as `::stacks` and `::walk cpu | ::cpustack` might be useful
at this point.
