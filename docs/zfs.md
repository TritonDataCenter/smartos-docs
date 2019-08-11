# ZFS

<!-- markdownlint-disable no-inline-html -->

<div class="youtube-player">
  <iframe type="text/html" src="https://www.youtube.com/embed/6F9bscdqRpo"
    frameborder="0" allowfullscreen></iframe>
</div>

ZFS keeps your data safe and makes data and disk administration fast
and easy by removing traditional limitations in filesystem design. It
is a [future proof file system][zfs-wikipedia] - and also a
[logical volume manager][lvm-wikipedia] - which gives us:

[zfs-wikipedia]: http://en.wikipedia.org/wiki/Zfs
[lvm-wikipedia]: http://en.wikipedia.org/wiki/Logical_volume_manager

- Fast file system creation: The creation and startup of additional
  zones ("SmartMachines" in Joyent terminology) – in other words,
  adding new paying customers — is nearly instantaneous.
- Data integrity is guaranteed, with particular emphasis on preventing
  silent data corruption.
- [Storage pools][storage-pools]: "virtualized storage" makes administrative
  tasks and scaling far easier. To expand storage capacity, all you need
  to do is add new disks (hard disks, flash memory, and whatever may come
  along in the future) to a zpool.
- Snapshots: ZFS' [copy-on-write][cow-wikipedia] transactional
  model makes it possible to capture a snapshot of an entire file
  system at any time, storing only the differences between that and
  the working file system as it continues to change. This creates a
  backup point that the administrator can easily roll back to.
- Clones: Snapshots of volumes and filesystems
  can be cloned, creating an identical copy. Cloning is nearly
  instantaneous and initially consumes no additional disk space. This
  facilitates the rapid creation of new, nearly identical, VMs.
- The ARC (Adaptive Replacement Cache) improves file system and disk
  performance, driving down overall system latency.

[storage-pools]: http://en.wikipedia.org/wiki/ZFS#Storage_pools
[cow-wikipedia]: http://en.wikipedia.org/wiki/Copy-on-write

## OpenZFS Developers' Summit

The first was held November 18-19, 2013. The goals of the event were:

- to foster cross-platform community discussions of OpenZFS work
- to make progress on some of the projects proposed for this community.

[Video recordings of the presentations][openzfs-dev-summit-playlist] are
in the OpenZFS channel on YouTube.

[openzfs-dev-summit-playlist]: https://www.youtube.com/playlist?list=PLaUVvul17xSdWMBt5tAC8Hu7bbeWskD_q

See the [OpenZFS site][openzfs-summit-site] for more details.

[openzfs-summit-site]: http://open-zfs.org/wiki/OpenZFS_Developer_Summit

Videos:

- Matt Ahrens [Intro][vid-01]
- [Platform Panel][vid-02]: illumos (Chris Siden), FreeBSD, Linux
  (Brian Behlendorf), and OSX (Jurgen)
- [Platform-independent code repository][vid-03] (Matt Ahrens)
- [Storage Tiering][vid-04] (Boris Protopopov)
- [Vendor Panel][vid-05] (all represented companies sharing their work)
- [Community Planning][vid-06] (Karyn Ritter)
- [Channel Programs][vid-07] (Chris Siden & Max Grossman)
- [Test Coverage][vid-08] (John Kennedy)
- [Data-Driven Development of OpenZFS][vid-09] (Adam Leventhal)
- [Performance on full/fragmented pools][vid-10] (George Wilson)
- [Scalability][vid-11] (Kirill Davydychev)
- [Virtual memory interactions][vid-12] (Brian Behlendorf)
- [Multi-Tenancy][vid-13] (Robert Mustacchi)
- [Examining on-disk format][vid-14] (Max Bruning)
- [Closing][vid-15], Future Plans (Matt & Co.)

[vid-01]: https://www.youtube.com/watch?v=U3dMhpmQTrU
[vid-02]: http://www.youtube.com/watch?v=U3dMhpmQTrU&t=13m38s
[vid-03]: http://www.youtube.com/watch?v=U3dMhpmQTrU&t=48m7s
[vid-04]: http://www.youtube.com/watch?v=tm0NYEVS6qM&t=2m12s
[vid-05]: https://www.youtube.com/watch?v=EGKek5sZ2Xw
[vid-06]: http://www.youtube.com/watch?v=EGKek5sZ2Xw&t=45m6s
[vid-07]: http://www.youtube.com/watch?v=EGKek5sZ2Xw&t=73m0s
[vid-08]: http://www.youtube.com/watch?v=M5RnPZW0_Xk&t=4m10s
[vid-09]: http://www.youtube.com/watch?v=w3-eppY7ICc&t=6m24s
[vid-10]: http://www.youtube.com/watch?v=UuscV_fSncY&t=0m30s
[vid-11]: http://www.youtube.com/watch?v=hvoL6z8YKgM&t=1m30s
[vid-12]: http://www.youtube.com/watch?v=hvoL6z8YKgM&t=15m55s
[vid-13]: http://www.youtube.com/watch?v=MLTX1i7UEL4&t=0m18s
[vid-14]: http://www.youtube.com/watch?v=MLTX1i7UEL4&t=8m18s
[vid-15]: http://www.youtube.com/watch?v=MLTX1i7UEL4&t=18m50s

## ZFS in SmartOS

- [SmartOS ZFS Architecture][smartos-zfs-arch]
- [Running Without a ZFS Root Pool][running-without-rpool]

[smartos-zfs-arch]: http://smartos.org/2012/08/21/789/
[running-without-rpool]: http://smartos.org/2013/01/22/new-video-running-without-a-zfs-root-pool/

## Learning and Using ZFS

