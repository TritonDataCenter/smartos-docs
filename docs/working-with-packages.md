# Working with Packages

Unlike other operating systems, SmartOS is distributed as a single
(mostly) read-only image with no packaging system to allow for
installation of additional software packages. To fill this void we
leverage [The NetBSD Packages
Collection](http://www.netbsd.org/docs/software/packages.html), also
known as "pkgsrc".

[pkgsrc](http://www.netbsd.org/docs/software/packages.html) is a
cross-platform framework for building software from source and
distributing binary packages. Each "package" consists of a Makefile and
several metadata files which specify how to build the software (as an
example, look at the
[tmux](http://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/misc/tmux/)
package). The flexibility of this framework allows for easy porting of
software en mass for OS's like ours without reinventing the wheel as
well as allowing us to participate in and contribute to the larger
pkgsrc community at large.

pkgsrc is not present in the SmartOS global zone out of the box but can
be easily installed using a bootstrap. Please refer to
[Installing pkgin][installing].

In SmartOS Zones, however, pkgsrc takes center stage by providing all
the software you require from compilers to web servers to editors.

The `pkgin` utility is the typical way to manage packages. Use `pkgin
av` to list the available packages for installation. Use `pkgin ls` to
view already installed packages. Use `pkgin in somepackage` to install a
package. All software will be installed under `/opt/local` and should
therefore be included in your path.

[installing]: https://pkgsrc.joyent.com
[building]: https://github.com/joyent/pkgsrc/wiki/pkgdev:setup

## Using `pkgin`

<!-- markdownlint-disable line-length -->

This table lists common `pkgin` commands.

| Command    | Description |
| -----------| --------------------------------------------------------- |
| `pkgin up` | Updates the `pkgin` database. You should run this command before installing any new packages just in case. |
| `pkgin ls` | Lists all the installed packages |
| `pkgin av` | Lists all of the available packages |
| `pkgin in` | Installs a package |
| `pkgin rm` | Removes a package |
| `pkgin se` | Searches for a package |
| `pkgin`    | With no additional arguments, lists all of the available `pkgin` commands. |

For example, to install `tidy`, you run this:

    sudo pkgin update
    sudo pkgin in tidy

## Directory Paths used by pkgsrc

The pkgsrc utility installs files in several directories within `/opt/local`.

| Directory                            | Description |
| -------------------------------------+-------------------------------- |
| `/opt/local`                         | This is where pkgsrc installs software including binaries, libraries, configuration files, supporting files, examples, documentation etc.  |
+--------------------------------------+-------------------------------- ------+
| `/opt/local/etc`                     | Contains configuration files.  |
+--------------------------------------+-------------------------------- ------+
| `/opt/local/share/examples`          | Example configuration files. When you add a new package, pkg src installs sample configuration f iles here, and then copies them to `/opt/local/etc` if they do not already exist.  |
+--------------------------------------+-------------------------------- ------+
| `/var/db/pkg`                        | This directory contains two directories that contain the database of installed and avail able  packages. If you delete or damage these directories, you will not be able to use the pkgsrc management tools. |

As noted in the table above, pkgsrc copies configuration files
into `/opt/local/etc` only if they do not already exist. That means that
you will not lose any custom configurations when you update, remove, or
reinstall a pacakage. If you break your configuration file, you can
always get a clean one from `/opt/local/share/examples`.
