# smartos-docs

This repo builds a static site for SmartOS documentation. This replaces the
old confluence based wiki.

## Layout

There are two directories of note.

1. `docs` - the markdown docs. This gets rendered to the site.
2. `confluence-export` - An HTML export of the confluence content. This is
    for reference purposes and will likely be removed once all of the
    content is converted.

## Requirements

There are very few external dependencies. Most needed tools will be installed
internally to the repo. You'll need the following available:

* git
* node.js (>=8)
* python3.7
  * pip3.7
  * virtualenv3.7

It's recommended to get these from [pkgsrc](https://pkgsrc.joyent.com), but
you may get them from elsewhere if you choose.

    pkgin -y install git nodejs-8 python-3.7 py37-pip py37-virtualenv

After you have the external dependencies installed, install the internal
dependencies

    make deps

## Contributing

Pull requests welcome! Unlike other Joyent repositories, this repo only uses
github pull requests in order to make it as easy to contribute as possible.

Please feel free to update anything that needs fixing and send us a pull
request. Pull requests must pass `make check` before they'll be approved.
Once merged, changes should show up on the live site within about five minutes.

Before submitting a pull request, you should run ensure that your changes will
pass `make check`, and run `make serve` and check it with your local browser
to make sure that everything looks the way you expect. Pull requests that do
not pass `make check` will not be merged.
