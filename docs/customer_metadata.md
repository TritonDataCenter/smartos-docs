# Instance Metadata

Instances can retrieve, list, and store metadata with the hypervisor using
the following commands:

* `mdata-list` - List metadata keys
* `mdata-get` - Retrieve the value of a metadata key
* `mdata-put` - Store data to a key name
* `mdata-delete` - Delete a metadata key

Metadata is provided to instances via the `customer_metadata` key in the VM
JSON object used to create the instance.

The following is a transcript of an example instance performing various
metadata operations:

    root@cf7514d9:~# mdata-list
    key1
    key2
    root@cf7514d9:~# mdata-get key1
    val1
    root@cf7514d9:~# mdata-list
    key1
    key2
    root@cf7514d9:~# mdata-put key3 val3
    root@cf7514d9:~# mdata-get key2
    val2
    root@cf7514d9:~# mdata-delete key2
    root@cf7514d9:~# mdata-list
    key1
    key3

Metadata may be added to the JSON manifest used to create the image and will
be available to the guest. Metadata stored by guests is also available to be
read via `vmadm`.

    [root@pris (sv16) ~]# vmadm get cf7514d9-6313-45ba-a4cb-f1cc10349c8d | json customer_metadata
    {
      "key1": "val1",
      "key2": "val2",
      "key3": "val3"
}

**Note:** All metadata in the JSON manifest ***must*** be *strings*. To store
JSON it must be stringified. Text with line breaks must use `\n`. Metadata
values will be de-stringified by `mdata-get`. Bare JSON will be automatically
stringified by `mdata-put`.

## Metadata Keys With Defined Guest Behavior

For images obtained from `images.smartos.org`, there is a reserved set of keys
with specific behavior.

All non-reserved keys have no defined behavior and may be used in any way
you wish.

### `root_authorized_keys`

The value of this key is a set of linefeed-separated SSH public keys, in the
format of an OpenSSH authorized_keys file. In HVM virtual machines and LX
brand zones, this key is read during first boot and written to
`/root/.ssh/authorized_keys`, or wherever the SSH keys for the root user are
located. This mechanism allows us to provide seamless login using the same SSH
keys the user has placed within their account in the provisioning system.

Example:

    "customer_metadata": {
        "root_authorized_keys": "ecdsa-sha2-nistp256 ... \nssh-rsa ...\n"
    }

SmartOS instances do not generally make use of this key. Instead, a more
advanced mechanism in Triton called SmartLogin is used – SmartLogin queries SSH
keys from the provisioning system at each login.

### `user-script`

This key may contain a program that is written to a file in the filesystem of
the guest on each boot and then executed. It may be of any format that would be
considered executable in the guest instance.

In a UNIX system, a shebang line (e.g. #!/bin/ksh) may be used to specify the
interpreter for the script. The script may also not have a shebang line, at
which point the traditional UNIX behaviour of executing the script with the
current shell will occur. The current shell in this context is generally
`/bin/bash`, or some other Bourne-compatible shell. The specific shell used will
be the default shell of the guest image.

### `user-data`

This key has no defined format, but its value is written to the file
`/var/db/mdata-user-data` on each boot prior to the phase that runs
`user-script`. This file is not to be executed. This allows a configuration
file of some kind to be injected into the machine to be consumed by the
`user-script` when it runs.

### `cloud-init:user-data`

Instances that support `cloud-init` will retrieve the `cloud-config` from this
key. The format of this key is `JSON.stringify()`'d `yml`.

Example:

<!-- markdownlint-disable line-length -->
    ...
    "customer_metadata": {
        "cloud-init:user-data": "#cloud-config\n\package_update: true\npackage_upgrade: true\n"
    }
<!-- markdownlint-enable line-length -->

See [below](#cloud-init) for more information.

## Metadata Namespacing

Metadata may be namespaced in the format of `namespace:key`. Using this,
you can provide keys that are reserved by your organization. This is mostly
used by vendors creating images for SmartOS to provide additional configuration
options that are specific to the product.

To ensure that there are not inter-vendor key name conflicts, vendors are
encouraged to use the reversed version of their corporate DNS domain as a
prefix. For example:

    com.ubuntu:user-data

or

    com.riverbed:stingray-license-key

### Reserved Namespaces

The following namespaces are reserved and should not be used by vendors or
guests.

#### `sdc:`

The `sdc:` namespace provides access to keys in the instance JSON. Guest
instances are not allowed to write to the `sdc:` namespace but may retrieve
values.

The following keys are supported:

* `sdc:uuid`
* `sdc:image_uuid`
* `sdc:server_uuid`
* `sdc:owner_uuid`
* `sdc:alias`
* `sdc:datacenter_name`
* `sdc:nics`
* `sdc:resolvers`
* `sdc:hostname`
* `sdc:dns_domain`
* `sdc:routes`

For full details, see the SmartOS [Metadata Dictionary][dd].

[dd]: https://eng.tritondatacenter.com/mdata/datadict.html

#### `cloud-init:`

The `cloud-init:` namespace is reserved for the `cloud-config` system. The
only supported key is `cloud-init:user-data`.

The exact behavior of `cloud-init` will depend on the version installed in the
image you are using. Not all images will have `cloud-init` installed.

For full details refer to the [`cloud-init` documentation][ci].

[ci]: https://cloudinit.readthedocs.io/
