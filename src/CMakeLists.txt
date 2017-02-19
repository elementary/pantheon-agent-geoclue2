vala_precompile(VALA_C ${EXEC_NAME}
    Agent.vala
    Geoclue2Dialog.vala
    Interfaces.vala
    Utils.vala
PACKAGES
    gtk+-3.0
    posix
OPTIONS
  --target-glib=2.32
  --thread
)

add_executable (${EXEC_NAME} ${VALA_C})
target_link_libraries (${EXEC_NAME} ${DEPS_LIBRARIES})

install (TARGETS ${EXEC_NAME} DESTINATION ${EXECDIR})

