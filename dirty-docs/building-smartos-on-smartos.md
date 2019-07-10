+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Building SmartOS on
SmartOS </span>

</div>

<div class="pagesubheading">

This page last changed on Jun 28, 2019 by
<font color="#0050B2">cjr</font>.

</div>

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
This page is now deprecated. The [SmartOS repository](https://github.com
/joyent/smartos-live/#building-smartos) now has build instructions that
are kept up to date as changes are made.
  ---------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------

</div>

<p>
<style type="text/css">/**/
div.rbtoc1561740960014 {margin-left: 1.5em;padding: 0px;}
div.rbtoc1561740960014 ul {margin-left: 0px;padding-left: 1em;}
div.rbtoc1561740960014 li {margin-left: 0px;padding-left: 0px;}

/**/</style>
<div class="rbtoc1561740960014">

<ul>
<li>
<span class="TOCOutline">1</span> [Zone
creation](#BuildingSmartOSonSmartOS-Zonecreation)
</li>
- <span class="TOCOutline">1.1</span> [In-zone
    Configuration](#BuildingSmartOSonSmartOS-InzoneConfiguration)
- <span class="TOCOutline">1.2</span> [Getting the source
    trees](#BuildingSmartOSonSmartOS-Gettingthesourcetrees)
- <span class="TOCOutline">1.3</span> [Building
    SmartOS](#BuildingSmartOSonSmartOS-BuildingSmartOS)
- <span class="TOCOutline">1.4</span> [Building CD and USB
    images](#BuildingSmartOSonSmartOS-BuildingCDandUSBimages)

</ul>

</div>

</p>
Zone creation
=================

<div class="panelMacro">

  ------------------------------------------------------------------- --
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
----------------------------------
  ![](images/icons/emoticons/forbidden.gif){width="16" height="16"}   **
host version**\
                                                                      Sm
artOS is self hosting. Make sure you are running the latest release of S
martOS to do your builds. If you're on a build from before the fake subs
et was killed – April 2013, there is a high likelihood the build will fa
il. Please update your platform.
  ------------------------------------------------------------------- --
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
----------------------------------

</div>

SmartOS is built in a zone. Use the **base-multiarch-lts 14.4.X** zone
image (e.g. 14.4.2 is UUID e69a0918-055d-11e5-8912-e3ceb6df4cf8)\
Do not use any other zone image.

\* Note:

**base-multiarch-lts  16.4.1** ** (bafa230e-e6ea-11e6-8438-c72c10ff2d1f)
reported to work (thanks pmooney)--confirmed working as of 08 Mar 2019**

<font color="#000000">**base-multiarch-lts 18.4.0
(**</font><font color="#000000">**359338a0-1d65-11e9-a6f0-c749702590d9)
not working**</font>

Import the zone image:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
imgadm import e69a0918-055d-11e5-8912-e3ceb6df4cf8
```

</div>

</div>

</div>

Your zone will need sufficient memory, space, space in tmpfs, and access
to the ufs, pcfs, and tmpfs drivers. Below are some settings to make
sure to include in your zone's json specification (**make sure to set up
a NIC as well**... see [How to create a zone ( OS virtualized machine )
in
SmartOS](How%20to%20create%20a%20zone%20(%20OS%20virtualized%20machine%2
0)%20in%20SmartOS.html "How to create a zone ( OS virtualized machine )
in SmartOS")
for further details).

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .javascript; .gutter: .false}
{
  "brand": "joyent",
  "fs_allowed": "ufs,pcfs,tmpfs",
  "image_uuid": "e69a0918-055d-11e5-8912-e3ceb6df4cf8"
}
```

</div>

</div>

</div>

We recommend that you give your zone at least 2-4 Gb of DRAM and at
least 25 Gb of disk space. These are lower bounds and you'll find that
the build goes much faster if you are able to throw more memory to the
zone. More memory allows more jobs to be run in parallel.

Use vmadm to create your zone, then you can use zlogin to log in.

vmadm validate create will fail with bad\_value for fs\_allowed, but
this can be ignored, the zone will be created correctly.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
[root@core ~]# vmadm validate create -f sobh.json
{
  "bad_values": [
    "fs_allowed"
  ],
  "bad_properties": [],
  "missing_properties": []
}
```

</div>

</div>

</div>

In-zone Configuration
-------------------------

You should generally be working on, and building, the software as an
unprivileged user -- that is, a non-root user. Some of the steps of the
configure script, and of the live image creation, require root
privileges. The SmartOS build process will use
[pfexec(1)](http://smartos.org/man/1/pfexec) to obtain root privileges
just for the commands that need them.

Configure your non-root user account to be able to escalate privileges
to `root` with the `usermod(1M)` tool:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# usermod -P 'Primary Administrator' yournonrootuser
```

</div>

</div>

</div>

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
-----------------------------------------------------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   **Sh
ell**\
                                                                    Peop
le have reported build errors using shells other than bash as their user
 shell. Please use bash as the shell for your build user.
                                                                    For
creating user with bash shell use the following command :

                                                                    user
add -s "/usr/bin/bash" -m  yournonrootuser
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
-----------------------------------------------------------

</div>

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
---------------------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   **Po
stfix**\
                                                                    Enab
le postfix service: svcadm enable postfix\
                                                                    If y
ou don't you'll have error in logs at build time, like:\
                                                                    "pos
tdrop: warning: mail\_queue\_enter: create file maildrop/810830.89198: N
o such file or directory"
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
---------------------------

</div>

Getting the source trees
----------------------------

SmartOS requires the illumos kernel source tree and a couple more
repositories (kvm, ...) as well as various compilation tools to build.
The following steps download the various source trees and binaries
required for the build:

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------------------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   **Pr
ivileges**\
                                                                    The
`configure` script requires root privileges for a limited subset of its
operation. Earlier, this document describes using `usermod` to grant tho
se privileges to your build user account.
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------------------------

</div>

<div class="panelMacro">

  --------------------------------------------------------------- ------
------------------------------------------------------------------------
------------------
  ![](images/icons/emoticons/check.gif){width="16" height="16"}   **debu
g build**\
                                                                  To cre
ate debug builds add the following line to configure.smartos before runn
ing ./configure.
                                                                  <div c
lass="code panel" style="border-width: 1px;">

                                                                  <div c
lass="codeContent panelContent">

                                                                  <div i
d="root">

                                                                  ``` {.
theme: .Confluence; .brush: .java; .gutter: .false}
                                                                  ILLUMO
S_ENABLE_DEBUG="yes"
                                                                  ```

                                                                  </div>

                                                                  </div>

                                                                  </div>
  --------------------------------------------------------------- ------
------------------------------------------------------------------------
------------------

</div>

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
pfexec pkgin -y in scmgit
git clone https://github.com/joyent/smartos-live
cd smartos-live
cp sample.configure.smartos configure.smartos
./configure
```

</div>

</div>

</div>

If any git clone operation launched by configure hangs, it can be
interrupted with Ctrl-C and configure can be restarted (it will pick up
at the last unfinished step). After configure finishes successfully, the
build zone is ready for the build. One can make a snapshot of the build
zone at this point and rollback later if the build fails for any reason.

Building SmartOS
--------------------

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   **Bu
ilding on an "underpowered" system**\
                                                                    If y
our system doesn't actually have a lot of RAM or CPU, the build will aut
omatically throttle down the number of concurrent jobs which are run. If
 you'd like to manually control it, for example, you know that you can r
un more, than you should set the following environment variable to the m
aximum number of jobs you'd be willing to run:
                                                                    <div
 class="code panel" style="border-width: 1px;">

                                                                    <div
 class="codeContent panelContent">

                                                                    <div
 id="root">

                                                                    ```
{.theme: .Confluence; .brush: .bash; .gutter: .false}
                                                                    expo
rt MAX_JOBS=8
                                                                    ```

                                                                    </di
v>

                                                                    </di
v>

                                                                    </di
v>
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------

</div>

You are now ready to build.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
gmake live
```

</div>

</div>

</div>

Good luck! Build times for SmartOS on various hardware configurations
should be similar to the build times for the illumos kernel itself which
can be found [in the illumos
wiki](http://wiki.illumos.org/display/illumos/Build+Times), plus of
course the time required to build the SmartOS-specific parts.

Building CD and USB images
------------------------------

The default output of the SmartOS build is a platform file which is
suitable for PXE booting. However, a bootable CD-ROM ISO image or a
bootable USB key can also be generated. To generate those run one of the
following Makefile targets:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
gmake iso
gmake usb
```

</div>

</div>

</div>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


