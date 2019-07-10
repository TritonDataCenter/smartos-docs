+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Installing Joyent
SmartOS onto a Bootable Disk Partition </span>

</div>

<div class="pagesubheading">

This page last changed on Jan 05, 2016 by
<font color="#0050B2">nahamu</font>.

</div>

This page was deprecated, then updated, but it's still not recommended,
not supported, and most likely not a good idea.

A better idea is to use SmartOS as intended:
<http://wiki.smartos.org/display/DOC/Getting+Started+with+SmartOS#Gettin
gStartedwithSmartOS-CreatingaPersistentzpool>

<div>

- [Creating a bootable zones
    pool](#InstallingJoyentSmartOSontoaBootableDiskPartition-Creatingabo
otablezonespool)
- [Updating to the latest
    release](#InstallingJoyentSmartOSontoaBootableDiskPartition-Updating
tothelatestrelease)
- [The only good reasons to do
    this](#InstallingJoyentSmartOSontoaBootableDiskPartition-Theonlygood
reasonstodothis)
- [If you upgrade
    your zpool...](#InstallingJoyentSmartOSontoaBootableDiskPartition-If
youupgradeyourzpool...)
- [References](#InstallingJoyentSmartOSontoaBootableDiskPartition-Refe
rences)

</div>

Creating a bootable zones pool
----------------------------------

<div class="panelMacro">

  ------------------------------------------------------------------- --
------------------------------------------------------------------------
------------------------------------------------------------------
  ![](images/icons/emoticons/forbidden.gif){width="16" height="16"}   **
THIS WILL WIPE YOUR DISKS AND DESTROY YOUR BITS AND WILL BE COMPLETELY U
NSUPPORTED IF YOU DO IT**\
                                                                      Se
riously, unless you understand what every step in this process does, don
't do this.
                                                                      An
d if you understand every step in the process, think very hard before yo
u do this.

                                                                      Th
is is not supported, and if you have problems with your system you will
politely be told to boot off a USB stick, a CD, or a PXE server.
  ------------------------------------------------------------------- --
------------------------------------------------------------------------
------------------------------------------------------------------

</div>

<div class="panelMacro">

  ------------------------------------------------------------------- --
---------------------------------------------------------------
  ![](images/icons/emoticons/forbidden.gif){width="16" height="16"}   Th
ese instructions are based on notes and haven't been verified
  ------------------------------------------------------------------- --
---------------------------------------------------------------

</div>

1.  Install SmartOS to a single disk or a single mirror (no RAIDZn or
    stripes of vdevs) (e.g. c0d0, d0d1, c0t0d0, c0t1d0, etc.), in this
    example, a mirror on c0d0 and c0d1:
2.  Let the system reboot after the install and log in as root.
3.  Download the latest iso, rip it open, copy files to where they
    are needed.
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
    zfs create zones/smartos
    cd /zones/smartos
    curl -k -O https://us-east.manta.joyent.com/Joyent_Dev/public/SmartO
S/smartos-latest.iso
    mount -F hsfs smartos-latest.iso /mnt
    rsync -av /mnt/ .
    umount /mnt
    cp -r /zones/smartos/boot /zones/boot
    ```

    </div>

    </div>

    </div>

4.  Fix up your /zones/boot/grub/menu.lst file (note the path!) and
    install GRUB.
    <div class="code panel" style="border-width: 1px;">

    <div class="codeContent panelContent">

    <div id="root">

    ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
    cd /zones/boot/grub
    cp menu.lst{,.orig}
    < menu.lst.orig > menu.lst awk 'BEGIN{print "findroot (pool_zones,0)
"} {print} /title/{print "   bootfs zones/smartos"}'
    installgrub -m -f  stage1 stage2 /dev/rdsk/c0d0s0
    installgrub -M /dev/rdsk/c0d0s0 /dev/rdsk/c0d1s0
    ```

    </div>

    </div>

    </div>

5.  Remove the CD and do a reboot. You should now boot directly off of
    your zones pool.

