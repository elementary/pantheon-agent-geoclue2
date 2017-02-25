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

		private uint _max_accuracy_level = GeoClue2.AccuracyLevel.EXACT;
        public uint max_accuracy_level { get { return _max_accuracy_level; } }
        private MainLoop loop;
		private uint object_id;
		private bool bus_registered = false;		

		private GeoClue2Client? client = null;
		private Settings settings = new Settings (app_id);
		private VariantDict remembered_apps;

        public Agent () {
            Object (application_id: app_id);
            loop = new MainLoop ();  
			refresh_enabled_state ();    
			refresh_remembered_apps ();

			settings.changed.connect ((key) => {
				refresh_enabled_state ();
				refresh_remembered_apps ();
			});
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
			    register_with_geoclue.begin ();

				
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

			DesktopAppInfo app_info = new DesktopAppInfo (id + ".desktop");
			if (app_info == null) {
				debug ("Rejecting for invalid desktop file");
				authorized = false;
				allowed_accuracy = req_accuracy;
				return;
			}

			Variant? remembered_accuracy = get_remembered_accuracy (id);
			if (remembered_accuracy != null) {
				var stored_auth = remembered_accuracy.get_child_value (0).get_boolean ();
				var stored_accuracy = remembered_accuracy.get_child_value (1).get_uint32 ();				
				if (req_accuracy <= stored_accuracy && stored_auth) {
					authorized = true;
					allowed_accuracy = req_accuracy;
					return;
				}				
			}

			string app_name = app_info.get_display_name ();
			string accuracy_string = accuracy_to_string (app_name, req_accuracy);

			debug ("Registering client...");
			get_geoclue_client.begin ((obj, res) => {
				client = get_geoclue_client.end (res);
				try {
					client.start ();
				} catch (Error e) {
					warning ("Error while registering geoclue client: %s", e.message);
				}
			}); 

			var dialog = new Widgets.Geoclue2Dialog (accuracy_string, app_name, app_info.get_icon ().to_string ());
			dialog.show_all ();

			var result = dialog.run ();

			switch (result) {
				case Gtk.ResponseType.YES:
					authorized = true;
					break;
				default:
					authorized = false;
					break;
			}

			remember_app (id, authorized, req_accuracy);

			dialog.destroy ();

			if (client != null) {
				try {
					client.stop ();
				} catch (Error e) {
					warning ("Error while stopping geoclue client: %s", e.message);
				}
			}

            allowed_accuracy = req_accuracy;
        }

		private string accuracy_to_string (string app_name, uint accuracy) {
			string message = "";
			switch (accuracy) {
				case GeoClue2.AccuracyLevel.COUNTRY:
					message = _("the current country");
					break;
				case GeoClue2.AccuracyLevel.CITY:
					message = _("the nearest city or town");
					break;
				case GeoClue2.AccuracyLevel.NEIGHBORHOOD:
					message = _("the nearest neighborhood");
					break;
				case GeoClue2.AccuracyLevel.STREET:
					message = _("the nearest street");
					break;
				case GeoClue2.AccuracyLevel.EXACT:
					message = _("your exact location");
					break;
				default:
					message = _("your location");
					break;
			}
			
			return _("%s will be able to detect %s. Permissions can be changed in <a href='settings://security/privacy/location'>Location Settings…</a>").printf (app_name, message);
		}

        private async void register_with_geoclue () {
            yield Utils.register_with_geoclue (app_id);
        }

		private async GeoClue2Client get_geoclue_client () {
			return yield Utils.get_geoclue2_client (app_id);
		}

		private void refresh_remembered_apps () {
			remembered_apps = new VariantDict(settings.get_value("remembered-apps"));
		}

		private void refresh_enabled_state () {
			bool enabled = settings.get_value ("location-enabled").get_boolean ();
			if (enabled) {
				_max_accuracy_level = GeoClue2.AccuracyLevel.EXACT;
			} else {
				_max_accuracy_level = GeoClue2.AccuracyLevel.NONE;
			}
		}

		public void remember_app (string desktop_id, bool authorized, uint32 accuracy_level) {
			Variant[2] tuple_vals = new Variant[2];
			tuple_vals[0] = new Variant.boolean (authorized);
			tuple_vals[1] = new Variant.uint32 (accuracy_level);
			remembered_apps.insert_value (desktop_id, new Variant.tuple (tuple_vals));
			settings.set_value ("remembered-apps", remembered_apps.end ());
		}

		public Variant? get_remembered_accuracy (string desktop_id) {
			return remembered_apps.lookup_value (desktop_id, GLib.VariantType.TUPLE);
		}
    }

    public static int main (string[] args) {
        var agent = new Agent ();
        return agent.run (args);
    }
}
