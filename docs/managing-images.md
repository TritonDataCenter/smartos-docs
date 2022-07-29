# Managing Images

<!-- markdownlint-disable no-trailing-punctuation -->
<!-- These are FAQs, after all -->

SmartOS relies on *images* heavily. Images are templates that contain a
disk or filesystem image and metadata which are using when creating new
Zones or VM's.

Images are managed using the `imgadm` tool. With this tool you can:

- View & Download images available on a public image server
- Import remote images or Install from local images
- List, Show or Print details about an image
- Destroy images

Here we'll discuss how to find available images and start using them.
Then we'll look at what images are and how to create our own.   Finally,
we look at how to create your own private image server.

## Basics

### Viewing & Downloading Public Images

The default image server is <https://images.joyent.com>. You can edit
this list of sources using the `imgadm sources -a <URL>` command,
as documented in [imgadm(1m)](https://smartos.org/man/1m/imgadm). Using
the command `imgadm update`, you'll cause the local cache
(`/var/db/imgadm/imgcache.json`) to be updated with the available
images on the servers found in your sources.list. Once your local cache
is updated, you can list all available images for use using `imgadm avail`:

<!-- markdownlint-disable line-length -->

    # imgadm avail | head -n 1 ; imgadm avail | tail
    UUID                                  NAME                VERSION         OS       PUBLISHED
    380539c4-3198-11e5-82c8-bf9eeee6a395  debian-7                20150724    linux    2015-07-24T00:09:14Z
    ab3db4c0-31ac-11e5-8856-43e56a8e4285  centos-6                20150724    linux    2015-07-24T02:35:38Z
    7459f182-31af-11e5-b23a-eb0fd8799c77  freebsd-10              20150724    bsd      2015-07-24T02:55:34Z
    ead4ff68-320a-11e5-bd54-3749d04712df  ubuntu-14.04            20150724    linux    2015-07-24T13:50:17Z
    0764d78e-3472-11e5-8949-4f31abea4e05  minimal-32              15.2.0      smartos  2015-07-27T15:13:25Z
    8ec06130-3472-11e5-bf91-ebc747dbae7e  minimal-64              15.2.0      smartos  2015-07-27T15:17:13Z
    1e5d6e28-3473-11e5-9e94-1fd77993b49f  minimal-multiarch       15.2.0      smartos  2015-07-27T15:21:14Z
    2bd52afe-3474-11e5-b07d-c7fb14b2c9e8  base-32                 15.2.0      smartos  2015-07-27T15:28:46Z
    5c7d0d24-3475-11e5-8e67-27953a8b237e  base-64                 15.2.0      smartos  2015-07-27T15:37:17Z
    9caff6c6-3476-11e5-9951-bf98c6cb8636  base-multiarch          15.2.0      smartos  2015-07-27T15:46:14Z

    # imgadm avail | grep base-64 | tail
    c02a2044-c1bd-11e4-bd8c-dfc1db8b0182  base-64-lts             14.4.0      smartos  2015-03-03T15:55:44Z
    24648664-e50c-11e4-be23-0349d0a5f3cf  base-64-lts             14.4.1      smartos  2015-04-17T14:15:04Z
    4166f6d6-ea5f-11e4-addd-8351b159d9b6  base-64                 15.1.0      smartos  2015-04-24T08:52:36Z
    b67492c2-055c-11e5-85d8-8b039ac981ec  base-64-lts             14.4.2      smartos  2015-05-28T17:12:26Z
    0edf00aa-0562-11e5-b92f-879647d45790  base-64                 15.1.1      smartos  2015-05-28T17:50:41Z
    5c7d0d24-3475-11e5-8e67-27953a8b237e  base-64                 15.2.0      smartos  2015-07-27T15:37:17Z

<!-- markdownlint-enable line-length -->

To download one of these images, say "base-64", we'll *import* it using
the images UUID:

    # imgadm import 5c7d0d24-3475-11e5-8e67-27953a8b237e
    Importing 5c7d0d24-3475-11e5-8e67-27953a8b237e (base-64@15.2.0) from "https://images.joyent.com"
    Gather image 5c7d0d24-3475-11e5-8e67-27953a8b237e ancestry
    Must download and install 1 image (127.2 MiB)
    Imported image 5c7d0d24-3475-11e5-8e67-27953a8b237e (base-64@15.2.0)

    # imgadm list
    UUID                                  NAME     VERSION       OS  PUBLISHED
    5c7d0d24-3475-11e5-8e67-27953a8b237e  base-64  15.2.0   smartos  2015-07-27T15:37:17Z

To learn how to create a Zone or VM from these images, please refer to:

- [How to create a zone](how-to-create-a-zone.md)
- [How to create an HVM zone](how-to-create-an-hvm-zone.md)

## Advanced Topics

### What exactly *is* an Image?

An **image** is the data and metadata required to create a new VM. The
"data" is one or more compressed ZFS datasets which will be cloned to
create a new VM. The "metadata" describes, as JSON, the data and
outlines the specification for a machine that would utilize it.

Here is an example of the two files:

    benr@magnolia:~/datasets$ ls -lh
    total 41M
    -rw-rw-r-- 1 benr benr 996 Sep 10 14:54 smartos-1.3.12.dsmanifest
    -rw-rw-r-- 1 benr benr 41M Jun 10  2011 smartos-1.3.12.zfs.bz2

### Image Manifests

The following is an example manifest taken from the public repository
<https://datasets.joyent.com/datasets/> (re-arranged and line breaks
added for clarity).

