# Mix momo.new

Provides `momo_new` installer as an archive.

## Installation

To install from Hex, run:

    $ mix archive.install hex momo_new

To build and install it locally, ensure any previous archive versions are removed:

    $ mix archive.uninstall momo_new

Then run:

    $ cd installer
    $ MIX_ENV=prod mix do archive.build, archive.install

## Usage

Create a new `momo` project with:

    $ mix momo.new hello_world
