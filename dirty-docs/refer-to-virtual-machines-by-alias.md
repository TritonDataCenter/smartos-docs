+--------------------------------------------------------------------------+
<div class="pageheader">

<span class="pagetitle"> SmartOS Documentation : Refer to Virtual
Machines by Alias </span>

</div>

<div class="pagesubheading">

This page last changed on Mar 27, 2015 by
<font color="#0050B2">sjorge</font>.

</div>

Introduction
----------------

This is a set of instructions to allow one to refer to virtual machines
by their alias instead of UUID as long as the alias is unique

<div>

<ul>
<li>
[Introduction](#RefertoVirtualMachinesbyAlias-Introduction)
</li>
<li>
[Method](#RefertoVirtualMachinesbyAlias-Method)
</li>
<ul>
- [Wrapper function](#RefertoVirtualMachinesbyAlias-Wrapperfunction)
- [Example usage](#RefertoVirtualMachinesbyAlias-Exampleusage)
- [Variation of wrapper
    function](#RefertoVirtualMachinesbyAlias-Variationofwrapperfunction)
- [Example Usage](#RefertoVirtualMachinesbyAlias-ExampleUsage)
- [Optional: Bash tab
    completion](#RefertoVirtualMachinesbyAlias-Optional%3ABashtabcomplet
ion)

</ul>
<li>
[Alternative wrapper](#RefertoVirtualMachinesbyAlias-Alternativewrapper)
</li>
- [.bashrc](#RefertoVirtualMachinesbyAlias-.bashrc)
- [Example Usage](#RefertoVirtualMachinesbyAlias-ExampleUsage)

</ul>

</div>

Method
----------

#### Wrapper function

After creating persistent root dot files, append this to wrapper
function to your .bashrc

<div class="code panel" style="border-width: 1px;">

<div class="codeHeader panelHeader" style="border-bottom-width: 1px;">

**.bashrc excerpt**

</div>

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
#Function allowing for use of <alias> in place of <uuid> when alias is u
nique
function vmadm
{
    local input=""
    if [[ ! -t 0 ]]; then
        while read -r words;
        do
            input=$input$words;
        done
    fi
    local op=$1; shift
    if [[ "${op}" == "alias" ]]; then
        case $# in
            0)
                echo "Usage:"
                echo ""
                echo "vmadm alias <alias>"
                echo " -or- vmadm alias <command> <alias> [options]"
                ;;
            1)
                echo ${input} | /usr/sbin/vmadm lookup alias=$1
                ;;
            *)
                op=$1; shift
                local vm_alias=$1; shift
                local uuid=$(vmadm lookup -1 alias=${vm_alias})
                if [[ -n ${uuid} ]]; then
                    echo ${input} | /usr/sbin/vmadm ${op} ${uuid} $@
                fi
                ;;
        esac
    else
        echo ${input} | /usr/sbin/vmadm  ${op} $@
    fi
    return $?
}
```

</div>

</div>

</div>

#### Example usage

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
# vmadm
Usage: /usr/sbin/vmadm <command> [options]

create [-f <filename>]
create-snapshot <uuid> <snapname>
console <uuid>
delete <uuid>
delete-snapshot <uuid> <snapname>
get <uuid>
info <uuid> [type,...]
install <uuid>
list [-p] [-H] [-o field,...] [-s field,...] [field=value ...]
lookup [-j|-1] [field=value ...]
reboot <uuid> [-F]
receive [-f <filename>]
rollback-snapshot <uuid> <snapname>
send <uuid> [target]
start <uuid> [option=value ...]
stop <uuid> [-F]
sysrq <uuid> <nmi|screenshot>
update <uuid> [-f <filename>]
 -or- update <uuid> property=value [property=value ...]

For more detailed information on the use of this command,type 'man vmadm
'.

# vmadm alias
Usage:

vmadm alias <alias>
 -or- vmadm alias <command> <alias> [options]

# vmadm list
UUID                                  TYPE  RAM      STATE             A
LIAS
f281fd3d-f00d-4350-abb5-aac21fd951af  OS    256      stopped           c
icero
2c9d6220-190f-46c5-b924-81546cbbe6f4  KVM   2048     stopped           m
arcus
3e6d88ae-ded8-4461-8eaf-e9e66454391d  OS    2048     stopped           c
icero
24ab469a-d791-41c2-bee0-4c2a463b1e41  OS    8192     stopped           -

# vmadm alias cicero
3e6d88ae-ded8-4461-8eaf-e9e66454391d
f281fd3d-f00d-4350-abb5-aac21fd951af

# vmadm alias start marcus
Successfully started 2c9d6220-190f-46c5-b924-81546cbbe6f4

# vmadm stop 2c9d6220-190f-46c5-b924-81546cbbe6f4
Succesfully completed stop for 2c9d6220-190f-46c5-b924-81546cbbe6f4

# vmadm alias get cicero | json zonepath
Requested unique lookup but found 2 results.

# vmadm alias get marcus | json zonepath
/zones/2c9d6220-190f-46c5-b924-81546cbbe6f4

# vmadm alias update nobody autoboot=false
Requested unique lookup but found 0 results.

# vmadm alias update marcus autoboot=false
Successfully updated 2c9d6220-190f-46c5-b924-81546cbbe6f4
```

</div>

</div>

</div>

#### Variation of wrapper function

I came up with this wrapper because I found the need to add the word
alias too cumbersome for my lazy self. This wrapper will let you use
either uuid or alias.

<div class="code panel" style="border-width: 1px;">

<div class="codeHeader panelHeader" style="border-bottom-width: 1px;">

**.bashrc excerpt**

</div>

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
 ##
 # Allows the use of <uuid|alias> in vmadm
 ##

 function vmadm() {
         local op="$1"; shift
         local uuid="$1"; shift

         local r='^[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0
-9]{4}-[a-zA-Z0-9]{12}$'
         local skip=(create list lookup receive help)

         # These options don't take a uuid argument
         if [[ ! ${skip[*]} =~ $op ]]; then
                 # If a uuid was passed, then do nothing
                 if [[ ! "$uuid" =~ $r ]]; then
                         uuid=$(command vmadm lookup -1 alias=$uuid)
                         if [[ ! -n "$uuid" ]]; then
                                 echo "Alias $uuid not found."
                         fi
                 fi
         fi
         command vmadm $op $uuid $@
 }
```

</div>

</div>

</div>

#### Example Usage

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
bash-4.1# vmadm get 5a43b721-c2ce-49eb-b463-5aa0af99640c | grep create_t
imestamp
   "create_timestamp": "2013-01-17T06:18:49.215Z",

 bash-4.1# vmadm get snap | grep create_timestamp
   "create_timestamp": "2013-01-17T06:18:49.215Z",
```

</div>

</div>

</div>

#### Optional: Bash tab completion

Allows tab completion of available aliases when using 'vmadm alias
&lt;command&gt; &lt;alias&gt;' or 'vmadm alias &lt;alias&gt;'. Apply
this patch to /etc/bash/bash\_completion.d/vmadm (need to have
persistent symlink copy, writable root filesystem, or custom build).

<div class="code panel" style="border-width: 1px;">

<div class="codeHeader panelHeader" style="border-bottom-width: 1px;">

**bash\_completion.d/vmadm.patch**

</div>

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .bash; .gutter: .false}
--- /opt/custom/etc/bash/bash_completion.d/vmadm Tue Jan 15 21:19:28 201
3
+++ /opt/custom/etc/bash/bash_completion.d/vmadm    Tue Jan 15 20:18:33
2013
@@ -26,6 +26,30 @@
             sort | uniq)
         COMPREPLY=( $(compgen -W "${vms_uuids}" -- ${cur}) )

+    elif [[  ${prev} == 'boot'
+        || ${prev} == 'console'
+        || ${prev} == 'delete'
+        || ${prev} == 'destroy'
+        || ${prev} == 'get'
+        || ${prev} == 'halt'
+        || ${prev} == 'json'
+        || ${prev} == 'reboot'
+        || ${prev} == 'send'
+        || ${prev} == 'start'
+        || ${prev} == 'stop'
+        || ${prev} == 'update'
+    ]] && [[ ${COMP_WORDS[COMP_CWORD-2]} == "alias"
+    ]] && [[ ${COMP_WORDS[COMP_CWORD-3]} == "vmadm" ]]; then
+
+        vms_alias=$(vmadm list -o alias | grep -v ALIAS | grep -v "^\-$
" | \
+            sort | uniq)
+        COMPREPLY=( $(compgen -W "${vms_alias}" -- ${cur}) )
+
+    elif [[ ${prev} == 'alias' ]]; then
+        vms_alias=$(vmadm list -o alias | grep -v ALIAS | grep -v "^\-$
" | \
+            sort | uniq)
+        COMPREPLY=( $(compgen -W "${vms_alias}" -- ${cur}) )
+
     elif [[ ${prev} == 'info'
           || ${prev} == 'sysrq' ]]; then
```

</div>

</div>

</div>

Alternative wrapper
-----------------------

### .bashrc

<div class="code panel" style="border-width: 1px;">

<div class="codeHeader panelHeader" style="border-bottom-width: 1px;">

**.bashrc excerpt**

</div>

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Midnight; .brush: .bash; .gutter: .true}
function zlogin() {
  cmd_opts=
  while test $# -gt 0; do
    case $1 in
      alias=*)
        alias=$(echo $1 | cut -d"=" -f 2)
        vmuuid=$(/usr/sbin/vmadm list -H -o uuid alias=${alias})
        cmd_opts="${cmd_opts} ${vmuuid}"
        shift
      ;;
      *)
        cmd_opts="${cmd_opts} $1"
        shift
      ;;
    esac
  done

  /usr/sbin/zlogin ${cmd_opts}
}

function vmadm() {
  cmd_opts=
  while test $# -gt 0; do
    case $1 in
      alias=*)
        alias=$(echo $1 | cut -d"=" -f 2)
        vmuuid=$(/usr/sbin/vmadm list -H -o uuid alias=${alias})
        cmd_opts="${cmd_opts} ${vmuuid}"
        shift
      ;;
      *)
        cmd_opts="${cmd_opts} $1"
        shift
      ;;
    esac
  done

  /usr/sbin/vmadm ${cmd_opts}
}
```

</div>

</div>

</div>

### Example Usage

<div class="code panel" style="border-width: 1px;">

<div class="codeContent panelContent">

<div id="root">

``` {.theme: .Confluence; .brush: .java; .gutter: .false}
vmadm start alias=myalias
zlogin -l user alias=myalias
```

</div>

</div>

</div>

To put it simple the wrapper replaced **alias=xxx** with the actual uuid
or empty if non existing.
+--------------------------------------------------------------------------+

  ----------------------------------------------------------------------------------
  ![](images/border/spacer.gif){width="1" height="1"}
  <font color="grey">Document generated by Confluence on Jul 07, 2019 00:15</font>
  ----------------------------------------------------------------------------------


