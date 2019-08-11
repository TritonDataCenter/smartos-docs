# dtrace.conf 2012 - ZFS DTrace Provider

<!-- markdownlint-disable no-inline-html -->

<div class="youtube-player">
  <iframe type="text/html" src="https://www.youtube.com/embed/m_V7yrrn49Y"
    frameborder="0" allowfullscreen></iframe>
</div>

Matt Ahrens and George Wilson of Delphix.

ZFS DTrace Provider

provide file info in io provider

- this will only work for "normal" i/o's
- zil, mos, aggregate io's will not have file info
- initially, only reads will have file info

ZIO probes

- provides zfs-specific information about each logical i/o
- aggregation
- arguments to probe will include:
  - bookmark
  - dnode type
  - file name
  - dataset name
  - sync vs. async
  - zil vs. other (including dmu\_sync())
  - for zil, allocated vs written size
  - is it a read-to-write
  - is it a scrub
  - is it a send
  - is it from the L2ARC
  - prefetch
  - perhaps the originating PID? (otherwise not knowable for
    async writes)
- pipeline stages
  - allocation details

TXG probes

- track txg state changes and why
  - open -&gt; quiescing -&gt; syncing -&gt; done
  - why: timer, memory throttle, dirty throttle, requested
- phases of sync (pass1; sync task; scan; ...)
- calls to txg\_wait\_sync (usually indicates administrative action)
- calls to txg\_wait\_open (usually indicates write throttling)

ARC probes

- global variables (arc\_c, etc)?
- buffer state changes (mru -&gt; mfu -&gt; evict -&gt; evict ghost)
  - arguments to probe will include:
  - bookmark / file name / dataset name
  - time block was initially added to ARC
- why it was initially added to ARC (prefetch vs read vs write)
