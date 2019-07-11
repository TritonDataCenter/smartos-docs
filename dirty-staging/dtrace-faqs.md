+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : DTrace FAQs </span>

</div>

<div class="pagesubheading">

This page last changed on Nov 03, 2011 by
<font color="#0050B2">deirdre</font>.

</div>

originally written by [Brendan Gregg](http://dtrace.org/blogs/brendan/)
in 2005

<div>

<ul>
<li>
[General](#DTraceFAQs-General)
</li>
- [Is it "DTrace", "Dtrace", "dTrace" or
    "DTRACE"?](#DTraceFAQs-Isit%22DTrace%22%2C%22Dtrace%22%2C%22dTrace%2
2or%22DTRACE%22%3F)
- [What is DTrace?](#DTraceFAQs-WhatisDTrace%3F)
- [What are the risks of
    DTrace?](#DTraceFAQs-WhataretherisksofDTrace%3F)
- [What Operating Systems have
    DTrace?\*](#DTraceFAQs-WhatOperatingSystemshaveDTrace%3F%5C)
- [Why is DTrace different from other performance
    tools?](#DTraceFAQs-WhyisDTracedifferentfromotherperformancetools%3F
)
- [What is DTrace used for?](#DTraceFAQs-WhatisDTraceusedfor%3F)
- [Who can use DTrace?](#DTraceFAQs-WhocanuseDTrace%3F)
- [Do I need to know kernel internals to use
    DTrace?](#DTraceFAQs-DoIneedtoknowkernelinternalstouseDTrace%3F)
- [Is there an easier way to use the power of
    DTrace?](#DTraceFAQs-IsthereaneasierwaytousethepowerofDTrace%3F)
- [What are some DTrace success
    stories?](#DTraceFAQs-WhataresomeDTracesuccessstories%3F)
- [Wasn't this invented 20 years ago on
    mainframes?](#DTraceFAQs-Wasn%27tthisinvented20yearsagoonmainframes%
3F)
- [Is the source code
    available?](#DTraceFAQs-Isthesourcecodeavailable%3F)
- [Are there books for DTrace?](#DTraceFAQs-AretherebooksforDTrace%3F)
- [Will DTrace be released for Solaris
    9?](#DTraceFAQs-WillDTracebereleasedforSolaris9%3F)

<li>
[D Language](#DTraceFAQs-DLanguage)
</li>
- [What language is D most
    like?](#DTraceFAQs-WhatlanguageisDmostlike%3F)
- [What are Probes and
    Providers?](#DTraceFAQs-WhatareProbesandProviders%3F)

<li>
[How do I DTrace ...?](#DTraceFAQs-HowdoIDTrace...%3F)
</li>
- [Syscalls](#DTraceFAQs-Syscalls)
- [Disk I/O](#DTraceFAQs-DiskI%2FO)

<li>
[Error Messages](#DTraceFAQs-ErrorMessages)
</li>
- [DTrace requires additional
    privileges](#DTraceFAQs-DTracerequiresadditionalprivileges)
- [drops on CPU \#dtrace: 864476 drops on CPU
    0](#DTraceFAQs-dropsonCPU%23dtrace%3A864476dropsonCPU0)
- [invalid address (0x...) in
    action](#DTraceFAQs-invalidaddress%280x...%29inaction)
- [failed to create probe ... Not enough
    space](#DTraceFAQs-failedtocreateprobe...Notenoughspace)

<li>
[See Also](#DTraceFAQs-SeeAlso)
</li>
</ul>

</div>

General
-----------

### Is it "DTrace", "Dtrace", "dTrace" or "DTRACE"?

It's "DTrace".

### What is DTrace?

DTrace is a performance analysis and troubleshooting tool that provides
a comprehensive view of operating system and application behaviour. It
has functionality similar to many other performance tools combined,
bundled into a single scriptable tool that can examine both userland
activity and the kernel. DTrace was designed to be safe for use on live
production servers, and to operate with minimum performance overhead.

### What are the risks of DTrace?

Safety was a [key design
tenet](http://dtrace.org/blogs/bmc/2005/07/19/dtrace-safety/) in the
development of DTrace. Since its release in 2005, DTrace has proven safe
for production use, as it was designed to be. In some production
environments DTrace is running continually 24x7 without harm or even
serious performance degradation.

### What Operating Systems have DTrace?\*

DTrace was developed as key Solaris 10 technology by former Sun
Microsystems engineers [Bryan Cantrill](http://dtrace.org/blogs/bmc),
[Mike Shapiro](http://blogs.sun.com/mws) and [Adam
Leventhal](http://dtrace.org/blogs/ahl), and was released in March 2005
with the first release of Solaris 10. It's now available for
[Illumos](https://www.illumos.org/), SmartOS,
[FreeBSD](http://wiki.freebsd.org/DTrace) and [Mac OS
X](http://dtrace.org/blogs/brendan/2011/10/10/top-10-dtrace-scripts-for-
mac-os-x/),
and two different ports for Linux are in early stages.

### Why is DTrace different from other performance tools?

- greater observability
- production safe
- realtime data

For example, DTrace can fetch latency metrics from functions in the
kernel and applications at the same time, summarizing the data in a low
cost manner, and passing the summaries every second to user-land for
real-time visualization.

### What is DTrace used for?

Performance analysis, observability, troubleshooting, debugging.
Examples include watching disk I/O details live, and timing userland
functions to determine hotspots.

### Who can use DTrace?

Firstly, you need to be root or have one of the DTrace privileges to be
able to invoke DTrace.

- Sysadmins can use DTrace to understand the behaviour of the
    operating system and applications.
- Application Programmers can use DTrace to fetch timing and argument
    details from the functions that they wrote, both in development and
    from live customer production environments.
- Kernel and Device Driver Engineers can use DTrace to debug a live
    running kernel and all its modules, without needing to run drivers
    in debug mode.

### Do I need to know kernel internals to use DTrace?

No, although it can help. The following points should explain:

- You can get value from DTrace by using the many pre-written and
    documented scripts available from:
    -   the [DTraceToolkit](http://www.opensolaris.org/os/community/dtra
ce/dtracetoolkit) -
        many of which are [included in Mac OS
        X](http://dtrace.org/blogs/brendan/2011/10/10/top-10-dtrace-scri
pts-for-mac-os-x/)
    -   the scripts and one-liners documented in [Solaris Peformance and
        Tools](http://www.solarisinternals.com/) (2005)
    -   the scripts and one-liners documented in the [DTrace
        book](http://dtrace.org/blogs/brendan/2011/02/23/dtrace-book-sam
ple-chapter-file-systems/) (2011)
- However, it's useful to learn to write your own custom scripts, to
    solve your specific issues.
- There are many high level "providers" carefully designed to provide
    a succinct, stable and documented abstraction of the kernel (see
    the [DTrace
    Guide](http://download.oracle.com/docs/cd/E19253-01/817-6223/817-622
3.pdf),
    eg: proc, io, sched, sysinfo, vminfo), which make tracing the kernel
    much easier than it may sound.
- No kernel knowledge is required to study user-level application
    code only. Application developers can study the functions that they
    wrote, and that they are already familiar with.
- Understanding the OS kernel is necessary for writing advanced DTrace
    scripts for which there is currently no high level provider; for
    example, to examine TCP and IP activity in detail. [Solaris
    Internals 2nd Edition](http://www.solarisinternals.com/) is
    highly recommended.

### Is there an easier way to use the power of DTrace?

The power of DTrace underlies several observability tools, including a
[GUI for Netbeans](http://wiki.netbeans.org/DTrace), [Mac OS X
Instruments](http://developer.apple.com/technologies/tools/), Analytics
for the Oracle ZFS Storage product family.

And we've been tapping Joyent's internal DTrace expertise ([Bryan
Cantrill](http://en.wikipedia.org/wiki/Bryan_Cantrill), [Brendan
Gregg](http://en.wikipedia.org/wiki/Brendan_Gregg), [Dave
Pacheco](http://dtrace.org/blogs/dap/), [Robert
Mustacchi](http://dtrace.org/blogs/rm/)) to make the power of DTrace
ever more accessible:

- If you're a customer of the Joyent Public Cloud (including
    [no.de](https://no.de/)), you can use Joyent's powerful [Cloud
    Analytics](http://www.joyentcloud.com/carousel/joyent-rocks/powerful
-analytics/)
    to observe the performance of your Joyent SmartMachine.
- With Joyent's SmartDataCenter, you can [apply the power of Cloud
    Analytics across all
    nodes](http://www.joyent.com/products/smartdatacenter/cloud-analytic
s/),
    to see what's going on throughout your cloud datacenter.
- You can also use Joyent's [Cloud Analytics
    API](http://apidocs.joyent.com/sdcapidoc/clan/) to create custom
    instrumentations and visualizations for any or all of your nodes in
    the Joyent Public Cloud, or your entire SmartDataCenter.

### What are some DTrace success stories?

DTrace has had countless wins, see the blogs on
[dtrace.org](http://dtrace.org/) for some examples.

### Wasn't this invented 20 years ago on mainframes?

No! DTrace can dynamically trace every function entry and return in the
live kernel (around 36,000 probes); plus every function in user-level
application code and libraries (for example, mozilla + libraries is over
100,000 probes); and user-level instructions (over 200,000 probes - just
for the Bourne shell).

### Is the source code available?

Yes, Sun Microsystems released it in January, 2005, and it was the first
major component of the Solaris source to be open-sourced.

### Are there books for DTrace?

Yes!

- The [DTrace
    Guide](http://download.oracle.com/docs/cd/E19253-01/817-6223/817-622
3.pdf) is
    a superb reference for DTrace which covers the language, providers,
    and is packed with examples. It was written by the DTrace engineers,
    and is the authorative reference. This entire book is available
    online in both HTML and PDF format, at no charge. A hardcopy is
    available
    to [purchase](http://corppub.iuniverse.com/marketplace/sun/059528548
1.html) from iUniverse.
- [Solaris Performance and
    Tools](http://vig.prenhall.com/catalog/academic/product/0,1144,01315
68191,00.html) demonstrates
    using DTrace in practical ways for performance observability
    and debugging. It was written by Richard McDougall and Jim Mauro
    (who also wrote [Solaris
    Internals](http://www.solarisinternals.com/)), and [Brendan
    Gregg](http://www.opensolaris.org/os/community/dtrace/FAQ/dtracetool
kit) (DTraceToolkit).
- The [DTrace book](http://www.dtracebook.com) by Brendan Gregg and
    Jim Mauro, published in early 2011, is a comprehensive "cookbook" on
    all aspects of DTrace. Sample chapter
    [here](http://dtrace.org/blogs/brendan/2011/02/23/dtrace-book-sample
-chapter-file-systems/).

There are also lots of videos about DTrace, search YouTube or start
[here](http://wiki.smartos.org/display/DOC/DTrace+Resources).

### Will DTrace be released for Solaris 9?

No. (this used to be FAQ \#1 back in '05).

D Language
--------------

### What language is D most like?

The D programming language is based on C, and so any background in C
programming will help. D is arguably far easier than C, as you only need
to know a small number of functions and variable types to be able to
write powerful scripts.

D programs are similar in form to awk programs: they are not a top-down
programS, but action-based.

### What are Probes and Providers?

A **probe** is an instrumentation point that can be traced by DTrace.
For example, the probe "syscall::read:entry" is called when a read(2)
syscall is called, and "syscall::read:return" is called when a read(2)
syscall completes. There are four components to the probe name,
provider:module:function:name. Provider is the most significant, the
role of the other names are explained in the [DTrace
guide](http://download.oracle.com/docs/cd/E19253-01/817-6223/817-6223.pd
f).

A **provider** is a collection of related probes, much like a library is
a collection of functions. For example, the "syscall" provider provides
probes for the entry and return for all system calls. The DTrace guide
lists the providers as seperate chapters.

How do I DTrace ...?
------------------------

### Syscalls

System calls can be easily traced using the syscall provider, which
provides a probe for both the entry and the return of the syscall, and
variables for the entry arguments and the return code. As the midway
point between user-land and the kernel, the syscall interface often
reflects application behaviour well. Each syscall is also well
documented in section 2 of the man pages. The following are some example
DTrace one-liners.

Files opened by process name

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# dtrace -n 'syscall::open*:entry { printf("%s %s",execname,copyinstr(ar
g0)); }'
dtrace: description 'syscall::open*:entry ' matched 2 probes
CPU     ID                    FUNCTION:NAME
0   6329                       open:entry df /var/ld/ld.config
0   6329                       open:entry df /usr/lib/libcmd.so.1
0   6329                       open:entry df /usr/lib/libc.so.1
0   6329                       open:entry df /etc/mnttab
```

</div>

</div>

</div>

Syscall count by process name

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# dtrace -n 'syscall:::entry { @num[execname] = count(); }'
dtrace: description 'syscall:::entry ' matched 228 probes
^C
svc.startd                                                        1
mozilla-bin                                                      26
sshd                                                             58
bash                                                             88
dtrace                                                           95
df                                                              108
```

</div>

</div>

</div>

Syscall count by syscall

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# dtrace -n 'syscall:::entry { @num[probefunc] = count(); }'

# dtrace: description 'syscall:::entry ' matched 228 probes
^C
lwp_self                                                          1
<i>...</i>
write                                                            33
sigaction                                                        33
lwp_sigmask                                                      53
ioctl                                                            95
```

</div>

</div>

</div>

Of particular value may be to measure the elapsed time and on-CPU time
of system calls, to both explain response time and CPU load. The
procsystime tool from
the [DTraceToolkit](http://www.opensolaris.org/os/community/dtrace/dtrac
etoolkit) does
this using the -e and -o flags.

### Disk I/O

Disk events can be traced using the io provider, which provides probes
for the request and completion of both disk and client NFS I/O. Each
probe provides extensive details of the I/O through the args\[\] array,
as documented in the DTrace guide. The following lists the disk related
probes.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# dtrace -ln 'io:genunix::'
ID   PROVIDER            MODULE                          FUNCTION NAME
9571         io           genunix                           biodone done
9572         io           genunix                           biowait wait
-done
9573         io           genunix                           biowait wait
-start
9582         io           genunix                    default_physio star
t
9583         io           genunix                     bdev_strategy star
t
9584         io           genunix                           aphysio star
t
```

</div>

</div>

</div>

Points to bear in mind when using the io provider for tracing disk
activity:

- This is actual disk I/O requests. Your application may be doing
    loads of I/O which is being absorbed by the file system cache.
- I/O completions (io:::done) are asynchronous,
    so pid and execname will not identify the responsible process.
- Disk write requests (io:::start) often occur asynchronously to the
    responsible process, as the file system has cached the write and is
    flushed to storage at a later time.
- io events don't necessarily mean that disk heads are moving
    somewhere - many disks have buffers to cache I/O activity,
    especially storage arrays.

The following are some example one-liners.

Disk size by process ID

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# dtrace -n 'io:::start { printf("%d %s %d",pid,execname,args[0]->b_bcou
nt); }'
dtrace: description 'io:::start ' matched 6 probes
CPU     ID                    FUNCTION:NAME
0   9583              bdev_strategy:start 8238 tar 1024
0   9583              bdev_strategy:start 8238 tar 4096
0   9583              bdev_strategy:start 8238 tar 4096
0   9583              bdev_strategy:start 8238 tar 1024
0   9583              bdev_strategy:start 8238 tar 1024
0   9583              bdev_strategy:start 8238 tar 2048
```

</div>

</div>

</div>

Disk size aggregation

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# dtrace -n 'io:::start { @size[execname] = quantize(args[0]->b_bcount);
 }'
dtrace: description 'io:::start ' matched 6 probes
^C
tar
value  ------------- Distribution ------------- count
512 |                                         0
1024 |@@                                       37
2048 |@@@@@@@                                  114
4096 |@@@@@@@                                  116
8192 |@@@@@@@@@@@@@@@@@                        286
16384 |@@                                       33
32768 |@@@@@                                    87
65536 |                                         0
```

</div>

</div>

</div>

The
[DTraceToolkit](http://www.opensolaris.org/os/community/dtrace/dtracetoo
lkit)
contains many tools for analysing disk I/O, including:

- iosnoop - snoop I/O events as they occur
- iotop - display top disk I/O events by process
- bitesize.d - print disk event size report
- iofile.d - I/O wait time by filename and process
- iopattern - print disk I/O pattern
- seeksize.d - print disk seek size report

Error Messages
------------------

### DTrace requires additional privileges

You must either be root or have additional privileges to be able to use
DTrace. Those privileges are:

- dtrace\_user - allows the use of profile, syscall and fasttrap
    providers, on processes that the user owns.
- dtrace\_proc - allows the use of the pid provider on processes that
    the user owns.
- dtrace\_kernel - allows most providers to probe everything, in read
    only mode.

Privileges can be added to a process (such as a user's shell)
temporarily by using the ppriv(1) command. For example, to add
dtrace\_user to PID 1851, ppriv -s A+dtrace\_user 1851\
usermod can be used to make this a permanent change to a user account.
For example, usermod -K defaultpriv=basic,dtrace\_user brendan

### drops on CPU \#dtrace: 864476 drops on CPU 0

dtrace: 2179050 drops on CPU 0\
dtrace: 1343451 drops on CPU 0

The DTrace kernel buffer is overflowing due to output being generated
too quickly for /usr/sbin/dtrace to read. This usually happens when your
script would output hundreds of screens of text per second. Some
remedies:

- Increase the switchrate of /usr/sbin/dtrace, so that rather than
    flushing the buffer at 1 Hertz (default), it is reading the
    buffer faster. At the command line this can be -x switchrate=10hz.
- Increase the size of the DTrace primary buffer. By default this is
    usually 4 Mbytes per CPU. At the command line it can be increased,
    eg -b 8m.
- Do you really want that much data to be output? Try to probe
    fewer events. Also, aggregations can be used so that DTrace can
    summarise the data and output the the final report, avoiding an
    output buffer overflow.

### invalid address (0x...) in action

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# dtrace -n 'syscall::open:entry { trace(stringof(arg0)); }'

dtrace: description 'syscall::open:entry ' matched 1 probe
dtrace: error on enabled probe ID 1 (ID 6329: syscall::open:entry):
invalid address (0xd27f7a24) in action #1
dtrace: error on enabled probe ID 1 (ID 6329: syscall::open:entry):
invalid address (0xd27fbf38) in action #1
```

</div>

</div>

</div>

This error is caused when DTrace attempts to dereference a memory
address which isn't mapped. In the above example, the arg0 variable for
the open(2) syscall refers to a user-land address, however DTrace
executes in the kernel address space; this example can be fixed by
changing stringof to copyinstr. Listing remedies:

- Use either copyin() or copyinstr() to copy the data from user-land
    into the kernel.
- Attempt to dereference on the return of a function, not the entry.
    On the entry, an address may be valid but not faulted in.

### failed to create probe ... Not enough space

DTrace ran out of RAM when trying to create probes. This can happen if
you attempt to probe far too many events. For example, here we leave
fields blank in our probe description (wildcards), and so our probe
description will attempt to match every instruction from every function
of mozilla (which would be millions of probes).

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# dtrace -ln 'pid$target:::' -p `pgrep mozilla-bin`
dtrace: invalid probe specifier pid$target:::: failed to create probe in
 process 7424:
Not enough space
#
```

</div>

</div>

</div>

In this case, perhaps we meant to probe just function entries
- pid\$target:::entry, or perhaps instructions from just one library
- pid\$target:libaio::.

See Also
------------

- [DTrace Tips, Tricks and
    Gotchas](http://blogs.sun.com/roller/resources/bmc/dtrace_tips.pdf)
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