Updating to the latest release
----------------------------------

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
cd /zones/smartos
rm -f platform-latest.iso
curl -k -O https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/pl
atform-latest.tgz
tar xzvf platform-latest.tgz
rm -rf platform platform-latest.tgz
echo platform-* | sed 's|.*-||' > version
mv platform-* platform
zfs snapshot zones/smartos@$(cat version)
reboot
```

</div>

</div>

</div>

The only good reasons to do this
------------------------------------

1.  This machine you've just set up hosts your [Simple PXE
    Server](Simple%20PXE%20Server.html "Simple PXE Server") for the rest
    of your SmartOS machines and nothing else.
2.  You are a developer and want to be able to do fresh build of
    SmartOS, slurp the platform directory out of your build zone into
    your zones/smartos filesystem, and reboot onto your freshly
    built image. Those details are again left to the reader.

If you upgrade your zpool...
--------------------------------

You might hit one of the reasons this is not recommended; newer pool
versions / feature flags may require you to re-install grub.\
If this is a development machine where you've rebuilt SmartOS, it's not
so bad... From the GZ:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
cd /zones/<build-zone-zonename>/root/root/smartos-live/proto/boot/grub
installgrub -m -f  stage1 stage2 /dev/rdsk/c0d0s0
installgrub -M /dev/rdsk/c0d0s0 /dev/rdsk/c0d1s0
```

</div>

</div>

</div>

If you forget to do this and reboot to find that grub is broken, you
will need to rescue yourself with a USB stick or CD so that you can do
it.

So in case it wasn't clear yet, DO NOT RUN A PRODUCTION SERVER THIS
WAY!!!

References
--------------

- <http://wiki.openindiana.org/oi/2.1+Post-installation>
- <http://notallmicrosoft.blogspot.com/>
- <http://omnios.omniti.com/file.php/core/kayak/disk_help.sh>
- <http://www.listbox.com/member/archive/182179/entry/1:34/20150226170
314:3DEB93A0-BE03-11E4-A54E-FDC306128275/>

\
<div class="tabletitle">


Attachments:
------------

</a>

</div>

<div class="greybox" align="left">

