+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Building node.js Binary
Addons on SmartMachines </span>

</div>

<div class="pagesubheading">

This page last changed on Sep 13, 2012 by
<font color="#0050B2">tmpvar</font>.

</div>

Background
--------------

SmartMachines installed with the "smartos64" image differ from those
installed with the "smartos" image only in that the former has 64-bit
binaries and libraries installed in /opt/local.  Because pkgsrc does not
yet support multilib, it is necessary to choose one or the other and
build all derived binaries with the same bitness, including binary add
ons for node.js.  There are several factors at present that make this
more difficult than it otherwise should be, all of which are being
worked on.  In the meantime, these tips will help you successfully build
binary add ons, whether you've chosen a 32-bit or a 64-bit userland
environment.

Tips for Configuration and Building
---------------------------------------

In general, you'll want to set your environment variables for the entire
configuration and build process.  Most node 0.6 binary add-ons use
node-waf, and these instructions are geared primarily toward those.  The
[waf
documentation](http://code.google.com/p/waf/wiki/EnvironmentVariables)
is generally applicable.  However, node-waf has been removed in node
0.8, and binary module authors are being encouraged to migrate to
[node-gyp](https://github.com/TooTallNate/node-gyp) instead.  [Other
approaches](http://github.com/wesolows/v8plus) also exist and may become
more widespread over time.  While each build system has its own quirks,
these rules are actually applicable to most general-purpose build
systems, and are in most cases applicable even to things other than
node.js add ons.

1.  You will need to make sure the compiler is passed
    -I/opt/local/include so that it can find the appropriate headers.
     If you are building an add-on for node 0.6, your add-on most likely
    uses node-waf to build, and this can be accomplished by setting the
    environment variable CPPFLAGS to "-I/opt/local/include".  This works
    even if node-waf is being invoked by npm(1) or some other utility.
     Most makefiles and other build systems also honor this variable.
     Future pkgsrc repositories will incorporate a compiler that does
    this automatically.
2.  Make sure that the add-on's build system invokes the compiler with
    the correct bitness flag, -m32 for the smartos image or -m64 for the
    smartos64 image.  You can normally accomplish this by setting the CC
    and CXX environment variables to "/opt/local/bin/gcc -m64" and
    "/opt/local/bin/g++ -m64" respectively.  Obviously, substitute -m32
    if you are on the 32-bit image, though this step is optional as
    32-bit is currently the default.  Again, most build systems will
    honor these environment variables; if your add-on's does not, check
    the documentation to see if there's an alternate way to make it use
    a particular compiler.  Future pkgsrc repositories will have a
    compiler that defaults to the same bitness as the binaries installed
    by pkgsrc.
3.  If your add-on needs to link with any libraries, make sure it uses
    the libraries installed on /opt/local/lib by pkgsrc, unless you want
    it to use libraries you have built and installed yourself.  In
    particular, you should avoid using the libraries in /usr/lib and
    /lib unless the add-on requires them for SmartOS-specific
    functionality such as DTrace.  In general, we try to avoid shipping
    compilation symlinks to such libraries, making it impossible to
    accidentally build against them.  To ensure that the correct library
    search path is used, consider setting the environment variable
    LD\_OPTIONS to include "-L/opt/local/lib".  This variable is
    interpreted directly by the link-editor; while node-waf is supposed
    to honor the LINKFLAGS variable, it has been our experience that it
    does not always do so.  Consult the add-on's documentation to see
    whether there may be other ways to accomplish this.  You can also
    include other linker options, such as linking with another library
    such as libsocket or libnsl, if the add-on requires these libraries
    but did not incorporate the requirement into its build
    system configuration.  If this occurs, config.log will usually
    contain mention of missing symbols, such as:

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    [1/2] cxx: build/.conf_check_0/test.cpp -> build/.conf_check_0/testb
uild/Release/test_1.o
    ['/opt/local/bin/g++', '-m64', '-g', '-I/opt/local/include', '../tes
t.cpp', '-c', '-o', 'Release/test_1.o']
    [2/2] cxx_link: build/.conf_check_0/testbuild/Release/test_1.o -> bu
ild/.conf_check_0/testbuild/Release/testprog
    Undefined           first referenced
     symbol                 in file
    getservbyname                       /opt/local/lib/libpcap.so
    ether_hostton                       /opt/local/lib/libpcap.so
    gethostbyname                       /opt/local/lib/libpcap.so
    socket                              /opt/local/lib/libpcap.so
    getprotobyname                      /opt/local/lib/libpcap.so
    getaddrinfo                         /opt/local/lib/libpcap.so
    getnetbyname                        /opt/local/lib/libpcap.so
    freeaddrinfo                        /opt/local/lib/libpcap.so
    freeifaddrs                         /opt/local/lib/libpcap.so
    getifaddrs                          /opt/local/lib/libpcap.so
    ld: fatal: symbol referencing errors. No output written to /var/tmp/
node_pcap/build/.conf_check_0/testbuild/Release/testprog
    collect2: ld returned 1 exit status

</div>

</div>

Because libsocket and libnsl are unique to illumos-derived operating
systems such as SmartOS, neglecting to link with them when using
networking functionality is one of the most common oversights developers
make when configuring their build systems, and the above output is
representative of this failure mode.

Putting It All Together
---------------------------

In this real-world example, we wish to build
[node\_pcap](http://github.com/mranney/node_pcap).  First, we'll need to
install libpcap itself.  Next, we'll use npm to download and build the
module.  Because of DATASET-477, the pkgsrc libpcap is improperly linked
and does not encode its dependencies on libsocket and libnsl, so we will
need to ensure that these additional libraries are linked in.  This bug
has since been fixed, so if your system has libpcap-1.1.1nb1 or later,
you can dispense with the socket and nsl libraries.  We will assume that
we are in a smartos64 SmartMachine image, though the procedure is very
similar on the 32-bit image, and that we are using the node.js from
pkgsrc.

<div class="preformatted panel" style="border-width: 1px;">

<div class="preformattedContent panelContent">

    wesolows at playground in ~wesolows at playground in ~
    $ sudo bash
    [root@playground /zones/d8d9d711-2847-4e52-9436-4f308630a1df/data/we
solows]# pkgin in libpcap
    calculating dependencies... done.

    nothing to upgrade.
    1 packages to be installed: libpcap-1.1.1 (0B to download, 865K to i
nstall)

    proceed ? [Y/n]
    downloading packages...
    installing packages...
    installing libpcap-1.1.1...
    pkg_install warnings: 0, errors: 0
    reading local summary...
    processing local summary...
    updating database: 100%
    marking libpcap-1.1.1 as non auto-removable
    [root@playground /zones/d8d9d711-2847-4e52-9436-4f308630a1df/data/we
solows]# exit
    exit
    wesolows at playground in ~
    $ CXX='/opt/local/bin/g++ -m64' CPPFLAGS='-I/opt/local/include' LD_O
PTIONS='-L/opt/local/lib -lsocket -lnsl -R/opt/local/lib' npm install pc
ap
    npm http GET https://registry.npmjs.org/pcap
    npm http 200 https://registry.npmjs.org/pcap
    npm http GET https://registry.npmjs.org/pcap/-/pcap-0.3.0.tgz
    npm http 200 https://registry.npmjs.org/pcap/-/pcap-0.3.0.tgz

    > pcap@0.3.0 install /zones/d8d9d711-2847-4e52-9436-4f308630a1df/dat
a/wesolows/node_modules/pcap
    > node-waf configure clean build

    Checking for program g++ or c++          : /opt/local/bin/g++ -m64
    Checking for program cpp                 : /opt/local/bin/cpp
    Checking for program ar                  : /usr/bin/ar
    Checking for program ranlib              : /opt/local/bin/ranlib
    Checking for g++                         : ok
    Checking for node path                   : not found
    Checking for node prefix                 : ok /opt/local
    Checking for library pcap                : yes
    'configure' finished successfully (0.222s)
    'clean' finished successfully (0.010s)
    Waf: Entering directory `/zones/d8d9d711-2847-4e52-9436-4f308630a1df
/data/wesolows/node_modules/pcap/build'
    [1/2] cxx: pcap_binding.cc -> build/Release/pcap_binding_1.o
    [2/2] cxx_link: build/Release/pcap_binding_1.o -> build/Release/pcap
_binding.node
    Waf: Leaving directory `/zones/d8d9d711-2847-4e52-9436-4f308630a1df/
data/wesolows/node_modules/pcap/build'
    'build' finished successfully (0.676s)
    pcap@0.3.0 ./node_modules/pcap

</div>

</div>

Nothing to it!

Feel free to ask for help building node.js add ons, or anything else, in
\#smartos on [Freenode](http://freenode.net).
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


