+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Booting SmartOS from
GRUB2 </span>

</div>

<div class="pagesubheading">

This page last changed on Dec 07, 2015 by
<font color="#0050B2">nahamu</font>.

</div>

<div>

<ul>
<li>
[Why?](#BootingSmartOSfromGRUB2-Why%3F)
</li>
<li>
[How?](#BootingSmartOSfromGRUB2-How%3F)
</li>
- [From the ISO](#BootingSmartOSfromGRUB2-FromtheISO)
- [From the platform
    tarball](#BootingSmartOSfromGRUB2-Fromtheplatformtarball)

</ul>

</div>

Why?
========

Someone asked on the mailing list (read through [this
message](http://www.listbox.com/member/archive/184463/20151202143056:335
30B9A-992B-11E5-A6E6-D9B5A4355D94/))

In more detail, what if you have a multi-boot system that already has
just about any flavour of Linux on it? Nowadays, they pretty much all
boot out of [grub2.](https://www.gnu.org/software/grub/) You want to
*continue* to multiboot, but also have SmartOS as one of your boot
options. At the same time, you don't want to install the SmartOS grub
bootloader, because that will override all of your existing
configurations.

So how do you take an existing grub2 bootloader, and make SmartOS an
<ins>additional</ins> boot option?

How?
========

This page assumes you generally know what you're doing with GRUB2 and
already have something booting with it and for some reason want it to
boot SmartOS too.

### From the ISO

Since the SmartOS philosophy is too boot from immutable, read-only media
as much of the time as possible, this how-to will assume that you will
do so as well here. The end of this document also describes the
(not-recommended) alternate way.

1.  Place the downloaded SmartOS iso on a partition that can be read by
    the bootloader. You have a number of options for this:
    1.  Use an existing Linux /boot partition, since it already must be
        readable by grub2.
    2.  Use an existing Linux / or data partition, assuming it is
        readable by grub2. In older days (i.e. grub1 and LILO), this
        partition could not be LVM, since those could not read it. grub2
        nowadays can read LVM partitions.
    3.  Create a special partition. If you do, make sure it is a
        filesystem type that grub2 knows how to read. The simplest
        option is just a FAT filesystem.

2.  Track which hard drive and partition the iso is on. This is not an
    extended grub2 manual, but grub2 drives begin with 0, while
    partitions begin with 1. Thus Linux "sda3" will be grub2 (hd0,3).
    grub2 usually is smart enough to figure out what your partition
    table is, so if you have GPT, you can just do "(hd0,3)" and
    not "(hd0,gpt3)".
3.  Add a section to your grub config:
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    menuentry "SmartOS" {
        insmod multiboot
        insmod loopback
        loopback loop0 (hd0,3)/path/to/smartos-latest.iso
        set root='loop0'
        multiboot /platform/i86pc/kernel/amd64/unix /platform/i86pc/kern
el/amd64/unix -B smartos=true
        module /platform/i86pc/amd64/boot_archive /platform/i86pc/amd64/
boot_archive type=rootfs name=ramdisk
    }
    ```

    </div>

    </div>

    </div>

Let's take that apart.

First, create a menu entry named "SmartOS". If you have multiple
versions or boot methods, you will create multiple menu entries:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
menuentry "SmartOS" {
}
```

</div>

</div>

</div>

Next, load the multiboot module, which is like the old "kernel" from
grub1 (and is used in the default SmartOS boot configuration. You need
this because grub2 does not understand SmartOS's kernel, only that it is
there:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
insmod multiboot
```

</div>

</div>

</div>

Next, load the loopback module, which allows you to loopback mount an
ISO file:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
insmod loopback
```

</div>

</div>

</div>

Now mount the iso via the loopback as a filesystem:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
loopback loop0 (hd0,3)/path/to/smartos-latest.iso
```

</div>

</div>

</div>

The above assumes three things:

- Your iso is on the partition at (hd0,3), in Linux terms sda3 (Linux
    and grub2 determine partitions beginning with 1). If your iso is on
    a different partition, then use that one.
- Your iso is named smarts-latest.iso. If it is named something else
    on the disk, well, you should use a different name here.
- /path/to/smartos-latest.iso is the path from the root *of this
    disk*. grub2 doesn't care where in your filesystem you normally
    mount this disk, only the path relative to the root of this disk.

Next set the mounted loop0 device as your root:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
set root='loop0'
```

</div>

</div>

</div>

Note that you do not use the normal '(' and ')' when setting the root.

Finally, tell grub2 how to use the kernel and module:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
multiboot /platform/i86pc/kernel/amd64/unix /platform/i86pc/kernel/amd64
/unix -B smartos=true
module /platform/i86pc/amd64/boot_archive /platform/i86pc/amd64/boot_arc
hive type=rootfs name=ramdisk
```

</div>

</div>

</div>

Note that the file names are entered twice, so that the kernel knows how
to find itself. Same for the module. **This is not a typo.**

When you select this menu option, you boot away!

### From the platform tarball

If you prefer to use just the kernel ("unix") and boot\_archive files
from a platform tarball you can do that as well. The process is pretty
similar, minus the loopback.

1.  Extract the downloaded SmartOS platform tarball onto a partition
    that can be read by the bootloader. You have a number of options for
    this:
    1.  Use an existing Linux /boot partition, since it already must be
        readable by grub2.
    2.  Use an existing Linux / or data partition, assuming it is
        readable by grub2. In older days (i.e. grub1 and LILO), this
        partition could not be LVM, since those could not read it. grub2
        nowadays can read LVM partitions.
    3.  Create a special partition. If you do, make sure it is a
        filesystem type that grub2 knows how to read. The simplest
        option is just a FAT filesystem.

2.  Track which hard drive and partition the files are on. This is not
    an extended grub2 manual, but grub2 drives begin with 0, while
    partitions begin with 1. Thus Linux "sda3" will be grub2 (hd0,3).
    grub2 usually is smart enough to figure out what your partition
    table is, so if you have GPT, you can just do "(hd0,3)" and
    not "(hd0,gpt3)".
3.  Add a section to your grub config:
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    menuentry "SmartOS" {
        insmod multiboot
        set root='hd0,3'
        multiboot /platform/i86pc/kernel/amd64/unix /platform/i86pc/kern
el/amd64/unix -B smartos=true
        module /platform/i86pc/amd64/boot_archive /platform/i86pc/amd64/
boot_archive type=rootfs name=ramdisk
    }
    ```

    </div>

    </div>

    </div>

Notice the differences:

- You do not need to insmod the loopback module since you are not
    mounting an iso.
- You do not do the loopback mount.
- You set the root to the partition to which the files are, rather
    than the loopback device.
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