You'll notice we have properties to identify the image (UUID, name,
version, description, etc), the author (creator\_name, creator\_uuid,
etc), when the image was created/updated/published, and then an array
identifying the ZFS Dataset file or files, and finally an array
outlining some requirements.

<!-- markdownlint-disable line-length -->

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
            "url": "https://datasets.joyent.com/datasets/febaa412-6417-11e0-bc56-535d219f2590/smartos-1.3.12.zfs.bz2"
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

<!-- markdownlint-enable line-length -->

When creating your own manifest, the following properties are required:

- **uuid**: The UUID of the image (use an [online UUID
  generator](http://www.guidgenerator.com/))
- **name**: The name of the image (eg: "centos-6")
- **version**: The version of the image (eg: "1.0.0")
- **description**: A short description of the image
- **published\_at**: A timestamp for the date of publication on an
  image server (this does not need to be accurate); to output the
  current time in the proper format use the command: `date +"%Y-%m-%dT%T.000Z"`
- **creator\_uuid**: The UUID of the author of the image (use an
  [online UUID generator](http://www.guidgenerator.com/) if you don't
  have one)
- **creator\_name**: The name of the image author
- **urn**: A special string for describing the image in the form
  `cloud_name:creator_name:name:version`; for the `cloud_name` I
  suggest `smartos` if you are unsure, the creator name is usually
  your organization. The string should not contain spaces.
  (eg: `smartos:cuddletech:plan9:1.0.0`)
- **type**: The type of image, either `zvol` for KVM or `zone-dataset`
  for Zones
- **os**: The OS of this image, required. As of this writing, must be
  one of smartos, linux, windows, bsd, illumos, other.
- **files**: An array of one or more file objects, containing the
  following properties for each:
  - **path**: Local file path to the image data file (compressed
  zfs dump)
  - **sha1**: The SHA1 for the image data file; to obtain the SHA1
  hash use: `digest -a sha1 <file>`
  - **size**: The file size of the image data file; to obtain use:
  `ls -l <file>`

The requirements section is recommended but not currently required, nor
is it enforced.

### Creating a Custom Zone Image

The process of creating a zone image looks like this:

1. Create and customize a zone as you wish
2. Purge the logs, etc. and run the `sm-prepare-image` to make the
   machine image-ready (remember to read the warning message!).
3. Halt the zone: `vmadm stop <uuid>`
4. Snapshot the Zone dataset: `zfs snapshot zones/<uuid>@image`
5. Dump & Compress the dataset: `zfs send zones/<uuid>@image |
   gzip > image_name.zfs.gz`
6. Create the manifest as described above

You can now import the image locally via `imgadm` or transfer it to an
image server.

#### Dataset Compression

Datasets **must** be compressed. You may use either Xz, GZip, or BZip2.
Currently, GZip is preferred. GZip is compatible with all platform images,
and modern platforms have `pigz`, making gzip fastest as well.

### Creating a Custom KVM Image

The process of creating a KVM image looks like this:

1. Create and customize a KVM instance as you wish
2. Purge and ready the instance
3. Halt the VM: `vmadm stop <UUID>`
4. Snapshot the disk0 ZVol: `zfs snapshot zones/<UUID>-disk0@image`
5. Dump & Compress the dataset: `zfs send zones/<UUID>-disk0@image | gzip > image_name.zvol.gz`

You can now import the image locally via imgadm or transfer it to an
image server.

### Importing Images Locally

Typically images are downloaded from an image server, however they can
also be imported locally using: `imgadm install -m <manifest> -f <file>`

The process looks like this:

    # imgadm install -m smartos-1.3.12.dsmanifest -f smartos-1.3.12.zfs. bz2
    febaa412-6417-11e0-bc56-535d219f2590 doesnt exist. continuing with install
    febaa412-6417-11e0-bc56-535d219f2590 successfully installed
    image febaa412-6417-11e0-bc56-535d219f2590 successfully imported

## Serving Images

If you want to run your own image repository service, see the imgapi
[Standalone Setup](https://github.com/TritonDataCenter/sdc-imgapi/blob/master/docs/operator-guide.md#standalone-setup)
guide and accompanying
[imgapi documentation](https://github.com/TritonDataCenter/sdc-imgapi/blob/master/docs/index.md).
