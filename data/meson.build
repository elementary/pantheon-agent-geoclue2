install_data(
    'io.elementary.desktop.agent-geoclue2.gschema.xml',
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

i18n.merge_file(
    input: 'io.elementary.desktop.agent-geoclue2.desktop.in',
    output: 'io.elementary.desktop.agent-geoclue2.desktop',
    po_dir: join_paths(meson.source_root(), 'po', 'extra'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

test (
    'Validate desktop file',
    find_program('desktop-file-validate'),
    args: join_paths(meson.current_build_dir (), 'io.elementary.desktop.agent-geoclue2.desktop')
)
