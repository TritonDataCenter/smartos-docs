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

pkgsrc is not present by default in the SmartOS global zone but can
be easily installed using a bootstrap. Please refer to
[Installing pkgsrc-tools][installing].

In SmartOS Zones, however, pkgsrc takes center stage by providing all
the software you require from compilers to web servers to editors.

The `pkgin` utility is the typical way to manage packages. Use `pkgin
av` to list the available packages for installation. Use `pkgin ls` to
view already installed packages. Use `pkgin in somepackage` to install a
package. All software will be installed under `/opt/local` and should
therefore be included in your path.

[installing]: https://pkgsrc.smartos.org/illumos

## Using `pkgin`

<!-- markdownlint-disable line-length -->

This table lists common `pkgin` commands.

| Command    | Description |
| -----------| --------------------------------------------------------- |
| `pkgin up` | Updates the `pkgin` database. You should run this command before installing any new packages just in case. |
| `pkgin ls` | Lists all the installed packages |
| `pkgin av` | Lists all of the available packages |
| `pkgin in` | Installs a package |
| `pkgin rm` | Removes a package |
| `pkgin se` | Searches for a package |
| `pkgin`    | With no additional arguments, lists all of the available `pkgin` commands. |

For example, to install `tidy`, you run this:

    sudo pkgin update
    sudo pkgin in tidy

## Directory Paths used by pkgsrc

The pkgsrc utility installs files into `/opt/local` (or `/opt/tools` in the
global zone). Under this root, pkgsrc uses a fairly standard filesystem
heirarchy layout (e.g., `bin`, `lib`, `etc`, etc.).

<!-- markdownlint-disable no-inline-html -->

| Directory                   | Description |
| ----------------------------|-------------------------------- |
| `/opt/local`<br />(`/opt/tools` in gz)               | This is where pkgsrc installs software including binaries, libraries, configuration files, supporting files, examples, documentation etc.  |
| `/opt/local/etc`<br />(`/opt/tools/etc` in gz)            | Contains configuration files.  |
| `/opt/local/share/examples`<br />(`/opt/tools/share/examples` in gz) | Example configuration files. When you add a new package, pkg src installs sample configuration f iles here, and then copies them to `/opt/local/etc` if they do not already exist.  |
| `/var/db/pkg`<br />(`/opt/tools/var/db` in gz)               | This directory contains two directories that contain the database of installed and avail able  packages. If you delete or damage these directories, you will not be able to use the pkgsrc management tools. |

<!-- markdownlint-enable no-inline-html -->

As noted in the table above, pkgsrc copies configuration files
into `/opt/local/etc` only if they do not already exist. That means that
you will not lose any custom configurations when you update, remove, or
reinstall a pacakage. If you break your configuration file, you can
always get a clean one from `/opt/local/share/examples`.
