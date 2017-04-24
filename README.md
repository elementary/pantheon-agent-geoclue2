# Pantheon Geoclue2 Agent
[![l10n](https://l10n.elementary.io/widgets/desktop/pantheon-agent-geoclue2/svg-badge.svg)](https://l10n.elementary.io/projects/desktop/pantheon-agent-geoclue2)

## Building, Testing, and Installation

You'll need the following dependencies:

* cmake
* libdbus-glib-1-dev
* libgeoclue-2-dev
* libgtk-3-dev
* valac

It's recommended to create a clean build environment

    mkdir build
    cd build/
    
Run `cmake` to configure the build environment and then `make all test` to build and run automated tests

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make all test
    
To install, use `make install`

    sudo make install
