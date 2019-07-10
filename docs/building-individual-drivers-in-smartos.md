# Building Individual Drivers in SmartOS

## Building a single device driver

The following is based on the assumption that you have done a complete build.
See <https://github.com/joyent/smartos-live#building-smartos>.

### Prepare the environment

    cd illumos/usr/src
    ./tools/proto/root_i386-nd/opt/onbld/bin/bldenv ../../illumos.sh

### Build your driver

    cd uts/intel/<drivername>
    dmake

### Protip ([rmustacc](https://wiki.smartos.org/display/~rm))

use

    git ls-files |grep <drivername>

and/or

    git ls-files | grep '<drivername>/Makefile'

when locating file for a particular driver

### Developing a new network device driver

When developing a new device driver the convention is to have:

- `common/io/<drivername>` for code
- `intel/<drivername>/Makefile` for makefile on x86
- `sparc/<drivername>/Makefile` for makefile on SPARC
