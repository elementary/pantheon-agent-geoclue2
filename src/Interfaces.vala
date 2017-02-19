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
        public abstract async void add_agent (string id) throws IOError;
    }

    [DBus (name = "org.freedesktop.GeoClue2.Agent")]
	public interface GeoClue2Agent : GLib.Object {
        [DBus (name = "AuthorizeApp")]
		public abstract void authorize_app(string desktop_id, uint req_accuracy_level, out bool authorized, out uint allowed_accuracy_level) throws DBusError, IOError;
        [DBus (name ="MaxAccuracyLevel")]
		public abstract uint max_accuracy_level {  get; }
	}
}
