# Basic SMF Commands

SMF consists of four command line utilities:

- `svcs`: allows you to examine the state of your services and
    determine what went wrong.
- `svcadm`: enable, disable, and restart a service.
- `svccfg`: load manifest files (XML) that maintain configurations
    for each service.
- `svcprop`: retrieves properties on a service (useful when writing
    custom scripts)

## Examining Service Status - svcs

The `svcs` command displays information about the state of your
services. This typically means whether or not they are running and any
problems encountered when attempting to start them. In general, services
will fall into three different states:

- `online`: the service is enabled and functioning normally
- `offline`: the service is stopped and disabled
- `maintenance`: the service has encountered a problem and is on hold
    until the problem is addressed by an administrator.

Running the `svcs` command with the `-a` argument displays a list of all
online and offline services. By default `svcs` prints out:

- `status`: the current state of the service.
- `stime`: when the service entered the current state.
- `FMRI`: the name of the service.

Each service is identified by a Fault Management Resource Identifier
(FMRI). For example, the FMRI for the Apache service is:

    svc:/network/http:cswapache2

The above FMRI breaks down in the following way:

| String            | Description           |
| ----------------- | --------------------- |
| `svc:`            | The service type      |
| `/network/http`   | The service name      |
| `:cswapache2`     | The service instance  |

For example, this output shows that Apache was disabled on May 31st:

    $ svcs svc:/network/http:cswapache2
    STATE    STIME  FMRI
    disabled May_31 svc:/network/http:cswapache2

An easy way of uncovering the FMRI for a service is by using `grep` in
combination with `svcs -a`. For example, using grep in the following
exposes the FMRI of the MySQL service, which is `cswmysql5`:

    $ svcs -a | grep -i mysql
    enabled  May_31  svc:/network/cswmysql5:default

You ca n abbreviate an FMRI by specifying the instance name or the
trailing portion of the service name. For example, valid abbreviations
for `svc:/network/http:cswapache2` are:

- `cswapache2`
- `:cswapache2`
- `http`
- `http:cswapache2`
- `network/http`

## Starting and Stoping Services - svcadm

The `svcadm` command is used to enable, disable, restart, or refresh
services. For example, this command enables the MySQL service.

    sudo svcadm enable cswmysql5

Using `svcs`, you can verify that the service is enabled:

    $ svcs cswmysql5
    STATE   STIME     FMRI
    online  15:20:39  svc:/network/cswmysql5:default

You use `disable` to stop services. For example, this stops the MySQL
service:

    sudo svcadm disable cswmysql5

You use `restart` to refresh a service. For example, after making a
configuration change, you can refresh an enabled service like this:

    sudo svcadm restart cswmysql5

Some daemons do not respond to the `restart` command. If that is the
case, you will need to disable and re-enable the service.

### Conducting Service Maintenance - svcadm clear

If a service enters maintenance mode or becomes disabled, you will need
to perform some maintenance before SMF can restart the service. This
means resolving any conflicts that prevent the service from running then
using `svcadm clear` to clear the service state. When
using `svcadm clear`, you need to specify the service FMRI.

This command does nothing to fix a service, it just signals that the
service is ready to resume. Before you can clear a service state, you
need to ensure that you resolve the conflict that caused the service to
go into maintenance mode. For example, if you configure Postgres to use
an IP port that is already in use by another service, the Postgres
service will terminate abnormally and go into maintenance mode. In this
case, you would need to resolve the IP conflict by modifying the
Postgres configuration to use another IP or terminating the conflicting
service. You would then clear the state after resolving the conflict.

Once the state is cleared, the service can resume. Each service has an
assigned service restarter agent that is responsible for carrying out
actions against it. The default service restarter is `svc.startd`.

- If a service instance is in maintenance mode, this command informs
    the restarter agent that the service was repaired.
- If a service instance is disabled, this command requests that the
    restarter agent transition the service to the online state.

For example, the following will clear the state of the Apache service
and SMF will automatically restart the service once cleared:

    sudo svcadm clear svc:/network/http:cswapache2

### Verifying a Service is in Maintenance Mode

