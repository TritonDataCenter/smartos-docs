# Glossary

<!-- markdownlint-disable no-trailing-punctuation -->

## API

"An application programming interface (API) is a particular set of rules and
specifications that software programs can follow to communicate with each other.
" - [wikipedia](https://en.wikipedia.org/wiki/Api)

## CDN

Content Delivery Network  
"A system of computers containing copies of data placed at various nodes of a
network. When properly designed and implemented, a CDN can improve access to the
data it caches by increasing access bandwidth and redundancy and reducing access
latency." - [wikipedia](https://en.wikipedia.org/wiki/Content_delivery_network)

## Clone

A writable [snapshot](glossary.md#snapshot) of a file system.

## Cloud

"... a style of computing in which dynamically scalable and often virtualized
resources are provided as a service over the internet." -
[wikipedia](https://en.wikipedia.org/wiki/Cloud_computing)

The [National Institute of Standards and Technology](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-145.pdf)
(pdf): "Cloud computing is a model for enabling ubiquitous, convenient,
on-demand network access to a shared pool of configurable computing resources
(e.g., networks, servers, storage, applications, and services) that can be
rapidly provisioned and released with minimal management effort or service
provider interaction."

## Colocation

"A type of data center... Colocation allows multiple customers to locate
network, server, and storage gear - and connect them to a variety of
telecommunications and network service providers - with a minimum of cost and
complexity." - [wikipedia](https://en.wikipedia.org/wiki/Colocation_centre)

## Compute node

Compute nodes are the physical servers in a [datacenter](glossary.md#datacenter)
that are managed by a [head node](glossary.md#head-node).

## CRM

Customer Relationship Management  
"... a widely-implemented strategy for managing a company’s interactions with
customers, clients and sales prospects. It involves using technology to
organize, automate, and synchronize business processes---principally sales
activities, but also those for marketing, customer service, and technical
support." -
[wikipedia](https://en.wikipedia.org/wiki/Customer_Relationship_Management)

## Customer portal

The customer portal is a reference portal that consumers can use to manage their
[SmartMachine](glossary.md#smartmachine).

## Datacenter

A datacenter is both a physical and virtual location that connects to the
Internet, and holds a [head node](glossary.md#head-node) and one or more
[compute nodes](glossary.md#compute-node). A datacenter may have several head
nodes. In this case each head node has its own name to differentiate between
each of their instances.

## Dataset

A dataset describes the software that's going to end up on a newly provisioned
machine. A dataset is sometimes called an image. All machines provisioned from
the same dataset have the same software. On Virtual Machines, the dataset also
includes the operating system and the disk that contains it.

## DIRT

Data-intensive real-time applications.

## DTrace

A performance analysis and troubleshooting tool for user-level software,
operating system kernels and device drivers. It is included by default with
various operating systems. See [DTrace.org](http://dtrace.org/blogs/about/)

## Endpoint

A URL, the end of an API that communicates with the rest of the world.  
"An endpoint can call and be called. It generates and terminates the information
stream." - [webopedia](https://www.webopedia.com/TERM/E/endpoint.html)

## Global zone

The native name of the system that holds all the other [zones](glossary.md#zone)
in a [compute node](glossary.md#compute-node) or a [head node](glossary.md#head-node)
. The operating system which is running directly on bare metal. This is a
Solaris term.

## Head node

This is the physical server/node that controls all the other physical and
virtual servers. It controls the provisioning and maintenance of
[SmartMachines](glossary.md#smartmachine) and Virtual Machines.

## Hypervisor

"A hypervisor, also called virtual machine manager (VMM), is one of many
hardware virtualization techniques that allow multiple operating systems to run
concurrently on a host computer." - [wikipedia](https://en.wikipedia.org/wiki/Hypervisor)

## IP-KVM

Keyboard/video/mouse.

## IaaS

"Cloud infrastructure services, also known as Infrastructure as a Service
(IaaS), deliver computer infrastructure – typically a platform virtualization
environment – as a service. Rather than purchasing servers, software,
data-center space or network equipment, clients instead buy those resources as
a fully outsourced service. Suppliers typically bill such services on a utility
computing basis; the amount of resources consumed (and therefore the cost) will
typically reflect the level of activity. IaaS evolved from virtual private
server offerings." - [wikipedia](https://en.wikipedia.org/wiki/IaaS)

## illumos

An operating system derived from Sun Microsystems' [OpenSolaris](https://en.wikipedia.org/wiki/Opensolaris).

## Kernel

The main component of a computer operating system, which manages system
resources and communications between those resources and applications running
on the system.

## KVM

Kernel virtual machine: a virtual machine implementation using the operating
system's kernel. - [wikipedia](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine)

## LAN

Local Area Network.

## Latency

The time an operation takes to complete; "a measure of customer pain". Lower =
better.

## Logical Network

A mechanism that SmartDataCenter uses to associate network segments with
physical network adapters on the head node and on compute nodes.

## Managed hosting

"A type of Internet hosting in which the client leases an entire server not
shared with anyone." - [wikipedia](https://en.wikipedia.org/wiki/Managed_hosting)

## MAPI

The Cloud Management API provides low-level access to SmartDataCenter. Every
head node runs an instance of MAPI.

## NAS

Network-attached storage.

## Network virtualization

A set of features in OpenSolaris, Illumos and SmartOS which provides an internal
network virtualization and quality of service scenario. -
[wikipedia](https://en.wikipedia.org/wiki/OpenSolaris_Network_Virtualization_and_Resource_Control)

## NIC

Network Interface Card (or Controller).

## NIC tags

NIC tags (network interface card/controller tags) are the physical network label
(a name not a number) that is associated with an active network interface port.
Each active network interface port will have a MAC (media access control) from
the NIC vendor and SDC NIC_tag.

## NoSQL

Non Relational Database.

## Object storage

"An Object-based Storage Device (OSD) is a computer storage device, similar to
disk storage but working at a higher level. Instead of providing a
block-oriented interface that reads and writes fixed sized blocks of data, an
OSD organizes data into flexible-sized data containers, called objects." -
[wikipedia](https://en.wikipedia.org/wiki/Object_storage_device)

## OpenSolaris

An open-source computer operating system based on Sun Microsystems' Solaris.

## Operations portal

The Operations Portal is a web application that allows administrators to manage
a [datacenter](glossary.md#datacenter).
The Operations Portal can be used to:

- Manage data centers, racks, physical servers, and SmartMachines
- Provision SmartMachines for new and existing customers
- Maintain accounts of customers, compute nodes, SmartMachine, and IP addresses

## Orchestration

"... the automated arrangement, coordination, and management of complex computer
systems, [middleware](https://en.wikipedia.org/wiki/Middleware), and services" -
[wikipedia](https://en.wikipedia.org/wiki/Orchestration_(computing)). In
cloud computing, refers to a platform for managing cloud infrastructure from
multiple providers.

## PaaS

"Platform as a Service (PaaS) is the delivery of a computing platform and
solution stack as a service." -
[wikipedia](https://en.wikipedia.org/wiki/Platform_as_a_service)

## Package

A package describes the size and capacity of a machine: the size of its disk,
how many processes it can spawn, how many CPUs it has, how its networking is
laid out. Two machines can be provisioned with the same dataset but different
packages. Virtual Machines always have at least two disks: one for the operating
system and one from the package.

## Paravirtualization

Paravirtualization is virtualization technique supported by certain hypervisors
that presents a software interface to virtual machines that is similar but not
identical to that of the underlying hardware. -
[wikipedia](https://en.wikipedia.org/wiki/Paravirtualization)

## QoS

Quality of Service - [wikipedia](https://en.wikipedia.org/wiki/Quality_of_Service)

## RAID

Redundant Array of Independent (originally "Inexpensive") Disks.

## REST

Representational State Transfer  
[Wikipedia](https://en.wikipedia.org/wiki/Representational_State_Transfer):
"A style of software architecture for distributed hypermedia systems such as
the World Wide Web... REST-style architectures consist of clients and servers.
Clients initiate requests to servers; servers process requests and return
appropriate responses. Requests and responses are built around the transfer of
representations of resources. A resource can be essentially any coherent and
meaningful concept that may be addressed. A representation of a resource is
typically a document that captures the current or intended state of a resource.

At any particular time, a client can either be in transition between application
states or "at rest". A client in a rest state is able to interact with its user,
but creates no load and consumes no per-client storage on the servers or on the
network."

## SaaS

Software as a Service, "a software delivery model in which software and its
associated data are hosted centrally (typically in the cloud) and are typically
accessed by users using a thin client, normally using a web browser over the
Internet." - [wikipedia](https://en.wikipedia.org/wiki/Software_as_a_service)

## SDC

SmartDataCenter.

## SLA

Service Level Agreement.

## SmartMachine

A SmartMachine a [SmartOS](glossary.md#smartos) zone created by Joyent.
SmartMachines share / and /usr from the [compute node's](glossary.md#compute-node)
global zone. Users store their files in a dataset that belongs exclusively to
a particular SmartMachine.

## SmartOS

SmartOS is a Joyent-developed live image-based operating system derived from
the OpenSolaris 147 build.

## Snapshot

A snapshot is a copy of an entire file system at a particular point in time.
SmartOS uses copy-on-write snapshotting. (The initial snapshot is empty. When
blocks are about to be written on the original volume, the original data is
copied to the snapshot)

## TLA

Three Letter Acronym.

## Template

A template is a named set of files and scripts used to generate a deployable
[dataset](glossary.md#dataset). You can think of a template as a recipe for a
"dataset generator", and the fact that it's versioned means that generations of
the same dataset type can be generated. Templates may be published to a
Templates API, which also provides dataset generating services.

## UUID

[Universally Unique Identifier](https://en.wikipedia.org/wiki/Universally_unique_identifier).
An identifier that is highly unlikely to be used by anyone else in any other
system anywhere.

## Userland

In a computer operating system, the software layer where user applications and
software libraries run. Contrast with [kernel](glossary.md#kernel).

## Virtual appliance

A software image containing a software stack designed to run inside a virtual
machine.

## Virtualization

"The creation of a virtual (rather than actual) version of something, such as a
hardware platform, operating system, a storage device or network resources." -
[wikipedia](https://en.wikipedia.org/wiki/Virtualization)

## VLAN

[Virtual Local Area Network](https://en.wikipedia.org/wiki/Virtual_LAN).

## VNIC

In OpenSolaris/Illumos/SmartOS network virtualization and resource control, "a
Virtual Network Interface Card (VNIC) is a pseudo network interface that is
configured on top of a system's physical Network adapter, also called a network
interface (NIC). A physical interface can have more than one VNIC. Each VNIC
operates like and appears to the system as a physical NIC." -
[wikipedia](https://en.wikipedia.org/wiki/OpenSolaris_Network_Virtualization_and_Resource_Control#VNIC)

## VPS (Virtual Private Server)

"A marketing term used by Internet hosting services to refer to a virtual
machine for use exclusively by an individual customer of the service." -
[wikipedia](https://en.wikipedia.org/wiki/Virtual_private_server)

## ZFS

The file system and logical volume manager used in
[SmartOS](glossary.md#smartos). You can learn more about ZFS
[here](https://en.wikipedia.org/wiki/ZFS).

## Zone

[SmartOS](glossary.md#smartos) operating system-level virtualization. Zones
provide containment and name-space isolation for processes, akin to running
SmartOS on bare metal, however there is only a single OS kernel running on
the system. There is no kernel duplication or overhead, or hardware or emulation
per zone.
