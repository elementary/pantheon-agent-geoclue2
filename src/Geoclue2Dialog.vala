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

namespace Ag.Widgets {
    public class Geoclue2Dialog : Gtk.Dialog {
        public signal void done (bool allow);
        private Gtk.CheckButton remember_checkbox;

        public Geoclue2Dialog (string message, string icon_name) {
            Object (title: _("Location Dialog"), window_position: Gtk.WindowPosition.CENTER, resizable: false, deletable: false, skip_taskbar_hint: true);

            set_keep_above (true);

            var heading = new Gtk.Label (_("Location Request"));
            heading.get_style_context ().add_class ("primary");
            heading.valign = Gtk.Align.END;
            heading.xalign = 0;

            var message_label = new Gtk.Label (message);
            message_label.max_width_chars = 60;
            message_label.wrap = true;
            message_label.valign = Gtk.Align.START;
            message_label.xalign = 0;

            remember_checkbox = new Gtk.CheckButton.with_label (_("Remember this choice"));

            var image = new Gtk.Image.from_icon_name ("dialog-question", Gtk.IconSize.DIALOG);

            var overlay = new Gtk.Overlay ();
            overlay.valign = Gtk.Align.START;
            overlay.add (image);

            if (icon_name != "" && Gtk.IconTheme.get_default ().has_icon (icon_name)) {
                var overlay_image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.LARGE_TOOLBAR);
                overlay_image.halign = overlay_image.valign = Gtk.Align.END;
                overlay.add_overlay (overlay_image);
            }

            var grid = new Gtk.Grid ();
            grid.column_spacing = 12;
            grid.row_spacing = 6;
            grid.margin_left = grid.margin_right = 12;
            grid.attach (overlay, 0, 0, 1, 3);
            grid.attach (heading, 1, 0, 1, 1);
            grid.attach (message_label, 1, 1, 1, 1);
            grid.attach (remember_checkbox, 1, 2, 1, 1);

            var deny_button = (Gtk.Button)add_button (_("Deny"), Gtk.ResponseType.NO);
            var allow_button = (Gtk.Button)add_button (_("Allow"), Gtk.ResponseType.YES);
            allow_button.get_style_context ().add_class ("suggested-action");

            set_default (deny_button);

            get_content_area ().add (grid);

            var action_area = get_action_area ();
            action_area.margin_right = 6;
            action_area.margin_bottom = 6;
            action_area.margin_top = 14;
        }

        public override void show_all () {
            base.show_all ();

            var window = get_window ();
            if (window == null) {
                return;
            }

            window.focus (Gdk.CURRENT_TIME);
        }

        public bool remember_checked () {
            return remember_checkbox.get_active ();
        }
    }
}
