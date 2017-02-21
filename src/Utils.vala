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
    public const string GEOCLUE2_MANAGER_IFACE = "org.freedesktop.GeoClue2";
    public const string GEOCLUE2_MANAGER_PATH = "/org/freedesktop/GeoClue2/Manager";

    public async void register_with_geoclue (string app_id) {
        try {
            GeoClue2Manager? manager = yield Bus.get_proxy (BusType.SYSTEM, GEOCLUE2_MANAGER_IFACE, GEOCLUE2_MANAGER_PATH);
            yield manager.add_agent (app_id);
        } catch (Error e) {
            warning ("Unable to register with GeoClue2: %s", e.message);
        }
    }

    public async GeoClue2Client? get_geoclue2_client (string app_id) {
        GeoClue2Client? client = null;
        ObjectPath? path = null;

        try {
            GeoClue2Manager? manager = yield Bus.get_proxy (BusType.SYSTEM, GEOCLUE2_MANAGER_IFACE, GEOCLUE2_MANAGER_PATH);
            path = yield manager.get_client ();
        } catch (Error e) {
            warning ("Unable to register with GeoClue2: %s", e.message);
            return null;
        }

        try {
            client = yield Bus.get_proxy (BusType.SYSTEM, GEOCLUE2_MANAGER_IFACE, path);
        } catch (Error e) {
            warning ("Unable to get Private Client proxy: %s", e.message);
            return null;
        }

        if (client != null) {
            client.desktop_id = app_id;
        }

        return client;
    }
}
