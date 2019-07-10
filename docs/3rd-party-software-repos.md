# 3rd Party Software Repos

## EveryCity Userland for SmartOS and Solaris 10

Summary: A stack containing software useful for web hosting (Such as PHP
5.2, 5.3, 5.4 and MySQL 5.5) on SmartOS and Solaris 10, using the IPS
package manager from OpenSolaris/OpenIndiana/Solaris 11. Installs
software to `/ec`.  Created by
[EveryCity Managed Hosting](http://www.everycity.com).

Key Features: Integration with SMF, DTrace probes for core software,
combined 32bit/64bit packages, kept up to date with latest
Apache/PHP/MySQL/etc. For a list of software please see the catalogues on
the package repositories:

<!-- markdownlint-disable line-length -->

| Repository              | Target OS                      | BootStrap
| ----------------------- | ------------------------------ | --------- |
| <http://smartos.pkg.ec> | SmartOS & Joyent SmartMachines | [pkg5-smartos-bootstrap-20111221.tar.gz](http://svn.everycity.co.uk/public/solaris/misc/pkg5-smartos-bootstrap-20111221.tar.gz) |
| <http://s10.pkg.ec>     | Solaris 10                     | [pkg5-s10-bootstrap-20110518.tar.gz](http://svn.everycity.co.uk/public/solaris/misc/pkg5-s10-bootstrap-20110518.tar.gz) |

<!-- markdownlint-enable line-length -->

### Installing EveryCity Userland

Installation is incredibly simple:

    cd / && wget -O- -q BOOTSTRAPARCHIVE | gtar -zxf-

(Replacing BOOTSTRAPARCHIVE with a link to the bootstrap tarball from
the table above for your platform). Note on SmartOS this may produce
warnings about /lib/svc not being writable - these can safely be
ignored, they are pkg5 manifests that are not needed.

This extracts everything to `/ec` - you can then install packages by doing:

    /ec/bin/pkg install foobar

You will then need to adjust the runtime linker search path to look in
`/ec/lib`:

    crle -l /lib:/usr/lib:/ec/lib
    crle -64 -l /lib/64:/usr/lib/64:/ec/lib/amd64

(Note: Doing this will remove /opt/local from the runtime linker search
path, as having both pkgsrc and OpenWebstack listed can cause library
conflicts)

### Benefits

EC Userland is built specifically for Solaris/SmartOS and includes
things like integration with SMF, dtrace probes for some key software,
and combined 32bit/64bit packages. It is also built specifically for
hosting environments, by a company that manages hosting across a fleet
of cloud servers.

This makes EC Userland the ideal software stack to deploy on your
Solaris 10, SmartOS or Joyent Cloud SmartMachine server if you're going
to be doing hosting tasks.

It is kept up to date with the latest versions of Apache, PHP and MySQL -
we increment minor version numbers as they come out, so you can stay
up to date with "pkg update". For major version numbers, we introduce a
new package.

The directory structure is laid out to facilitate this, for example:

    # ls -l /ec/lib/php/
    total 4
    drwxr-xr-x 7 root bin  7 Dec 16 23:05 5.2
    drwxr-xr-x 7 root bin  7 Dec 16 23:05 5.3
    lrwxrwxrwx 1 root root 3 Dec 18 03:24 active -> 5.3

    # ls -l /ec/lib/apache/2.2/modules/mod_php*
    -r-xr-xr-x 1 root bin 3499880 Dec 19 06:24 /ec/lib/apache/2.2/modules/mod_php52.so
    -r-xr-xr-x 1 root bin 7277200 Dec 19 06:51 /ec/lib/apache/2.2/modules/mod_php53.so

    #  ls -l /ec/etc/apache/2.2/mods-available/php*
    -r--r--r-- 1 root bin 353 Dec 16 23:06 /ec/etc/apache/2.2/mods-available/php52.conf
    -r--r--r-- 1 root bin 285 Dec 16 23:06 /ec/etc/apache/2.2/mods-available/php52.load
    -r--r--r-- 1 root bin 353 Dec 16 23:06 /ec/etc/apache/2.2/mods-available/php53.conf
    -r--r--r-- 1 root bin 285 Dec 16 23:06 /ec/etc/apache/2.2/mods-available/php53.load

This allows you to install PHP 5.2 and PHP 5.3 along side each other,
and deactivate/active them within apache as simply as "a2dismod php52 &&
a2enmod php53". When PHP 5.4 comes out, this will get added in just the
same way - seamless upgrades!

We also provide combined 32bit/64bit packages, as Solaris/SmartOS is a
combined 32bit/64bit OS. With Apache and MySQL you can pick which
bittyness gets loaded by setting the SMF property "enable\_64bit=true".
Apache is 32bit by default with the prefork mpm and MySQL is 64bit by
default.

We also include software such as ffmpeg and vlc - please only install
this software if it is legal to do so in your own country. This
repository is hosted in the UK where pure software patents are not
applicable.

### List of core software

- Exim 4
- Apache 2.2
- PHP 5.2, 5.3 and 5.4
- MySQL 5.5
- gcc 4.4
- node.js
- perl 5.12
- python 2.6
- mod\_wsgi
- activemq
- Varnish 3
- cronolog, cronie, logrotate, syslog-ng
- ImageMagick
- QT4
- VLC
- FFMpeg

And [much much more](http://smartos.pkg.ec/en/catalog.shtml).

### Contributing

The source code to the repo is available at
<https://github.com/everycity/ec-userland>

It uses the "userland-gate" build format from the OpenSolaris project,
also used by Illumian and OpenIndiana. OpenIndiana-specific instructions
can be found
[here](http://wiki.openindiana.org/oi/Building+with+oi-build), however
the general usage is to:

1. Check out the source
2. Run `./mkrepo.sh` to create a local IPS repo
3. Add the repo as a file based repo with
   `pkg set-publisher -p file:///path/to/ec-userland/i386/repo`
4. `cd components/foobar`
5. `gmake publish`
