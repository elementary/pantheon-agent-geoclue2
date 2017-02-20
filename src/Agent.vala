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
    public class Agent : Gtk.Application, GeoClue2Agent {
        private const string app_id = "org.pantheon.agent-geoclue2";

        public uint max_accuracy_level { get { return GeoClue2.AccuracyLevel.EXACT; } }
        private MainLoop loop;
		private uint object_id;
		private bool bus_registered = false;

        public Agent () {
            Object (application_id: app_id);
            loop = new MainLoop ();                  
        }

        public override void activate () {
            loop.run ();
        }
               
	    void on_name (DBusConnection conn) {
		    try {
			    if (bus_registered) {
				    conn.unregister_object (object_id);
				    bus_registered = false;
			    }
				
				debug ("Adding agent...");
			    object_id = conn.register_object ("/org/freedesktop/GeoClue2/Agent", (GeoClue2Agent)this);
			    bus_registered = true;
			    register_with_geoclue ();
		    } catch (Error e) {
			    error ("Error while registering the agent: %s \n", e.message);
		    }
	    }

	    private void watch (DBusConnection connection) {
		    Bus.watch_name (BusType.SYSTEM, "org.freedesktop.GeoClue2", BusNameWatcherFlags.AUTO_START, on_name);
	    }

	    public override bool dbus_register (DBusConnection connection, string object_path) throws Error {
		    base.dbus_register (connection, object_path);
		    watch (connection);

		    return true;
	    }

	    public override void dbus_unregister (DBusConnection connection, string object_path) {
		    if (bus_registered) {
			    connection.unregister_object (object_id);
			}
		    base.dbus_unregister (connection, object_path);
	    }
        
        public void authorize_app (string id, uint req_accuracy, out bool authorized, out uint allowed_accuracy) {
			debug ("Request for '%s' at level '%u'", id, req_accuracy);

			var dialog = new Widgets.Geoclue2Dialog ("%s wants to use your location".printf (id), "");
			dialog.show_all ();
			var response = dialog.run ();
			if (response == Gtk.ResponseType.YES) {
				authorized = true;
			} else {
				authorized = false;
			}
            allowed_accuracy = req_accuracy;
        }

        private async void register_with_geoclue () {
            yield Utils.register_with_geoclue (app_id);
        }
    }

    public static int main (string[] args) {
        var agent = new Agent ();
        return agent.run (args);
    }
}
