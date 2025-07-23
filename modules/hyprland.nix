{ config, pkgs, user, hexToRgb, ... }:
let
  future-cyan = pkgs.fetchFromGitLab {
    owner = "Pummelfisch";
    repo = "future-cyan-hyprcursor";
    hash = "sha256-Pi8+efEohVfH1iJ3oLcWLQuAOAZfR4iUOPmo4oyvrLE=";
    rev = "44282bb5fe218b14f44af42368ef3c9ad439d646";
  };
  # cursor = "rose-pine-hyprcursor";
  cursor = "future-cyan-hyprcursor";
in
{
  home.packages = with pkgs; [
    hyprsunset
    hyprsysteminfo
    hyprcursor
    rose-pine-hyprcursor
    nwg-displays
  ];
  
  # home.file.".local/share/icons/rose-pine-hyprcursor/".source = "${pkgs.rose-pine-hyprcursor}/share/icons/rose-pine-hyprcursor/hyprcursor/";
  home.file.".icons/future-cyan-hyprcursor".source = "${future-cyan}/Future-Cyan-Hyprcursor_Theme";
  # home.pointerCursor = {
  #   name = "rose-pine-hyprcursor";
  #   package = pkgs.rose-pine-hyprcursor;
  #   hyprcursor = {
  #     enable = true;
  #     size = 50;
  #   };
  # };

  services.kanshi = {
    enable = false;
    systemdTarget = "hyprland-session.target";
    profiles = {
      hdmi-only = {

        outputs = [
          {
            criteria = "Philips Consumer Electronics Company PHL 288E2 AU5203400317";
            status = "enable";
          }
          {
            criteria = "ViewSonic Corporation XG2401 SERIES 0x0101010";
            status = "disable";
          }
        ];
      };
      dual = {
        outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
          }
          {
            criteria = "DP-3";
            status = "enable";
          }
        ];
      };
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      label = [ 
          # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"'';
          color = "rgba(${hexToRgb "," config.colorScheme.palette.base06}, 0.70)";
          font_size = 130;
          font_family = "SF Pro Display Bold";
          position = "0, 140";
          halign = "center";
          valign = "center";
        }
          # Day-Month-Date
        {
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %d %B")"'';
          color = "rgba(${hexToRgb "," config.colorScheme.palette.base06}, 0.70)";
          font_size = "30";
          font_family = "SF Pro Display Bold";
          position = "0, 25";
          halign = "center";
          valign = "center";
        }
          # User
        {
          monitor = "";
          text = "$USER";
          color = "rgba(${hexToRgb "," config.colorScheme.palette.base06}, 0.70)";
          font_size = "25";
          font_family = "SF Pro Display Bold";
          position = "0, -60";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          size = "250, 60";
          position = "0, -130";
          monitor = "";
          dots_center = true;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          fade_on_empty = false;
          font_family = "SF Pro Display Bold";
          font_color = "rgba(${hexToRgb "," config.colorScheme.palette.base06}, 0.70)";
          inner_color = "rgba(${hexToRgb "," config.colorScheme.palette.base02}, 0.40)";
          outer_color = "rgb(${config.colorScheme.palette.base01})";
          outline_thickness = 2;
          placeholder_text = ''<span foreground="##${config.colorScheme.palette.base06}99">Enter Password</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };
  
  services.hypridle = {
    enable = true;
    settings = {
      general = {    
        after_sleep_cmd = "hyprctl dispatch dpms on";
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";         # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r";                 # monitor backlight restore.
        }
        { # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          timeout = 150;                                          # 2.5min.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1200;                                # 30min
          on-timeout = "systemctl suspend";                # suspend pc
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # nvidiaPatches = true;
    settings = {
      exec-once = [
        "waybar" 
        # "killall -q waybar;sleep .5 && waybar" 
        "systemctl --user start hyprpolkitagent"
        "[workspace 2 silent] ghostty -e 'nu -e tmux'"
        "[workspace 3 silent] brave"
        "kanshi"
      ];

      "$mod" = "SUPER";
      "$menu" = "wofi -S drun";
      "$terminal" = "ghostty";
      "$fileManager" = "thunar";

      layerrule = [
        "noanim,wofi"
      ];

      env = [
        "HYPRCURSOR_THEME,${cursor}"
        "HYPRCURSOR_SIZE,35"
      ];

      input = {
        repeat_delay = 300;
        sensitivity = -0.6;
      };

      cursor = {
        inactive_timeout = 30.0;
        # hide_on_touch = false;
        no_hardware_cursors = 1; # 1 disabled; 2 auto; this caused cursor disappearing
      };

      workspace = [
        "9, monitor:DP-3"
        "9, monitor:DP-1"
      ];

      general = {
        monitor = [
           "HDMI-A-1, preferred, 0x0, 1.25" 
           "DP-1, preferred, auto, 0" 
           "DP-3, preferred, auto, 0" 
        ];
        animation = [
          "workspaces, 0, 2, default, fade"
          "windows, 1, 8, default, gnomed"
        ];
        layout = "master";
        gaps_in = 6;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = true;
        # "col.active_border" = "rgba(50,200,255,0.9) rgba(0,255,150,0.9) 45deg";
        # "col.active_border" = "0xff0000ff";
        "col.active_border" = "rgba(${hexToRgb "," config.colorScheme.palette.base0C},0.8) rgba(${hexToRgb "," config.colorScheme.palette.base0D},0.8) 45deg";
        "col.inactive_border" = "rgba(${hexToRgb "," config.colorScheme.palette.base0C},0.2)";
      };

      misc = {
        force_default_wallpaper = 2;
        disable_splash_rendering = true;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      bind = [
        "$mod, Q, exec, kitty"
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, Q, killactive"
        "$mod, C, killactive"
        "$mod, F, fullscreen"
        "$mod, D, exec, $menu"
        "$mod, B, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod CONTROL, left, swapwindow, l"
        "$mod CONTROL, right, swapwindow, r"
        "$mod CONTROL, up, swapwindow, u"
        "$mod CONTROL, down, swapwindow, d"
        ", Print, exec,nu ${user.homeDir}/dotfiles/scripts/screenshot.nu"
        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

      bindl = [
        # Laptop multimedia keys for volume and LCD brightness
         ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
         ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
         ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
         ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
         ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
         ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };

    extraConfig = "
      
    ";
  };
}
