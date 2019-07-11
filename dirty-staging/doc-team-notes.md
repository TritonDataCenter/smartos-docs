+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Doc Team Notes </span>

</div>

<div class="pagesubheading">

This page last changed on Sep 05, 2012 by
<font color="#0050B2">benr@joyent.com</font>.

</div>

This was previous the SmartOS Doc Wiki home page.

<div>

<ul>
<li>
[Proposed Outline and Structure of SmartOS
Wiki](#DocTeamNotes-ProposedOutlineandStructureofSmartOSWiki)
</li>
<ul>
<li>
[Type of content needed in SmartOS
wiki](#DocTeamNotes-TypeofcontentneededinSmartOSwiki)
</li>
<li>
[Audience Profiles](#DocTeamNotes-AudienceProfiles)
</li>
<li>
[Proposed outline](#DocTeamNotes-Proposedoutline)
</li>
<li>
[SmartOS Wiki Feedback](#DocTeamNotes-SmartOSWikiFeedback)
</li>
<ul>
<li>
[Topic on how to Integrate "my stuff" with
SmartOS](#DocTeamNotes-TopiconhowtoIntegrate%22mystuff%22withSmartOS)
</li>
<li>
[Too much overlap in current
wiki](#DocTeamNotes-Toomuchoverlapincurrentwiki)
</li>
<li>
[Use of vmadm biggest culprit when it comes to
overlap](#DocTeamNotes-Useofvmadmbiggestculpritwhenitcomestooverlap)
</li>
<li>
[Perspective on why you don't install SmartOS to
disk](#DocTeamNotes-Perspectiveonwhyyoudon%27tinstallSmartOStodisk)
</li>
<li>
[More introduction/perspective on SmartOS
features](#DocTeamNotes-Moreintroduction%2FperspectiveonSmartOSfeatures)
</li>
<li>
[More direction from SmartOS dev
heavy-weights](#DocTeamNotes-MoredirectionfromSmartOSdevheavyweights)
</li>
<li>
[Need sections on migration](#DocTeamNotes-Needsectionsonmigration)
</li>
<li>
[Need to emphasize pkgin](#DocTeamNotes-Needtoemphasizepkgin)
</li>
<li>
[Cheatsheets](#DocTeamNotes-Cheatsheets)
</li>
<li>
[Section on creating your own
services](#DocTeamNotes-Sectiononcreatingyourownservices)
</li>
- Recently Updated

</ul>
</ul>
</ul>

</div>

Proposed Outline and Structure of SmartOS Wiki
==================================================

The SmartOS wiki is an excellent hub for community resources where the
community can learn about SmartOS and directly contribute to the SmartOS
development effort. However, the wiki can use a helping hand. So, I put
together this proposed outline in the hope of imbuing the SmartOS wiki
with a logical structure. My goal with this outline is to make the
content easier to consume and also make it easier for people to
contribute.

Please take a look and let me know what you think! At some point, I will
compile all feedback and share it with the community. You can comment
directly on this page or you can send an email directly to me at
jason.davis@joyent.com.

Type of content needed in SmartOS wiki
------------------------------------------

My general approach is to identify how I can compartmentalize the
content into discrete and semantic sections. I don't know if that
approach is appropriate for this content. So, I want to start first by
identifying the type of content the community needs based on what we
already have.\
\* Configuration tasks\
\* Management tasks\
\* FAQs and additional resources\
\* Community engagement\
\* Context and historical relevance\
\* Issue tracking/change log

Audience Profiles
---------------------

Here are a few audience profiles that I have identified as the type of
people most likely to look for information in this wiki. Once we have a
better idea of who is looking for what, we can mold the wiki so that
people know how to zero in on the information they need. I'm not sure if
the below designations work but they do provide context for how best to
structure the wiki. Does this adequately cover all use cases?

\* <font color="#222222">**Beginner:**</font>
<font color="#222222">Don't know anything about SmartOS and are curious.
These people need access to introductory content, links to videos, use
cases, historical content, etc.</font>\
\* <font color="#222222">**Intermediate:**</font>
<font color="#222222">Just downloaded the ISO and want to fire up their
first VMs. These people need short and sweet quickstart guides.</font>\
\* <font color="#222222">**Advanced:**</font> <font color="#222222">Want
to modify SmartOS and/or recompile it themselves,
w</font><font color="#222222">ant to migrate from a different
virtualization product, etc.</font>

Proposed outline
--------------------

Here is my proposed outline. I consider this fluid at the moment. This
outline is based on how my brain compartmentalizes stuff and how we
currently structure the SmartOS wiki. To my untrained eye, most of what
we have in the SmartOS wiki could go into a "tips and tricks" section.
 That is probably a misguided view.

So, the challenge here is to figure out how the content we have fits in
with the core SmartOS setup/usage experience vs. ancillary tasks/useful
tips. This should then lead to a better understanding of current gaps
and what we need to do with the wiki going forward.\
\# Introduction/Home\
\#\# Why SmartOS, KVM, DTrace\
\#\# SmartOS Virtualization\
\#\# SmartOS changelog. Optionally I can stuff this in the back of the
wiki somewhere and just link to it from the Introduction page.\
\# Community Engagement\
\#\# Annoucements\
\#\# Events\
\#\#\# Event suggestions\
\#\# Historical relevance\
\#\#\# Who is who\
\#\# Wish list or Requests\
\# Install it\
\#\# Download\
\#\# Getting started\
\#\# Hardware support\
\#\# Creating bootable USB key\
\#\# Guest OSs\
\# Use it\
\#\# How to create a VM\
\#\#\# "...a single page (easy to locate) that describes (in
copy'n'paste form) how to install your server and get your first vm
up'n'running."\
\#\#\# Using VM admn\
\#\# How create a zone\
\#\# Managing Datasets\
\#\# Working with Packages\
\# Extend it\
\#\# How to integrate your stuff with SmartOS\
\#\#\# "What I do have (and I'm pretty sure I'm not alone there) is a
fair amount of experience from various opensource projects I'd \_love\
\_ to see running on SmartOS."\
\#\#\# "...tips about hooks and libraries we may utilize to get an even
better 'out of the box' experience running under SmartOS."\
\#\# Contributing to SmartOS\
\#\# Building your own packages\
\#\# Building your own dataset\
\#\#\# SmartOS based\
\#\#\# VM based\
\#\# Building SmartOS on SmartOS\
\#\# Extending SmartOS-live\
\#\# 3rd Party SmartOS Extensions\
\# FAQs\
\#\# Extra configuration options\
\#\# How do I take obtain a system crash dump via IPMI?\
\#\# Questions from SmartOS the Modern OS Webinar\
\# Tips and tricks\
\#\# Tuning the IO throttle\
\#\# Enlarging a Windows 7 VM disk\
\#\# Managing NICs\
\#\# Migrating from ESXi 4.x\
\#\# Remotely upgrading a USB key based deployment\
\#\# SmartOS remote management\
\# Resources\
\#\# Consolidate videos here\
\#\#\# SmartOS KVM screencast demo\
\#\# More information and resources

SmartOS Wiki Feedback
-------------------------

Here are some notable comments on the SmartOS wiki and thoughts on
improvement. Names and faces have been omitted to protect the innocent.

### Topic on how to Integrate "my stuff" with SmartOS

"...there should be a page describing 'How do I integrate my stuff to
SmartOS'. I would love to contribute to SmartOS itself, but
unfortunately I don't have enough time to sit down to get my head above
the water to learn about how all the nice stuff in the kernel works.
What I do have (and I'm pretty sure I'm not alone there) is a fair
amount of experience from various opensource projects I'd \_love\
\_ to see running on SmartOS. It would be great to have some tips about
hooks and libraries we may utilize to get an even better "out of the
box" experience running under SmartOS."

### Too much overlap in current wiki

"One of the biggest issues I have with the wiki is that duplicate
information is sometimes spread across multiple pages (in slightly
different forms on each) and when someone comes onto IRC it's not always
obvious which (if any) wiki page will best answer a question they've
asked."

### Use of vmadm biggest culprit when it comes to overlap

"The biggest culprit when it comes to overlap is information on use of
vmadm to create KVM VMs and SmartMachine zones. If that stuff could be
cleaned up and properly consolidated / reorganized, I think that would
be a big win."

### Perspective on why you don't install SmartOS to disk

"Somewhere in Section 2 (Installation) there probably ought to be some
space set aside to discuss why SmartOS works better without actually
being installed to disk."

### More introduction/perspective on SmartOS features

"Several key features are named over & over when selling SmartOS, but in
& around the Illumos community it can be very hard to find good
introductory doc on what they are and how to use them: DTrace, Crossbow,
etc."

### More direction from SmartOS dev heavy-weights

"As part of the Community section, I think it's very important for the
well-versed "silverback" devs to take a step back and define a
foundation to help bring new contributors in quickly. How to set up a
build zone, what's the workflow for keeping up with SCM & getting
patches pulled in, how to contribute patches, etc."

### Need sections on migration

"There's two sections that weren't mentioned in your outline: "Migrating
from Linux KVM" and "Migrating from VirtualBox". I know the former is
quite easy, and the latter is possible. I've heard a number of people
asking questions about both."

### Need to emphasize pkgin

"Another section is pkgin. Zones without pkgin are a hostile place --
I've been there, and I'd never do it again. pkgin really deserves
emphasizing."

\*JD: Do you mind sharing some of your pitfalls on working in a zone
without pkgin?\*

"It's a pain in the arse!

Zones exist to do things with. Typically a zone doesn't contain the
application code or many of the libraries you want, so they have to come
from somewhere.

Here are some alternatives:

a\) blastwave - they're trying, but my experience with that stuff was
unpleasant\
b) sunfreeware - worse than blastwave\
c) compile from source - on Linux this'd be easy, but fudging is often
required to get things compiling on Solaris-derivatives

Just use pkgin. The End.

Well, not quite. The stuff in pkgsrc isn't thoroughly tested, so often
some package or another doesn't work properly. It's important that the
community get feedback about these failures so we can fix it for others
as well. One alternative is letting us know on
\#joyent@irc.freenode.net. A second is writing an issue on
\[https://github.com/mamash\]. The third is probably writing to
smartos-discuss email list.

We really need to make this as simple as possible, because without a
good package manager SmartOS zones become nigh useless."

### Cheatsheets

"I strongly urge a cheatsheet section that quickly summarizes important
things. Many of my favourite textbooks take such an approach, leaving
the details for later chapters. This section could (and arguably should)
serve double purpose: IIRC, some BSD's have a "man firstboot" which
serves as a crashdrive into the system, and content from such a section
in the wiki could be copied into this manpage too."

\*JD: Can you elaborate on this a bit more? Do you have an example you
could share with me?\*

"Not offhand, no.

By double-purpose, I think it'd be nice to have all this material in a
manpage too. Someone on IRC once mentioned that some BSD's have a
manpage for newcomers that summarizes various common commands,
filesystem locations, and differences with other unicies. I think we
should copy that. If you're writing that material for the wiki anyway,
might as well copy it into a man page.

As an aside, the major problem with most manpages is they don't provide
any examples. Examples make life so much easier. Perhaps the cheatsheet
should be a table divided in two, one side a common command, the other
an example: \[\^cheatsheet example.rtf\]

\*Nahum:\* I don't have code I can point to, so this suggestion is only
partly useful... If there's something that can parse confluence markup,
perhaps a tool could be written that pulls some cheetsheet pages from
the wiki and converts them into man pages to be included in SmartOS.

### Section on creating your own services

"It just occurred to me that it'd be nice to have a section on the wiki
about how to create your own services. This is common for any server
application, yet making a service is a somewhat tedious affair that
usually involves cargo-culting. There are a number of small apps out
there which make the creation of a service manifest much simpler. Beyond
packages, I think services are the second most likely thing to scare
people off."

+--------------------------+--------------------------+-----------------
---------+
| <div                     |                          | <div
         |
| class="recently-updated  |                          | id="pagetreesear
ch">     |
| recently-updated-concise |                          |
         |
| ">                       |                          | <form method="PO
ST" acti |
|                          |                          | on="https://wiki
.smartos |
| #### Recently Updated {# |                          | .org/plugins/pag
etreesea |
| recently-updated .sub-he |                          | rch/pagetreesear
ch.actio |
| ading}                   |                          | n" name="pagetre
esearchf |
|                          |                          | orm">
         |
| <fieldset class="hidden  |                          | <input type="hid
den" nam |
| parameters">             |                          | e="ancestorId" v
alue="75 |
| <input type="hidden" id= |                          | 6407">
         |
| "changesUrl" value="/plu |                          | <input type="hid
den" nam |
| gins/recently-updated/ch |                          | e="spaceKey" val
ue="DOC" |
| anges.action?theme=conci |                          | >
         |
| se&amp;pageSize=15&amp;s |                          | <input type="tex
t" size= |
| tartIndex=0&amp;spaceKey |                          | "20" name="query
String"> |
| s=DOC">                  |                          | <input type="sub
mit" val |
| </fieldset>              |                          | ue="Search" disa
bled="ye |
| <div                     |                          | s">
         |
| class="results-container |                          | </form>
         |
| ">                       |                          |
         |
|                          |                          | </div>
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          | <div
         |
| r content-type-page">[Bu |                          | class="plugin_pa
getree"> |
| ilding                   |                          |
         |
|     SmartOS on           |                          | <fieldset class=
"hidden" |
|     SmartOS](null/displa |                          | >
         |
| y/DOC/Building+SmartOS+o |                          | <input type="hid
den" nam |
| n+SmartOS "SmartOS Docum |                          | e="treeId" value
>        |
| entation")</span>        |                          | <input type="hid
den" nam |
|     <div                 |                          | e="treeRequestId
" value= |
|     class="update-item-d |                          | "/plugins/pagetr
ee/natur |
| esc">                    |                          | alchildren.actio
n?decora |
|                          |                          | tor=none&amp;exc
erpt=fal |
|     updated by [Chris    |                          | se&amp;sort=posi
tion&amp |
|     Ridd](null/display/~ |                          | ;reverse=false&a
mp;disab |
| cjr){.confluence-userlin |                          | leLinks=false">
         |
| k                        |                          | <input type="hid
den" nam |
|     .url .fn}            |                          | e="treePageId" v
alue>    |
|                          |                          | <input type="hid
den" nam |
|     </div>               |                          | e="noRoot" value
="false" |
|                          |                          | >
         |
|     <div                 |                          | <input type="hid
den" nam |
|     class="update-item-c |                          | e="rootPageId" v
alue="75 |
| hanges">                 |                          | 3667">
         |
|                          |                          | <input type="hid
den" nam |
|     ([view               |                          | e="rootPage" val
ue>      |
|     change](null/pages/d |                          | <input type="hid
den" nam |
| iffpagesbyversion.action |                          | e="startDepth" v
alue="0" |
| ?pageId=754234&selectedP |                          | >
         |
| ageVersions=83&selectedP |                          | <input type="hid
den" nam |
| ageVersions=82))         |                          | e="spaceKey" val
ue="DOC" |
|                          |                          | >
         |
|     </div>               |                          | <input type="hid
den" nam |
|                          |                          | e="i18n-pagetree
.loading |
|     <div                 |                          | " value="Loading
...">    |
|     class="update-item-d |                          | <input type="hid
den" nam |
| ate">                    |                          | e="i18n-pagetree
.error.p |
|                          |                          | ermission" value
="Unable |
|     Jun 28, 2019         |                          |  to load page tr
ee. It s |
|                          |                          | eems that you do
 not hav |
|     </div>               |                          | e permission to
view the |
|                          |                          |  root page.">
         |
| -   <span                |                          | <input type="hid
den" nam |
|     class="icon-containe |                          | e="i18n-pagetree
.eeror.g |
| r content-type-page">[Bu |                          | eneral" value="T
here was |
| ilding                   |                          |  a problem retri
eving th |
|     SmartOS on           |                          | e page tree. Ple
ase chec |
|     SmartOS](null/displa |                          | k the server log
 file fo |
| y/DOC/Building+SmartOS+o |                          | r more informati
on.">    |
| n+SmartOS "SmartOS Docum |                          | <input type="hid
den" nam |
| entation")</span>        |                          | e="loginUrl" val
ue>      |
|     <div                 |                          | <fieldset class=
"hidden" |
|     class="update-item-d |                          | >
         |
| esc">                    |                          | <input type="hid
den" nam |
|                          |                          | e="ancestorId" v
alue="75 |
|     updated by [Brian    |                          | 3667">
         |
|     Bennett](null/displa |                          | </fieldset>
         |
| y/~bbennett){.confluence |                          | </fieldset>
         |
| -userlink                |                          |
         |
|     .url .fn}            |                          | </div>
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=754234&selectedP |                          |
         |
| ageVersions=82&selectedP |                          |
         |
| ageVersions=81))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     May 15, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Re |                          |
         |
| motely                   |                          |
         |
|     Upgrading A USB Key  |                          |
         |
|     Based                |                          |
         |
|     Deployment](null/dis |                          |
         |
| play/DOC/Remotely+Upgrad |                          |
         |
| ing+A+USB+Key+Based+Depl |                          |
         |
| oyment "SmartOS Document |                          |
         |
| ation")</span>           |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Rob      |                          |
         |
|     Johnston](null/displ |                          |
         |
| ay/~rejohnst){.confluenc |                          |
         |
| e-userlink               |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=754556&selectedP |                          |
         |
| ageVersions=23&selectedP |                          |
         |
| ageVersions=22))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Apr 30, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Do |                          |
         |
| wnload                   |                          |
         |
|     SmartOS](null/displa |                          |
         |
| y/DOC/Download+SmartOS " |                          |
         |
| SmartOS Documentation")< |                          |
         |
| /span>                   |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Rob      |                          |
         |
|     Johnston](null/displ |                          |
         |
| ay/~rejohnst){.confluenc |                          |
         |
| e-userlink               |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=753728&selectedP |                          |
         |
| ageVersions=89&selectedP |                          |
         |
| ageVersions=88))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Apr 29, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Ho |                          |
         |
| w                        |                          |
         |
|     do I obtain a system |                          |
         |
|     crash dump via       |                          |
         |
|     IPMI?](null/pages/vi |                          |
         |
| ewpage.action?pageId=754 |                          |
         |
| 743 "SmartOS Documentati |                          |
         |
| on")</span>              |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Rob      |                          |
         |
|     Johnston](null/displ |                          |
         |
| ay/~rejohnst){.confluenc |                          |
         |
| e-userlink               |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=754743&selectedP |                          |
         |
| ageVersions=6&selectedPa |                          |
         |
| geVersions=5))           |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Apr 29, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Cr |                          |
         |
| eating                   |                          |
         |
|     a SmartOS Bootable   |                          |
         |
|     USB                  |                          |
         |
|     Key](null/display/DO |                          |
         |
| C/Creating+a+SmartOS+Boo |                          |
         |
| table+USB+Key "SmartOS D |                          |
         |
| ocumentation")</span>    |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Rob      |                          |
         |
|     Johnston](null/displ |                          |
         |
| ay/~rejohnst){.confluenc |                          |
         |
| e-userlink               |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=753670&selectedP |                          |
         |
| ageVersions=29&selectedP |                          |
         |
| ageVersions=28))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Apr 29, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Ma |                          |
         |
| iling                    |                          |
         |
|     Lists and            |                          |
         |
|     IRC](null/display/DO |                          |
         |
| C/Mailing+Lists+and+IRC  |                          |
         |
| "SmartOS Documentation") |                          |
         |
