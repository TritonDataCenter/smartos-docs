# About Memory Usage and Capping

When monitoring the memory usage of processes and zones, the numbers may
not seem to add up, which can lead to confusion. This topic explains how
SmartOS calculates the various values and why they normally do not
agree.

## Calculating the RSS of a Process

The RSS values for the `ps` and `prstat` process lists come from
the `/proc` file system. Internally these values are calculated by
the `rm_asrss()` function, which determines how much memory the address
space of a process is using. The comment on
the `rm_asrss()` implementation explains the drawbacks to this approach:

> This is currently implemented as the number of active hardware
> translations that have page structures. Therefore, it can
> underestimate the traditional resident set size, eg, if the physical
> page is present and the hardware translation is missing; and it can
> overestimate the rss, eg, if there are active translations to a frame
> buffer with page structs. Also, it does not take sharing and XHATs
> into account.

## Calculating the RSS of a Zone

In addition to the limitations inherent in `rm_asrss()`, you can't
simply sum the per-process RSS values to obtain the size of the zone's
RSS. This is because it's common for processes in a zone to share pages,
such as code pages from `libc` or other libraries on the system. Because
of this type of page sharing, it is difficult to calculate the overall
RSS for a zone.

Operationally, the overall RSS for a zone is the value reported
by `prstat -Z`. This value is calculated by the
internal `getvmusage()` system call, which counts the number of resident
memory pages used by all of the processes in the zone. It tries to
determine a more accurate zone RSS value by avoiding double-counting
pages. This is the value used for memory capping.

The `getvmusage()` system call calculates RSS so that for a given zone,
a page is only counted once. For example, if multiple processes in the
same zone map the same page, then the zone is only charged once for that
page. On the other hand, if two processes in different zones map the
same page, then both zones are charged for the page.

The following pseudocode describes how `getvmusage()` calculates the RSS
for a zone.

- For each process:
  - Figure out process's zone
    - For each segment in process's address space:
      - If segment is private:
        - Lookup anons in the amp.
        - For incore pages not previously visited each of the process's zones,
          add incore pagesize to each zone. Anon's with a refcnt of 1 can
          be assummed to be not previously visited.
        - For address ranges without anons in the amp:
          - Lookup pages in underlying vnode.
          - For incore pages not previously visited for each of the process's
            zones, add incore pagesize to each zone.
      - If segment is shared:
        - Lookup pages in the shared amp or vnode.
        - For incore pages not previously visited for each of
          the process's zones, add incore pagesize to each zone.

Because both the `/proc` and the `getvmusage()` RSS calculation are
looking at processes at a point in time, it is possible for the numbers
to disagree or to be different from one moment to the next as the
processes on the system cause page faults, as pages are paged out, or as
processes start and end.

Thus, the RSS is at best an approximation of the physical memory usage
of processes and zones.
