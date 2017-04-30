project (pantheon-agent-geoclue2)

cmake_minimum_required (VERSION 2.8)

include (GNUInstallDirs)

set (PKGDATADIR "${CMAKE_INSTALL_FULL_DATADIR}/${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE ${CMAKE_PROJECT_NAME})
set (EXEC_NAME ${CMAKE_PROJECT_NAME})
set (VERSION "0.0.1")
set (DOLLAR "$")

set (EXECDIR "${CMAKE_INSTALL_FULL_LIBEXECDIR}/geoclue2-1-pantheon")

# CTest
include (CTest)
if (BUILD_TESTING)
    add_test (NAME validate-desktop-file COMMAND desktop-file-validate ${CMAKE_BINARY_DIR}/data/org.pantheon.agent-geoclue2.desktop)
endif ()

add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_definitions (-w)

find_package (PkgConfig)
pkg_check_modules (DEPS REQUIRED gtk+-3.0 libgeoclue-2.0 gio-unix-2.0 dbus-glib-1)

add_definitions (${DEPS_CFLAGS})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.34.1" MINIMUM)

include (ValaPrecompile)

add_subdirectory (po)
add_subdirectory (src)
add_subdirectory (data)
