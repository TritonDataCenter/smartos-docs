+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Installing NRPE in the
global zone </span>

</div>

<div class="pagesubheading">

This page last changed on Jun 17, 2013 by
<font color="#0050B2">arai</font>.

</div>

Are you using Nagios, op5 or some other Nagios based monitoring
solution? Then you'll probably want NRPE installed in the global zone of
your SmartOS nodes to monitor them. This is how to do it.

Installing NRPE
===================

Since the GZ doesn't come with pkgin to install packages by default you
have two choices. Install pkgin as described in [Installing
pkgin](Installing%20pkgin.html "Installing pkgin") and install it using
pkgin (plus do any modifications necessary to make it run in the global
zone) or you'll have to install NRPE manually. This is how to do it
manually.

Start by downloading NRPE from the latest pkgsrc available at
smartos.org, for example:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# wget http://pkgsrc.smartos.org/packages/illumos/2012Q4/All/nagios-nrpe
-2.12nb3.tgz
```

</div>

</div>

</div>

Copy the file to /opt/custom and unpack the file. /opt is one of the few
places in your SmartOS installation where you can have stuff that
persists through reboots

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# cp nagios-nrpe-2.12nb3.tgz /opt/custom
# cd /opt/custom
# tar zxvf nagios-nrpe-2.12nb3.tgz
```

</div>

</div>

</div>

Remove the files starting with +, those contain package information
needed by pkgin. NRPE should hopefully be installed under
/opt/custom/sbin/nrpe.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# rm +*
```

</div>

</div>

</div>

Configuration of NRPE
=========================

Under /opt/custom/share/examples/nagios/nrpe.cfg you can find an example
configuration for NRPE. Copy this file to /opt/custom/etc and modify it
for your needs. Also make sure you point nrpe.cfg at your nagios
monitoring scripts, for example /opt/custom/libexec/nagios.

Configure SMF
=================

NRPE should in most cases be started when the SmartOS node starts. To
accomplish this a manifest has to be added to SMF, the Service
Management Facility. Create a new manifest XML-file that it looks like
this:

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
<?xml version="1.0"?>
<!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.d
td.1">
<service_bundle type="manifest" name="nrpe">
  <service name="pkgsrc/nrpe" type="service" version="1">
    <create_default_instance enabled="false" />
    <single_instance />
    <dependency name="network" grouping="require_all" restart_on="error"
 type="service">
      <service_fmri value="svc:/milestone/network:default" />
    </dependency>
    <dependency name="filesystem" grouping="require_all" restart_on="err
or" type="service">
      <service_fmri value="svc:/system/filesystem/local" />
    </dependency>
    <method_context working_directory="/tmp">
      <method_credential user="nobody" group="nobody" />
    </method_context>
    <exec_method type="method" name="start" exec="/opt/custom/sbin/nrpe
-c %{config_file} -d" timeout_seconds="60" />
    <exec_method type="method" name="stop" exec=":kill" timeout_seconds=
"60" />
    <exec_method type="method" name="refresh" exec=":kill -HUP" timeout_
seconds="60" />
    <property_group name="startd" type="framework">
      <propval name="duration" type="astring" value="contract" />
      <propval name="ignore_error" type="astring" value="core,signal" />
    </property_group>
    <property_group name="application" type="application">
      <propval name="config_file" type="astring" value="/opt/custom/etc/
nrpe.cfg" />
    </property_group>
    <stability value="Evolving" />
    <template>
      <common_name>
        <loctext xml:lang="C">Nagios Remote Plug-In Executor (NRPE)</loc
text>
      </common_name>
    </template>
  </service>
</service_bundle>
```

</div>

</div>

</div>

As the GZ doesn't have user called "nagios" we'll run it as "nobody".\
Now, import it and enable it.

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# svccfg import manifest.xml
# svcadm enable nrpe
```

</div>

</div>

</div>

Now NRPE should be up and running.

Finally, copy the manifest XML file to /opt/custom/smf. This will load
it each time the system boots.
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


