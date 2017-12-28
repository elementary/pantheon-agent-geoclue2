project('pantheon-agent-geoclue2', 'vala', 'c')

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="' + meson.project_name() + '"', language:'c')

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

executable(
    meson.project_name(),
    'src/Agent.vala',
    'src/Geoclue2Dialog.vala',
    'src/Interfaces.vala',
    'src/Utils.vala',
    dependencies: [
        dependency('dbus-glib-1'),
        dependency('gio-unix-2.0'),
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('gtk+-3.0'),
        dependency('libgeoclue-2.0')
    ],
    install: true,
    install_dir: join_paths(get_option('libexecdir'), 'geoclue2-1-pantheon')
)

subdir('data')
subdir('po')
