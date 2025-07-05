{ lib, pkgs, config, user, ... }:
let
		file-manager = "${pkgs.xfce.thunar}/bin/thunar";
		web-browser = "${pkgs.brave}/bin/brave";
in
{
	home.packages = with pkgs; [
		# wayland packages for basic effin qol
		grim
		slurp
		wl-clipboard
		swayidle
		swaylock-effects
		wev
		libnotify
	];

	programs = {
		wlogout = {
			enable = true;
			layout = [
				{
					label = "lock";
					action = "swaylock";
					text = "Lock";
					keybind = "l";
				}
				{
				    label = "hibernate";
				    action = "systemctl hibernate";
				    text = "Hibernate";
				    keybind = "h";
				}
				{
				    label = "logout";
				    action = "loginctl terminate-user ${user.userName}";
				    text = "Logout";
				    keybind = "e";
				}
				{
				    label = "shutdown";
				    action = "systemctl poweroff";
				    text = "Shutdown";
				    keybind = "s";
				}
				{
				    label = "suspend";
				    action = "systemctl suspend";
				    text = "Suspend";
				    keybind = "u";
				}
				{
				    label = "reboot";
				    action = "systemctl reboot";
				    text = "Reboot";
				    keybind = "r";
				}
			];
		};
	};
		
  services = {
		swww.enable = true;
		mako = {
	    enable = true;
	    settings = {
	      actions = true;
	      anchor = "top-right";
	      backgroundColor = "#282a36";
	      borderColor = "#bd93f9";
	      borderSize = 3;
	      defaultTimeout = 3000;
	      # font = "Mononoki Nerd Font Mono 10";
	      height = 150;
	      width = 300;
	      icons = true;
	      textColor = "#f8f8f2";
	      layer = "overlay";
	      sort = "-time";
	      "urgency=low" = {
	        border-color="#282a36";
	        };
	      "urgency=normal" = {
	        border-color="#bd93f9";
	        };
	      "urgency=high" = {
	        border-color="#ff5555";
	        default-timeout=0;
	        };
	      "category=mpd" = {
	        default-timeout=2000;
	        group-by="category";
	        };
	      };
		};

		gammastep = {
	    enable = true;
	    provider = "manual";
	    dawnTime = "6:00-7:45";
	    duskTime = "18:35-20:15";
	    tray = true;
	    settings = {
	      general = {
	        adjustment-method = "wayland";
	        gamma = 0.8;
	      };
	    };
	  };
	};

	wayland.windowManager.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
		xwayland = true;
		config = rec {
			modifier = "Mod4";
			terminal = "${pkgs.ghostty}/bin/ghostty";
			menu = "${pkgs.wofi}/bin/wofi --show run";
			
			bars = [
				{ command = "${pkgs.waybar}/bin/waybar"; }
			];

			keybindings = lib.mkOptionDefault(
				(lib.attrsets.mergeAttrsList [
					(lib.optionalAttrs true {
						"${modifier}+y" = "exec ${web-browser}";
						"${modifier}+e" = "exec ${file-manager}";
						"${modifier}+j" = "exec wlogout";
						"Print" = "exec nu /home/${user.userName}/dotfiles/scripts/screenshot.nu";
						"${modifier}+o" = "exec 'nu /home/${user.userName}/dotfiles/scripts/script_launcher.nu'";

						"${modifier}+t" = "layout toggle tabbed split";
						"${modifier}+s" = "layout toggle split stacking";
						"${modifier}+v" = "layout toggle splitv splith";
						"${modifier}+w" = "split toggle";
						"Alt+Shift+grave" = "set $$workroom 0; workspace $$workroom$$workspace";
						"Alt+Shift+1" = "set $$workroom 1; workspace $$workroom$$workspace";
						"Alt+Shift+2" = "set $$workroom 2; workspace $$workroom$$workspace";
						"Alt+Shift+3" = "set $$workroom 3; workspace $$workroom$$workspace";
						"Alt+Shift+4" = "set $$workroom 4; workspace $$workroom$$workspace";
						"Alt+Shift+5" = "set $$workroom 5; workspace $$workroom$$workspace";

			      # Media buttons
			      "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
			      "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
			      "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
						"XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
 
						# Navigate
						"${modifier}+grave" = "workspace $$workroom$ws0; set $$workspace $ws0";
						"${modifier}+1" = "workspace $$workroom$ws1; set $$workspace $ws1";
						"${modifier}+2" = "workspace $$workroom$ws2; set $$workspace $ws2";
						"${modifier}+3" = "workspace $$workroom$ws3; set $$workspace $ws3";
						"${modifier}+4" = "workspace $$workroom$ws4; set $$workspace $ws4";
						"${modifier}+5" = "workspace $$workroom$ws5; set $$workspace $ws5";
						"${modifier}+6" = "workspace $$workroom$ws6; set $$workspace $ws6";
						"${modifier}+7" = "workspace $$workroom$ws7; set $$workspace $ws7";
						"${modifier}+8" = "workspace $$workroom$ws8; set $$workspace $ws8";
						"${modifier}+9" = "workspace $$workroom$ws9; set $$workspace $ws9";

						# move container
						"${modifier}+Shift+grave" = "move container to workspace $$workroom$ws0";
						"${modifier}+Shift+1" = "move container to workspace $$workroom$ws1";
						"${modifier}+Shift+2" = "move container to workspace $$workroom$ws2";
						"${modifier}+Shift+3" = "move container to workspace $$workroom$ws3";
						"${modifier}+Shift+4" = "move container to workspace $$workroom$ws4";
						"${modifier}+Shift+5" = "move container to workspace $$workroom$ws5";
						"${modifier}+Shift+6" = "move container to workspace $$workroom$ws6";
						"${modifier}+Shift+7" = "move container to workspace $$workroom$ws7";
						"${modifier}+Shift+8" = "move container to workspace $$workroom$ws8";
						"${modifier}+Shift+9" = "move container to workspace $$workroom$ws9";
					})
				])
			);

			startup = [
				{ command = ''swaymsg "workspace 01; exec ghostty -e tmux"''; }
				{ command = ''swaymsg "workspace 02; exec ghostty"''; }
				{ command = ''swaymsg "workspace 04; exec ${pkgs.xfce.thunar}/bin/thunar"''; }
				{ command = ''swaymsg "workspace 03; exec brave"''; }
				# { command = ''swaymsg "exec sleep workspace 1;"''; }
			
        {
          command = ''swayidle'';
          always = false;
        }
				{
					command = ''nu /home/${user.userName}/dotfiles/scripts/wallpaper.nu random /home/${user.userName}/files/wallpapers/'';
				}
			];
		};


		extraConfig = ''
			# give Sway a little time to startup before starting kanshi.
			exec sleep 5; exec systemctl --user start kanshi.service
set $mod Mod4
			# Workspaces:
set $ws0 0
set $ws1 1
set $ws2 2
set $ws3 3
set $ws4 4
set $ws5 5
set $ws6 6
set $ws7 7
set $ws8 8
set $ws9 9

# Workrooms:
set $workroom 0
set $workspace 1

		'';
	};
}
