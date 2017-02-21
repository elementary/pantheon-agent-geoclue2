vala_precompile(VALA_C ${EXEC_NAME}
    Agent.vala
    Geoclue2Dialog.vala
    Interfaces.vala
    Utils.vala
PACKAGES
    gtk+-3.0
    gio-unix-2.0
    geoclue2
    dbus-glib-1
OPTIONS
  --target-glib=2.32
  --thread
  --vapidir=${CMAKE_SOURCE_DIR}/vapi
)

add_executable (${EXEC_NAME} ${VALA_C})
target_link_libraries (${EXEC_NAME} ${DEPS_LIBRARIES})

install (TARGETS ${EXEC_NAME} DESTINATION ${EXECDIR})

