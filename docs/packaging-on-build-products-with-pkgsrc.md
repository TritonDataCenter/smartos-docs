# Packaging ON build products with pkgsrc

[See this Makefile](https://github.com/joyent/smartos-live/blob/master/pkgsrc/Makefile)

Until an `onbld` package is published
 [here](https://download.joyent.com/pub/build/pkgsrc/), if you desperately
need a copy of the `onbld` tools mentioned below, there's a tarball
available [here](http://us-east.manta.joyent.com/nahamu/public/smartos/onbld-0.0.1.tgz)

The remainder of this page is Nahum's notes on the idea that predate the
implementation linked above. It's being preserved for posterity... at least
for now...  This page can probably die in March of 2015.

## Plan

1. Identify desired packages to produce:
    - `onbld`
        - `ctfconvert`
        - `ctfmerge`
        - `ctfdump`
        - `cscope-fast`

2. Create a tool that generates tarballs of that output (should live
   in `smartos-live/tools`)
3. Design and implement a mechanism for publishing those tarballs (aka
   pick a webserver, pick a subdirectory, and dump them there)
4. Create pkgsrc recipes in the pkgsrc-joyent tree that take those
   tarballs and turn them into packages

## Notes from IRC conversations

    16:50 <nahamu> wesolows, you might have a helpful opinion about
    this: I've make pkgsrc recipes for all the dependencies that my modified
    QEMU needed that weren't already in pkgsrc.
    16:51 <nahamu> the last bit that the QEMU build needs is access
    to ctfconvert and ctfmerge. is there a sane way to package those up into
    a pkgsrc package so that I could even have QEMU built by pkgsrc, or
    should I just be satisfied with all the deps being in pkgsrc?
    16:52 <wesolows> I'm glad you asked.
    16:53 <wesolows> rm and I have discussed this and we want to do
    it, but no one has done the work to make it happen.
    16:53 <nahamu> uh oh...
    16:53 <nahamu> :)
    16:53 <wesolows> Same thing goes for other pkgsrc packages we
    could generate out of the ON build, like onbld, make, etc. that could
    install in pkgsrc.
    16:53 <wesolows> That said...
    16:53 <wesolows> LeftWing did something relevant for dmake, I
    think.
    16:54 <LeftWing> Hmm?
    16:54 <wesolows> dmake -> pkgsrc
    16:54 <LeftWing> Oh
    16:54 <LeftWing> <https://github.com/jclulow/pkgsrc-dmake>
    16:54 <wesolows> the short answer is that we'd be glad to see
    someone build a set of pkgsrc input files from the ON build, and a
    target for generating the packages themselves.
    16:55 <rmustacc> Mostly its blocked on killing the fake subset.
    16:55 <rmustacc> At least for me.
    17:05 <nahamu> so... that sounds like it's currently a bit out of
    my depth seeing as I've only just now managed to build new packages with
    pkgsrc
    17:05 <nahamu> I can't yet imagine how one would point pkgsrc at
    some sort of external ON build tree
    17:06 <nahamu> but if you mean making it generate tarballs of
    stuff that pkgin can handle, that might be a tiny bit easier.
    17:07 <nahamu> I think a came across some sort of pkgsrc
    equivalent of checkinstall...
    17:12 <nahamu> right, it was this blog post:
    <http://www.perkin.org.uk/posts/creating-local-smartos-packages.html>
    17:13 <nahamu> wesolows: did you mean pointing a tool at the
    proto dir that spits out packages that pkgin can handle (as opposed to
    having pkgsrc use bsd make)
    17:15 <wesolows> sure
    17:15 <wesolows> yes, that :-)
    17:16 <nahamu> rmustacc: is the goal so that you can just pkgin a
    bunch of stuff that comes from ON?
    17:18 <nahamu> where does onbld even get deposited?
    17:18 <nahamu> I don't see it in the proto dirs...
    17:18 <richlowe> tools proto
    17:18 <richlowe> usr/src/tools/proto/root_$(mach)-nd
    17:19 <nahamu> I wonder if pkgsrc would even be able to use such
    binary packages to satisfy dependencies...
    17:21 <rmustacc> nahamu: It would be nice if it could.
    17:21 <rmustacc> Particularly parts of sgs that we don't ship.
    17:21 <nahamu> "sgs"?
    17:21 <rmustacc> The software generation suite
    17:21 <rmustacc> At least, I think that's what it stands for.
    17:22 <rmustacc> Things in there are basically all the things you
    need to build a C program that aren't make and cc.
    17:22 <rmustacc> And I guess as.
    17:22 <rmustacc> But the linker and all its tools.
    17:22 <rmustacc> Things like yacc.
    17:23 <nahamu> rmustacc: so some of that does end up in proto but
    doesn't get shipped, right?
    17:23 <rmustacc> Yes.
    17:23 <wesolows> or that are make, actually
    17:23 <wesolows> since make isn't shipped in the platform (and
    shouldn't be, really)
    17:26 <nahamu> okay, so if we had some sort of alternate
    manifests of stuff to turn into pkgin packages and a tool to do that, it
    would not only help me build my QEMU with an onbld package (still have
    to test if that part will work) and might help further clean up setting
    up new build zones.
    17:26 <rmustacc> nahamu: Well, that's the whole point of it.
    17:26 <rmustacc> But to get to the point that we can clean up the
    build zone stuff we need to finish killing the fake subset.
    17:26 <rmustacc> Which will include doing that.
    
    ------------------------------------------------------------------------
    
    09:46 <nahamu> jperkin: if I were to package up some of the
    binaries built by compiling ON (the illumos-joyent tree) with the
    instructions on
    [http://www.perkin.org.uk/posts/creating-local-smartos-packages.html
    would](http://www.perkin.org.uk/posts/creating-local-smartos-packages.ht
    ml%20would)
    pkgsrc be able to use them to satisfy a dependency?
    09:47 <nahamu> in particular, the ON build process creates a
    directory of tools named "onbld"
    09:47 <jperkin> nahamu: what you'd probably do is bundle them
    into a tar, then create a package which sets that tar as the DISTFILE,
    and sets NO_BUILD so it just extracts the tar and packages it up in
    pkg_* format, then you could depend upon it as normal
    09:48 <nahamu> jperkin: perfect, thanks.
    09:48 <jperkin> nahamu: something like archivers/rar would be a
    good example to copy
    09:49 <jperkin> or converters/code2html is a bit simpler
    
    ------------------------------------------------------------------------
    
    11:37 <nahamu> jperkin: so if I use NO\_BUILD, the contents of
    11:39 <jperkin> nahamu: no, you'll need a custom 'do-install'
    target to move them into place from \$WRKSRC
    +--------------------------------------------------------------------------+