| </span>                  |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by           |                          |
         |
|     [Joshua M.           |                          |
         |
|     Clulow](null/display |                          |
         |
| /~jclulow){.confluence-u |                          |
         |
| serlink                  |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=755485&selectedP |                          |
         |
| ageVersions=21&selectedP |                          |
         |
| ageVersions=20))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Apr 03, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Bu |                          |
         |
| ilding                   |                          |
         |
|     SmartOS on           |                          |
         |
|     SmartOS](null/displa |                          |
         |
| y/DOC/Building+SmartOS+o |                          |
         |
| n+SmartOS "SmartOS Docum |                          |
         |
| entation")</span>        |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Catalin  |                          |
         |
|     Bostan](null/display |                          |
         |
| /~catalinbostan){.conflu |                          |
         |
| ence-userlink            |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=754234&selectedP |                          |
         |
| ageVersions=81&selectedP |                          |
         |
| ageVersions=80))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Mar 08, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Ha |                          |
         |
| rdware                   |                          |
         |
|     Requirements](null/d |                          |
         |
| isplay/DOC/Hardware+Requ |                          |
         |
| irements "SmartOS Docume |                          |
         |
| ntation")</span>         |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by           |                          |
         |
|     [Sebastian           |                          |
         |
|     Wiedenroth](null/dis |                          |
         |
| play/~wiedi){.confluence |                          |
         |
| -userlink                |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=754915&selectedP |                          |
         |
| ageVersions=47&selectedP |                          |
         |
| ageVersions=46))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Feb 11, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Ho |                          |
         |
