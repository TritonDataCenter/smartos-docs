+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : How to create a KVM VM
( Hypervisor virtualized machine ) in SmartOS </span>

</div>

<div class="pagesubheading">

This page last changed on Jan 31, 2019 by
<font color="#0050B2">shaner</font>.

</div>

Creating KVM VM's
=====================

Before creating a new KVM VM, a zone template image must be imported.
KVM templates are ZFS zvol snapshots with a (typically)
freely-distributable operating system such as a Linux variant
pre-installed. Images are available through the imgadm tool.

You will then be able to create and install zones and virtual machines
using `vmadm create`.

To list all available KVM images from Joyent:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
imgadm avail -o uuid,name,version,os,type,published | grep zvol
```

</div>

</div>

</div>

<div class="panelMacro">

  ---------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------------------------------------
  ![](images/icons/emoticons/information.gif){width="16" height="16"}
note that KVM images usually say something like "linux" or "bsd" in the
"OS" column of this output and "zvol" as the "TYPE".\

"smartos" images (zone templates) and images with "LX" in their names (d
atasets for use with LX-branded zones)\

aren't appropriate for the process being described here. These images ca
nnot be used to create KVM VM's.
  ---------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------------------------------------

</div>

To list all local images installed in on your SmartOS host:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
imgadm list
```

</div>

</div>

</div>

To import an image from Joyent, use the UUID of the image (from
`imgadm avail`):

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
imgadm import UUID
```

</div>

</div>

</div>

The image is now downloaded and installed at zones/UUID.

`vmadm create` is a tool for fast provisioning of zones and KVM VMs; it
takes a json payload and clones an image into a working virtual machine.

To use `vmadm create` you must first start by creating your VM/zone
definition file, for instance copying this in to /tmp/myvmspec
(substituting the image\_uuid, network information, and machine
dimensions that are appropriate):

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
{
  "brand": "kvm",
  "resolvers": [
    "208.67.222.222",
    "8.8.4.4"
  ],
  "ram": "512",
  "vcpus": "1",
  "nics": [
    {
      "nic_tag": "admin",
      "ip": "10.33.33.33",
      "netmask": "255.255.255.0",
      "gateway": "10.33.33.1",
      "model": "virtio",
      "primary": true
    }
  ],
  "disks": [
    {
      "image_uuid": "3162a91e-8b5d-11e2-a78f-9780813f9142",
      "boot": true,
      "model": "virtio"
    }
  ]
}
```

</div>

</div>

</div>

First, ensure you've imported the image you've specified in the vmspec
file. In the above example, you'd

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
imgadm import 3162a91e-8b5d-11e2-a78f-9780813f9142
```

</div>

</div>

</div>

then simply

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
vmadm create -f /tmp/myvmspec
```

</div>

</div>

</div>

and `vmadm` will respond with a status and your VM will be created and
booted.

Once you have created the VM with `vmadm create`, you can see your VM's
video console by finding it's VNC connection info:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
vmadm info <UUID> vnc

#### example output here:
{
  "vnc": {
    "host": "10.0.1.152",
    "port": 52922,
    "display": 47022
  }
}
```

</div>

</div>

</div>

Then connect to that VNC service with your local workstation's VNC
viewer. <span class="image-wrap"
style="">![](attachments/755505/1146943.png)</span>

<div class="panelMacro">

  ------------------------------------------------------------------- --
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------
  ![](images/icons/emoticons/forbidden.gif){width="16" height="16"}   Be
 aware that the VNC console service is NOT authenticated, and is intende
d to run on a private network. Typically, your SmartOS machine won't hav
e it's primary interface on the internet. Please be aware of what servic
es you're exposing, and apply firewall rules as necessary.
  ------------------------------------------------------------------- --
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------

</div>

<div class="panelMacro">

  ------------------------------------------------------------------- --
------------------------------------------------------------------------
------------------------------------------------------------------------
--------------------------------------------------------
  ![](images/icons/emoticons/forbidden.gif){width="16" height="16"}   Re
alVNC VNC Viewer will crash when connecting unless you set FullColour to
 True in the options.  On Windows make sure to go to Options, click Adva
nced, go to the Expert tab and set FullColour to True.
  ------------------------------------------------------------------- --
------------------------------------------------------------------------
------------------------------------------------------------------------
--------------------------------------------------------

</div>

Note that the VM images distributed by Joyent at
<https://images.joyent.com/images> are designed to be used with
SmartDatacenter, and typically have hooks to set passwords and/or ssh
keys from SmartDatacenter services. To use them with the open-source
SmartOS, you'll probably need to first boot single-user and set a
password for the root user.

#### Passing SSH keys to the VM

With some images you won't be able to log in to unless you pass an SSH
public key to validate your connection with. Adjust your config to
contain a customer\_metadata block:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .javascript; .gutter: .false}
"customer_metadata": {
    "root_authorized_keys":
"ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8aQRt2JAgq6jpQOT5nukO8gI0Vst+EmBtwB
z6gnRjQ4Jw8pERLlMAsa7jxmr5yzRA7Ji8M/kxGLbMHJnINdw/TBP1mCBJ49TjDpobzztGO9
icro3337oyvXo5unyPTXIv5pal4hfvl6oZrMW9ghjG3MbIFphAUztzqx8BdwCG31BHUWNBde
fRgP7TykD+KyhKrBEa427kAi8VpHU0+M9VBd212mhh8Dcqurq1kC/jLtf6VZDO8tu+XalWAI
JcMxN3F3002nFmMLj5qi9EwgRzicndJ3U4PtZrD43GocxlT9M5XKcIXO/rYG4zfrnzXbLKEf
abctxPMezGK7iwaOY7w== wooyay@houpla"
  }
```

</div>

</div>

</div>

#### Passing cloud-init data to the VM

SmartOS provides the ability to inject cloud-init data into a zone/VM.
This is useful for automating the menial tasks one would need to perform
manually like setting up users, installing packages, or pulling down a
git repo. Basically, anything you can stuff into cloud-init user-data is
at your disposal.

Since SmartOS zone definitions are in JSON and cloud-init data is in
yaml, it’s not immediately obvious how to supply this information.
Maintaining proper yaml indentation, escape all double-quotes (“) and
line-feeds.

Here’s an example cloud-init yaml file that creates a new user and
imports their ssh key from launchpad.net.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
#cloud-config

users:
  - default
  - name: shaner
    ssh_import_id: shaner
    lock_passwd: false
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell: /bin/bash
```

</div>

</div>

</div>

Here's what it would look like in our zone definition.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
"customer_metadata": {
    "cloud-init:user-data": "#cloud-config\n\nusers:\n  - default\n  - n
ame: shaner\n    ssh_import_id: shaner\n    lock_passwd: false\n    sudo
: \"ALL=(ALL) NOPASSWD:ALL\"\n    shell: /bin/bash"
  }
```

</div>

</div>

</div>

You can find more on cloud-init at
<https://cloudinit.readthedocs.io/en/latest/topics/examples.html>

\
<div class="tabletitle">


Attachments:
------------

</a>

</div>

<div class="greybox" align="left">

![](images/icons/bullet_blue.gif){width="8" height="8"}
[debian-vnc-kvm-booting.png](attachments/755505/1146943.png)
(image/png)\

</div>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


