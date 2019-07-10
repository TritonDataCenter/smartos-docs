+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Packaging ON build
products with pkgsrc </span>

</div>

<div class="pagesubheading">

This page last changed on Feb 16, 2015 by
<font color="#0050B2">nahamu</font>.

</div>

See <https://github.com/joyent/smartos-live/blob/master/pkgsrc/Makefile>

Until an onbld package is published at
<https://download.joyent.com/pub/build/pkgsrc/> , if you desperately
need a copy of the onbld tools mentioned below, there's a tarball
available at
<http://us-east.manta.joyent.com/nahamu/public/smartos/onbld-0.0.1.tgz>

<div class="panelMacro">

  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
-------------
  ![](images/icons/emoticons/warning.gif){width="16" height="16"}   The
remainder of this page is Nahum's notes on the idea that predate the imp
lementation linked above. It's being preserved for posterity... at least
 for now...
                                                                    This
 page can probably die in March of 2015.
  ----------------------------------------------------------------- ----
------------------------------------------------------------------------
------------------------------------------------------------------------
-------------

</div>

Plan
========

1.  Identify desired packages to produce:
    -   onbld
        -   ctfconvert
        -   ctfmerge
        -   ctfdump
        -   cscope-fast

2.  Create a tool that generates tarballs of that output (should live
    in smartos-live/tools)
3.  Design and implement a mechanism for publishing those tarballs (aka
    pick a webserver, pick a subdirectory, and dump them there)
4.  Create pkgsrc recipes in the pkgsrc-joyent tree that take those
    tarballs and turn them into packages

Notes from IRC conversations
================================