SMF will place a service in maintenance mode when the service encounters
something that causes it to crash. This usually indicates an error with
the service but can also occur if your SmartMachine is running out of
resources (RAM or disk space).

To verify if a service is in maintenance mode:

1. Run this command:

        svcs -a

    This will show all running and disabled services. If a service is in
    maintenance mode, you will see something similar to this:

        maintenence 18:50:25 svc:/network/webmin:webmin

2. Review the log to root-cause why the service was in maintenance mode.
3. Take the service out of maintenance mode:

        svcadm clear service_name

### Verifying a Service is Disabled

To verify if a service is disabled:

    svcs -a

If the service is disabled, you will see something similar to this:

    disabled 18:51:10 svc:/network/webmin:webmin

### Enabling a Service

To enable a service:

1. Enable the service:

        svcadm enable service_name

2. Verify the service is enabled:

        svcs -a | grep service_name

If successful, you should see something similar to this:

    online 18:50:25 svc:/network/webmin:webmin

The term "online" is the service state and indicates that the service is
running.

## Examining Service Contracts - `svcs -p`

SMF maintains a contract with every running service it manages. The
contract keeps track of what processes are running for any given
service. Using the `-p` option, you can determine all the processes that
belong to a service. In the following example, the MySQL daemon is
process number 29004.

    $ svcs -p network/cswmysql5
    STATE      STIME       FMRI
    online     16:55:27    svc:/network/cswmysql5:default
               16:55:27    28938 mysqld_safe
               16:55:27    29004 mysqld

The following example demonstrates how SMF restarts a service when it
stops unexpectedly:

    $ kill -9 29004
    $ svcs -p network/cswmysql5
    STATE   STIME     FMRI
    online* 17:00:01  svc:/network/cswmysql5:default
            16:55:27  28938 mysqld_safe
            17:00:01  29228 mysqld
    $ mysql -u mysql
    ...
    mysql> \q
    Bye

Even though the MySQL daemon was unexpectedly terminated, it was
automatically restarted by SMF. Notice that the STIME shows that the
MySQL service is back online. The inclusion of an asterisk with the
"online" state indicates that the service is currently in transition.
However, the MySQL service is already back online by the time the next
command is run.

SMF does not restart the service in brain-dead mode like a
legacy `inittab`; You can configure a threshold for service restarts.
For example, numerous restarts of a service in a 60 second time frame
might indicate a severe issue in your environment. You can configure a
restart threshold in SMF for that service. At that point, SMF will put
the service in "maintenance" mode, and the service will remain in that
state until you clear it with `svcadm clear`.

Configuring Services - `svccfg`

The `svccfg` command allows you to import, export, and modify service
configurations. You specify entities to manipulate by using
the `-s` option with an FMRI. The following example will set an
environment variable for the specified FMRI with the value you specify.

    svccfg -s FMRI setenv ENV_VARIABLE value

You can invoke `svccfg` directly with individual subcommands or by
specifying a script file.

If you make any changes to a service using this command, you need to
restart the service for the changes to take effect.

## Enabling SMF Access

If you want to enable users with no sudo access to manage SMF, you can
modify a user profile with the following command:

    usermod -P 'Service Management' myuser

After this change, the specified user is able to manage SMF (import,
stop, start) without access to `sudo`. This minimizes the need for
unnecessarily sharing sudo access among users.

## Checking properties of a service

To retrieve a specific setting for a service, we use svcprop in this
case to figure out which ipf.conf ipfilter is using:

    # svcprop -p firewall_config_default/custom_policy_file network/ipfilter
    :default
    /etc/ipf/ipf.conf

## Uncovering Information About Services

Using SMF to uncover information about a service is easy.

<!-- markdownlint-disable line-length -->
| Command          | Description
| ---------------- | ----------------------------------------------------- |
| `svcs -a`        | List all services for this SmartMachine, including disabled services. |
| `svcs -x`        | List explanations for all services that are running but not enabled or services that are preventing another service from runn ing. |
| `svcs -p NAME`   | List all processes for the service you specify. |
<!-- markdownlint-enable line-length -->

## Links

- Ben Rockwood's [SMF CheatSheet](http://www.cuddletech.com/blog/pivot/entry.php?id=182).
