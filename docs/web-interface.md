# SmartOS Web Interface

SmartOS now has a web based user interface available. This UI is most directly
simply exposing SmartOS primitives via a web interface for the purposes of
managing instances and aims to make simpler tasks much more approachable for new
users, as well as make more complex tasks easier for advanced users.

Note that while we have tried to make sure SmartOS features are represented in
the Web UI, not all features are yet exposed. And due to the nature of SmartOS
being much more free form than Triton, it's possible that you may have a
configuration on an instance or image that causes errors in the UI.
[Please report these][i] errors so that we may correct this.

[i]: https://github.com/TritonDataCenter/smartos-ui/issues

## Installation

You can use `uiadm` to install the web interface:

```sh
uiadm install latest
```

## Accessing the Web UI

The UI is available on port 4443. The installer will print out the URL
by IP. If you are link-local to your SmartOS host you can also use the
multicast DNS name. E.g.: `https://192.168.122.184:4443` or
`https://my-smartos-host.local:4443`.

The login for the Web UI is the root user and password of the system.
This would be the same credentials used to log in via ssh or the console.

The SSL certificate is automatically generated and stored in `/usbkey/tls`. This
may be replaced with a custom certificate if you choose.

## The `uiadm` command

The `uiadm` command can be used to upgrade or uninstall the Web UI. It uses the
following subcommands.

<!-- markdownlint-disable line-length -->

| command                   | action                                                                                                  |
| ------------------------- | ------------------------------------------------------------------------------------------------------- |
| `uiadm avail`             | List available installation candidates. Only versions newer than currently installed will be displayed. |
| `uiadm install <version>` | Install the specified version. You can also use the keyword `latest`.                                   |
| `uiadm install latest`    | Install the latest version.                                                                             |
| `uiadm info`              | Display information about the current installation, including URL.                                      |
| `uiadm remove`            | Completely uninstall the Web UI.                                                                        |

<!-- markdownlint-enable line-length -->

## UI Tour

The UI has the following tabs.

* Dashboard
* Instances
* Images
* Global Zone Config

### Dashboard

This page shows a summary of the overall system, including the number of
instances and estimated available provisioning capacity.

In the future this may include management of the PI or zpool, or the ability
to reboot the entire server.

### Instances

This page allows management of existing instances. You can view the details and
perform actions such as start, stop, or destroy. If the instance uses static
IPs, the IP information will also be displayed.

In the future, you will be able to update instance properties.

#### Creating instances

To create a new instance click the **Create** button. After selecting an image
you may choose an appropriate instance brand and fill in additional details
using the guided form.

On the **Additional Properties** tab you can supply a JSON object that will
be merged with properties from the guided form. You may also choose a merging
strategy, whether the form or the JSON will take precedence if there are
duplicate keys.

Finally, you can preview the JSON payload on the **Final Properties** tab
before provisioning. The Web UI will validate the JSON payload before
provisioning to let you know about any errors.

### Images

This page allows you to view, import, or remove images.

Images can only be removed if there are zero instances that depend on it.

### Global Zone Config

This page displays the global zone config file (`/usbkey/config`) as key value
pairs.

In the future you will be able to edit properties here.
