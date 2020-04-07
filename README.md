# Location Services Agent
[![Translation status](https://l10n.elementary.io/widgets/desktop/-/pantheon-agent-geoclue2/svg-badge.svg)](https://l10n.elementary.io/engage/desktop/?utm_source=widget)

The location services agent appears whenever an application wants to request permission to use location services. From this dialog, you can see what level of access the application is requesting and either approve or deny its access to your current location.

![Location Services Agent Screenshot](data/screenshot.png?raw=true)

## Building, Testing, and Installation

You'll need the following dependencies:

* libgeoclue-2-dev
* libgtk-3-dev
* meson
* valac

Run `meson` to configure the build environment and then `ninja test` to build and run automated tests

    meson build --prefix=/usr
    cd build
    ninja test

To install, use `ninja install`

    sudo ninja install
