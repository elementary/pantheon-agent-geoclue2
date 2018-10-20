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

namespace Ag {
    [DBus (name = "org.freedesktop.GeoClue2.Manager")]
    public interface GeoClue2Manager : Object {
        public abstract async void add_agent (string id) throws GLib.Error;
        public abstract async ObjectPath get_client () throws GLib.Error;
    }

    [DBus (name = "org.freedesktop.GeoClue2.Agent")]
    public interface GeoClue2Agent : GLib.Object {
        [DBus (name = "AuthorizeApp")]
        public abstract async void authorize_app (string desktop_id, GeoClue2.AccuracyLevel req_accuracy_level, out bool authorized, out GeoClue2.AccuracyLevel allowed_accuracy_level) throws GLib.Error;
        [DBus (name ="MaxAccuracyLevel")]
        public abstract GeoClue2.AccuracyLevel max_accuracy_level {  get; }
    }

    [DBus (name = "org.freedesktop.GeoClue2.Client")]
    public interface GeoClue2Client : GLib.Object {
        [DBus (name = "Start")]
        public abstract void start () throws GLib.Error;
        [DBus (name = "Stop")]
        public abstract void stop () throws GLib.Error;
        [DBus (name = "DesktopId")]
        public abstract string desktop_id { owned get; set; }
    }
}
