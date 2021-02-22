# How to create a Virtual Machine in SmartOS

In SmartOS, virtual machines are created using the `vmadm create` tool.
This tool takes a JSON payload and creates a
zone with the properties specified in the input JSON. Normal
output is a series of single-line JSON objects with type set to one of:

- success
- failure
- update
- notice

each object having at least the 'type' and 'message' fields. A message
of type 'success' or 'failure' will be followed by the process exiting
with the exit status 0 indicating success and all other exits indicating
failure.

    vmadm create -f <filename.json>

## Getting Started

You will need

- The latest copy of SmartOS, available from
  <http://download.joyent.com> (release details [here](download-smartos.md))
- The ISO of your OS of choice
- A VNC client

## The Machine JSON Description

Save the code snippet below to a file called "vmspec.json". You can make
changes to the networks and other variables as appropriate. This is by
no means an exhaustive list of all options. For all options see
[vmadm(1m)](https://smartos.org/man/1m/vmadm). (Sizes are listed in MiB)

    {
      "brand": "kvm",
      "vcpus": 1,
      "autoboot": false,
      "ram": 1024,
      "resolvers": ["208.67.222.222", "208.67.220.220"],
      "disks": [
        {
          "boot": true,
          "model": "virtio",
          "size": 40960
        }
      ],
      "nics": [
        {
          "nic_tag": "admin",
          "model": "virtio",
          "ip": "10.88.88.51",
          "netmask": "255.255.255.0",
          "gateway": "10.88.88.1",
          "primary": 1
        }
      ]
    }

When installing OS's that do not ship with `virtio` support instead of using
`virtio` on the disk for the model use `ide` and `e1000` for the network
model.

## Create the Empty Virtual Machine

Create the empty virtual machine using the create-machine tool. Please
note that the virtual machine will not be running.

    vmadm create

Note the UUID in the last step. This UUID is the ID of the VM and will
be used to reference it for the rest of its lifecycle.

<!-- markdownlint-disable line-length -->

    $ vmadm create < vmspec.json
    {"percent":1,"type":"update","message":"checking and applying defaults to payload"}
    {"percent":2,"type":"update","message":"checking required datasets"}
    {"percent":28,"type":"update","message":"we have all necessary datasets"}
    {"percent":29,"type":"update","message":"creating volumes"}
    {"percent":51,"type":"update","message":"creating zone container"}
    {"percent":94,"type":"update","message":"storing zone metadata"}
    {"uuid":"b8ab5fc1-8576-45ef-bb51-9826b52a4651","type":"success","message":"created VM"}

<!-- markdownlint-enable line-length -->

## Copy your OS ISO to the zone

The path to the ISO image in the json is relative to the root of the zone.

    cd /zones/b8ab5fc1-8576-45ef-bb51-9826b52a4651/root/
    wget http://mirrors.debian.com/path_to_an_iso/debian.iso

## Ensure permissions are correct on the ISO

    chown root debian.iso
    chmod u+r debian.iso

## Boot the VM from the ISO Image

`vmadm` is the virtual machine administration tool. It is used to manage
the lifecycle of a virtual machine after it already exists. We will boot
the virtual machine we have just created, but tell it to boot off of the
ISO image the first time it comes up.

    vmadm boot b8ab5fc1-8576-45ef-bb51-9826b52a4651 order=cd,once=d cdrom=/debian.iso,ide

Please note that the path for the ISO image will be the relative path of
the ISO to the zone you are in. This is why it starts with the '/'

If you are booting from an img file rather than an iso, this may not work.  
Instead try:

    vmadm boot b8ab5fc1-8576-45ef-bb51-9826b52a4651 disk=/debian.img,ide

## Use VNC to Connect to the VM

The `vmadm` tool can print out the information on the VM. You can also
append a section to print specificially.

    $ vmadm info b8ab5fc1-8576-45ef-bb51-9826b52a4651 vnc
    {
      "vnc": {
        "display": 39565,
        "port": 45465,
        "host": "10.99.99.7"
      }
    }

Your VM is now running. You can shutdown your virtual machine and it
will still remain on disk. To learn more about managing the lifecycle of
a virtual machine, run `vmadm --help`.

## Troubleshooting

### Zone Networking Issues

If you are running SmartOS as a guest vm then you might have networking
issues with your zones. In order to fix this we need to create a
bridge.
If you look at
<https://github.com/joyent/smartos-overlay/blob/master/lib/svc/method/net-physical#L179>
You can see that the script will create a bridge for vmare products but
if you are using VirtualBox or Parallells then you need to do it
manually.

<!-- markdownlint-disable line-length -->

    $ ifconfig -a
    e1000g0: flags=1100943<UP,BROADCAST,RUNNING,PROMISC,MULTICAST,ROUTER,IPv4> mtu 1500 index 2
            inet 10.216.214.7 netmask ffffff00 broadcast 10.216.214.255
            ether 8:0:27:e1:35:cb
    $ dladm create-bridge -l e1000g0 vboxbr

<!-- markdownlint-enable line-length -->

Your zones should now be able to access the network. You don't need to
change the `nic_tag` for any of the zones, leave them as `admin` or
`external`.

There is a way to make this happen on boot with my adding an smf script
to `/opt/custom/smf`. Here is a nice write up that shows you how it's
done.
<http://www.psychicfriends.net/blog/archives/2012/03/21/smartosorg_run_things_at_boot.html#003979>

## Further Reading

Those versed in JavaScript can learn a lot more by reading the
[vmadm.js source](https://github.com/joyent/smartos-live/blob/master/src/vm/sbin/vmadm.js).
