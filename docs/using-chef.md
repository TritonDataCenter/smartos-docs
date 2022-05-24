# Using Chef

(If you prefer to be educated by video, try these:
[SmartOS: An SA Primer](http://www.youtube.com/watch?v=dxZExLeJz2I) and/or
[SmartOS Operations – Ben Rockwood at illumos Day](http://www.youtube.com/watch?v=96PGoXHli3Q))

By far the most popular solution for managing SmartOS configuration is
[Opscode Chef](http://www.opscode.com). It is a very powerful tool with
a very active community of users. Here you'll learn about the various
ways in which you can utilize Chef to manage your SmartOS nodes.

Before we dig into the various components and procedures, lets briefly
consider the various combinations of options available to you. These
methods can be mixed-and-matched to fit your specific situation. Please
consider the following:

- Chef Client Installation. Options available include:
  - **The illumos Ops Omnibus Spin**: Discussed below, this is our
    binary distribution of Chef to simplify and speed installation
  - **Install pkgsrc's Ruby, then install the Chef Gem**: This is a
    more complex solution which takes more time and consume far more
    disk, but if wish to leverage pkgsrc in other ways, such as
    installing Nagios for example, it may be a viable option
- Cookbook Distribution &amp; Orchestration
  - **Hosted Chef & Knife**: In this case you would orchestrate
    using the `knife` utility. This includes sending cookbooks to
    the Opscode Platform, bootstrapping new nodes with Knife
    Bootstrap Templates, and running the `chef-client` as a daemon
    which executes on a regular schedule finding and applying
    changes to your cookbooks.
  - **Chef Solo & Scripts**: In this case you would create a custom
    bash bootstrap script, hosted on a web server accessible to the
    nodes, which would be responsible for installing Chef on the
    node, configuring it, and creating an SMF service to
    wrap chef-solo. The cookbooks would be stored on the web server
    as a tarball which would be downloaded on each chef-solo run
    which is initiated manually by restarting the Chef SMF service.

As I said, these options can be mixed and matched. For instance, if you
opt to use Knife to bootstrap a node, you may use a bootstrap template
which installs PKG-SRC and then Chef and its dependencies or you may opt
for a simpler bootstrap template which uses the fat client. There are
many possible combinations and it would be possible to explore all of
them. Therefore, we will present some details here on some of the
concepts and you can use them in whichever order is best for you.

## The Joyent smartos_cookbooks Github Repo

Many of the tools and cookbooks referenced on this page can be found in
the
[`joyent/smartos_cookbooks`](https://github.com/joyent/smartos_cookbooks)
Github repository.

For cookbooks and scripts to be used with SmartMachines/Zones, please
refer to the
[`joyent/smartmachine_cookbooks`](https://github.com/joyent/smartmachine_cookbooks)
repo.

## Installing Chef

### The illumos Ops Omnibus Spin

To speed up deployment and minimize dependencies on nodes, illumos
Operations produces a spin of the official Chef Omnibus build for
Solaris.

**Please note that this client distribution is not official or supported
by either Chef, illumos, or Joyent.**

Due to licensing changes, `13.7.6` is the last version that will be provided.
This bundle has patched a bug in package handling.

- <https://us-central.manta.mnx.io/smartos/public/3rd-party/chef/chef-13.7.16-1a.sunos.tar.gz>

To extract the tarball, run

    tar zxf chef-13.7.16-1a.sunos.tar.gz -C /opt

Chef will be located in `/opt/chef`.

### Installation via pkgsrc and gem

If you'd prefer to use the Chef gem, you can use `pkgin install` to install
the Ruby and then `gem install chef`.

## Managing SmartOS using the Opscode Platform (Hosted Chef) & Knife

### Getting Started with Knife & The Opscode Platform

For clarity, we'll assume this is your first time using Chef. Install
Chef on your local system as appropriate; see [Chef Wiki:
Installation](http://wiki.opscode.com/display/chef/Installation) for
help.

Start by going to [Opscode.com](http://opscode.com) and signing up for a
free Hosted Chef account. Once you've logged into your account, navigate
to the [Organizations page](https://manage.opscode.com/organizations)
and download the "Knife Config" (`knife.rb`). Create a `~/.chef/~`
directory and copy the `knife.rb` file you downloaded into it. When
you created your account you should have received a *client key* and
*validation key*; if you don't have them, generate a new validation key
on your [Organizations page](https://manage.opscode.com/organizations)
and a generate a new client (user) key on your account [change
password](https://www.opscode.com/account/password) page. When you have
both keys, copy them into the `/.chef/` directory.

    benr@magnolia:~$ mkdir ~/.chef
    benr@magnolia:~$ cp ~/Downloads/knife.rb ~/.chef/
    benr@magnolia:~$ cp Downloads/*.pem ~/.chef

Next we need to download some cookbooks. Get a head start by pulling the
[`smartos_cookbooks`](https://github.com/joyent/smartos_cookbooks)
repository from Github. The cookbook root is
`smartos_cookbooks/cookbooks`. You'll want to then update your Knife
configuration to use this directory as your cookbook path, by modifying
the `cookbook_path` line in `~/.chef/knife.rb`.

    benr@magnolia:~/git$ git clone https://github.com/joyent/smartos_cookbooks.git
    Cloning into 'smartos_cookbooks'...
    remote: Counting objects: 91, done.
    remote: Compressing objects: 100% (66/66), done.
    remote: Total 91 (delta 6), reused 88 (delta 6)
    Unpacking objects: 100% (91/91), done.

    benr@magnolia:~/git$ cd smartos_cookbooks/cookbooks/
    benr@magnolia:~/git/smartos_cookbooks/cookbooks$ ls
    bart  logging  smartos  zabbix

    benr@magnolia:~/git$ grep cookbook_path ~/.chef/knife.rb
    cookbook_path            ["/home/benr/git/smartos_cookbooks/cookbooks"]

Now we're ready to start working with `knife`. You can upload the
cookbooks you'd like to use.

    benr@magnolia:~$ knife cookbook upload smartos bart
    Uploading bart                [0.0.1]
    Uploading smartos             [0.0.1]
    Uploaded 2 cookbooks.

### Bootstrap SmartOS Using Knife

Knife has the ability to "bootstrap" a node. This process consists of
SSH'ing to the node and executing a bootstrap script which installs Chef
as appropriate for the "distribution", then configures the client and
starts it running. At the time of this writting there is no SmartOS
bootstrap scripts provided by default with Chef, so we'll need to create
our own. This is done by creating a `.erb` file for the "distribution"
in `\~/.chef/bootstrap/` and then specifying the distro name during
boostrap with knife.

There are 2 Knife Bootstraps available for the SmartOS Global Zone, one
using the flat client and another using PKG-SRC, which can be downloaded
here: [SmartOS GZ Knife Bootstraps on Github][smartos-knife-bootstrap].

[smartos-knife-bootstrap]: https://github.com/joyent/smartos_cookbooks/tree/master/knife_bootstrap

Once the bootstrap template is in place, we can use `knife bootstrap
&lt;ip addr&gt;` to setup the node. We will pass 3 optional arguments:
"-d smartos-fat" to specify the bootstrap template ("distribution"), "-r
smartos" to specify which cookbooks should be in the initial cookbook
run\_list, and finally "-N hostname" to specify the name we wish to give
to this node, which the smartos cookbook will also set as your hostname.

Here is example of what bootstrapping using the Fat Client looks like:

<!-- markdownlint-disable line-length -->

    benr@magnolia:~$ knife bootstrap 165.111.222.333 -d smartos-gz-fat -r smartos -N smartos20
    Bootstrapping Chef on 165.111.222.333
    Password:
    165.111.222.333 [2012-09-20T18:21:45+00:00] INFO: *** Chef 10.14.2 ***
    165.111.222.333 [2012-09-20T18:21:46+00:00] INFO: Client key /var/chef/client.pem is not present - registering
    165.111.222.333 [2012-09-20T18:21:49+00:00] INFO: Setting the run_list to ["smartos"] from JSON
    165.111.222.333 [2012-09-20T18:21:49+00:00] INFO: Run List is [recipe[smartos]]
    165.111.222.333 [2012-09-20T18:21:49+00:00] INFO: Run List expands to [smartos]
    165.111.222.333 [2012-09-20T18:21:49+00:00] INFO: Starting Chef Runfor smartos20
    165.111.222.333 [2012-09-20T18:21:49+00:00] INFO: Running start handlers
    165.111.222.333 [2012-09-20T18:21:49+00:00] INFO: Start handlers complete.
    165.111.222.333 [2012-09-20T18:21:50+00:00] INFO: Loading cookbooks[smartos]
    165.111.222.333 [2012-09-20T18:21:50+00:00] INFO: Storing updated cookbooks/smartos/recipes/default.rb in the cache.
    165.111.222.333 [2012-09-20T18:21:50+00:00] INFO: Storing updated cookbooks/smartos/recipes/ssh.rb in the cache.
    165.111.222.333 [2012-09-20T18:21:51+00:00] INFO: Storing updated cookbooks/smartos/recipes/nicstat.rb in the cache.
    165.111.222.333 [2012-09-20T18:21:51+00:00] INFO: Storing updated cookbooks/smartos/recipes/ntp.rb in the cache.
    165.111.222.333 [2012-09-20T18:21:51+00:00] INFO: Storing updated cookbooks/smartos/recipes/motd.rb in the cache.
    165.111.222.333 [2012-09-20T18:21:51+00:00] INFO: Storing updated cookbooks/smartos/attributes/default.rb in the cache.
    165.111.222.333 [2012-09-20T18:21:52+00:00] INFO: Storing updated cookbooks/smartos/metadata.rb in the cache.
    165.111.222.333 [2012-09-20T18:21:52+00:00] INFO: Storing updated cookbooks/smartos/metadata.json in the cache.
    165.111.222.333 [2012-09-20T18:21:52+00:00] INFO: Storing updated cookbooks/smartos/README.rdoc in the cache.
    165.111.222.333 [2012-09-20T18:21:52+00:00] INFO: Processing service[name-service-cache] action enable (smartos::default line 13)
    165.111.222.333 [2012-09-20T18:21:52+00:00] INFO: Processing service [name-service-cache] action start (smartos::default line 13)
    165.111.222.333 [2012-09-20T18:21:52+00:00] INFO: Processing template[/etc/nsswitch.conf] action create (smartos::default line 21)
    165.111.222.333 [2012-09-20T18:21:52+00:00] INFO: Processing template[/etc/resolv.conf] action create (smartos::default line 32)
    165.111.222.333 [2012-09-20T18:21:53+00:00] INFO: Processing execute[Set hostname to smartos20] action run (smartos::default line 43)
    165.111.222.333 [2012-09-20T18:21:53+00:00] INFO: execute[Set hostname to smartos20] ran successfully
    165.111.222.333 [2012-09-20T18:21:53+00:00] INFO: Processing execute[Enable atime for /var] action run (smartos::default line 51)
    165.111.222.333 [2012-09-20T18:21:53+00:00] INFO: Processing cookbook_file[/opt/custom/bin/nicstat] action create (smartos::nicstat line 8)
    165.111.222.333 [2012-09-20T18:21:53+00:00] INFO: Processing template[/etc/inet/ntp.conf] action create (smartos::ntp line 1)
    165.111.222.333 [2012-09-20T18:21:53+00:00] INFO: Processing service[ntp] action restart (smartos::ntp line 5)
    165.111.222.333 [2012-09-20T18:21:53+00:00] INFO: service[ntp] restarted
    165.111.222.333 [2012-09-20T18:21:53+00:00] INFO: Processing template[/etc/motd] action create (smartos::motd line 5)
    165.111.222.333 [2012-09-20T18:21:55+00:00] INFO: Chef Run complete in 5.542686643 seconds
    165.111.222.333 [2012-09-20T18:21:55+00:00] INFO: Running report handlers
    165.111.222.333 [2012-09-20T18:21:55+00:00] INFO: Report handlers complete
    benr@magnolia:~$ ssh root@165.111.222.333
    Password:
    Last login: Thu Sep 20 18:21:39 2012 from 76.xx.xx.xx
                              _
     ___ _ __ ___   __ _ _ __| |_ ___  ___
    / __| '_ ` _ \ / _` | '__| __/ _ \/ __|    smartos20
    \__ \ | | | | | (_| | |  | || (_) \__ \    joyent_20120809T221258Z
    |___/_| |_| |_|\__,_|_|   \__\___/|___/    PowerEdge R510 (XXXXXXXXX)

    You have new mail.
    [root@smartos20 ~]# svcs -H chef-client
    online         18:21:56 svc:/application/management/chef-client:default

<!-- markdownlint-enable line-length -->

## Managing SmartOS using Chef Solo & A Web Server

Chef Solo provides a means of executing cookbooks without the need for a
Chef server. This is ideal in both very small (where it's not worth the
trouble) and very large (where a single server may be overwhelmed)
deployments. The following is a description of the process of building a
Chef Solo implementation similar to that used by Joyent Operations.

At a high level, the process will look like this:

1. Fork the `smartos_cookbooks` Repository
2. Modify the bootstrap script to match your web server IP's and URL scheme
3. Create one or more Node Attribute files
4. Review, modify, or add to the Cookbooks as you wish
5. Copy the bootstrap script, fat client, cookbook tarball, node
   attributes to a web server
6. Execute the bootstrap script on new clients

### Your Web Server

With Solo we'll server all content to our nodes using standard HTTP
rather than a Chef server. Therefore, you'll require a directory on a
web server somewhere which can serve your files, we'll assume
<http://meme.com/chef/>. Remember that one of key advantages of using
this method instead of Chef Server is because it is so easy to scale web
servers, so please choose a capable machine for the task.

In your web directory you will host the following files:

    [cuddletech:/www/smartos] benr$ ls -l
    total 27436
    -rw-r--r--   1 benr     other        13M Sep 18 10:08 Chef-fatclient-SmartOS-10.14.2.tar.bz2
    -rwxr-xr-x   1 benr     other       1.3K Sep 21 01:17 bootstrap-smartos.sh*
    -rw-r--r--   1 benr     other       1.9K Sep 21 01:17 chef-solo.xml
    -rw-r--r--   1 benr     other         41 Sep 21 01:17 smartos.json
    -rw-r--r--   1 benr     other       234K Sep 21 01:17 smartos_cookbooks.tar.gz

All but the fatclient come directly from the [`smartos_cookbooks` git
repository](https://github.com/joyent/smartos_cookbooks). Clone the
repository to your load system, then edit the `SERVER_DEST`
variable in the `Makefile` to the host and path where your files will be
`scp`'ed to. Once done, you can modify and commit changes to your local repo
and send them all to the server by simply typing "make":

<!-- markdownlint-disable line-length -->

    benr@magnolia:~/git/smartos_cookbooks$ head Makefile
    # Makefile for SmartOS Deployment
    #
    TAR=            tar
    DISTNAME=       smartos_cookbooks.tar.gz
    SERVER_DEST=    8.12.35.49:/www/smartos/

    benr@magnolia:~/git/smartos_cookbooks$ make
    tar cfz /tmp/smartos_cookbooks.tar.gz cookbooks
    scp /tmp/smartos_cookbooks.tar.gz 8.12.35.49:/www/smartos/smartos_cookbooks.tar.gz 100%  234KB 233.5KB/s   00:00
    ...

<!-- markdownlint-disable line-length -->

Finally, you should lock down your Chef files if they contain sensitive
information. The best method is to add ACL's to a `.htaccess` file in
the directory your using. Here is an example:

    Order Deny,Allow
    Deny from all
    ## Lab Nodes:
    Allow from 192.168.100.2 192.168.100.3
    ## Hosts in DC2:
    Allow from 10.0.10.0/23 10.0.100.0/24

### The Chef Solo Bootstrap Script

The bootstrap script is a BASH script which can be curl'ed and executed
as a single line thus making node setup as easy and mistake proof as
possible. *This should* ***not*** *be confused with the earlier
mentioned Knife Bootstrap scripts.*

    # curl -s http://8.19.33.143/smartos/bootstrap-smartos.sh | NODENAME="smartos01" bash
    Installation complete. Chef Solo SMF Service State: offline*

    # svcs -H chef-solo
    online          1:17:48 svc:/application/management/chef-solo:default

    # tail -4 `svcs -L chef-solo`
    [2012-09-21T01:17:48+00:00] INFO: Chef Run complete in 0.625087464 seconds
    [2012-09-21T01:17:48+00:00] INFO: Running report handlers
    [2012-09-21T01:17:48+00:00] INFO: Report handlers complete
    [ Sep 21 01:17:48 Method "start" exited with status 0. ]

![Using Chef Solo](assets/images/using-chef-solo.gif)
