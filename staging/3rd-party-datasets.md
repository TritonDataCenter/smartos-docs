# 3rd party datasets

There's an effort to consolidate community dataset servers at
<http://datasets.at/>.There is also a list of community servers below.
To use them, simply add their source URL below to your
/var/db/imgadm/sources.list file.  You can add as many as you like, but
we recommend you always keep the official Joyent Dataset server in the
list (datasets.joyent.com).

Once you've changed your sources, be sure to run `imgadm update`
to refresh your local cache file.  Then use `imgadm avail` to view
all the available choices.  For more information provided by the dataset
authors, please visit the home page link corresponding to the source.

<!-- markdownlint-disable line-length -->

| Source URL                                    | Owner         | Home Page                               | Created        | Comments |
| --------------------------------------------- | ------------- | ------------- ------------------------- | -------------- | -------- |
| <http://cuddletech.com/datasets/>             | Ben Rockwood  | <http://cuddletech.com/datasets.html>   | Aug 6th, 2012  |  |
| <http://datasets.shalman.org/datasets>        | Nahum Shalman | [Spice on SmartOS](spice-on-smartos.md) | Aug 31st, 2012 | Speaks the old DSAPI |
| <http://datasets.at/datasets>                 | Daniel Malon  | <http://datasets.at/#\!/about>          |                | Also auto-generates JSON for using a particular image |
| <https://imgapi.smartos.skylime.net/images>   | SkyLime       | <https://imgapi.smartos.skylime.net>    | Dec 2014       | Contact wiedi or drscream on irc |

<!-- markdownlint-disable line-length -->

The datasets are w/o any guarantee - use them at your own risk.
