project(
    'pantheon-agent-geoclue2',
    'vala', 'c',
    version: '1.0'
)

install_path = join_paths(get_option('prefix'), get_option('libexecdir'), 'geoclue2-1-pantheon')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

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
    install_dir: install_path
)

conf_data = configuration_data()
conf_data.set('EXEC_NAME', meson.project_name())
conf_data.set('EXECDIR', install_path)

subdir('data')
subdir('po')