![](images/icons/bullet_blue.gif){width="8" height="8"} [Create New
Virtual Machine.jpg](attachments/753696/1146884.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"} [Oracle VM
VirtualBox Manager.jpg](attachments/753696/1146885.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"} [smartos
\[Running\].jpg](attachments/753696/1146886.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"} [smartos
\[Running\]-1.jpg](attachments/753696/1146887.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"} [smartos
\[Running\]-2.jpg](attachments/753696/1146888.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"} [smartos
\[Running\]-3.jpg](attachments/753696/1146889.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[smartos.jpg](attachments/753696/1146890.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[smartos-1.jpg](attachments/753696/1146891.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[smartos-2.jpg](attachments/753696/1146892.jpg) (image/jpeg)\
![](images/icons/bullet_blue.gif){width="8" height="8"}
[smartos-3.jpg](attachments/753696/1146893.jpg) (image/jpeg)\

</div>

<div class="tabletitle">


Comments:
---------

</a>

</div>

+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| See early discussion
   |
| [here](http://smartos.org/2011/08/16/ryans-rough-guide-to-the-smartos-
is |
| o/#comments).
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| deirdre at Aug 22, 2011 18:38
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I'm wondering if SmartOS will have more convenient installation method
.. |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| alhazred at Jan 24, 2012 08:53
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| No. The live image model was chosen intentionally
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by joh
ns |
| at Jan 24, 2012 14:56
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Alexander, actually it was never meant to be installed to disk. It
   |
| actually works a lot better this way, booting from a live media like
   |
| PXE, CDROM, or USB thumb drive.
   |
|
   |
| This video really explains it a lot better than I ever could.
   |
| <http://www.youtube.com/watch?v=ieGWbo94geE>
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| magnus at Apr 29, 2012 05:01
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I like the Live image approach but the live image is perpetually
   |
| rebooting asking the same questions each time.  I don't really ever "g
et |
| into" the live image.  Any common pitfalls?
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| daverubert at May 29, 2012 19:04
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| If you step through the configuration it should not ask you again afte
r  |
| a reboot.
   |
|
   |
| You should check if you enter the disk names if asked - just pressing
   |
| enter at this point does not configure any disks and will guide you
   |
| through the settings again after reboot.
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| merlindmc at May 30, 2012 06:17
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I would like to use SmartOS but our datacentre is managed remotely. Ho
w  |
| do I use SmartOS in this case? I would definitely not want the boot
   |
| process to depend on a PXE server because it means a reliance on a
   |
| separate server. If this separate server goes down, then my SmartOS
   |
| hypervisor won't start.
   |
|
   |
| Surely there is a solution to this kind of (relatively common) scenari
o? |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| torbjoern@gmail.com at May 31, 2012 21:23
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| use an usbkey to boot
   |
|
   |
| For the initial configuration you should use some remote
   |
| keyboard/display thingy
   |
|
   |
| Updates can be done remotely as well
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| merlindmc at Jun 01, 2012 05:57
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Hi Daniel, thanks for your reply but it's not going to work as I have
no |
| means to insert the USB key into the remote server.
   |
|
   |
| So it's really a remote server in the true sense of the word - it's ev
en |
| on a different continent. This is a pretty common scenario with
   |
| dedicated server offerings around the world.
   |
|
   |
| I suppose I could ask one of the remote techs to insert a USB key into
   |
| the machine. But at a later stage when someone using the same shared
   |
| rackspace pulls out my USB drive, it's also going to mean potential
   |
| downtime.
   |
|
   |
| Is there no way to put the boot volume on disk? I.e. on a mirrored vde
v  |
| zpool.
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| torbjoern@gmail.com at Jun 01, 2012 06:44
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I also use a dedicated server hosted by some company. There was no
   |
| problem getting a 16GB USB key inserted.
   |
|
   |
| You could also use some extra disk inside the chassis but you could ju
st |
| use the disk to boot and nothing else (I guess).
   |
|
   |
| Some small 8GB ssd on an IDE or SATA interface should work - but I thi
nk |
| it's easier to get an USB key and use that ;)
   |
|
   |
| You also have potential downtime if someone needs YOUR network cable a
nd |
| just pulls it out ;) Something like that should just not happen.
   |
|
   |
| And also it's just critical if you reboot your box at exact that time.
   |
| The USB key is just used while booting. (A dvd in a dvd-rom would also
   |
| work - but someone could also go there and remove the disk)
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| merlindmc at Jun 01, 2012 06:54
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I see your point regarding the network cable, but I believe that's qui
te |
| different. If a tech sees a network cable sticking out he will put it
   |
| back in. He will not at any point look at a network cable and pull it
   |
| out.
   |
|
   |
| However let's assume they are doing some restructuring of their server
   |
| racks. A tech sees a USB key sticking out of a dedicated server. Well,
   |
| none of the other dedicated servers have a USB key sticking out, so wh
y  |
| should this one? He might pull it out! And if he does pull it out,
   |
| there's nothing you can do to complain to the hosting company because
   |
| it's a special request that nobody has taken any responsibilities for.
   |
|
   |
| I still think it should be possible to boot up SmartOS from the actual
   |
| main storage. I prefer servers to be resiliant and to always boot up
   |
| with no human intervention. You can still use USB keys to boot up, but
   |
| potentially have a backup SmartOS image on the physical drives
   |
| somewhere. What do you think about this?
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| torbjoern@gmail.com at Jun 01, 2012 08:11
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Dedicated hosting companies tend to do once off's for customers (like
   |
| inserting USB keys into dedicated servers) when you submit support
   |
| tickets so they have a paper trail and use customer notes to track thi
s  |
| sort of thing.
   |
|
   |
| I wrote a script (available
   |
| from [https://gist.github.com/jacques/34b8767b549a379fdb28)&nbsp;which
]( |
| https://gist.github.com/jacques/34b8767b549a379fdb28)%C2%A0which)
   |
| I am using to write to the USB keys in SmartOS Compute Nodes.  For
   |
| critical systems you can do dual USB keys and if the one fails you can
   |
| change your boot order using IPKVM.
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| jacques at Jun 26, 2013 18:43
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Hi All
   |
|
   |
| I am trying to install Zones using above method on VM created on
   |
| Virtualbox but it never able to rcognize network when "smartos=true"
   |
| removed and "standalone=true,noimport=true" used. In that case it fail
s  |
| to authenticate. Is there anyway to get network recognized with that
   |
| option so that I can install or is there any other option to configure
   |
| this.
   |
|
   |
| If I configure with "smartos=true" and follow above steps than when it
   |
| reboots with disk it comes up in grub mode and not able to find root.
   |
|
   |
| Please let me know if there is simple process to configure zones on
   |
| virtualbox vm.
   |
|
   |
| Thanks
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| parthivs at Jul 30, 2013 16:52
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| **Do not use this wiki page for setting up a Virtualbox VM of
   |
| SmartOS!** Use SmartOS the way it was intended to be used. Use the ISO
   |
| and just leave the virtual CD in all the time.
   |
|
   |
| See also: [SmartOS on
   |
| VirtualBox](SmartOS%20on%20VirtualBox.html "SmartOS on VirtualBox") an
d  |
| [SmartOS
   |
| as a Sandboxed VirtualBox
   |
| Guest](SmartOS%20as%20a%20Sandboxed%20VirtualBox%20Guest.html "SmartOS
 a |
| s a Sandboxed VirtualBox Guest")
   |
|
   |
| </font>
   |
| <div class="smallfont" align="left"
   |
| style="color: #666666; width: 98%; margin-bottom: 10px;">
   |
|
   |
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by
   |
| nahamu at Jul 30, 2013 16:58
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


