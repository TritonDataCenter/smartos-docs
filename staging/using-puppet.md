# Using Puppet

[Puppet](http://puppetlabs.com/) is a very popular configuration
management tool on a variety of platforms. Here you'll find tips on
using Pupppet on SmartOS.

## Installation via PKG-SRC

The easiest way to get started with Puppet is to install it from
PKG-SRC. To get started, ensure that pkgin is installed. See
<https://pkgsrc.joyent.com/>

Now, simply install either the **ruby18-puppet** or **ruby19-puppet**
package, as you prefer. All dependencies will be installed as needed:

<!-- markdownlint-disable line-length -->

    # pkgin in ruby19-puppet
    calculating dependencies... done.

    nothing to upgrade.
    5 packages to be installed: libiconv-1.14nb2 db4-4.8.30 ruby19-facter-1.6.10nb1 ruby19-base-1.9.2pl320 ruby19-puppet-2.7.18nb1 (105M to download, 0B to install)

    proceed ? [Y/n] y
    downloading packages...
    ...

<!-- markdownlint-enable line-length -->

## Resources

- [Puppet Home](http://puppetlabs.com/)
- [Puppet Documentation](http://docs.puppetlabs.com/puppet/)
