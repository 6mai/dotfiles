{ config, pkgs, user, ... }:
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

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # nvidiaPatches = true;
    settings = {
      exec-once = [
        "killall -q waybar;sleep .5 && waybar" 
        "systemctl --user start hyprpolkitagent"
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
      };

      cursor = {
        inactive_timeout = 30.0;
        # hide_on_touch = false;
        no_hardware_cursors = 1; # 1 disabled; 2 auto; this caused cursor disappearing
      };

      general = {
        layout = "master";
        gaps_in = 6;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = true;
        # "col.active_border" = "rgba(50,200,255,0.9) rgba(0,255,150,0.9) 45deg";
        # "col.active_border" = "0xff0000ff";
        "col.active_border" = "rgba(10,0,255,0.8) rgba(10,50,255,0.8) 45deg";
        "col.inactive_border" = "rgba(10,0,255,0.2)";
      };

      misc = {
        force_default_wallpaper = 2;
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
        ", Print, exec, nu ${user.homeDir}/dotfiles/scripts/screenshot.nu"
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
