# LX Brand Development

As changes are made in the Linux kernel and new Linux distribution releases
make use of them, illumos may not yet support those features. Periodically we
need to add new LX facilities for compatiblity with those newer binaries.

The following is an unstructured collection of notes for working on identifying
what's missing from illumos when Linux binaries aren't behaving properly.

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

* `prctl(PR_SET_DUMPABLE)`
    * allow process to enable coredumps, should have no functional impact
* `prctl option 4`
    * same as PR_SET_DUMPABLE
* `set_robust_list / get_robust_list`
    * part of libc initialization, but if the feature is never used, then
      it doesn't really end up mattering.
* `futex 0x9`
    * usespace mutex call, mostly harmless
* `socket flag MSG_CMSG_CLOEXEC`
    * auto close fd's... dbus spamsthese a lot. Looks like they get
      closed anyway.
* `ioctl 0xc020660b (fiemap)`
    * used to find holes in files by querying the inode extend info, apt
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

[Bryan's talk and demo of sdc-docker](https://www.tritondatacenter.com/developers/videos/docker-and-the-future-of-containers-in-production)

* <https://github.com/TritonDataCenter/smartos-live/blob/master/src/dockerinit/README.md>
* <https://github.com/TritonDataCenter/smartos-live/commit/06610676fc05aca2938eb7b8bb07485f3709e9e3>
* <https://github.com/TritonDataCenter/illumos-joyent/commit/e7225aa358c52af4e3ba284399ea8b34fb8348df>
* <https://github.com/TritonDataCenter/sdc-docker>

## Vagrant

Initial support for lx brand is complete:

* [Quickstart example](https://gist.github.com/bixu/782a4e67644b2fdb1000)
* <https://github.com/vagrant-smartos/vagrant-smartos-zones>

## Random Notes

### Using /native binaries to work

SmartOS (in fact, the entire SmartOS userland) binaries are mounted in
`/native` in all LX zones. They mostly work, but some native binaries execute
other native binaries. (For example, `arp` calls `netstat`.)
For programs written in C, this can be fixed, so please file a ticket if
it doesn't work in a recent release.

### Creating your own zone dataset

* <https://github.com/TritonDataCenter/debian-lx-brand-image-builder>
* <https://github.com/TritonDataCenter/ubuntu-lx-brand-image-builder>
* <https://github.com/TritonDataCenter/centos-lx-brand-image-builder>
* <https://github.com/TritonDataCenter/sdc-vmtools-lx-brand>
* <https://github.com/TritonDataCenter/lx-brand-image-tests>
* <https://us-central.manta.mnx.io/jperkin/public/lximg/README>

### Triton CI builds

If you run into a new bug, someone might ask you to try the latest CI
build after it's been fixed. This is how.

The Triton CI system constantly rebuilds the platform tarball when there
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
