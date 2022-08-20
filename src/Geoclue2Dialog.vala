/*-
 * Copyright 2017-2021 elementary, Inc.
 *           2017 David Hewitt <davidmhewitt@gmail.com>
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

public class Ag.Widgets.Geoclue2Dialog : Granite.MessageDialog {
    public Geoclue2Dialog (string message, string app_name, GLib.Icon? icon) {
        Object (
            image_icon: new ThemedIcon ("find-location"),
            primary_text: _("Allow %s to Access This Device's Location?").printf (app_name),
            secondary_text: message,
            resizable: false,
            skip_taskbar_hint: true,
            title: _("Location Dialog")
        );

        if (icon != null) {
            badge_icon = icon;
        }
    }

    construct {
        var deny_button = (Gtk.Button) add_button (_("Deny"), Gtk.ResponseType.NO);

        var allow_button = (Gtk.Button) add_button (_("Allow"), Gtk.ResponseType.YES);
        allow_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        set_default (deny_button);
        set_keep_above (true);
    }

    public override void show_all () {
        base.show_all ();

        var window = get_window ();
        if (window == null) {
            return;
        }

        window.focus (Gdk.CURRENT_TIME);
    }
}
