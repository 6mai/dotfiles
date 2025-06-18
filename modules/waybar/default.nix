{ lib, pkgs, config, user, ... }:

{
  services = {
    # Networking
    network-manager-applet.enable = true;
    # Bluetooth
    blueman-applet.enable = true;
    # Pulseaudio
    pasystray.enable = true;
    # Battery Warning
    cbatticon.enable = true;
  };

  programs.waybar = {
      enable = true;
      systemd.enable = false;
      style = ''
        ${builtins.readFile ./style.css}
      '';
			settings = [{
			    layer = "top";
			    position = "top";
			    height = 30;
			    output = [
			      "eDP-1"
			      "HDMI-A-1"
			    ];
          modules-left = [
              "sway/workspaces"
              "sway/mode"
              "sway/scratchpad"
              "sway/window"
          ];
          modules-center = [
              "clock"
          ];
          modules-right = [
              "cpu"
              "memory"
              "backlight"
              "battery"
              "network"
              "idle_inhibitor"
              "tray"
              "custom/power"
          ];

          # "custom/power" = {
          #     format = "${user.userName}";
          #     tooltip-format = "power manager";
          #     on-click = "swaynag -t warning -m 'Power Menu Options' -b 'Shutdown' 'shutdown -h now' -b 'Restart' 'shutdown -r now' -b 'Logout' 'swaymsg exit' -b 'Hibernate' 'systemctl hibernate' --background=#005566 --button-background=#009999 --button-border=#002b33 --border-bottom=#002b33";
          # };

          "custom/power" = {
              format = "";
              tooltip-format = "Power Manager";
              on-click = "wlogout";
          };

          clock = {
              interval = 30;
              format = "{:%a, %d %b %Y | %H:%M %p}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          cpu = {
              interval = 1;
              format = "  {usage}%";
              # format = "CP: {usage}%";
          };

          memory = {
              interval = 1;
              format = "  {percentage}%";
              # format = "Mem:{}%";
          };

          backlight = {
              format = "{icon} {percent}%";
              format-icons = ["🔅" "🔆"];
          };

          battery = {
              states = {
                  warning = 30;
                  critical = 15;
              };
              interval = 1;
              format = "{icon} {capacity}%";
              format-charging = "⚡ {capacity}%";
              format-icons = ["" "" "" "" ""];
          };

          network = {
              format-wifi = " ({signalStrength}%) {essid}";
              # format-ethernet = "{ipaddr}/{cidr} ";
              format-ethernet = " {bandwidthUpBits}  {bandwidthDownBits}";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
          };

          pulseaudio = {
              format = "{icon} {volume}%";
              format-bluetooth = "{icon} {volume}%";
              format-muted = " {format_source}";
              format-source = " {volume}%";
              format-source-muted = "";
              format-icons = {
                  headphone = "";
                  hands-free = "";
                  default = ["" "" ""];
              };
              on-click = "pwvucontrol";
          };

          idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                  activated = "";
                  deactivated = "";
              };
          };

          tray = {
              spacing = 10;
          };
			  }];
  };
	
}
