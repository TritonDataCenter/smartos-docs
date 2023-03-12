# Performance

- [About Memory Usage and Capping](about-memory-usage-and-capping.md)
- [Managing CPU Cycles in a Zone](managing-cpu-cycles-in-a-zone.md)

## Cloud Performance Training: What's in the Course

<!-- markdownlint-disable no-inline-html -->
<div class="youtube-player">
  <iframe type="text/html" src="https://www.youtube.com/embed/pb95K_2Xt-0"
    frameborder="0" allowfullscreen></iframe>
</div>
<!-- markdownlint-enable no-inline-html -->

See the
[Course Calendar](http://www.tritondatacenter.com/developers/training-services/upcoming-courses)
for upcoming offerings of this and other Joyent courses.

## Text and Video

see also: [DTrace](dtrace.md)

<!-- markdownlint-disable line-length -->

- [Brendan Gregg's](http://brendangregg.com/) site
- [Systems Performance: Enterprise and the Cloud](http://www.brendangregg.com/sysperfbook.html)
  by Brendan Gregg (covers SmartOS / illumos and Linux)
- [Solaris Internals, Solaris Performance and Tools](http://www.solarisinternals.com/wiki/index.php/Solaris_Internals_and_Performance_FAQ) (books and wiki)
- [Little Shop of Performance Horrors](http://www.beginningwithi.com/comments/2009/11/06/little-shop-of-performance-horrors/) (video)
- [LUN Alignment](https://www.youtube.com/watch?v=MnsszXHsAGA) - An informal talk by Roch Bourbonnais.
- [Performance: Experimentation](https://www.youtube.com/watch?v=W0IEZsLaEUU):
  Brendan Gregg and Roch Bourbonnais share the thought process they use to
  troubleshoot system performance problems.
- [Performance: The "Not a Problem"?  Problem](https://www.youtube.com/watch?v=wmeIojzH9hw):
  Jim Mauro, Brendan Gregg, and Roch Bourbonnais discuss a type of
  performance issue that's very difficult to troubleshoot: the problem
  that isn't actually a problem.
- [Performance Instrumentation Counters](http://www.youtube.com/playlist?list=PL3oXECC9Rpm1rcYtbJp_zNLSZr_VvuvwE):
  An informal discussion among Roch Bourbonnais, Brendan Gregg, and Jim Mauro.
- [Performance: Interrupts](http://www.beginningwithi.com/2010/10/24/performance-interrupts/):
  Brendan Gregg, Jim Mauro, Roch Bourbonnais on a common performance issue:
  interrupts.
- [Performance Analysis: new tools and concepts from the cloud](http://www.beginningwithi.com/2010/04/30/performance-instrumentation-counters/):
  Brendan Gregg, Lead Performance Engineer, Joyent, speaks at SCALE 10x.
  [full slide deck](http://dtrace.org/blogs/brendan/files/2012/01/scale10x-performance.pdf)
- [Performance Analysis Methodology](http://dtrace.org/blogs/brendan/2012/12/13/usenix-lisa-2012-performance-analysis-methodology/) - Brendan Gregg, USENIX LISA 2012

### SmartOS Tools

- [Flame Graphs](http://dtrace.org/blogs/brendan/2011/12/16/flame-graphs/) (original article by Brendan Gregg)
    - [source on GitHub](https://github.com/brendangregg/FlameGraph)
    - [Flame on: Graphing hot paths through X server code](http://blogs.oracle.com/alanc/entry/flame_on_graphing_hot_paths)
- [The Gregg Performance Series (videos)](http://smartos.org/2011/05/04/video-the-gregg-performance-series/):
  Tutorial videos about SmartOS performance tools: vmstat, mpstat, uptime.
- [vfsstat(1m) – Report VFS read and write activity](https://github.com/TritonDataCenter/smartos-live/blob/master/man/src/vfsstat.1m.md)
- [ziostat(1m) – Report ZFS read I/O activity](https://github.com/TritonDataCenter/smartos-live/blob/master/man/src/ziostat.1m.md)
- [zonestat(1) – report active zone statistics](https://github.com/TritonDataCenter/smartos-live/blob/master/man/src/zonestat.1.md)
- [zonestatd(1m) – zones monitoring daemon](https://github.com/TritonDataCenter/smartos-live/blob/master/man/src/zonestatd.1m.md)