| w                        |                          |
         |
|     to create a KVM VM ( |                          |
         |
|     Hypervisor           |                          |
         |
|     virtualized          |                          |
         |
|     machine ) in         |                          |
         |
|     SmartOS](null/displa |                          |
         |
| y/DOC/How+to+create+a+KV |                          |
         |
| M+VM+%28+Hypervisor+virt |                          |
         |
| ualized+machine+%29+in+S |                          |
         |
| martOS "SmartOS Document |                          |
         |
| ation")</span>           |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Shane    |                          |
         |
|     Peters](null/display |                          |
         |
| /~shaner){.confluence-us |                          |
         |
| erlink                   |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=755505&selectedP |                          |
         |
| ageVersions=18&selectedP |                          |
         |
| ageVersions=17))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Jan 31, 2019         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[NA |                          |
         |
| T                        |                          |
         |
|     using                |                          |
         |
|     Etherstubs](null/dis |                          |
         |
| play/DOC/NAT+using+Ether |                          |
         |
| stubs "SmartOS Documenta |                          |
         |
| tion")</span>            |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Brian    |                          |
         |
|     Bennett](null/displa |                          |
         |
| y/~bbennett){.confluence |                          |
         |
| -userlink                |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=755846&selectedP |                          |
         |
| ageVersions=20&selectedP |                          |
         |
| ageVersions=19))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Oct 02, 2018         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Wh |                          |
         |
