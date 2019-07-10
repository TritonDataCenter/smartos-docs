# Extending smartos-live

The design of smartos-live makes it easy to add additional software for
the purpose of making custom live images and extending the SmartOS core.
To facilitate this we have what we call 'local' projects.

Examples of local projects include:

- kvm
- kvm-cmd
- mdata-client
- ur-agent

To get started with this the first things that you would do are:

1. Make a directory or clone in a repository for your project in
   projects/local/
2. Create a file called Makefile.joyent
3. Add the required targets to Makefile.joyent
4. Go back to the smartos-live root and run gmake world and gmake live

The details of what needs to go into this Makefile are below.
[Here](https://github.com/joyent/illumos-kvm-cmd/blob/master/Makefile.joyent)
is an example of the Makefile that we use for kvm-cmd.

The local projects are built after illumos-joyent and illumos-extra.
Anything can be added in there. The main requirement is to add a
Makefile that has specific targets. If you're adding something that
already has its own Makefile that you don't want to modify, then you
should name it Makefile.joyent.

The required targets are:

- `world`
- `install`
- `manifest`
- `mancheck_conf`
- `update`
- `clean`

The world target should take care of building everything required for a
local project. Note some projects may not have anything to do here.

The install target installs built files into the proto area. The root of
the proto area is always defined as `$(DESTDIR)`.

The manifest target is where you need to specify what files need to be
copied from the proto area into the live image. The manifest should be a
file that is placed in: `$(DESTDIR)/$(DESTNAME)`. An example of a
manifest file as used by kvm is:

    d usr 0755 root sys
    d usr/kernel 0755 root sys
    d usr/kernel/drv 0755 root sys
    d usr/kernel/drv/amd64 0755 root sys
    f usr/kernel/drv/amd64/kvm 0755 root sys
    f usr/kernel/drv/kvm.conf 0644 root sys
    d usr/lib 0755 root bin
    d usr/lib/devfsadm 0755 root sys
    d usr/lib/devfsadm/linkmod 0755 root sys
    f usr/lib/devfsadm/linkmod/JOY_kvm_link.so 0755 root sys
    d usr/lib/mdb 0755 root sys
    d usr/lib/mdb/kvm 0755 root sys
    d usr/lib/mdb/kvm/amd64 0755 root sys
    f usr/lib/mdb/kvm/amd64/kvm.so 0555 root sys

The `mancheck_conf` target should produce and copy a `mancheck.conf` file
that describes check rules for shipping manual pages from the proto
area.  If no mancheck configuration is required, the target may exit
successfully without touching any files.

The update target is when someone has requested to update your project.
This may be as simple as a git pull.

The clean target asks you to clean up everything that you have
generated.

It is entirely plausible that these targets have no meaning for what
you're doing. For example, if you had a series of man pages, you
wouldn't have to build anything and you wouldn't have to clean anything.
