/*-
 * Copyright (c) 2017 elementary LLC.
 * Copyright (C) 2017 David Hewitt <davidmhewitt@gmail.com>   
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Authored by: David Hewitt <davidmhewitt@gmail.com>
 */

namespace Ag.Utils {
    public const string GNOME_SESSION_MANAGER_IFACE = "org.gnome.SessionManager";
    public const string GNOME_SESSION_MANAGER_PATH = "/org/gnome/SessionManager";

    public async SessionClient? register_with_session (string app_id) {
        SessionClient? sclient = null;
        ObjectPath? path = null;

        string? start_id = Environment.get_variable ("DESKTOP_AUTOSTART_ID");
        if (start_id != null) {
            Environment.unset_variable ("DESKTOP_AUTOSTART_ID");
        } else {
            start_id = "";
        }

        try {
            SessionManager? session = yield Bus.get_proxy (BusType.SESSION, GNOME_SESSION_MANAGER_IFACE, GNOME_SESSION_MANAGER_PATH);
            path = yield session.register_client (app_id, start_id);
        } catch (Error e) {
            warning ("Error registering client: %s", e.message);
            return null;
        }

        try {
            sclient = yield Bus.get_proxy (BusType.SESSION, GNOME_SESSION_MANAGER_IFACE, path);
        } catch (Error e) {
            warning ("Unable to get Private Client proxy: %s", e.message);
            return null;
        }

        return sclient;
    }
}
