# Persistent root dotfiles

## Introduction

Placing these SMF manifests in `/opt/custom/smf` will symlink root's
`.bash_history`, `.bashrc`, and `.inputrc` files to their analogs in
`/opt/custom/` on boot, allowing for a persistent, custom dotfiles for the
`root` user.

Double-click the source code blocks to expand and highlight the contained code.

### Manifests

<!-- markdownlint-disable line-length -->

#### `root_bash_history.xml`

    <?xml version='1.0'?>
    <!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.dtd.1'>
    <service_bundle type='manifest' name='export'>
      <service name='site/bash_history' type='service' version='0'>
        <create_default_instance enabled='true'/>
        <single_instance/>
        <dependency name='network' grouping='require_all' restart_on='error' type='service'>
          <service_fmri value='svc:/milestone/network:default'/>
        </dependency>
        <dependency name='filesystem' grouping='require_all' restart_on='error' type='service'>
          <service_fmri value='svc:/system/filesystem/local'/>
        </dependency>
        <method_context/>
        <exec_method name='start' type='method' exec='ln -nsf /opt/custom/.bash_history /root/.bash_history' timeout_seconds='60'/>
        <exec_method name='stop' type='method' exec=':kill' timeout_seconds='60'/>
        <property_group name='startd' type='framework'>
          <propval name='duration' type='astring' value='transient'/>
          <propval name='ignore_error' type='astring' value='core,signal'/>
        </property_group>
        <property_group name='application' type='application'/>
        <stability value='Evolving'/>
        <template>
          <common_name>
            <loctext xml:lang='C'>Link root .bash_history to /opt/custom/.bash_history</loctext>
          </common_name>
        </template>
      </service>
    </service_bundle>

#### `root_bashrc.xml`

        <?xml version='1.0'?>
        <!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.dtd.1'>
        <service_bundle type='manifest' name='export'>
          <service name='site/bashrc_link' type='service' version='0'>
            <create_default_instance enabled='true'/>
            <single_instance/>
            <dependency name='network' grouping='require_all' restart_on='error' type='service'>
              <service_fmri value='svc:/milestone/network:default'/>
            </dependency>
            <dependency name='filesystem' grouping='require_all' restart_on='error' type='service'>
              <service_fmri value='svc:/system/filesystem/local'/>
            </dependency>
            <method_context/>
            <exec_method name='start' type='method' exec='ln -nsf /opt/custom/.bashrc /root/.bashrc' timeout_seconds='60'/>
            <exec_method name='stop' type='method' exec=':kill' timeout_seconds='60'/>
            <property_group name='startd' type='framework'>
              <propval name='duration' type='astring' value='transient'/>
              <propval name='ignore_error' type='astring' value='core,signal'/>
            </property_group>
            <property_group name='application' type='application'/>
            <stability value='Evolving'/>
            <template>
              <common_name>
                <loctext xml:lang='C'>Link root .bashrc to /opt/custom/.bashrc</loctext>
              </common_name>
            </template>
          </service>
        </service_bundle>

#### `root_inputrc.xml`

    <?xml version='1.0'?>
    <!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.dtd.1'>
    <service_bundle type='manifest' name='export'>
      <service name='site/inputrc_link' type='service' version='0'>
        <create_default_instance enabled='true'/>
        <single_instance/>
        <dependency name='network' grouping='require_all' restart_on='error' type='service'>
          <service_fmri value='svc:/milestone/network:default'/>
        </dependency>
        <dependency name='filesystem' grouping='require_all' restart_on='error' type='service'>
          <service_fmri value='svc:/system/filesystem/local'/>
        </dependency>
        <method_context/>
        <exec_method name='start' type='method' exec='ln -nsf /opt/custom/.inputrc /root/.inputrc' timeout_seconds='60'/>
        <exec_method name='stop' type='method' exec=':kill' timeout_seconds='60'/>
        <property_group name='startd' type='framework'>
          <propval name='duration' type='astring' value='transient'/>
          <propval name='ignore_error' type='astring' value='core,signal'/>
        </property_group>
        <property_group name='application' type='application'/>
        <stability value='Evolving'/>
        <template>
          <common_name>
            <loctext xml:lang='C'>Link root .inputrc to /opt/custom/.inputrc</loctext>
          </common_name>
        </template>
      </service>
    </service_bundle>
