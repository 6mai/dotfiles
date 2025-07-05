{ config, pkgs, user, ... }:
{
  imports = [
    ./../../modules/sway/default.nix
    ./../../modules/waybar/default.nix
    ./../../modules/helix/helix.nix
    ./../../modules/nu/default.nix
    ./../../modules/mpv/default.nix
    ./../../modules/tmux.nix
  ];
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
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    "./.swaylock/config".source = ../../cfgs/swaylock/config;
    "./.swayidle/config".source = ../../cfgs/swayidle/config;
    ".doom.d/config.el".source = ../../cfgs/.doom.d/config.el;
    ".doom.d/packages.el".source = ../../cfgs/.doom.d/packages.el;
    ".doom.d/init.el".source = ../../cfgs/.doom.d/init.el ; 
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixOS/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "brave";
    TERMINAL = "ghostty";
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

    wofi = {
      enable = true;
      settings = {
        location = "bottom-right";
        allow_markup = true;
        width = 1250;
        always_parse_args = true;
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
