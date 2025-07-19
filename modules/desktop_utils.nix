{ lib, pkgs, config, user, hexToRgb, ... }:
let
    col = config.colorScheme.palette;
in
{
	home.packages = with pkgs; [
		# necessary
		hyprpolkitagent
		# wayland packages for basic effin qol
		grim
		slurp
		wl-clipboard
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
					action = "loginctl lock-session";
					text = "Lock";
					keybind = "l";
				}
				{
				    label = "hibernate";
				    action = "loginctl lock-session && systemctl hibernate";
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
				    action = "loginctl lock-session && systemctl suspend";
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

			style = ''
			
				* {
				  font-family: "Fira Sans Semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
					background-image: none;
					transition: 20ms;
					box-shadow: none;
				}

			  window {
			    background: rgba(${hexToRgb "," col.base02}, 0.8);
			  }
  
			  button {
					margin: 6px;
	        border-color: rgba(${hexToRgb "," col.base0C},0.2);
	        text-decoration-color: #${col.base00};
					font-size: 20px;
	        color: #${col.base06};
	        background-color: #${col.base01};
	        border-style: solid;
	        border-width: 2px;
					border-radius: 22px;
	        background-repeat: no-repeat;
	        background-position: center;
	        background-size: 25%;
			  }

				button:focus, button:active, button:hover {
					outline-style: none;
					border-color: rgba(${hexToRgb "," col.base0C},0.8);
					background-color: #${col.base01};
				}
				
				#lock {
					background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
				 }
				
				#logout {
					background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
				 }
				
				#suspend {
					background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
				 }
				
				#hibernate {
					background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
				 }
				
				#shutdown {
					background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
				 }
				
				#reboot {
					background-image: url("${pkgs.wlogout}/share/wlogout/icons/reboot.png");
				 }
			'';
		};
	};
		
  services = {
		# swww.enable = true;
		mako = {
	    enable = true;
	    settings = {
	      actions = true;
	      anchor = "top-right";
	      background-color = "#${col.base01}";
	      border-color = "#${col.base0C}";
	      border-size = 3;
	      border-radius = 12;
	      default-timeout = 5000;
	      font = "Mononoki Nerd Font Mono 10";
	      height = 150;
	      width = 300;
	      icons = true;
	      text-color = "#${col.base06}";
	      layer = "overlay";
	      sort = "-time";
	      "urgency=low" = {
	        border-color="#${col.base05}";
	        };
	      "urgency=normal" = {
	        border-color="#${col.base0C}";
	        };
	      "urgency=high" = {
	        border-color="#${col.base08}";
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
}