16:50 &lt; nahamu&gt; wesolows, you might have a helpful opinion about
this: I've make pkgsrc recipes for all the dependencies that my modified
QEMU needed that weren't already in pkgsrc.\
16:51 &lt; nahamu&gt; the last bit that the QEMU build needs is access
to ctfconvert and ctfmerge. is there a sane way to package those up into
a pkgsrc package so that I could even have QEMU built by pkgsrc, or
should I just be satisfied with all the deps being in pkgsrc?\
16:52 &lt; wesolows&gt; I'm glad you asked.\
16:53 &lt; wesolows&gt; rm and I have discussed this and we want to do
it, but no one has done the work to make it happen.\
16:53 &lt; nahamu&gt; uh oh...\
16:53 &lt; nahamu&gt; :)\
16:53 &lt; wesolows&gt; Same thing goes for other pkgsrc packages we
could generate out of the ON build, like onbld, make, etc. that could
install in pkgsrc.\
16:53 &lt; wesolows&gt; That said...\
16:53 &lt; wesolows&gt; LeftWing did something relevant for dmake, I
think.\
16:54 &lt; LeftWing&gt; Hmm?\
16:54 &lt; wesolows&gt; dmake -&gt; pkgsrc\
16:54 &lt; LeftWing&gt; Oh\
16:54 &lt; LeftWing&gt; <https://github.com/jclulow/pkgsrc-dmake>\
16:54 &lt; wesolows&gt; the short answer is that we'd be glad to see
someone build a set of pkgsrc input files from the ON build, and a
target for generating the packages themselves.\
16:55 &lt; rmustacc&gt; Mostly its blocked on killing the fake subset.\
16:55 &lt; rmustacc&gt; At least for me.\
17:05 &lt; nahamu&gt; so... that sounds like it's currently a bit out of
my depth seeing as I've only just now managed to build new packages with
pkgsrc\
17:05 &lt; nahamu&gt; I can't yet imagine how one would point pkgsrc at
some sort of external ON build tree\
17:06 &lt; nahamu&gt; but if you mean making it generate tarballs of
stuff that pkgin can handle, that might be a tiny bit easier.\
17:07 &lt; nahamu&gt; I think a came across some sort of pkgsrc
equivalent of checkinstall...\
17:12 &lt; nahamu&gt; right, it was this blog post:
<http://www.perkin.org.uk/posts/creating-local-smartos-packages.html>\
17:13 &lt; nahamu&gt; wesolows: did you mean pointing a tool at the
proto dir that spits out packages that pkgin can handle (as opposed to
having pkgsrc use bsd make)\
17:15 &lt; wesolows&gt; sure\
17:15 &lt; wesolows&gt; yes, that :-)\
17:16 &lt; nahamu&gt; rmustacc: is the goal so that you can just pkgin a
bunch of stuff that comes from ON?\
17:18 &lt; nahamu&gt; where does onbld even get deposited?\
17:18 &lt; nahamu&gt; I don't see it in the proto dirs...\
17:18 &lt; richlowe&gt; tools proto\
17:18 &lt; richlowe&gt; usr/src/tools/proto/root\_\$(mach)-nd\
17:19 &lt; nahamu&gt; I wonder if pkgsrc would even be able to use such
binary packages to satisfy dependencies...\
17:21 &lt; rmustacc&gt; nahamu: It would be nice if it could.\
17:21 &lt; rmustacc&gt; Particularly parts of sgs that we don't ship.\
17:21 &lt; nahamu&gt; "sgs"?\
17:21 &lt; rmustacc&gt; The software generation suite\
17:21 &lt; rmustacc&gt; At least, I think that's what it stands for.\
17:22 &lt; rmustacc&gt; Things in there are basically all the things you
need to build a C program that aren't make and cc.\
17:22 &lt; rmustacc&gt; And I guess as.\
17:22 &lt; rmustacc&gt; But the linker and all its tools.\
17:22 &lt; rmustacc&gt; Things like yacc.\
17:23 &lt; nahamu&gt; rmustacc: so some of that does end up in proto but
doesn't get shipped, right?\
17:23 &lt; rmustacc&gt; Yes.\
17:23 &lt; wesolows&gt; or that are make, actually\
17:23 &lt; wesolows&gt; since make isn't shipped in the platform (and
shouldn't be, really)\
17:26 &lt; nahamu&gt; okay, so if we had some sort of alternate
manifests of stuff to turn into pkgin packages and a tool to do that, it
would not only help me build my QEMU with an onbld package (still have
to test if that part will work) and might help further clean up setting
up new build zones.\
17:26 &lt; rmustacc&gt; nahamu: Well, that's the whole point of it.\
17:26 &lt; rmustacc&gt; But to get to the point that we can clean up the
build zone stuff we need to finish killing the fake subset.\
17:26 &lt; rmustacc&gt; Which will include doing that.

------------------------------------------------------------------------

09:46 &lt; nahamu&gt; jperkin: if I were to package up some of the
binaries built by compiling ON (the illumos-joyent tree) with the
instructions on
[http://www.perkin.org.uk/posts/creating-local-smartos-packages.html
would](http://www.perkin.org.uk/posts/creating-local-smartos-packages.ht
ml%20would)
pkgsrc be able to use them to satisfy a dependency?\
09:47 &lt; nahamu&gt; in particular, the ON build process creates a
directory of tools named "onbld"\
09:47 &lt; jperkin&gt; nahamu: what you'd probably do is bundle them
into a tar, then create a package which sets that tar as the DISTFILE,
and sets NO\_BUILD so it just extracts the tar and packages it up in
pkg\_\* format, then you could depend upon it as normal\
09:48 &lt; nahamu&gt; jperkin: perfect, thanks.\
09:48 &lt; jperkin&gt; nahamu: something like archivers/rar would be a
good example to copy\
09:49 &lt; jperkin&gt; or converters/code2html is a bit simpler

------------------------------------------------------------------------

11:37 &lt; nahamu&gt; jperkin: so if I use NO\_BUILD, the contents of
the tarball will get dumped straight into .destdir for matching by
PLIST?\
11:39 &lt; jperkin&gt; nahamu: no, you'll need a custom 'do-install'
target to move them into place from \$WRKSRC
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


