+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : How to create a zone (
OS virtualized machine ) in SmartOS </span>

</div>

<div class="pagesubheading">

This page last changed on Jan 11, 2018 by
<font color="#0050B2">brian.bennett@joyent.com</font>.

</div>

OS Virtualized Machines, hereafter referred to as Zones, is a
lightweight virtualization technology. Zones are fully isolated
user-land environments, they do not possess their own kernel and
therefore have effectively no performance overhead allowing for bare
metal performance. Network and disk virtualization are provided by ZFS
and the SmartOS networking stack ("Crossbow"). The result is a virtual
environment that in every way acts like a complete environment.

Creating Zones
==================

The process of creating zones is simple:

1.  Download a Zone Image
2.  Create a Manifest describing the Zone
3.  Create the Zone using *vmadm*
4.  Use the Zone

### Obtaining a Zone Image

Zone creation requires an
[image](Managing%20Images.html "Managing Images") to use as a template.

To find a zone image, use the command
*[imgadm](https://smartos.org/man/1m/imgadm)* *avail*. Images with the
OS type "smartos" are zone images. The "base" and "base-64" images are
minimal images with only a basic 32bit or 64bit
[pkgsrc](Working%20with%20Packages.html "Working with Packages")
installation and should be considered for building your own custom
images.

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    # imgadm avail name=base-64
    UUID                                  NAME     VERSION  OS       TYP
E          PUB
    163cd9fe-0c90-11e6-bd05-afd50e5961b6  base-64  16.1.0   smartos  zon
e-dataset  2016-04-27
    13f711f4-499f-11e6-8ea6-2b9fb858a619  base-64  16.2.0   smartos  zon
e-dataset  2016-07-14
    adf9565c-8be6-11e6-a077-57637270218d  base-64  16.3.0   smartos  zon
e-dataset  2016-10-06
    70e3ae72-96b6-11e6-9056-9737fd4d0764  base-64  16.3.1   smartos  zon
e-dataset  2016-10-20
    f6acf198-2037-11e7-8863-8fdd4ce58b6a  base-64  17.1.0   smartos  zon
e-dataset  2017-04-13
    643de2c0-672e-11e7-9a3f-ff62fd3708f8  base-64  17.2.0   smartos  zon
e-dataset  2017-07-12

</div>

</div>

Import an image by specifying its UUID:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    # imgadm import 643de2c0-672e-11e7-9a3f-ff62fd3708f8
    Importing 643de2c0-672e-11e7-9a3f-ff62fd3708f8 (base-64@17.2.0) from
 "https://images.joyent.com"
    Gather image 643de2c0-672e-11e7-9a3f-ff62fd3708f8 ancestry
    Must download and install 1 image (176.6 MiB)
    Imported image 643de2c0-672e-11e7-9a3f-ff62fd3708f8 (base-64@17.2.0)

</div>

</div>

You will reference this image's UUID when you create the zone manifest.

### The Zone Manifest

A manifest is a JSON object which describes your zone. There are many
options which are fully described in the
[vmadm(1m)](https://smartos.org/man/1m/vmadm) man page. The most
important are:

- **brand**: This must be set to "joyent" for Zones
- **image\_uuid**: The UUID of the image you are using as a template
    (images were previously called "datasets")
- **alias**: An arbitrary name displayed in *vmadm list* output in
    addition to the UUID
- **hostname**: Hostname that will be set within the zone
- **max\_physical\_memory**: Amount of RAM (RSS) available to the zone
    in MB
- **quota**: Amount of disk space in GB
- **resolvers:** DNS nameservers for this zone to use (placed in the
    zone's `/etc/resolv.conf` file)
- **nics**: One or more network interfaces attached to this zone

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
{
 "brand": "joyent",
 "image_uuid": "643de2c0-672e-11e7-9a3f-ff62fd3708f8",
 "alias": "web01",
 "hostname": "web01",
 "max_physical_memory": 512,
 "quota": 20,
 "resolvers": ["8.8.8.8", "208.67.220.220"],
 "nics": [
  {
    "nic_tag": "admin",
    "ip": "10.88.88.52",
    "netmask": "255.255.255.0",
    "gateway": "10.88.88.2"
  }
 ]
}
```

</div>

</div>

</div>

#### Passing SSH keys to the VM

With some images you won't be able to log in to unless you pass an SSH
public key to validate your connection with. Adjust your config to
contain a customer\_metadata block:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
"customer_metadata": {
    "root_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8aQRt2J
Agq6jpQOT5nukO8gI0Vst+EmBtwBz6gnRjQ4Jw8pERLlMAsa7jxmr5yzRA7Ji8M/kxGLbMHJ
nINdw/TBP1mCBJ49TjDpobzztGO9icro3337oyvXo5unyPTXIv5pal4hfvl6oZrMW9ghjG3M
bIFphAUztzqx8BdwCG31BHUWNBdefRgP7TykD+KyhKrBEa427kAi8VpHU0+M9VBd212mhh8D
cqurq1kC/jLtf6VZDO8tu+XalWAIJcMxN3F3002nFmMLj5qi9EwgRzicndJ3U4PtZrD43Goc
xlT9M5XKcIXO/rYG4zfrnzXbLKEfabctxPMezGK7iwaOY7w== wooyay@houpla",
    "user-script" : "/usr/sbin/mdata-get root_authorized_keys > ~root/.s
sh/authorized_keys ; /usr/sbin/mdata-get root_authorized_keys > ~admin/.
ssh/authorized_keys"
}
```

</div>

</div>

</div>

### Creating the Zone

With your image imported and your manifest created, you can now create
the zone. Do this by simply passing the manifest to *vmadm create -f
manifest.json*:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    # vmadm create -f web01.json
    Successfully created VM d6a0a022-3855-4762-a2e5-3f16969ca2fb

</div>

</div>

Alternatively, you can pass the manifest via STDIN:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    # vmadm create <<EOL
      (manifest json here)
    EOL

</div>

</div>

The zone is now created and running.

### Connecting to your Zone

Once you have created a zone with `vmadm create`, you can log into your
zone via ssh or connect to the console with one of two methods:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
vmadm console UUID
```

</div>

</div>

</div>

or

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
zlogin UUID
```

</div>

</div>

</div>

Please refer to the manpage for
[vmadm(1m)](https://smartos.org/man/1m/vmadm) and
[zlogin(1)](https://smartos.org/man/1/zlogin) respectively, for the
escape sequence to exit out of console mode.

<div class="tabletitle">


Comments:
---------

</a>

</div>

+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| It'd be great to add information on where to look for login credential
s  |
| for joyent templates. Case in point I have just created a new VM using
   |
| the base64 template and I have no idea what username / password to use
   |
| on its console.
   |
|
   |
| ...
   |
|
   |
| So I realised I should use the 'zlogin UUID' method as that doesn't
   |
| require authentication, then 'passwd admin' etc. (as opposed to 'vmadm
   |
| console UUID' which of course gives you the console login prompt).
   |
|
   |
| I also tried replacing the password in the zones shadow file but that
   |
| didn't seem to work.
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
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by jes
se |
| at Oct 28, 2012 08:30
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| You can set those passwords for the two predefined users yourself.
   |
|
   |
| Just add a section to your json while creating the machine:
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
| <div id="root">
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
| "customer_metadata": {
   |
|   "root_pw": "...",
   |
|   "admin_pw": "..."
   |
| }
   |
| ```
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| You can use the username "admin" to connect via ssh or root/admin if y
ou |
| use the console on the GZ
   |
|
   |
| <div class="panelMacro">
   |
|
   |
|   --------------------------------------------------------------------
-  |
| ----------------------------------------------------------------------
-- |
| ----------------------------------
   |
|   ![](images/icons/emoticons/information.gif){width="16" height="16"}
   |
| **Behaviour changed**\
   |
|
   |
| in the later SmartOS versions all metadata keys that end in '\_pw' nee
d  |
| to go into 'internal\_metadata':
   |
|
   |
| <div class="code panel" style="border-width: 1px;">
   |
|
   |
|
   |
| <div class="codeContent panelContent">
   |
|
   |
|
   |
| <div id="root">
   |
|
   |
|
   |
| ``` {.theme: .Confluence; .brush: .java; .gutter: .false}
   |
|
   |
| "internal_metadata": {
   |
|
   |
|   "root_pw": "...",
   |
|
   |
|   "admin_pw": "..."
   |
|
   |
| }
   |
|
   |
| ```
   |
|
   |
|
   |
| </div>
   |
|
   |
|
   |
| </div>
   |
|
   |
|
   |
| </div>
   |
|   --------------------------------------------------------------------
-  |
| ----------------------------------------------------------------------
-- |
| ----------------------------------
   |
|
   |
| </div>
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
| merlindmc at Oct 31, 2012 06:48
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Hi, Daniel
   |
|
   |
| As you mentioned, "username" and "password" can be added in the
   |
| coustermer\_metedata.
   |
|
   |
| Do you know any other keys can be added in the metedata field?
   |
|
   |
| Assuming I wanna install mysql in the vm, what should I do in the
   |
| creatation stepps?
   |
|
   |
| thank you!
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
| tx\_seu@hotmail.com at Nov 03, 2012 09:00
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| it should be noted that "root" and "admin" are the only accounts this
   |
| works with, and that this is specific to the zoneinit scripts in
   |
| specific datasets.  You can't, for example, use: "ryan\_pw":
   |
| "secretstuff" ... that will not work.
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
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by rya
n  |
| at Feb 10, 2013 03:37
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| I've did this little hack to make my ssh\_key working for the root and
   |
| admin account, add the following to your json file, it's not perfect,
   |
| but it works.
   |
|
   |
| <div class="preformatted panel" style="border-width: 1px;">
   |
|
   |
| <div class="preformattedContent panelContent">
   |
|
   |
|     "customer_metadata" : {
   |
|        "root_authorized_keys" : " ssh-rsa lalalalbbalak x@whatever\nss
h- |
| rsa 98ydoiowiu y@blah",
   |
|        "user-script" : "/usr/sbin/mdata-get root_authorized_keys > ~ro
ot |
| /.ssh/authorized_keys ; /usr/sbin/mdata-get root_authorized_keys > ~ad
mi |
| n/.ssh/authorized_keys"
   |
|     }
   |
|
   |
| </div>
   |
|
   |
| </div>
   |
|
   |
| That's it
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
| sebasp at Mar 21, 2013 14:25
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| Sebastien, that is *brilliant*!  Thank you for sharing that.  Really
   |
| cool.  That just saved me a lot of headaches.
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
| alainodea at Sep 16, 2013 00:27
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| How do I create a zone on a dedicated disk? I've 4 SATA disks, during
   |
| setup, I specified the first disk and then used another one for dump.
   |
| Created two VMs as well. Now I'd like each one of these VMs to have
   |
| exclusive access to one disk each. How do I do that?
   |
|
   |
| Thanks.
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
| deepaksmos at Sep 27, 2013 16:19
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


