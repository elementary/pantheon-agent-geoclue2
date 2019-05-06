/*-
 * Copyright (c) 2017-2019 elementary, Inc.
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
        public GeoClue2.AccuracyLevel max_accuracy_level {
            get {
                bool enabled = settings.get_value ("location-enabled").get_boolean ();
                if (enabled) {
                    return GeoClue2.AccuracyLevel.EXACT;
                } else {
                    return GeoClue2.AccuracyLevel.NONE;
                }
            }
        }

        private uint object_id;
        private bool bus_registered = false;

        private GeoClue2Client? client = null;
        private GLib.Settings settings;

        construct {
            application_id = "io.elementary.desktop.agent-geoclue2";
            settings = new GLib.Settings (application_id);
            settings.changed.connect ((key) => {
                if (key == "location-enabled") {
                    notify_property ("max-accuracy-level");
                }
            });
        }

        public override void activate () {
            hold ();
        }

        private void on_name (DBusConnection conn) {
            try {
                if (bus_registered) {
                    conn.unregister_object (object_id);
                    bus_registered = false;
                }

                debug ("Adding agent...");
                object_id = conn.register_object ("/org/freedesktop/GeoClue2/Agent", (GeoClue2Agent)this);
                bus_registered = true;
                Utils.register_with_geoclue.begin ();
            } catch (Error e) {
                error ("Error while registering the agent: %s", e.message);
            }
        }

        public override bool dbus_register (DBusConnection connection, string object_path) throws Error {
            base.dbus_register (connection, object_path);
            Bus.watch_name (BusType.SYSTEM, "org.freedesktop.GeoClue2", BusNameWatcherFlags.AUTO_START, on_name);

            return true;
        }

        public override void dbus_unregister (DBusConnection connection, string object_path) {
            if (bus_registered) {
                connection.unregister_object (object_id);
            }

            base.dbus_unregister (connection, object_path);
        }

        public async void authorize_app (string id, GeoClue2.AccuracyLevel req_accuracy, out bool authorized, out GeoClue2.AccuracyLevel allowed_accuracy) {
            debug ("Request for '%s' at level '%u'", id, req_accuracy);

            DesktopAppInfo app_info = new DesktopAppInfo (id + ".desktop");
            if (app_info == null) {
                debug ("Rejecting for invalid desktop file");
                authorized = false;
                allowed_accuracy = req_accuracy;
                return;
            }

            var remembered_apps = settings.get_value ("remembered-apps");
            var remembered_apps_dict = new GLib.VariantDict (remembered_apps);
            Variant? remembered_accuracy = remembered_apps_dict.lookup_value (id, GLib.VariantType.TUPLE);
            if (remembered_accuracy != null) {
                bool stored_auth;
                GeoClue2.AccuracyLevel stored_accuracy;
                remembered_accuracy.get ("(bu)", out stored_auth, out stored_accuracy);
                if (stored_auth && req_accuracy <= stored_accuracy) {
                    authorized = true;
                    allowed_accuracy = req_accuracy;
                    return;
                }
            }

            unowned string app_name = app_info.get_display_name ();
            string accuracy_string = accuracy_to_string (app_name, req_accuracy);

            client = yield Utils.get_geoclue2_client ();
            debug ("Starting client...");
            if (client != null) {
                try {
                    client.start ();
                } catch (Error e) {
                    error ("Could not start client: %s", e.message);
                }
            }

            var dialog = new Widgets.Geoclue2Dialog (accuracy_string, app_name, app_info.get_icon ());
            dialog.show_all ();

            var result = dialog.run ();

            if (result == Gtk.ResponseType.YES) {
                authorized = true;
            } else {
                authorized = false;
            }

            dialog.destroy ();
            allowed_accuracy = req_accuracy;
            remember_app (id, authorized, req_accuracy);

            debug ("Stopping client...");
            if (client != null) {
                try {
                    client.stop ();
                } catch (Error e) {
                    error ("Could not stop client: %s", e.message);
                }
            }
        }

        private string accuracy_to_string (string app_name, uint accuracy) {
            unowned string message;
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

        public void remember_app (string desktop_id, bool authorized, GeoClue2.AccuracyLevel accuracy_level) {
            var remembered_apps = settings.get_value ("remembered-apps");
            var remembered_apps_dict = new GLib.VariantDict (remembered_apps);
            var val = new Variant ("(bu)", authorized, accuracy_level);
            remembered_apps_dict.insert_value (desktop_id, val);
            settings.set_value ("remembered-apps", remembered_apps_dict.end ());
        }
    }

    public static int main (string[] args) {
        var agent = new Agent ();
        return agent.run (args);
    }
}
