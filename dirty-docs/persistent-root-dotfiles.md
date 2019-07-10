+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Persistent root
dotfiles </span>

</div>

<div class="pagesubheading">

This page last changed on May 25, 2012 by
<font color="#0050B2">jason.davis@joyent.com</font>.

</div>

Introduction
----------------

Placing these SMF manifests in /opt/custom/smf will symlink root's
.bash\_history, .bashrc, and .inputrc files to their analogs in
/opt/custom/ on boot, allowing for a persistent, custom dotfiles for the
root user.

<div class="panelMacro">

  --------------------------------------------------------------- ------
------------------------------------------------------------------------
---
  ![](images/icons/emoticons/check.gif){width="16" height="16"}   Double
-click the source code blocks to expand and highlight the contained code
.
  --------------------------------------------------------------- ------
------------------------------------------------------------------------
---

</div>

#### Manifests

------------------------------------------------------------------------

<div class="code panel" style="border-width: 1px;">

<div class="codeHeader panelHeader" style="border-bottom-width: 1px;">

**bash\_history\_link.xml**

</div>

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .html/xml; .collapse: .true; .gutter:
.false}
<?xml version='1.0'?>
<!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.d
td.1'>
<service_bundle type='manifest' name='export'>
  <service name='site/bash_history' type='service' version='0'>
    <create_default_instance enabled='true'/>
    <single_instance/>
    <dependency name='network' grouping='require_all' restart_on='error'
 type='service'>
      <service_fmri value='svc:/milestone/network:default'/>
    </dependency>
    <dependency name='filesystem' grouping='require_all' restart_on='err
or' type='service'>
      <service_fmri value='svc:/system/filesystem/local'/>
    </dependency>
    <method_context/>
    <exec_method name='start' type='method' exec='ln -nsf /opt/custom/.b
ash_history /root/.bash_history' timeout_seconds='60'/>
    <exec_method name='stop' type='method' exec=':kill' timeout_seconds=
'60'/>
    <property_group name='startd' type='framework'>
      <propval name='duration' type='astring' value='transient'/>
      <propval name='ignore_error' type='astring' value='core,signal'/>
    </property_group>
    <property_group name='application' type='application'/>
    <stability value='Evolving'/>
    <template>
      <common_name>
        <loctext xml:lang='C'>Link root .bash_history to /opt/custom/.ba
sh_history</loctext>
      </common_name>
    </template>
  </service>
</service_bundle>
```

</div>

</div>

</div>

<div class="code panel" style="border-width: 1px;">

<div class="codeHeader panelHeader" style="border-bottom-width: 1px;">

**bashrc\_link.xml**

</div>

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .html/xml; .collapse: .true; .gutter:
.false}
<?xml version='1.0'?>
<!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.d
td.1'>
<service_bundle type='manifest' name='export'>
  <service name='site/bashrc_link' type='service' version='0'>
    <create_default_instance enabled='true'/>
    <single_instance/>
    <dependency name='network' grouping='require_all' restart_on='error'
 type='service'>
      <service_fmri value='svc:/milestone/network:default'/>
    </dependency>
    <dependency name='filesystem' grouping='require_all' restart_on='err
or' type='service'>
      <service_fmri value='svc:/system/filesystem/local'/>
    </dependency>
    <method_context/>
    <exec_method name='start' type='method' exec='ln -nsf /opt/custom/.b
ashrc /root/.bashrc' timeout_seconds='60'/>
    <exec_method name='stop' type='method' exec=':kill' timeout_seconds=
'60'/>
    <property_group name='startd' type='framework'>
      <propval name='duration' type='astring' value='transient'/>
      <propval name='ignore_error' type='astring' value='core,signal'/>
    </property_group>
    <property_group name='application' type='application'/>
    <stability value='Evolving'/>
    <template>
      <common_name>
        <loctext xml:lang='C'>Link root .bashrc to /opt/custom/.bashrc</
loctext>
      </common_name>
    </template>
  </service>
</service_bundle>
```

</div>

</div>

</div>

<div class="code panel" style="border-width: 1px;">

<div class="codeHeader panelHeader" style="border-bottom-width: 1px;">

**inputrc\_link.xml**

</div>

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .html/xml; .collapse: .true; .gutter:
.false}
<?xml version='1.0'?>
<!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.d
td.1'>
<service_bundle type='manifest' name='export'>
  <service name='site/inputrc_link' type='service' version='0'>
    <create_default_instance enabled='true'/>
    <single_instance/>
    <dependency name='network' grouping='require_all' restart_on='error'
 type='service'>
      <service_fmri value='svc:/milestone/network:default'/>
    </dependency>
    <dependency name='filesystem' grouping='require_all' restart_on='err
or' type='service'>
      <service_fmri value='svc:/system/filesystem/local'/>
    </dependency>
    <method_context/>
    <exec_method name='start' type='method' exec='ln -nsf /opt/custom/.i
nputrc /root/.inputrc' timeout_seconds='60'/>
    <exec_method name='stop' type='method' exec=':kill' timeout_seconds=
'60'/>
    <property_group name='startd' type='framework'>
      <propval name='duration' type='astring' value='transient'/>
      <propval name='ignore_error' type='astring' value='core,signal'/>
    </property_group>
    <property_group name='application' type='application'/>
    <stability value='Evolving'/>
    <template>
      <common_name>
        <loctext xml:lang='C'>Link root .inputrc to /opt/custom/.inputrc
</loctext>
      </common_name>
    </template>
  </service>
</service_bundle>
```

</div>

</div>

</div>
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