| y                        |                          |
         |
|     SmartOS - ZFS, KVM,  |                          |
         |
|     DTrace, Zones and    |                          |
         |
|     More](null/display/D |                          |
         |
| OC/Why+SmartOS+-+ZFS%2C+ |                          |
         |
| KVM%2C+DTrace%2C+Zones+a |                          |
         |
| nd+More "SmartOS Documen |                          |
         |
| tation")</span>          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Brian    |                          |
         |
|     Bennett](null/displa |                          |
         |
| y/~bbennett){.confluence |                          |
         |
| -userlink                |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=754218&selectedP |                          |
         |
| ageVersions=42&selectedP |                          |
         |
| ageVersions=41))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Sep 28, 2018         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Do |                          |
         |
| wnload                   |                          |
         |
|     SmartOS](null/displa |                          |
         |
| y/DOC/Download+SmartOS " |                          |
         |
| SmartOS Documentation")< |                          |
         |
| /span>                   |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Brian    |                          |
         |
|     Bennett](null/displa |                          |
         |
| y/~bbennett){.confluence |                          |
         |
| -userlink                |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=753728&selectedP |                          |
         |
| ageVersions=88&selectedP |                          |
         |
| ageVersions=87))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Sep 28, 2018         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Ma |                          |
         |
| naging                   |                          |
         |
