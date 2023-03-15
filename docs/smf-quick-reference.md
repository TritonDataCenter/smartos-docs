# SMF Service Quick Reference

This quick reference provides the most common usage patterns without having to
sort through a lot of documentation. For more detailed information see the
[SMF Guide](basic-smf-commands.md) or the `smf(7)` man page.

## List Services

To list all enabled services:

    svcs

To list all services, including disabled services:

    svcs -a

To check the status of a single service:

    svcs <fmri>

Obtain detailed information about a service:

    svcs -l <fmri>

Example:

    # svcs -l smartdc/metadata
    fmri         svc:/system/smartdc/metadata:default
    name         VM Metadata Daemon (node)
    enabled      true
    state        online
    next_state   none
    state_time   March  3, 2023 at 07:44:10 PM UTC
    logfile      /var/svc/log/system-smartdc-metadata:default.log
    restarter    svc:/system/svc/restarter:default
    contract_id  117
    dependency   require_all/none svc:/system/filesystem/local (online)
    dependency   require_all/none svc:/system/smartdc/vminfod:default (online)

## Service States

A service may be in one of several states:

* `online` - The service is enabled and running
* `disabled` - The service is administratively disabled. No attempt to start
  the service will be made.
* `offline` - The service is enabled, but not running due to a missing
  dependency
* `maintenance` - The service has encountered a problem
* `legacy_run` - The service is known, but not managed by SMF. In general you
  should leave these alone.

If the service state has an asterisk (e.g., `online*`) it means that the
service is transitioning *to* that state.

### Changing States (start/stop services)

To bring a disabled service online, enable it. Services that are enabled will
be started automatically.

    svcadm enable <frmi>

To disable an online service, disable it. Services that are disabled will be
stopped automatically.

    svcadm disable <fmri>

A service may be enabled or disabled tempoarily using the `-t` flag. This means
that the boot up preference will not be changed.

    svcadm disable -t <fmri>
    svcadm enable -t <fmri>

After a config change you will likely need to `restart` the associated service.
Restarting a service calls the service's `stop` method, then the `start`
method without modifying the desired state.
Note: Restarting a service that is not `online` has no affect. See below for
troubleshooting `offline` and `maintenance` states.

    svcadm restart <fmri>

## Troubleshooting Service Failures

A service that is enabled but not running will either be in `offline` or
`maintenance` state.

List all services with a problem

    svcs -xv

This will print out extended information about why the services cannot be
brought to online state.

### Services in `offline` State

A service that is `offline` is missing a required dependency. To correct this
the missing dependency must be satisfied. This may include addressing other
services that are `offline` or in `maintenance` state, or mising
files/directories.

### Services in `maintenance` State

A service will be moved to `maintenance` state if it exits 10 times within
10 seconds. This is usually do to an error. The program may be crashing, or it
may be exiting due to a configuration error.

In order to determine the cause of the error, you will need to examine the logs.
The SMF service maintains a log file of all `STDOUT` or `STDERR` emitted by
processes in the service.

To retrieve the name of the SMF log file:

    svcs -L <fmri>

Note that in SmartOS many services will emit logs in bunyan format. To
pretty-print these logs use the following:

    cat $(svcs -L <fmri>) | bunyan
    tail -f $(svcs -L <fmri>) | bunyan

Third party services, especially those installed via pkgsrc will usually be
configured with a specific application log, or may log messages to `syslog`.
The exact behavior will depend on the application itself, so you may need to
consult the documentation for the application to determine where logs are being
recorded.

### Repairing a Service in `maintenance` State

Once you have corrected the condition causing the failure, `clear` the service:

    svcadm clear <fmri>

This indicates to SMF that the error condition has been corrected by the
operator. SMF will then attempt to bring the service to the desired state.
If the service is enabled, it will start the service and attempt to bring it
`online`. Be aware that there may be additional error conditions that cause
the service to return to maintenance state For example, multiple errors in the
application config file, and the application only reports the *first* error.

**Note:** Clearing a service does not do anything to correct the error
condition. It only indicates to SMF that *you* fixed it, and that it should
try again.

## Creating Custom Services

SMF services are two parts:

* A **manifest** file
* One or more commands to run, referred to as **methods**

### SMF Manifests

An SMF manifest is an XML file that describes the service. The best way to
generate an SMF manifest is to use either `manifold` or `smfgen`.

[`manifold`][manifold] is a python program available via `pip` that will
interactively prompt you for parameters. New users often find `manifold`
easiest. `manifold` is maintained by an illumos community member.

[manifold]: https://code.google.com/archive/p/manifold/

[`smfgen`][smfgen] is a JavaScript program available via `npm` that will take
a JSON file as input and output XML. Experienced users often find `smfgen`
gives them a great deal of control. `smfgen` is maintained by the the Triton
team. See the [smfgen documentation][smfgen] for more details.

[smfgen]: https://github.com/TritonDataCenter/smfgen

Here is an example of using `smfgen`:

<!-- markdownlint-disable line-length commands-show-output code-block-style -->
<!-- The following was taken from the smfgen README.md -->

    $ cat bapi.json

``` json
{
    "ident": "bapi",
    "label": "Boilerplate API",
    "start": "node bapi.js"
}
```

    $ ./smfgen < bapi.json

``` xml
<?xml version="1.0"?>
<!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.dtd.1">
<!--
    Manifest automatically generated by smfgen.
 -->
<service_bundle type="manifest" name="application-bapi" >
    <service name="application/bapi" type="service" version="1" >
        <create_default_instance enabled="true" />
        <dependency name="dep1" grouping="require_all" restart_on="error" type="service" >
            <service_fmri value="svc:/milestone/multi-user:default" />
        </dependency>
        <exec_method type="method" name="start" exec="node bapi.js &amp;" timeout_seconds="10" />
        <exec_method type="method" name="stop" exec=":kill" timeout_seconds="30" />
        <template >
            <common_name >
                <loctext xml:lang="C" >Boilerplate API</loctext>
            </common_name>
        </template>
    </service>
</service_bundle>
```
<!-- markdownlint-enable line-length commands-show-output code-block-style -->

### SMF Methods

An SMF method is used to start or stop a sevice.

The start method is used to start the service and may be as simple as invoking
the desired command.

The stop method is used to stop the service and may be as simple as the special
`:kill`, which will send signals to the processes in the service group.

Often, the start and stop method are combined into a shell script that accepts
start and stop subcommands. This is very similar to System V init scripts that
you are used to.

SMF method script *should* source the file `/lib/svc/share/smf_include.sh`
which includes a library of features. See the contents of that file for details.

### Importing Your Custom Service

Having both a manifest file and a method file, place the manifest file in
`/opt/custom/smf`. This directory does not exist by default, but will persist
between reboots. The method script can be in any location, and for this reason
the manifest should refer to the method script by the absolute path name.
Method scripts are commonly placed in `/opt/custom/smf` or `/opt/custom/bin`,
but this is not required. Using `/opt/myapp/bin` or any other persistent
location is also fine.

To import the service:

    svccfg import /opt/custom/smf/<manifest>.xml

Or:

    svcadm restart manifest-import

After import, run `svcs` to check the status of your service.

To remove a service you need to:

* Stop the service (`svcadm disable <fmri>`)
* Delete the manifest (`rm /opt/custom/smf/<manifest>.xml`)
* Delete the service (`svccfg delete <frmr>`)
