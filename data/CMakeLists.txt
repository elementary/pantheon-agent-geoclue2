include(Translations)

configure_file(org.pantheon.agent-geoclue2.desktop.in.in ${CMAKE_CURRENT_BINARY_DIR}/org.pantheon.agent-geoclue2.desktop.in)
configure_file_translation(${CMAKE_CURRENT_BINARY_DIR}/org.pantheon.agent-geoclue2.desktop.in ${CMAKE_CURRENT_BINARY_DIR}/org.pantheon.agent-geoclue2.desktop ${CMAKE_SOURCE_DIR}/po/)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/org.pantheon.agent-geoclue2.desktop DESTINATION share/applications)