|     NICs](null/display/D |                          |
         |
| OC/Managing+NICs "SmartO |                          |
         |
| S Documentation")</span> |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Brian    |                          |
         |
|     Bennett](null/displa |                          |
         |
| y/~bbennett){.confluence |                          |
         |
| -userlink                |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=754315&selectedP |                          |
         |
| ageVersions=29&selectedP |                          |
         |
| ageVersions=28))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     Aug 22, 2018         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   <span                |                          |
         |
|     class="icon-containe |                          |
         |
| r content-type-page">[Bu |                          |
         |
| ilding                   |                          |
         |
|     SmartOS on           |                          |
         |
|     SmartOS](null/displa |                          |
         |
| y/DOC/Building+SmartOS+o |                          |
         |
| n+SmartOS "SmartOS Docum |                          |
         |
| entation")</span>        |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| esc">                    |                          |
         |
|                          |                          |
         |
|     updated by [Jorge    |                          |
         |
|     Schrauwen](null/disp |                          |
         |
| lay/~sjorge){.confluence |                          |
         |
| -userlink                |                          |
         |
|     .url .fn}            |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-c |                          |
         |
| hanges">                 |                          |
         |
|                          |                          |
         |
|     ([view               |                          |
         |
|     change](null/pages/d |                          |
         |
| iffpagesbyversion.action |                          |
         |
| ?pageId=754234&selectedP |                          |
         |
| ageVersions=77&selectedP |                          |
         |
| ageVersions=76))         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
|     <div                 |                          |
         |
|     class="update-item-d |                          |
         |
| ate">                    |                          |
         |
|                          |                          |
         |
|     May 23, 2018         |                          |
         |
|                          |                          |
         |
|     </div>               |                          |
         |
|                          |                          |
         |
| -   [<span               |                          |
         |
|     class="more-link-tex |                          |
         |
| t">More</span>           |                          |
         |
|     ![Please             |                          |
         |
|     wait](s/en/2166/1/_/ |                          |
         |
| images/icons/wait.gif){. |                          |
         |
| waiting-image            |                          |
         |
|     .hidden}](/plugins/r |                          |
         |
| ecently-updated/changes. |                          |
         |
| action?theme=concise&pag |                          |
         |
| eSize=15&startHandle=com |                          |
         |
| .atlassian.confluence.pa |                          |
         |
| ges.Page-6225928&spaceKe |                          |
         |
| ys=DOC&contentType=-mail |                          |
         |
| ,page,comment,blogpost,a |                          |
         |
| ttachment,userinfo,space |                          |
         |
| desc,personalspacedesc,s |                          |
         |
| tatus){.more-link        |                          |
         |
|     .more-link-base}     |                          |
         |
|                          |                          |
         |
| </div>                   |                          |
         |
|                          |                          |
         |
| </div>                   |                          |
         |
+--------------------------+--------------------------+-----------------
---------+
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


