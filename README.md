# Pantheon Geoclue2 Agent
[![l10n](https://l10n.elementary.io/widgets/desktop/pantheon-agent-geoclue2/svg-badge.svg)](https://l10n.elementary.io/projects/desktop/pantheon-agent-geoclue2)

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
