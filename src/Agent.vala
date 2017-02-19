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
    public class Agent {
        private const string app_id = "org.pantheon.agent-geoclue2";

        public Agent () {
            register_with_session.begin ((obj, res)=> {
                bool success = register_with_session.end (res);
                if (!success) {
                    warning ("Failed to register with Session manager");
                }
                
                register_with_geoclue.begin ();
            });
        }

        private async bool register_with_session () {
            var sclient = yield Utils.register_with_session (app_id);
            if (sclient == null) {
                return false;
            }

            sclient.query_end_session.connect (session_respond);
            sclient.end_session.connect (session_respond);
            sclient.stop.connect (session_stop);

            return true;
        }

        private async void register_with_geoclue () {
            yield Utils.register_with_geoclue (app_id);
        }

        private void session_respond (SessionClient sclient, uint flags) {
            try {
                sclient.end_session_response (true, "");
            } catch (Error e) {
                warning ("Unable to respond to session manager: %s", e.message);
            }
        }

        private void session_stop () {
            Gtk.main_quit ();
        }
    }

    public static int main (string[] args) {
        Gtk.init (ref args);

        var agent = new Agent ();

        Gtk.main ();
        return 0;
    }
}
