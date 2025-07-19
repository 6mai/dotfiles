{ lib, pkgs, config, user, inputs, ... }:
let
    col = config.colorScheme.palette;
in
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

      # style = ''
      #   ${builtins.readFile ./style.css}
      # '';

			settings = [{
			    layer = "top";
			    position = "top";
			    height = 30;
			    output = [
			      "eDP-1"
			      "HDMI-A-1"
			    ];
          modules-left = [
              "hyprland/workspaces"
              "hyprland/mode"
              "hyprland/scratchpad"
              "hyprland/window"
          ];
          # modules-left = [
          #     "sway/workspaces"
          #     "sway/mode"
          #     "sway/scratchpad"
          #     "sway/window"
          # ];
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
              format = "<big>{:%H:%M}</big>";
              tooltip-format = "<big>{:%Y - %d %B -}</big>\n<tt><small>{calendar}</small></tt>";
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

    	style = ''
        * {
            font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
            font-size: 16px;
            margin: 0;
            padding: 0;
            border: none;
            box-shadow: none;
            text-shadow: none;
        }

        window#waybar {
            background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ","  col.base03 },0.8);
            color: #${col.base07};
            transition: background-color 0.5s;
            border-radius: 8;
            /* border: solid; */
            /* border-width: 2px; */
            /* border-color: #ffffff; */
            /* margin: 3px; */
        }
        .modules-left,
        .modules-right,
        .modules-center {
            padding: 0px 4px;
            background-color: #${col.base01};
            border-radius: 8;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #window {
            font-family: 'Sarasa Gothic SC', sans-serif;
            margin: 0px 4px 0px 6px;
        }

        #clock {
            background: #${col.base01};
            color: #${col.base06};
            padding: 0px 10px;
            border-radius: 6px;
        }

        #custom-power {
            font-weight: bold;
            color: #${col.base06};
            background: #${col.base01};
            padding: 5px 10px;
            border-radius: 4px;
        }

        #battery,
        #cpu,
        #memory,
        #backlight,
        #network,
        #pulseaudio,
        #tray,
        #mode,
        #idle_inhibitor,
        #keyboard-state,
        #scratchpad {
            padding: 5px 8px;
            background-color: #${col.base01};
            color: #${col.base06};
        }

        #battery.charging{
             background-color: #${col.base0A};
        }

        #battery.critical:not(.charging) {
            background-color: #${col.base08};
            animation: blink 0.5s linear infinite alternate;
        }

        @keyframes blink {
            to {
                background-color: #${col.base06};
                color: #${col.base01};
            }
        }

        #network.disconnected {
            background-color: #${col.base08};
        }

        #pulseaudio.muted {
            background-color: #${col.base01};
            color: #${col.base0A};
        }

        #tray {
            border-radius: 6px;
            background-color: #${col.base02};
            color: #${col.base06};
        }

        #tray>.passive {
            -gtk-icon-effect: dim;
            color: #${col.base03};
        }

        #tray>.needs-attention {
            background-color: #${col.base02};
            color: #${col.base06};
        }

        #idle_inhibitor.activated {
            background-color: #${col.base0A}; 
            color: #${col.base01};
        }

        #workspaces button,
        #mode {
            padding: 5px 8px;
            background-color: transparent;
            color: #${col.base06};
        }

        #workspaces button:hover,
        #workspaces button.active {
            background-color: #${col.base0D};
            box-shadow: inset 0 -3px #${col.base06};
        }

        #workspaces button.urgent {
            background-color: #${col.base08};
        }

        label:focus {
            background-color: #000000;
        }
        '';
    };

}
