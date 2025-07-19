{ config, pkgs, user, lib, inputs, ... }:
let
  test = inputs.nix-colors.lib.conversions.hexToRGBString "," "0088ff";
in
{
  imports = [
    # ./../../modules/sway/default.nix
    ./../../modules/hyprland.nix
    ./../../modules/waybar/default.nix
    ./../../modules/helix/helix.nix
    ./../../modules/nu/default.nix
    ./../../modules/mpv/default.nix
    ./../../modules/tmux.nix
    ./../../modules/desktop_utils.nix
    ./../../modules/wofi.nix
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.onedark;
  # colorScheme = inputs.nix-colors.colorSchemes.dracula;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${user.userName}";
  home.homeDirectory = "/home/${user.userName}";

  # dont change
  home.stateVersion = "25.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    qbittorrent
    imagemagick
    unzip
    emacsGcc
    rust-analyzer
    sparrow
    surfraw
    wget
    btop
    xfce.thunar
    krusader
    wineWowPackages.waylandFull
    bottles
    doublecmd
  ];

  home.file = {
    "./.swaylock/config".source = ../../cfgs/swaylock/config;
    "./.swayidle/config".source = ../../cfgs/swayidle/config;
    ".doom.d/config.el".source = ../../cfgs/.doom.d/config.el;
    ".doom.d/packages.el".source = ../../cfgs/.doom.d/packages.el;
    ".doom.d/init.el".source = ../../cfgs/.doom.d/init.el ; 
  };

  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "brave";
    TERMINAL = "ghostty";
    TEST = "${test}";
  };
    
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
    };
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/8dc664291c0acdd539dd27715fac06b448431f2d.tar.gz";
      sha256 = "1gjxvikncxghkn9karfls74n12ag02n82d4c3mg9iwn396hvhcs5";
    }))
  ];

  
  programs = {

    
    chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      ];
      commandLineArgs = [
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
      ];
    };

    kitty.enable = true;
    
    tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };

    zathura = {
      enable = true;  
    };
    
    git = {
      enable = true;
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "${user.email}";
          name = "${user.userName}";
        };
      };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    ghostty = {
      enable = true; 
      settings = {
        command = "nu";
        # theme = "catppuccin-mocha";
        font-size = 14;
        keybind = [
          # "ctrl+h=goto_split:left"
          # "ctrl+l=goto_split:right"
        ];
      };
    };

    fd = {
      enable = true;
      hidden = false;
      ignores = [
        ".git/"
        "*.bak"  
      ];
    };

    ripgrep = {
      enable = true;
    };
  };
}
