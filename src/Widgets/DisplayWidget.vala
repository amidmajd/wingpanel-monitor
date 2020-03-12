/*-
 * Copyright (c) 2020 Tudor Plugaru (https://github.com/PlugaruT/wingpanel-monitor)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 * Authored by: Tudor Plugaru <plugaru.tudor@gmail.com>
 */


namespace WingpanelMonitor {
    public class DisplayWidget : Gtk.Grid {
        private IndicatorWidget cpu_info;
        private IndicatorWidget ram_info;
        private IndicatorWidget upload_info;
        private IndicatorWidget download_info;
        private IndicatorWidget workspace_info;
        private IndicatorWidget weather_info;

        public unowned Settings settings { get; construct set; }

        public DisplayWidget (Settings settings) {
            Object (settings: settings);
        }

        construct {
            valign = Gtk.Align.CENTER;
            margin_top = 4;


            cpu_info = new IndicatorWidget ("cpu-symbolic", 4);
            ram_info = new IndicatorWidget ("ram-symbolic", 4);
            upload_info = new IndicatorWidget ("upload-speed-symbolic", 8);
            download_info = new IndicatorWidget ("download-speed-symbolic", 8);
            workspace_info = new IndicatorWidget ("computer-symbolic", 2);
            weather_info = new IndicatorWidget ("weather-clear-symbolic", 4);
            weather_info.tooltip_text = "%s in %s".printf (
                settings.get_string ("weather-details"), settings.get_string ("weather-location")
                );


            settings.bind ("show-cpu", cpu_info, "display", SettingsBindFlags.GET);
            settings.bind ("show-ram", ram_info, "display", SettingsBindFlags.GET);
            settings.bind ("show-network", upload_info, "display", SettingsBindFlags.GET);
            settings.bind ("show-network", download_info, "display", SettingsBindFlags.GET);
            settings.bind ("show-workspace", workspace_info, "display", SettingsBindFlags.GET);
            settings.bind ("show-weather", weather_info, "display", SettingsBindFlags.GET);

            add (weather_info);
            add (cpu_info);
            add (ram_info);
            add (upload_info);
            add (download_info);
            add (workspace_info);
        }

        public void update_workspace (int val) {
            workspace_info.label_value = val.to_string ();
        }

        public void update_cpu (int val) {
            cpu_info.label_value = val.to_string () + "%";
        }

        public void update_memory (int val) {
            ram_info.label_value = val.to_string () + "%";
        }

        public void update_network (int upload, int download) {
            upload_info.label_value = WingpanelMonitor.Utils.format_net_speed (upload, true, false);
            download_info.label_value = WingpanelMonitor.Utils.format_net_speed (download, true, false);
        }

        public void update_weather () {
            weather_info.label_value = settings.get_string ("weather-temperature");
            weather_info.new_icon = settings.get_string ("weather-icon");
            string location = settings.get_string ("weather-location");
            string details = settings.get_string ("weather-details");
            weather_info.tooltip_text = "%s in %s".printf (details, location);
        }
    }
}
