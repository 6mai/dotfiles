{ lib, pkgs, config, user, ... }:
{
	home.packages = with pkgs; [
		# necessary
		hyprpolkitagent
		# wayland packages for basic effin qol
		grim
		slurp
		wl-clipboard
		swayidle
		swaylock-effects
		wev
		libnotify
	];

	xdg.portal.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	
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
		# swww.enable = true;
		mako = {
	    enable = true;
	    # settings = {
	    #   actions = true;
	    #   anchor = "top-right";
	    #   backgroundColor = "#282a36";
	    #   borderColor = "#bd93f9";
	    #   borderSize = 3;
	    #   defaultTimeout = 3000;
	    #   # font = "Mononoki Nerd Font Mono 10";
	    #   height = 150;
	    #   width = 300;
	    #   icons = true;
	    #   textColor = "#f8f8f2";
	    #   layer = "overlay";
	    #   sort = "-time";
	    #   "urgency=low" = {
	    #     border-color="#282a36";
	    #     };
	    #   "urgency=normal" = {
	    #     border-color="#bd93f9";
	    #     };
	    #   "urgency=high" = {
	    #     border-color="#ff5555";
	    #     default-timeout=0;
	    #     };
	    #   "category=mpd" = {
	    #     default-timeout=2000;
	    #     group-by="category";
	    #     };
	    #   };
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
}
