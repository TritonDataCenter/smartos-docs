+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Managing Images </span>

</div>

<div class="pagesubheading">

This page last changed on Jan 11, 2018 by
<font color="#0050B2">brian.bennett@joyent.com</font>.

</div>

SmartOS relies on *images* heavily. Images are templates that contain a
disk or filesystem image and metadata which are using when creating new
Zones or VM's.

Images are managed using the *imgadm* tool. With this tool you can:

- View & Download images available on a public image server
- Import remote images or Install from local images
- List, Show or Print details about an image
- Destroy images

Here we'll discuss how to find available images and start using them.
Then we'll look at what images are and how to create our own.   Finally,
we look at how to create your own private image server.

<div>

<ul>
<li>
[Basics](#ManagingImages-Basics)
</li>
- [Viewing & Downloading Public
    Images](#ManagingImages-Viewing%26DownloadingPublicImages)

<li>
[Advanced Topics](#ManagingImages-AdvancedTopics)
</li>
- [What exactly *is* an
    Image?](#ManagingImages-WhatexactlyisanImage%3F)
- [Image Manifests](#ManagingImages-ImageManifests)
- [Creating a Custom Zone
    Image](#ManagingImages-CreatingaCustomZoneImage)
- [Creating a Custom KVM
    Image](#ManagingImages-CreatingaCustomKVMImage)
- [Importing Images Locally](#ManagingImages-ImportingImagesLocally)

<li>
[Serving Images](#ManagingImages-ServingImages)
</li>
- [How Image Server Work](#ManagingImages-HowImageServerWork)
- [Creating a Poor Man's Image
    Server](#ManagingImages-CreatingaPoorMan%27sImageServer)
- [Using the
    *smartos-image-server*](#ManagingImages-Usingthesmartosimageserver)

</ul>

</div>

Basics
==========

### Viewing & Downloading Public Images

\*\* note, this information has changed recently, and this paragraph
could probably be edited for clarity and correctness \*\*

The default image server is
[https://images.joyent.com](https://images.joyent.com/). You can edit
this list of sources using the "imgadm sources -a &lt;URL&gt;" command,
as documented in [imgadm(1m)](https://smartos.org/man/1m/imgadm). Using
the command *imgadm update*, you'll cause the local cache
(**/var/db/imgadm/imgcache.json)** to be updated with the available
images on the servers found in your sources.list. Once your local cache
is updated, you can list all available images for use using *imgadm
avail*:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    # imgadm sources
    https://images.joyent.com

    # imgadm avail | head -n 1 ; imgadm avail | tail
    UUID                                  NAME                VERSION
 OS       PUBLISHED
    380539c4-3198-11e5-82c8-bf9eeee6a395  debian-7                201507
24    linux    2015-07-24T00:09:14Z
    ab3db4c0-31ac-11e5-8856-43e56a8e4285  centos-6                201507
24    linux    2015-07-24T02:35:38Z
    7459f182-31af-11e5-b23a-eb0fd8799c77  freebsd-10              201507
24    bsd      2015-07-24T02:55:34Z
    ead4ff68-320a-11e5-bd54-3749d04712df  ubuntu-14.04            201507
24    linux    2015-07-24T13:50:17Z
    0764d78e-3472-11e5-8949-4f31abea4e05  minimal-32              15.2.0
      smartos  2015-07-27T15:13:25Z
    8ec06130-3472-11e5-bf91-ebc747dbae7e  minimal-64              15.2.0
      smartos  2015-07-27T15:17:13Z
    1e5d6e28-3473-11e5-9e94-1fd77993b49f  minimal-multiarch       15.2.0
      smartos  2015-07-27T15:21:14Z
    2bd52afe-3474-11e5-b07d-c7fb14b2c9e8  base-32                 15.2.0
      smartos  2015-07-27T15:28:46Z
    5c7d0d24-3475-11e5-8e67-27953a8b237e  base-64                 15.2.0
      smartos  2015-07-27T15:37:17Z
    9caff6c6-3476-11e5-9951-bf98c6cb8636  base-multiarch          15.2.0
      smartos  2015-07-27T15:46:14Z

    # imgadm avail | grep base-64 | tail
    c02a2044-c1bd-11e4-bd8c-dfc1db8b0182  base-64-lts             14.4.0
      smartos  2015-03-03T15:55:44Z
    24648664-e50c-11e4-be23-0349d0a5f3cf  base-64-lts             14.4.1
      smartos  2015-04-17T14:15:04Z
    4166f6d6-ea5f-11e4-addd-8351b159d9b6  base-64                 15.1.0
      smartos  2015-04-24T08:52:36Z
    b67492c2-055c-11e5-85d8-8b039ac981ec  base-64-lts             14.4.2
      smartos  2015-05-28T17:12:26Z
    0edf00aa-0562-11e5-b92f-879647d45790  base-64                 15.1.1
      smartos  2015-05-28T17:50:41Z
    5c7d0d24-3475-11e5-8e67-27953a8b237e  base-64                 15.2.0
      smartos  2015-07-27T15:37:17Z

</div>

</div>

To download one of these images, say "base-64", we'll *import* it using
the images UUID:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    # imgadm import 5c7d0d24-3475-11e5-8e67-27953a8b237e
    Importing 5c7d0d24-3475-11e5-8e67-27953a8b237e (base-64@15.2.0) from
 "https://images.joyent.com"
    Gather image 5c7d0d24-3475-11e5-8e67-27953a8b237e ancestry
    Must download and install 1 image (127.2 MiB)
    Imported image 5c7d0d24-3475-11e5-8e67-27953a8b237e (base-64@15.2.0)

    # imgadm list
    UUID                                  NAME          VERSION       OS
       PUBLISHED
    5c7d0d24-3475-11e5-8e67-27953a8b237e  base-64  15.2.0   smartos  201
5-07-27T15:37:17Z

</div>

</div>

To learn how to create a Zone or VM from these images, please refer to:

- [How to create a zone (OS virtualized machine) in
    SmartOS](How%20to%20create%20a%20zone%20(%20OS%20virtualized%20machi
ne%20)%20in%20SmartOS.html "How to create a zone ( OS virtualized machin
e ) in SmartOS")
- [How to create a KVM VM (Hypervisor virtualized machine) in
    SmartOS](How%20to%20create%20a%20KVM%20VM%20(%20Hypervisor%20virtual
ized%20machine%20)%20in%20SmartOS.html "How to create a KVM VM ( Hypervi
sor virtualized machine ) in SmartOS")

Advanced Topics
===================

### What exactly *is* an Image?

An **image** is the data and metadata required to create a new VM. The
"data" is one or more compressed ZFS datasets which will be cloned to
create a new VM. The "metadata" describes, as JSON, the data and
outlines the specification for a machine that would utilize it.

Here is an example of the two files:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    benr@magnolia:~/datasets$ ls -lh
    total 41M
    -rw-rw-r-- 1 benr benr 996 Sep 10 14:54 smartos-1.3.12.dsmanifest
    -rw-rw-r-- 1 benr benr 41M Jun 10  2011 smartos-1.3.12.zfs.bz2

</div>

</div>

### Image Manifests

The following is an example manifest taken from the public repository
<https://datasets.joyent.com/datasets/> (re-arranged and line breaks
added for clarity).

You'll notice we have properties to identify the image (UUID, name,
version, description, etc), the author (creator\_name, creator\_uuid,
etc), when the image was created/updated/published, and then an array
identifying the ZFS Dataset file or files, and finally an array
outlining some requirements.

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

      {
        "uuid": "febaa412-6417-11e0-bc56-535d219f2590",
        "name": "smartos",
        "version": "1.3.12",
        "description": "Base template to build other templates on",

        "os": "smartos",
        "type": "zone-dataset",
        "platform_type": "smartos",
        "cloud_name": "sdc",
        "urn": "sdc:sdc:smartos:1.3.12",

        "creator_name": "sdc",
        "creator_uuid": "352971aa-31ba-496c-9ade-a379feaecd52",
        "vendor_uuid": "352971aa-31ba-496c-9ade-a379feaecd52",

        "created_at": "2011-04-11T08:45Z",
        "updated_at": "2011-04-11T08:45Z",
        "published_at": "2011-04-11T08:45Z",

        "files": [
          {
            "path": "smartos-1.3.12.zfs.bz2",
            "sha1": "246c9ae158dc8f204643afdd6bd4d3c4aa35e733",
            "size": 42016482,
            "url": "https://datasets.joyent.com/datasets/febaa412-6417-1
1e0-bc56-535d219f2590/smartos-1.3.12.zfs.bz2"
          }
        ],
        "requirements": {
          "networks": [
            {
              "name": "net0",
              "description": "public"
            }
          ]
        }
      }

</div>

</div>

When creating your own manifest, the following properties are required:

- **uuid**: The UUID of the image (use an [online UUID
    generator](http://www.guidgenerator.com/))
- **name**: The name of the image (eg: "centos-6")
- **version**: The version of the image (eg: "1.0.0")
- **description**: A short description of the image
- **published\_at**: A timestamp for the date of publication on an
    image server (this does not need to be accurate); to output the
    current time in the proper format use the command: *date
    +"%Y-%m-%dT%T.000Z"*
- **creator\_uuid**: The UUID of the author of the image (use an
    [online UUID generator](http://www.guidgenerator.com/) if you don't
    have one)
- **creator\_name**: The name of the image author
- **urn**: A special string for describing the image in the form
    "cloud\_name:creator\_name:name:version"; for the "cloud\_name" I
    suggest "smartos" if you are unsure, the creator name is usually
    your organization. The string should not contain spaces.
    (eg: "smartos:cuddletech:plan9:1.0.0")
- **type**: The type of image, either "zvol" for KVM or "zone-dataset"
    for Zones
- **os**: The OS of this image, required. As of this writing, must be
    one of smartos, linux, windows, bsd, illumos, other.
- **files**: An array of one or more file objects, containing the
    following properties for each:
    -   **path**: Local file path to the image data file (compressed
        zfs dump)
    -   **sha1**: The SHA1 for the image data file; to obtain the SHA1
        hash use: *digest -a sha1 &lt;file&gt;*
    -   **size**: The file size of the image data file; to obtain use:
        *ls -l &lt;file&gt;*

The requirements section is recommended but not currently required, nor
is it enforced.

### Creating a Custom Zone Image

The process of creating a zone image looks like this:

1.  Create and customize a zone as you wish
2.  Purge the logs, etc. and run the `sm-prepare-image` to make the
    machine image-ready (remember to read the warning message!).
3.  Halt the zone: *vmadm stop &lt;UUID&gt;*
4.  Snapshot the Zone dataset: *zfs snapshot zones/&lt;UUID&gt;@image*
5.  Dump & Compress the dataset: *zfs send zones/&lt;UUID&gt;@image |
    gzip &gt; image\_name.zfs.gz*
6.  Create the manifest as described above

You can now import the image locally via *imgadm* or transfer it to an
image server.

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   **Da
taset Compression**\
                                                                    Data
sets **must** be compressed. You may use either Xz, GZip, or BZip2. BZip
2 will offer a smaller file than GZip, but GZip compression is faster. P
articularly for datasets larger than 10GB, GZip is highly recommended. I
f all CNs you expect to use the image on are 20150402 or later, then Xz
is an option. Xz will provide better compression that BZip2 and is gener
ally close to GZip in speed. Xz is not available before release-20150402
.
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---

</div>

### Creating a Custom KVM Image

The process of creating a KVM image looks like this:

1.  Create and customize a KVM instance as you wish
2.  Purge and ready the instance
3.  Halt the VM: *vmadm stop &lt;UUID&gt;*
4.  Snapshot the disk0 ZVol: *zfs snapshot
    zones/&lt;UUID&gt;-disk0@image*
5.  Dump & Compress the dataset: *zfs send
    zones/&lt;UUID&gt;-disk0@image | gzip &gt; image\_name.zvol.gz*

You can now import the image locally via imgadm or transfer it to an
image server.

### Importing Images Locally

Typically images are downloaded from an image server, however they can
also be imported locally using: *imgadm -m &lt;manifest&gt; -f
&lt;file&gt;*

The process looks like this:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    # imgadm install -m smartos-1.3.12.dsmanifest -f smartos-1.3.12.zfs.
bz2
    febaa412-6417-11e0-bc56-535d219f2590 doesnt exist. continuing with i
nstall
    febaa412-6417-11e0-bc56-535d219f2590 successfully installed
    image febaa412-6417-11e0-bc56-535d219f2590 successfully imported

</div>

</div>

Serving Images
==================

The default community image (formerly *dataset*) server is
**datasets.joyent.com**. A wide variety of images are there for you to
use and build new images from. But what if you want to distribute your
own images for others to use? That's what we'll discuss here.

### How Image Server Work

The functions of an image are very simple. When an image server is added
to a clients **sources.list** and they preform an *imgadm update*, the
tool will preform an HTTP GET operation against the source URL. This get
will return an array of JSON objects which are dsmanifest files for each
available image. Here is an example:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    $ curl -ks https://datasets.joyent.com/datasets/
    [
      {
        "name": "mongodb",
        "version": "1.3.2",
        "type": "zone-dataset",
        "description": "64-bit MongoDB 2.0 SmartMachine Database Applian
ce with Quickbackup and Replica Sets",
        "published_at": "2012-08-31T16:04:51.970Z",
        "os": "smartos",
        "uuid": "6bf31ce2-f384-11e1-a338-e39c2fe4ab59",
        "creator_uuid": "352971aa-31ba-496c-9ade-a379feaecd52",
        "vendor_uuid": "352971aa-31ba-496c-9ade-a379feaecd52",
        "creator_name": "sdc",
        "platform_type": "smartos",
        "cloud_name": "sdc",
        "urn": "sdc:sdc:mongodb:1.3.2",
        "created_at": "2012-08-31T16:04:51.970Z",
        "updated_at": "2012-08-31T16:04:51.970Z",
        "files": [
          {
            "path": "mongodb-1.3.2.zfs.bz2",
            "sha1": "dff4787bcc8cd115a2307d1e833a49d23a1ad9b0",
            "size": 115202324,
            "url": "https://datasets.joyent.com/datasets/6bf31ce2-f384-1
1e1-a338-e39c2fe4ab59/mongodb-1.3.2.zfs.bz2"
          }
        ],
        "requirements": {
          "networks": [
            {
              "name": "net0",
    ....

</div>

</div>

When the client downloads an image using *imgadm import UUID*, by
default the client will download the image files (ZFS datasets)
specified in the manifest in the form:
&lt;source\_server\_url&gt;/&lt;image\_uuid&gt;/&lt;file\_path&gt;. So
in the example above the file downloaded will be
\*<https://datasets.joyent.com/datasets/6bf31ce2-f384-11e1-a338-e39c2fe4
ab59/mongodb-1.3.2.zfs.bz2*>.
You'll notice that the file in the manifest includes a URL, if present
it will be used, but it is not required.

The operation of an image server is therefore very simple and straight
forward.

### Creating a Poor Man's Image Server

As described above, the functions required of an "image" server are very
basic. Therefore we can emulate a dataset servers basic functions in the
following way:

1.  On your web server, create a directory for your SmartOS
    image server. We'll assume "images/" on <http://mysite.com>.
2.  Add each DS manifest into index.html. Do not include any HTML! We
    only use this filename because it is the default content sent when
    the directory is accessed. Remember that the file contains an array
    of manifest objects, therefore the format will be:
    <div class="preformatted panel" style="border-width: 1px;">

    <div class="preformattedContent panelContent">

        [
         { manifest1... },
         { manifest2... }
        ]

    </div>

    </div>

3.  For each image, create a directory using the images UUID,
    ie: "images/6bf31ce2-f384-11e1-a338-e39c2fe4ab59".
4.  Copy the image file(s) into the UUID directory
5.  Now try it! "curl -ks <http://mysite.com/images>" should return
    your objects.
6.  Add it to your **sources.list** and *imgadm update* to use.

The solution described here is not elegant, nor optimal, but is a viable
option for serving images from web accounts which do not have the option
of using the more elegant *smartos-image-server* described next.

### Using the *smartos-image-server*

A community image server project started by **nshalman** can be found on
github:
[smartos-image-server](https://github.com/nshalman/smartos-image-server)

The server is implemented in Node.js and implements the basic
functionality required to serve images. This is the recommended method
of serving images.

<div class="panelMacro">

  --------------------------------------------------------------- ------
------------------------------------------------------------------------
------------------------------------------------------------------------
----------------------------------------------------------
  ![](images/icons/emoticons/check.gif){width="16" height="16"}   **Comm
unity Image Servers**\
                                                                  Severa
l community image servers are available. To find the existing community
image servers, or to add your own, please go to the [3rd party datasets
page](3rd%20party%20datasets.html "3rd party datasets").
  --------------------------------------------------------------- ------
------------------------------------------------------------------------
------------------------------------------------------------------------
----------------------------------------------------------

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
| ### Can not import images locally
   |
|
   |
| Here comes the error info.
   |
|
   |
| \[root@b4-b5-2f-63-ef-20 /zones/imgadmInstall/ubuntu/liveimage\]\#
   |
| imgadm install -m test.dsmanifest -f ubuntulive.zvol.bz2\
   |
| ddab257c-09b9-4c82-9801-20386cc97338 doesnt exist. continuing with
   |
| install\
   |
| stream.js:81\
   |
|       throw er; // Unhandled stream error in pipe.\
   |
|             \^\
   |
| Error: write EPIPE\
   |
|     at errnoException (net.js:781:11)\
   |
|     at Object.afterWrite (net.js:594:19)\
   |
| \# imgadm install -m test.dsmanifest -f ubuntulive.zvol.bz2
   |
|
   |
| ddab257c-09b9-4c82-9801-20386cc97338 doesnt exist. continuing with
   |
| install
   |
|
   |
| stream.js:81
   |
|
   |
|       throw er; // Unhandled stream error in pipe.
   |
|
   |
|             \^
   |
|
   |
| Error: write EPIPE
   |
|
   |
|     at errnoException (net.js:781:11)
   |
|
   |
|     at Object.afterWrite (net.js:594:19)
   |
|
   |
| The local image was created through the way this page referred.
   |
|
   |
| 1.  Create and customize a KVM instance as you wish
   |
| 2.  Purge and ready the instance
   |
| 3.  Halt the VM: *vmadm stop &lt;UUID&gt;*
   |
| 4.  Snapshot the disk0 ZVol: *zfs snapshot
   |
|     zones/&lt;UUID&gt;-disk0@image*
   |
| 5.  Dump & Compress the dataset: *zfs send
   |
|     zones/&lt;UUID&gt;-disk0@image | gzip &gt; image\_name.zvol.gz*
   |
|
   |
|  About the first step, I did try two ways, "Use image imported from th
e  |
| imgadm avail" and "Created from a iso file". Both of them are failed
   |
| with the same error info.
   |
|
   |
| Could you please give a hand about this?
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
| tx\_seu@hotmail.com at Dec 06, 2012 08:25
   |
|
   |
| </div>
   |
+-----------------------------------------------------------------------
---+
|  <font class="smallfont">
   |
| The Serving Images section seems to be out of date/doesn't work since
   |
| the change from <font color="#29231a">DSAPI to IMGAPI.</font>
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
| ![](images/icons/comment_16.gif){width="16" height="16"} Posted by jau
er |
| at Oct 22, 2013 20:50
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


