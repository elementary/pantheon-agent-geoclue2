project (pantheon-agent-geoclue2)

cmake_minimum_required (VERSION 2.8)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE ${CMAKE_PROJECT_NAME})
set (EXEC_NAME ${CMAKE_PROJECT_NAME})
set (VERSION "0.0.1")
set (DOLLAR "$")

set (LIBDIR "${CMAKE_INSTALL_PREFIX}/lib")
set (EXECDIR "${LIBDIR}/geoclue2-1-pantheon")

add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_definitions (-w)

find_package (PkgConfig)
pkg_check_modules (DEPS REQUIRED gtk+-3.0 libgeoclue-2.0)

add_definitions (${DEPS_CFLAGS})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.34.1" MINIMUM)

include (ValaPrecompile)

add_subdirectory (po)
add_subdirectory (src)
add_subdirectory (data)
