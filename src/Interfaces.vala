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
    [DBus (name = "org.gnome.SessionManager")]
    public interface SessionManager : Object {
        public abstract async ObjectPath register_client (string app_id, string client_start_id) throws IOError;
    }

    [DBus (name = "org.gnome.SessionManager.ClientPrivate")]
    public interface SessionClient : Object {
        public abstract void end_session_response (bool is_ok, string reason) throws IOError;

        public signal void stop ();
        public signal void query_end_session (uint flags);
        public signal void end_session (uint flags);
        public signal void cancel_end_session ();
    }    
}
