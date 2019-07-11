# SmartOS Core Technologies </span>

## Documentation

<!-- markdownlint-disable ul-indent -->
- [Performance][core-02]
- [Virtualization][core-05]
    - [Zones][core-03]
    - [KVM][core-07]
    - [Bhyve][core-bhyve]
- [ZFS][core-04]
- [Networking and Network Virtualization][core-06]
- [SMF - Service Management Facility][core-10]
- [DTrace][core-01]
- [Modular Debugger (mdb)][core-11]
- [illumos Documentation][core-09]
<!-- markdownlint-enable ul-indent -->

[core-01]: dtrace.md
[core-02]: performance.md
[core-03]: zones.md
[core-04]: zfs.md
[core-05]: smartos-virtualization.md
[core-06]: networking-and-network-virtualization.md
[core-07]: kvm.md
[core-bhyve]: bhyve.md
[core-08]: tips-and-tricks.md
[core-09]: https://illumos.org/docs/
[core-10]: basic-smf-commands.md
[core-11]: mdb.md

## Guides

- [Dynamic Tracing Guide](http://illumos.org/books/dtrace/)
- [Modular Debugger Guide](http://illumos.org/books/mdb/)
- [Writing Device Drivers](http://illumos.org/books/wdd/)
- [Memory and Thread Placement Optimization Developer's Guide][lgrps]

[lgrps]: http://illumos.org/books/lgrps/

## SmartOS Training

Learn SmartOS from the experts with
[training from Joyent](https://www.joyent.com/training-services/).

## SmartOS Overviews

- [Using SmartOS as a Hypervisor][smartos-hypervisor]:
  Robert Mustacchi's talk at SCALE 10x. An excellent introduction to
  what SmartOS is and why it's better.
  [Slides available](https://fingolfin.org/illumos/talks/scale2012.pdf).
- [presentation by Geoff Flarity](https://github.com/gflarity/smartos_presentation)
  (can be adapted for other talks as desired)

[smartos-hypervisor]: http://smartos.org/2012/01/24/using-smartos-as-a-hypervisor/

## Discussion

The smartos-discuss mailing list is a forum for useful questions and
answers - see the searchable archives
[here](https://www.listbox.com/member/archive/184463/); sign up
[here](http://smartos.org/smartos-mailing-list/).

There's a `#smartos` room on `irc.freenode.net`, and you'll also find the
SmartOS crowd hanging out in `#illumos` and `#joyent`.

## illumos User Group

Get together with others interested in illumos, SmartOS, and related
topics. Join the
[Bay Area illumos user group on Meetup](http://www.meetup.com/illumos-User-Group/)
(so you'll receive meeting announements), and/or let us know if you want
to start a
[user group in your area](http://wiki.illumos.org/display/illumos/Local+User+Groups+and+MeetUps).

## SmartOS Repositories and Docs on GitHub

- [smartos-live](https://github.com/joyent/smartos-live)
- [illumos-kvm](https://github.com/joyent/illumos-kvm)
- [illumos-kvm-cmd](https://github.com/joyent/illumos-kvm-cmd)

## (Open)Solaris Documentation

- [Solaris Internals, Solaris Performance and Tools](http://www.solarisinternals.com/wiki/index.php/Solaris_Internals_and_Performance_FAQ)
  (books and wiki)
- [OpenSolaris](http://hub.opensolaris.org/bin/view/Main/documentation)
  documentation
- Solaris 11 Express Documentation: Aside from new additions that are
  well documented, Illumos is very similar to Solaris 11 Express. You
  can learn more about System Administration and features like ZFS,
  Zones, Networking by reading
  [these](http://docs.oracle.com/cd/E19963-01/index.html).

## The Larger Community

You can find information on our Solaris relatives here:

- [Illumos](https://www.illumos.org/), the fully open community fork of
  OpenSolaris
- [OpenIndiana](http://openindiana.org/), a distribution of Illumos
- [OmniOS](http://omniosce.org/), a distribution of Illumos
- [Oracle Solaris](http://www.oracle.com/us/products/servers-storage/solaris/index.html)

## Articles and Media

- [Joyent Announces SmartOS With KVM: an Open Source, Modern Operating System][article-01]
  Joyent press release - Aug 15, 2011
- [Joyent launches a new OS for the cloud][article-02]
  Gigaom - Aug 15, 2011
- [Joyent Brings KVM to SmartOS for DIRTY Environments][article-03]
  ReadWriteEnterprise - Aug 15, 2011
- [Joyent Open Sources SmartOS for the Cloud][article-04]
  Data Center Knowledge - Aug 15, 2011
- [Joyent's Jason Hoffman On SmartOS Cloud Server][article-05]
  The Web Host Industry Review - Sep 2, 2011

[article-01]: http://www.marketwire.com/press-release/joyent-announces-smartos-with-kvm-an-open-source-modern-operating-system-1549602.htm
[article-02]: http://gigaom.com/cloud/joyent-launches-a-new-os-for-the-cloud/
[article-03]: http://www.readwriteweb.com/enterprise/2011/08/joyent-brings-kvm-to-smartos-f.php
[article-04]: http://www.datacenterknowledge.com/archives/2011/08/15/joyent-open-sources-smartos/
[article-05]: http://www.thewhir.com/web-hosting-news/090211_QA_Joyents_Jason_Hoffman_on_SmartOS_Cloud_Server
