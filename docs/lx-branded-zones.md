# LX Branded Zones

## Background

[Bryan's talk (both entertaining and informative)](https://www.youtube.com/watch?v=TrfD3pC0VSs&list=PLH8r-Scm3-2VmZhZ76tFPAhPOG0pvmjdA&index=6)
([slides](http://www.slideshare.net/bcantrill/illumos-lx))

## Getting Started

1. this worked on 2017-10-30
2. log into the SmartOS machine as user `root`
3. `imgadm avail` | egrep lx; (I chose `e74a9cd0-f2d0-11e6-8b69-b3acf2ef87f7`
   from
   <https://docs.joyent.com/public-cloud/instances/infrastructure/images/debian>)
4. `imgadm import e74a9cd0-f2d0-11e6-8b69-b3acf2ef87f7` to download the
   snapshot and install in zones pool
5. `imgadm show e74a9cd0-f2d0-11e6-8b69-b3acf2ef87f7` to figure out the
    kernel version
6. this command will create a running virtual machine, complete with
   disc/memory/network/cpu:

        vmadm create <<EOL
            {
             "brand": "lx",
             "kernel_version": "3.16.0",
             "image_uuid": "e74a9cd0-f2d0-11e6-8b69-b3acf2ef87f7",
             "alias": "pg",
             "hostname": "pg",
             "max_physical_memory": 8192,
             "quota": 3000,
             "resolvers": ["192.168.180.1", "8.8.8.8"],
             "nics": [
              {
                "nic_tag": "v",
                "ip": "192.168.180.182",
                "netmask": "255.255.255.0",
                "gateway": "192.168.180.1",
                "vlan_id": 180
              }
             ]
            }
        EOL

7. `vmadm list` gave me the ID for my running instance:

        UUID                                  TYPE  RAM      STATE   ALIAS
        9f7dfe6d-d6ec-e108-d3be-ce1638b5a7c2  LX    8192     running pg

8. I had difficulty logging into that machine (`zlogin
   9f7dfe6d-d6ec-e108-d3be-ce1638b5a7c2` should have worked, too), this is
   why I created this writeup in the first place.  This is how you can get
   yourself into the newly created machine

        cd /zones/9f7*/root/root/.ssh && cp ~/.ssh/id_pub.rsa authorized_keys

9. Log in

        ssh root@192.168.180.182

10. final note: my SmartOS machine was on vlan 180, if you don't do vlans,
    leave out the `vlan_id` line and preceding comma, probably your interface
    is called `admin`; change paramaters as desired

### Platform Version

For best results, run the latest SmartOS release available.

### Import images

The lx zone images are on images.joyent.com so make sure that's one of
your image sources. Then you can import images:

    imgadm sources -a https://images.joyent.com
    imgadm avail | grep lx-dataset   # See available images
    imgadm import 05140a7e-279f-11e6-aedf-47d4f69d2887    # ubuntu-16.04 20160601

### Create A Zone

Create a zone (replace the nic values with ones appropriate for your
network)

If you're not sure what these values mean or what units they are in,
check out the [vmadm man page](https://smartos.org/man/1m/vmadm)

    {
      "alias": "lxtest",
      "brand": "lx",
      "kernel_version": "4.3.0",
      "max_physical_memory": 2048,
      "quota": 10,
      "image_uuid": "05140a7e-279f-11e6-aedf-47d4f69d2887",
      "resolvers": ["8.8.8.8","8.8.4.4"],
      "nics": [
        {
          "nic_tag": "external",
          "ips": ["dhcp"],
          "primary": true
        }
      ]
    }

## Cool Tech Demos

A selection of impressive demonstrations of the LX brand's capabilities.
Please add your favorites here.

### Show your friends

- X11 forwarded [Firefox](http://i.imgur.com/SkHLlxs.png) and
  [Thunderbird](http://i.imgur.com/hd0Spyc.png) in lx32 zone
- Plex Media Server usable on lx32 and lx64
- dtrace a linux binary
- [Video of docker in SDC (coming soon to the JPC)](https://www.joyent.com/developers/videos/docker-and-the-future-of-containers-in-production)
- (your favorite demo here)

### Networking

AF_INET and AF_INET6 mostly working (2014-12-19). Still have some sockopts missing.

ipadm is not working inside the lx brand, /native/sbin/ifconfig is usable.

#### Enabling IPv6 SLAAC auto configuration

Add `addrconf` to the `ips` array for the NIC to perform SLAAC and/or
DHCPv6 as appropriate.

### X11 forwarding

This is working fine on both 32-bit and 64-bit. After pmooney's
AF_INET6 commit this is working fine out of the box!

## Debugging

If debugging LX branded zones, first watch this video: [Debugging LX
branded zones on SmartOS](https://www.youtube.com/watch?v=6oIBiWdh41c)

### DTrace

### Enabling `lx_debug` probes

As the video above mentioned, probes associated with `lx_debug` (that
is, output associated with the `LX_DEBUG` environment variable) are
turned on it `LX_DTRACE` is set to a non-zero value in the environment.
However, this is not helpful if in a context that is hard to set
environment variable (e.g., early in boot). The video above neglected to
mention how to enable DTrace probes in this case. To do this, you must
first change the disposition of the brand to enable these by default by
modifying the binary. From the global zone, do the following:

    cp /usr/lib/amd64/lx_brand.so.1 /var/tmp
    cp /usr/lib/amd64/lx_brand.so.1 /var/tmp/lx_brand.so.1.$$
    echo "lx_dtrace_lazyload?W 0" | mdb -w /var/tmp/lx_brand.so.1.$$
    mount -O -F lofs /var/tmp/lx_brand.so.1.$$ /usr/lib/amd64/lx_brand.so.1

(If debugging 32-bit, the `lx_brand.so.1` that should be copied and
mounted over should be `/usr/lib/lx_brand.so.1` not
`/usr/lib/amd64/lx_brand.so.1`.)

At that point, `lx``pid``:::debug` probes should show up as processes
start, which will allow you to see where things are failing:

    dtrace -Zqn lx*:::debug'{printf("%s", copyinstr(arg0))}'

(String size and switch rate should be adjusted up if truncated strings
or drops are seen.)

When debugging a new distro or otherwise debugging the death of
processes before you can login, you can

### hunting for unsupported syscalls

With a dtrace script, `lxunsup.d`

    #!/usr/sbin/dtrace -s

    #pragma D option quiet

    BEGIN
    {
        printf("%6s %20s %s\n", "PID", "NAME", "CALL")
    }

    sdt:lx_brand::brand-lx-unsupported
    {
        printf("%6d %20s %S\n", pid, execname, stringof(arg0));
    }

And some 1-liners.

<!-- markdownlint-disable line-length -->

    dtrace -n 'sdt:lx_brand::brand-lx-unsupported {@num[execname,stringof(arg0)] = count()}'

<!-- -->

    dtrace -n 'lx-syscall::setsockopt:entry /arg1 == 0 && arg2 == 35/ { trace(arg4) }'

<!-- markdownlint-enable line-length -->

Harmless unsupported syscalls

- `prctl(PR_SET_DUMPABLE)`
  - allow process to enable coredumps, should have no functional impact
- `prctl option 4`
  - same as PR_SET_DUMPABLE
- `set_robust_list / get_robust_list`
  - part of libc initialization, but if the feature is never used, then
    it doesn't really end up mattering.
- `futex 0x9`
  - usespace mutex call, mostly harmless
- `socket flag MSG_CMSG_CLOEXEC`
  - auto close fd's... dbus spamsthese a lot. Looks like they get
    closed anyway.
- `ioctl 0xc020660b (fiemap)`
  - used to find holes in files by querying the inode extend info, apt
    tries to use this. have not noticed any impact.

### Probing socket options

This is handy for figuring out why a networking app is not behaving
properly.

D script `lxsockopt.d`

    #!/usr/sbin/dtrace -s

    #pragma D option quiet

    /*
     * PROTO values can be found here:
     * https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers
     * SOCKOPT values can be found here:
     * https://github.com/TritonDataCenter/illumos-joyent/blob/master/usr/src/lib/brand/lx/lx_brand/common/socket.c
     */
    BEGIN
    {
        printf("%6s %20s %5s %s\n", "PID", "NAME", "PROTO", "SOCKOPT");
    }

    lx-syscall::setsockopt:entry
    {
        printf("%6d %20s %5d %d\n", pid, execname, arg1, arg2);
    }

<!-- -->

Or, a 1-liner

    dtrace -n 'lx-syscall::setsockopt:entry { @num[execname,arg2] = count()}'

## Docker

[Bryan's talk and demo of sdc-docker](https://www.joyent.com/developers/videos/docker-and-the-future-of-containers-in-production)

- <https://github.com/TritonDataCenter/smartos-live/blob/master/src/dockerinit/README.md>
- <https://github.com/TritonDataCenter/smartos-live/commit/06610676fc05aca2938eb7b8bb07485f3709e9e3>
- <https://github.com/TritonDataCenter/illumos-joyent/commit/e7225aa358c52af4e3ba284399ea8b34fb8348df>
- <https://github.com/TritonDataCenter/sdc-docker>

## Vagrant

Initial support for lx brand is complete:

- [Quickstart example](https://gist.github.com/bixu/782a4e67644b2fdb1000)
- <https://github.com/vagrant-smartos/vagrant-smartos-zones>

## Random Notes

### Using /native binaries to work

SmartOS (in fact, the entire SmartOS userland) binaries are mounted in
`/native` in all LX zones. They mostly work, but some native binaries execute
other native binaries. (For example, `arp` calls `netstat`.)
For programs written in C, this can be fixed, so please file a ticket if
it doesn't work in a recent release.

### Creating your own zone dataset

- <https://github.com/TritonDataCenter/debian-lx-brand-image-builder>
- <https://github.com/TritonDataCenter/ubuntu-lx-brand-image-builder>
- <https://github.com/TritonDataCenter/centos-lx-brand-image-builder>
- <https://github.com/TritonDataCenter/sdc-vmtools-lx-brand>
- <https://github.com/TritonDataCenter/lx-brand-image-tests>
- <https://us-central.manta.mnx.io/jperkin/public/lximg/README>

### Joyent CI builds

If you run into a new bug, someone might ask you to try the latest CI
build after it's been fixed. This is how.

The Joyent CI system constantly rebuilds the platform tarball when there
are new commits.
You can extract that image and put into place on e.g. an existing
SmartOS USB stick to obtain the latest and greatest code from Joyent.

You can download that platform tarball like so:

    MANTA_URL=https://us-central.manta.mnx.io
    LATEST=$(curl ${MANTA_URL}/Joyent_Dev/public/builds/platform/master-latest)
    curl -O ${MANTA_URL}${LATEST}/platform/platform-master-${LATEST##*-}.tgz

To update an existing SmartOS USB stick:

1. Extract that tarball onto your USB stick (you'll get a directory
   named "platform-&lt;datestamp&gt;")
2. Move aside the directory named "platform" to e.g. "platform-orig"
3. Rename "platform-&lt;datestamp&gt;" to "platform"
4. Boot from your USB stic
