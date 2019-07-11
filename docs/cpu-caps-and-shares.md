# CPU Caps and Shares

SmartOS uses a Fair Share Scheduler (FSS) for handling allocation of CPU
resources to machines provisioned on a compute node. The FSS uses two
values to allocate CPU resources:

- **CPU cap** is the maximum amount of CPU resources a machine
  can use.
- **CPU share** the minimum amount of CPU resources a machine can use.

As previously described, the CPU cap is a hard limit. The CPU share is
used to determine how the CPU resource pool is allocated among running
machines.

Both the CPU cap and the CPU share values are given in the package used
to provision the machine. The CPU cap is given explicitly in the
package. The CPU share value is equivalent to the RAM allocated to the
machine in megabytes. For example, a machine with 1 GB RAM is given 1024
shares. A machine with 8 GB RAM is given 8192 shares.

SmartOS does not impose a relationship between RAM and shares. The
provisioning process simply uses the amount of RAM to ensure that a machine
with more memory gets more shares than a machine with less memory.

The CPU cap is the maximum number of CPUs that a provisioned machine can
use. This value is expressed as a percentage, where 100 means one CPU. A
CPU cap of 350 means that the provisioned machine can use at most 3.5
CPUs.

The CPU share is used to determine the minimum amount of CPUs that a
provisioned machine can use. The share value is relative to
the *total* number of shares for all the provisioned machines running in
the compute node.

## Example Use Cases

An example will help illustrate the relationship between CPU caps and
shares. Assume that your compute node has 24 CPU cores and that the
following SmartOS VMS are provisioned on it.

| Number of Machines | RAM  | Shares | CPU Cap       |
| ------------------ | ---- | ------ | ------------- |
| 4                  | 8 GB | 8192   |  200 (2 CPUs) |
| 2                  | 4 GB | 4096   |  300 (3 CPUs) |

### All Six Machines Running

If all six machines are running, the total number of shares is:

    (4 * 8192) + (2 * 4096) = 40960 shares

Each of the 8 GB machines has 20% of the shares, so it can get 4.8 CPUs.

    8192 / 40960 = 0.20
    24 * .20 = 4.8

And each of the 2 GB machines has 10% of the shares and 2.4 CPUs.

    4096 / 40960 = 0.10
    24 * .10 = 2.4

However, since the 8 GB machines are capped at 2 CPUs, that is the
maximum CPU resources they will get. The 2 GB machines are capped at 3
CPUs, but the shares allocate only 2.4 CPUs to them, so that's how much
CPU time they will get.

### Only Five Machines Running

Now suppose that one of the 8 GB machines is turned off. In this case,
the total number of shares is:

    (3 * 8192) + (2 * 4096) = 32768 shares

The 8 GB machines now have 25% of the shares, or 6 CPUs.

    8192 / 32768 = 0.25
    24 * 0.25 = 6

The 4 GB machines now have 12.5% of the shares, or 3 CPUs.

    4096 / 32768 = 0.125
    24 * 0.125 = 3

The 8 GB machines are capped at 2 CPUs, so they still get only 2 CPUs.
The 4 GB machines are capped at 3 CPUs, so they can use their full
share, which is 3 CPUs.

## Useful Commands

The section lists some useful SmartOS command that you can use to get
information about CPU usage on a compute node and provisioned machines.

### Finding the Total Number of CPUs on a Compute Node

Use the `psrinfo` command to get the total number of CPUs:

    computenode# psrinfo
    0       on-line   since 04/13/2012 15:32:01
    1       on-line   since 04/13/2012 15:32:01

### Finding the CPU Cap of a Machine

Use the `prctl` command to get the CPU cap of a machine. You can run
this command from the compute node's global zone to get the CPU cap
value for both SmartMachines and Virtual Machines.

    compnode# prctl -n zone.cpu-cap -i zone 9e39f274-1587-4c26-89e6-e445fd20c9b5
    zone: 4: 9e39f274-1587-4c26-89e6-e445fd20c9b5
    NAME    PRIVILEGE       VALUE    FLAG   ACTION                    RECIPIENT
    zone.cpu-cap
            usage               5
            privileged        350       -   deny                      -
            system          4.29G     inf   deny                      -

In the output, `usage` is the current percentage of CPU used, and
`privileged` is the CPU cap.

Within a SmartMachine you can use the value of `zonename` to get the CPU
cap of a machine:

    machine# prctl -n zone.cpu-cap -i zone $(zonename)
    zone: 1: 97c7f691-0c53-4651-9765-9c52c32c6dd4
    NAME    PRIVILEGE       VALUE    FLAG   ACTION                    RECIPIENT
    zone.cpu-cap
            usage               2
            privileged        350       -   deny                      -
            system          4.29G     inf   deny                      -

## Finding the Number of Shares Allocated to a Machine

Use the `prctl` command to get the number of shares allocated to a
machine. You can run this command from the compute node's global zone to
get the share value for both SmartMachines and Virtual Machines.

    compnode# prctl -n zone.cpu-shares -i zone 9e39f274-1587-4c26-89e6-e445fd20c9b5
    zone: 4: 9e39f274-1587-4c26-89e6-e445fd20c9b5
    NAME    PRIVILEGE       VALUE    FLAG   ACTION                    RECIPIENT
    zone.cpu-shares
            usage             128
            privileged        128       -   none                      -
            system          65.5K     max   none                      -

In t he output, `usage` means how many shares are being used, and
`privileged` means how many shares are allocated.

You can also use this command within a SmartMachine to find out how many
shares are allocated to it:

    [root@vanilla ~]# prctl -n zone.cpu-shares -i zone $(zonename)
    zone: 1: 97c7f691-0c53-4651-9765-9c52c32c6dd4
    NAME    PRIVILEGE       VALUE    FLAG   ACTION                    RECIPIENT
    zone.cpu-shares
            usage             128
            privileged        128       -   none                      -
            system          65.5K     max   none                      -
