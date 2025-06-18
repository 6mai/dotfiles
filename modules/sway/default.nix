{ lib, pkgs, config, user, ... }:
let
		file-manager = "${pkgs.xfce.thunar}/bin/thunar";
		web-browser = "${pkgs.brave}/bin/brave";
	  start-sway = pkgs.writeShellScriptBin "start-sway" /* sh */
	    ''
	      export WLR_DRM_NO_MODIFIERS=1
	      dbus-launch --sh-syntax --exit-with-session ${pkgs.sway}/bin/sway	    '';
in
{
	home.packages = with pkgs; [
		# wayland packages for basic effin qol
		start-sway
		grim
		slurp
		wl-clipboard
		swayidle
		swaylock-effects
		wev
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
		mako.enable = true;

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
						"Print" = "exec nu home/${user.userName}/dotfiles/scripts/screenshot.nu";
						"${modifier}+o" = "exec nu home/${user.userName}/dotfiles/scripts/script_launcher.nu";

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
					command = ''nu home/${user.userName}/dotfiles/scripts/wallpaper.nu random home/${user.userName}/files/wallpapers/'';
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