- [Bacon Preservation with ZFS][bacon-preservation] - article by
  Bryan Horstmann-Allen

[bacon-preservation]: http://sysadvent.blogspot.com/2012/12/day-7-bacon-preservation-with-zfs.html

## Presentations

### ZFS for Users

- [ZFS Discovery Day: Understanding the Technology][zfs4u-01]
- [Jack Adams Interviews George Wilson on ZFS][zfs4u-02]
- [Becoming a ZFS Ninja][zfs4u-03]
- [ZFS in the Trenches][zfs4u-04] (video)
- [ZFS Workshop at LISA 08][zfs4u-05] (6 hours of video!)
- [ZFS Performance Analysis and Tools][zfs4u-06]
- [SmartOS ZFS Architecture][zfs4u-07] - Bill Pijewski speaking at the
  BayLISA meetup at Joyent, August 16, 2012, on SmartOS' ZFS
  architecture and diskless boot.
- [Making the Impossible Possible: Disposable Staging Environments At
  Scale][zfs4u-08] - Eric Sproul of OmniTI speaks on ZFS Day
- [Why 4K? – George Wilson's ZFS Day Talk][zfs4u-09]

[zfs4u-01]: http://www.beginningwithi.com/2009/02/09/zfs-discovery-day-understanding-the-technology/
[zfs4u-02]: http://www.beginningwithi.com/2009/09/23/jack-adams-interviews-george-wilson-on-zfs/
[zfs4u-03]: http://www.beginningwithi.com/2009/09/16/becoming-a-zfs-ninja/
[zfs4u-04]: http://www.youtube.com/playlist?list=PL3007AB589342B4DA
[zfs4u-05]: http://www.beginningwithi.com/comments/2009/12/02/zfs-workshop-at-lisa-08/
[zfs4u-06]: http://smartos.org/2012/12/27/zfs-performance-analysis-and-tools/
[zfs4u-07]: http://smartos.org/2012/08/21/789/
[zfs4u-08]: http://smartos.org/2012/11/12/making-the-impossible-possible-disposable-staging-environments-at-scale/
[zfs4u-09]: http://smartos.org/2012/10/31/why-4k-george-wilsons-zfs-day-talk/

### ZFS for Developers

- [The Future of LibZFS][zfs4devs-01] illumos user group meeting Jan 2012
- [ZFS Feature Flags][zfs4devs-02] illumos user group meeting Jan 2012
- [ZFS: The Last Word in File Systems][zfs4devs-03] - 3-hour deep dive
  video with [Bonwick][bonwick-wikipedia] and Moore - various versions
  of [the slides][zfs4devs-03-slides] are available, including
  [this][someone-who-hated-sun] from someone who hated Sun and yet thought
  ZFS "Worth running Solaris to get".
- [ZFS on Solaris Internals][zfs4devs-04] site
- [ZFS Revisited - Understanding ZFS & ZFS ARC/L2ARC][zfs4devs-05] (blog post)
- [Activity of the ZFS ARC][zfs4devs-06] (blog post)
- [ZFS: The Last Word in File Systems][zfs4devs-07] -
  2.5 hours of Jeff Bonwick and Bill Moore at the SNIA Software
  Developers' Conference, Sept, 2008 - a very thorough foundation on
  the guts of ZFS.
- [ZFS, Cache and Flash][zfs4devs-08] - Adam Leventhal at the Open Storage
  Summit 2009
- [ZFS Boot in S10U6][zfs4devs-09] - Lori Alt gives us the deep-dive
  lowdown on ZFS boot.
- [Kernel Conference Australia: Panel Discussion on ZFS][zfs4devs-10]
- [ZFS the Next Word][zfs4devs-11]
- all [Deirdré's ZFS videos][zfs4devs-12]

[zfs4devs-01]: http://www.youtube.com/playlist?list=PL1A94C8EECCAF7340
[zfs4devs-02]: http://www.youtube.com/playlist?list=PLFC9970A828416AE5
[zfs4devs-03]: http://www.beginningwithi.com/comments/2009/01/15/zfs-the-last-word-in-file-systems-parts-1-2-3/
[zfs4devs-03-slides]: http://www.google.com/search?&q=ZFS%3A+The+Last+Word+in+File+Systems+pdf
[someone-who-hated-sun]: http://wiki.gnhlug.org/twiki2/pub/Www/ZfsSlides/zfs2.pdf
[zfs4devs-04]: http://www.solarisinternals.com//wiki/index.php?title=Category:ZFS
[zfs4devs-05]: http://nilesh-joshi.blogspot.com/2010/07/zfs-revisited.html
[zfs4devs-06]: http://dtrace.org/blogs/brendan/2012/01/09/activity-of-the-zfs-arc/
[zfs4devs-07]: http://www.youtube.com/playlist?list=PL1622CB7988FDD9F5
[zfs4devs-08]: http://www.beginningwithi.com/2009/11/04/zfs-cache-and-flash/
[zfs4devs-09]: http://www.beginningwithi.com/2009/01/15/zfs-boot-in-s10u6/
[zfs4devs-10]: http://www.beginningwithi.com/2009/10/31/kernel-conference-australia-panel-discussion-on-zfs/
[zfs4devs-11]: http://www.youtube.com/playlist?list=PL3oXECC9Rpm2oDL8fZJcnDwOcalnUtRhV
[zfs4devs-12]: http://www.beginningwithi.com/tag/zfs/

## Blogs

- [Jeff Bonwick's blog][bonwick-blog] (now defunct but still historically
  useful)

[bonwick-wikipedia]: http://en.wikipedia.org/wiki/Jeff_Bonwick
[bonwick-blog]: http://en.wikipedia.org/wiki/Jeff_Bonwick
