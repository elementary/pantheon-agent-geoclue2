install_data(
    'io.elementary.desktop.agent-geoclue2.gschema.xml',
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

desktop_in = configure_file(
    input: 'io.elementary.desktop.agent-geoclue2.desktop.in.in',
    output: '@BASENAME@',
    configuration: conf_data
)

i18n.merge_file(
    input: desktop_in,
    output: '@BASENAME@',
    po_dir: join_paths(meson.source_root(), 'po', 'extra'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

# Daemon File
configure_file(
    input: 'io.elementary.desktop.agent-geoclue2-daemon.desktop.in',
    output: '@BASENAME@',
    configuration: conf_data,
    install_dir: join_paths(get_option('sysconfdir'), 'xdg', 'autostart')
)

desktop_file_validate = find_program('desktop-file-validate')

test (
    'Validate desktop file',
    desktop_file_validate,
    args: join_paths(meson.current_build_dir (), 'io.elementary.desktop.agent-geoclue2.desktop')
)

test (
    'Validate desktop file',
    desktop_file_validate,
    args: join_paths(meson.current_build_dir (), 'io.elementary.desktop.agent-geoclue2-daemon.desktop')
)
