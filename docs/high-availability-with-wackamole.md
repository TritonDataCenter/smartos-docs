# High Availability with Wackamole

One of the authors of Wackamole recommends it's successor,
[vippy](https://github.com/postwait/vippy)

Wackamole is an application which manages a bunch of IPs which should be
accessible from outside all the time.

Given a set of machines and a IPs, wackamole will ensure that if any
machine goes down, other machine will take up its IP almost instantly
and outside world will see no impact.\
It tries to balance the number of IPs across the number of machines
available.\
Wackamole uses Spread network messaging system.

It's a good alternative to VRRP which has some flaws.

Pros:

- very easy to setup
- works very well
- ip switch very fast
- lightweight solution
- doesn't require vrrp or anything from the hypervisor

Cons:

- It is unknown if whackamole is maintained

Lets start configuring it. I am using two zones.
The concept can be extended to as many zones/VM/KVM as you want.

**Step 1:** Here's my example configuration:

    HAProxy1: 192.168.3.151
    HAProxy2: 192.168.3.251
    Virtual IP: 192.168.3.100

**Step 2:** Install wackamole with pkgin (spread will come as a
dependency) on both zones.

**Step3:** Do these 2 parts on the first server.

Edit `/opt/local/etc/wackamole.conf` and put this:

    Spread = 4805 #Spread port
    SpreadRetryInterval = 5s #How often to try to connect to spread, if it fails
    Group = haproxy #Cluster group
    Control = /var/run/wack.it #Name of the socket
    Prefer None #You treat all the IPs as equal

    VirtualInterfaces {
     # IPs from the virtual pool. Can be as many as you want.
     # Specify the network interface you're using for your nic (net0, net1 ...)
     { net1:192.168.3.100/24 }
    }

    Arp-Cache = 20s

    Notify {
     # Notify to this Broadcast address but a not more than 8 times.
     # Specify the network interface you use for your nic (net0, net1 ...)
     net1:192.168.3.1/32 throttle 8
     arp-cache
    }

    balance {
     AcquisitionsPerRound = all
     interval = 4s
    }

    mature = 5s

Edit `/opt/local/etc/spread.conf` and put this:

    Spread_Segment&nbsp; 192.168.3.255:4805 {
     # hostname / ip
     proxy-001 192.168.3.151
     proxy-002 192.168.3.251
    }
    EventLogFile = /var/log/spread.log

**Step4:** Start spread then wackamole on the first server.

You'll see a second network interface (net1:1 in my case, net0:1 if you
only have one nic) on the first server with your virtual ip.

**Step5:** Copy the 2 files above on the second server and start spread
then wackamole.

All done.
If your first server goes down or is unplugged from the network, your
virtual ip will automatically be switched to the second server.

(credits go to Aditya Patawari from
<http://blog.adityapatawari.com/2011/09/building-highly-available-cluster-using.html>)
