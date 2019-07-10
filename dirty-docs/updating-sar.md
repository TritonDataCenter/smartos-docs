+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Updating sar </span>

</div>

<div class="pagesubheading">

This page last changed on Mar 05, 2013 by
<font color="#0050B2">brendan</font>.

</div>

sar is the System Activity Reporter.

There have been numerous issues with it on Solaris-based systems. This
page is a working document to list and confirm issues to fix. Each
issue, once confirmed, can be promoted to filed bugs on
<https://github.com/joyent/smartos-live/issues> .

### svcadm enable sar

This never worked properly, reported by [CR
6302763](https://gist.github.com/jclulow/aa87a74cb24cb9671705). Has it
been fixed? It should enable sar from the sys crontab on the first
attempt, and further disable/enable cycles should behave as expected.

### sa1 crontab arguments

The sys crontab is:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# crontab -l
#ident  "@(#)sys        1.5     92/07/14 SMI"   /* SVr4.0 1.2   */
#
# The sys crontab should be used to do performance collection. See cron
# and performance manual pages for details on startup.
#
# 0 * * * 0-6 /usr/lib/sa/sa1
# 20,40 8-17 * * 1-5 /usr/lib/sa/sa1
# 5 18 * * 1-5 /usr/lib/sa/sa2 -s 8:00 -e 18:01 -i 1200 -A
```

</div>

</div>

</div>

Note that sa1 has no arguments. It is a simple shell script that runs
this:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# execsnoop
  UID    PID   PPID ARGS
    3  18112  18111 /sbin/sh /usr/lib/sa/sa1
    3  18113  18112 /usr/bin/date +%d
    3  18112  18111 /usr/lib/sa/sadc 1 1 /var/adm/sa/sa04
```

</div>

</div>

</div>

sa1 launches sadc with a "1 1" argument. The sadc (sar(1M)) man page
has:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
/usr/lib/sa/sadc [ t n] [ofile]
[...]
     sadc, the data collector, samples system data n times,  with
     an  interval  of  t  seconds  between samples, and writes in
     binary format to ofile or to standard output.  The  sampling
     interval  t should be greater than 5 seconds; otherwise, the
     activity of sadc itself may affect the sample.
```

</div>

</div>

</div>

This would imply that the default configuration is seriously incorrect:
1 second samples every 20 minutes. The fix would be to add interval
values in the crontab. However, I don't think it's that easy – some
statistics (all?) use cumulative counter deltas and infer the full 20
minute interval correctly. Either sar or the man page needs fixing, and
all statistics should be checked.

### Over 100 percent

Some statistics can report over 100%, due apparently to timing issues.
Eg, reporting 119% for a 5 second interval. How sar sleeps and collects
intervals needs to be investigated.

### 6215332 updating sar for the 21st century

I posted a list of irritations in Jan 2005 to an OpenSolaris mailing
list (
<http://mail.opensolaris.org/pipermail/opensolaris-rfe/2005-January/0000
25.html>
- while it's still online), which became this bug. This was the reply
(cached here) from Christopher P Johnson:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
Thanks for looking at this. As an interim step I captured your
suggestions in

6215332 updating sar for the 21st century

Note that I broke the rules by punting and putting all the suggestions
together - bugs/rfes should be granular to the level of a single
problem/suggestion (I'm just having trouble keeping up with you folks).

This shortcut is offset by the suggested process that whenever work is
started on a particular area of solaris (command, subsystem, driver,
etc.) that all bugs and rfes in that area be reviewed to insure that a
coherent set of changes, which address all important issues, are
developed and tested at the same time.

Of course, priorities and resources weigh on what work is planned (with
the new core of opensolaris developers, we will be expanding the
resources nicely!)

Brendan Gregg wrote:
> Hi Chris,
>
> On Wed, 5 Jan 2005, Christopher P Johnson wrote:
>
>
>>Hi Brendan:
>>Please do make suggestions, and I will work to get them entered in our
>>RFE database. I'm attaching a current bug list as food for thought.
>>
>
>
> Thanks for the list - many suggestions were already there. Of particul
ar
> importance is 4059019, sar with networking options (perhaps "sar -n").
> The following are some extra suggestions,
>
> (I've just checked sar on Solaris 10 build 69)
>
> * sar -b: what about the Cyclic Page Cache?
>    sar -b reports on the UFS Buffer Cache, however these days I think
we
>    would be more interested in the cyclic page cache activity. I'm
>    guessing here that sar was written in the days where buffer cache w
as
>    the primary cache, and sar hasn't been updated along with the new
>    caches. It would be nice to have a new switch for the cyclic
>    page cache.
>
> * sar -r: add more fields, eg "swap -s" data.
>    It would be useful to have extra fields in this report, such as
>    those printed by swap -s. Or even similar data to ::memstat from
>    mdb -k!
>
> * sar -p: add more fields, eg "vmstat -p" data.
>    It would be handy to see a break down of executable, anonymous
>    and filessytem page statistics in this report, similar to vmstat -p
.
>    Perhaps just the pageins.
>
> * sar -d: "r+w/s" should be seperate.
>    It would be nice if these were seperate fields, "r/s" and "w/s".
>
> * sar -q: "runq-sz" is buggy.
>    This has always reported odd values, such as no fraction between
>    0.0 and 1.0. (hmm, from a brief look in Solaris 10 it seems to
>    be behaving somewhat better so far).
>
> * sar -q: "%runocc" is buggy.
>    This sometimes reports values > 100%.
>    09:47:21 runq-sz %runocc swpq-sz %swpocc
>    09:47:31     1.0      98     0.0       0
>    09:47:32     1.5     196     0.0       0
>
> * sar -a: more fields needed to be meaningful.
>    The three fields provided don't seem useful by themselves. Eg,
>    "iget/s" is described on docs.sun.com as "The number of requests ma
de
>    for inodes that were not in the directory name look-up cache (DNLC)
".
>    So this sounds like DNLC misses - I'm not sure the value is useful
>    without DNLC hits as well.
>
> * sar -u: "%wio" not meaningful.
>    This field is not very meaningful, and often confuses sysadmins.
>    When I explain what it really means to sysadmins they often say
>    that Sun should drop it. I don't think Sun should drop it - people
>    should just read the man pages more carefully! :) Anyhow, I'm just
>    passing this experience on.
>
> thanks,
>
> Brendan Gregg
>
> [Syndey, Australia]
>
>
```

</div>

</div>

</div>

**This list is just the "extra" bugs beyond what was already known at
the time. I also think more issues were later added to the bug. If
anyone can find the missing bugs, please add them here.**

As with the other issues, these need to be investigated and confirmed.
We know what happened with %wio, at least – that was hardwired to zero.

### ZFS

Something meaningful with ZFS and the ARC.

### Kernel Memory update

Where did this come from?

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
sar -k

SunOS mars 5.10 Generic_127128-11 i86pc    03/04/2013

09:53:14 sml_mem   alloc  fail  lg_mem   alloc  fail  ovsz_alloc  fail
09:53:14        unix restarts
10:04:04 122311104 77652371     0 2206978048 2033626064     0    3764224
0     0
10:04:25 122311104 77667851     0 2206978048 2033561392     0    3764224
0     0
[...]
```

</div>

</div>

</div>

I understand what the "small" and "large" pools are from the source
(small is &lt; 256 bytes, large is &lt; oversize), but why categorize
them this way? I suspect this is a historic left-over from supporting
SVR4's lazy buddy allocator (pre-slab allocator), which used large and
small memory pools.

It may make sense to redo sar -k's kernel memory statistics, for slab
allocation.

### sar Not Zone Aware

If sar is enabled in a Zone (eg, a Joyent SmartMachine), most (perhaps
all) of its statistics refer to the entire system. This is
counter-intuitive for a virtualized environment, especially for users
who are familiar with other virtualization types (HW). Note: some
observability tools are zone-aware, such as top(1) and the load
averages, whereas others like sar(1) are currently not, which include
vmstat(1M) and mpstat(1M).

Ideally, sar reports something that is obvious to the user, whether they
are in a Zone or not. Such as clearly showing physical server statistics
and resource control statistics (if set).
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


