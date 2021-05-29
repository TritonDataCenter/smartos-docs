# DTrace

DTrace exists to help you figure out how the system works and why the
system is sluggish or acting in an unexpected manner. The name is short
for Dynamic Tracing: a powerful idea pioneered by DTrace. Dynamic
tracing allows one to **peer into all parts of the system** -- kernel,
device drivers, libraries, services, web servers, applications,
databases -- without any restarts, recompilations,or overhead. DTrace is
a powerful tool in any programmer's toolkit, and has been included by
default with various operating systems including Illumos, Solaris, Mac
OS X, FreeBSD, and QNX. A Linux port is in development.

DTrace works by dynamically patching live running instructions with
instrumentation code. The DTrace facility also supports Static Tracing:
where user-friendly trace points are added to code and compiled-in
before deployment.

DTrace provides a language, 'D', for writing DTrace scripts and
one-liners. The language is like C and awk, and provides powerful ways
to filter and summarize data in-kernel before passing to user-land. This
is an important feature that enables DTrace to be used in
performance-sensitive production environments, as it can greatly reduce
the overhead of gathering and presenting data.
...[more](http://dtrace.org/blogs/about/)

## DTrace for Beginners

- [Tutorial: DTrace by Example][dt-beginner-01]
- [Using DTrace to Analyze Your Webstack][dt-beginner-02] (short video)
- [Top 10 DTrace scripts for Mac OS X][dt-beginner-03]
- [Introducción a DTrace][dt-beginner-04] (in Spanish)

[dt-beginner-01]: https://web.archive.org/web/20120626144504/http://developers.sun.com/solaris/articles/dtrace_tutorial.html
[dt-beginner-02]: http://www.youtube.com/watch?v=47mgwxnbM9M
[dt-beginner-03]: http://dtrace.org/blogs/brendan/2011/10/10/top-10-dtrace-scripts-for-mac-os-x/
[dt-beginner-04]: http://www.youtube.com/watch?v=rM48nvJiZAQ

## More DTrace

- [DTrace FAQs](http://wiki.illumos.org/display/illumos/DTrace+FAQs)
- [Advanced DTrace Tips, Tricks and Gotchas](http://dtrace.org/resources/bmc/dtrace_tips.pdf)
- [DTrace: printf debugging for seventh-level wizards](http://sartak.org/talks/perl-oasis-2012/dtrace/)

## Books

- [DTrace Guide][dt-books-01] - now ported and updated for illumos!
- The Original [Dynamic Tracing Guide][dt0books-02] available as a 408 page
  PDF (2008)
- [Solaris Performance and Tools][dt-books-03]: takes Solaris perf analysis
  further with DTrace, 440 pages (2006)
- DTrace: the DTrace book of scripts and strategy, 1100 pages (2011).
  - [Sample Chapter][dt-books-04]
  - [Introduction to the DTrace Book][dt-books-05]
  - [What's in the DTrace Book][dt-books-06]
  - [Brendan's talk at BayLISA about DTrace and the DTrace book][dt-books-07]
  - [Updated DTrace book intro, DTrace book and Solaris 11][dt-books-07]

[dt-books-01]: http://dtrace.org/guide/preface.html
[dt-books-02]: http://download.oracle.com/docs/cd/E19253-01/817-6223/817-6223.pdf
[dt-books-03]: http://www.amazon.com/Solaris-Performance-Tools-Techniques-OpenSolaris/dp/0131568191/ref=sr_1_1?s=books&ie=UTF8&qid=1328815305&sr=1-1
[dt-books-04]: http://dtrace.org/blogs/brendan/2011/02/23/dtrace-book-sample-chapter-file-systems/
[dt-books-05]: http://smartos.org/2010/10/24/introduction-to-the-dtrace-book/
[dt-books-06]: http://www.youtube.com/watch?v=k7mwj9Km3fg
[dt-books-07]: http://dtrace.org/blogs/brendan/2011/06/28/baylisa-talk/
[dt-books-08]: http://dtrace.org/blogs/brendan/2011/10/02/dtrace-book-short-videos/

## Videos on DTrace

- [Bryan Cantrill's Google Tech Talk][dt-vid-01]
- [Breaking Down MySQL/Percona Query Latency With DTrace][dt-vid-01]
- [Little Shop of Performance Horrors][dt-vid-01]
- [DTrace BoF at LISA10][dt-vid-01]
- [Brendan Gregg on DTrace][dt-vid-01] at Kernel Conference Australia, 2009
- [How to Build Better Applications with Oracle Solaris DTrace][dt-vid-01]
- [Observing Your App and Everything Else it Runs on Using DTrace][dt-vid-01]
- [DTracing Your Website][dt-vid-01]
- [The Problems Solaris Solves: Diagnosing Live Systems with DTrace][dt-vid-01]
- [DTrace, Goals, Successes, Failures, and Solving Problems][dt-vid-01] - [Adam Leventhal][al]
- [Building a monitoring framework using DTrace and MongoDB][dt-vid-01] - [DanKimmel][dk]
- [Debugging with DTrace][dt-vid-01] - [Max Bruning][mb] - Training Director, Joyent
- [Solving Problems with DTrace on any Platform][dt-vid-01] - [Brendan Gregg][bg]

[dt-vid-01]: http://video.google.com/videoplay?docid=-8002801113289007228
[dt-vid-02]: http://dtrace.org/blogs/brendan/2011/07/06/breaking-down-mysqlpercona-query-latency-with-dtrace/
[dt-vid-03]: http://smartos.org/2009/11/06/video-little-shop-of-performance-horrors/
[dt-vid-04]: http://smartos.org/2010/11/17/dtrace-bof-at-lisa10/
[dt-vid-05]: http://www.youtube.com/playlist?list=PLE0C1BA9B7A144AE0
[dt-vid-06]: http://www.beginningwithi.com/comments/2010/10/24/how-to-build-better-applications-with-oracle-solaris-dtrace/
[dt-vid-07]: http://www.beginningwithi.com/comments/2010/05/30/observing-your-app-and-everything-else-it-runs-on-using-dtrace/
[dt-vid-08]: http://www.beginningwithi.com/comments/2010/07/27/dtracing-your-website/
[dt-vid-09]: http://www.beginningwithi.com/comments/2010/05/26/the-problems-solaris-solves-4-diagnosing-live-systems-with-dtrace/
[dt-vid-10]: http://smartos.org/2013/05/30/adam-leventhal-on-dtrace/
[dt-vid-11]: http://smartos.org/2013/06/01/building-a-monitoring-framework-using-dtrace-and-mongodb/
[dt-vid-12]: http://smartos.org/2013/05/29/debugging-with-dtrace/
[dt-vid-13]: http://smartos.org/2013/05/28/solving-problems-with-dtrace-on-any-platform/

[al]: http://www.linkedin.com/in/adamleventhal
[dk]: http://www.linkedin.com/pub/dan-kimmel/4a/88a/425
[mb]: http://www.linkedin.com/pub/max-bruning/0/337/180
[bg]: http://www.linkedin.com/pub/brendan-gregg/1/3a8/3/

### dtrace.conf 2012 Videos

For a good overview and wrap-up, see
[Adam's blog post on dtrace.conf][adams-post].

[adams-post]: http://dtrace.org/blogs/ahl/2012/04/09/dtrace-conf12-wrap-up/

<!-- markdownlint-disable line-length -->
| Title | Speaker |
| ----- | ------- |
| State of the Union - [video](http://smartos.org/2012/04/05/dtrace-conf-2012-dtrace-state-of-the-union/) | [Bryan Cantrill](http://dtrace.org/blogs/bmc) |
| Setting the Agenda - [video](http://www.youtube.com/watch?v=274w2PcN66Y) |  |
| User-Level CTF - [video](http://smartos.org/2012/04/07/dtrace-conf-2012-user-level-ctf/) | [Adam Leventhal](http://dtrace.org/blogs/ahl) |
| Dynamic Translators - [video](http://smartos.org/2012/04/07/dtrace-conf-2012-dynamic-translators/) | [Dave Pacheco](http://dtrace.org/blogs/dap) |
| Control flow & language enhancements - [video](http://smartos.org/2012/04/07/dtrace-conf-2012-control-flow-language-enhancements/) | [Eric Schrock](http://dtrace.org/blogs/eschrock) |
| [Carousel ride!](http://smartos.org/2012/04/05/a-carousel-of-dtrace/) |  |
| Clang Parser for DTrace - [video](http://www.youtube.com/watch?v=6NqV_Uj8Ba4) | John Thompson |
| Visualizations - [video](http://www.youtube.com/watch?v=XD5hdaWnQM4) | [Brendan Gregg](http://dtrace.org/blogs/brendan) |
| Visualizations, Enabling toolchain for seamless USDT - [video](http://www.youtube.com/watch?v=3Sqa8mmtnMM) | Theo Schlossnagle |
| Visualizations - [video](http://www.youtube.com/watch?v=-B6u6wY3Iro) | [Richard Elling](http://blog.richardelling.com/) |
| [DTrace in node.js](http://mcavage.github.com/presentations/dtrace_conf_2012-04-03/) - [video](http://www.youtube.com/watch?v=0ZMvSh7lUdM) | [Mark Cavage](https://twitter.com/mcavage) |
| [User-land probes for Erlang virtual machine](http://www.snookles.com/scott/publications/dtrace.conf-2012.erlang-vm.pdf) - [video](http://smartos.org/2012/04/09/dtrace-conf-2012-dtrace-and-erlang/) | Scott Lystig Fritchie |
| DTrace on Linux - [video](http://www.youtube.com/watch?v=NElog3MvUC8) | Kris Van Hees |
| [ZFS DTrace provider](dtrace.conf-2012-zfs-dtrace-provider.md) | [Matt Ahrens](http://blog.delphix.com/matt/) |
| DTrace on FreeBSD - [video](http://smartos.org/2012/04/09/dtrace-conf-2012-dtrace-on-freebsd/) | Ryan Stone |
| Barriers to Adoption - [video](http://www.youtube.com/watch?v=P95LHZ-WOWw) | Jarod Jenson |
<!-- markdownlint-enable line-length -->
