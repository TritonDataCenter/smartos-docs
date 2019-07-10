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

## Converting Confluence Content


