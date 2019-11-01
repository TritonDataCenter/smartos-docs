# How to create a zone

OS Virtualized Machines, hereafter referred to as Zones, is a
lightweight virtualization technology. Zones are fully isolated
user-land environments, they do not possess their own kernel and
therefore have effectively no performance overhead allowing for bare
metal performance. Network and disk virtualization are provided by ZFS
and the SmartOS networking stack ("Crossbow"). The result is a virtual
environment that in every way acts like a complete environment.

## Creating Zones

The process of creating zones is simple:

1. Download a Zone Image
2. Create a Manifest describing the Zone
3. Create the Zone using *vmadm*
4. Use the Zone

### Obtaining a Zone Image

Zone creation requires an
[image](managing-images.md) to use as a template.

To find a zone image, use the command `imgadm avail`. Images with the
OS type "smartos" are zone images. The "base" and "base-64" images are
minimal images with only a basic 32bit or 64bit
[pkgsrc](working-with-packages.md) installation and should be considered
for building your own custom images.

<!-- markdownlint-disable line-length -->

    # imgadm avail name=base-64
    UUID                                  NAME     VERSION  OS       TYPE          PUB
    163cd9fe-0c90-11e6-bd05-afd50e5961b6  base-64  16.1.0   smartos  zone-dataset  2016-04-27
    13f711f4-499f-11e6-8ea6-2b9fb858a619  base-64  16.2.0   smartos  zone-dataset  2016-07-14
    adf9565c-8be6-11e6-a077-57637270218d  base-64  16.3.0   smartos  zone-dataset  2016-10-06
    70e3ae72-96b6-11e6-9056-9737fd4d0764  base-64  16.3.1   smartos  zone-dataset  2016-10-20
    f6acf198-2037-11e7-8863-8fdd4ce58b6a  base-64  17.1.0   smartos  zone-dataset  2017-04-13
    643de2c0-672e-11e7-9a3f-ff62fd3708f8  base-64  17.2.0   smartos  zone-dataset  2017-07-12

<!-- markdownlint-enable line-length -->

Import an image by specifying its UUID:

    # imgadm import 643de2c0-672e-11e7-9a3f-ff62fd3708f8
    Importing 643de2c0-672e-11e7-9a3f-ff62fd3708f8 (base-64@17.2.0) from "https://images.joyent.com"
    Gather image 643de2c0-672e-11e7-9a3f-ff62fd3708f8 ancestry
    Must download and install 1 image (176.6 MiB)
    Imported image 643de2c0-672e-11e7-9a3f-ff62fd3708f8 (base-64@17.2.0)

You will reference this image's UUID when you create the zone manifest.

### The Zone Manifest

A manifest is a JSON object which describes your zone. There are many
options which are fully described in the
[vmadm(1m)](https://smartos.org/man/1m/vmadm) man page. The most
important are:

- `brand`: This must be set to "joyent" for Zones
- `image_uuid`: The UUID of the image you are using as a template
  (images were previously called "datasets")
- `alias`: An arbitrary name displayed in `vmadm list` output in
  addition to the UUID
- `hostname`: Hostname that will be set within the zone
- `max_physical_memory`: Amount of RAM (RSS) available to the zone
  in MB
- `quota`: Amount of disk space in GB
- `resolvers:` DNS nameservers for this zone to use (placed in the
  zone's `/etc/resolv.conf` file)
- `nics`: One or more network interfaces attached to this zone

Here is an example json payload.

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

#### Passing SSH keys to the VM

With most images you won't be able to log in to unless you pass an SSH
public key to validate your connection with. Adjust your config to
contain a `customer_metadata` block:

<!-- markdownlint-disable line-length -->

    "customer_metadata": {
        "root_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8aQRt2JAgq6jpQOT5nukO8gI0Vst+EmBtwBz6gnRjQ4Jw8pERLlMAsa7jxmr5yzRA7Ji8M/kxGLbMHJnINdw/TBP1mCBJ49TjDpobzztGO9icro3337oyvXo5unyPTXIv5pal4hfvl6oZrMW9ghjG3MbIFphAUztzqx8BdwCG31BHUWNBdefRgP7TykD+KyhKrBEa427kAi8VpHU0+M9VBd212mhh8Dcqurq1kC/jLtf6VZDO8tu+XalWAIJcMxN3F3002nFmMLj5qi9EwgRzicndJ3U4PtZrD43GocxlT9M5XKcIXO/rYG4zfrnzXbLKEfabctxPMezGK7iwaOY7w== wooyay@houpla",
        "user-script" : "/usr/sbin/mdata-get root_authorized_keys > ~root/.ssh/authorized_keys ; /usr/sbin/mdata-get root_authorized_keys > ~admin/.ssh/authorized_keys"
    }

<!-- markdownlint-enable line-length -->

### Creating the Zone

With your image imported and your manifest created, you can now create
the zone. Do this by simply passing the manifest to `vmadm create -f
manifest.json`:

    # vmadm create -f web01.json
    Successfully created VM d6a0a022-3855-4762-a2e5-3f16969ca2fb

Alternatively, you can pass the manifest via STDIN:

    # vmadm create <<EOL
      (manifest json here)
    EOL

The zone is now created and running.

### Connecting to your Zone

Once you have created a zone with `vmadm create`, you can log into your
zone via ssh or connect to the console with one of two methods:

    vmadm console UUID

or

    zlogin UUID

Please refer to the manpage for
[vmadm(1m)](https://smartos.org/man/1m/vmadm) and
[zlogin(1)](https://smartos.org/man/1/zlogin) respectively, for the
escape sequence to exit out of console mode.
