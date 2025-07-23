# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
let
  system = {
    arch = "x86-64_linux";
  };
  user = {
    nixConfName = "desktop"; # important for nu rebuild script; must be the same as the conf name in the flake 
    userName = "station";
    hostName = "nixos";
    email = "987654321mai6@gmail.com";
    homeDir = "/home/${user.userName}";
    dotfiles = "${user.homeDir}/dotfiles/";
  };
  hexToRgb = inputs.nix-colors.lib.conversions.hexToRGBString;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./../../modules/tor/default.nix
  ];

  virtualisation.docker = {
    enable = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.libva-intel-driver 
      pkgs.linux-firmware
    ];
  };

  # services.xserver.videoDrivers = ["nvidia"];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit user;
      inherit system;
      inherit hexToRgb;
    };
    users = {
      ${user.userName} = import ./home.nix;
    };
  };
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

   networking.hostName = "${user.hostName}"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
   time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
	# most strightforward way to launch sway
	services.greetd = {                                                      
	  enable = true;                                                         
	  settings = rec {                                                           
	    login = {                                                  
	      command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --user-menu --sessions ${pkgs.hyprland}/share/wayland-sessions --power-shutdown "systemctl shotdown" --power-reboot "systemctl reboot" --cmd ${pkgs.hyprland}/bin/hyprland;bash'';
	      user = "${user.userName}";                                                  
	    };                                                                   
      # initial_session = {
      #   command = "${pkgs.hyprland}/bin/hyprland;bash";
      #   # command = "${pkgs.sway}/bin/sway";
	     #  user = "${user.userName}";                                                  
      # };
      default_session = login;
	  };                                                                     
	};

  systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

  systemd = {
    tmpfiles.settings = {
      "files_home" = {
        "${user.homeDir}/files/" = { d = { mode = "0755"; user = "${user.userName}"; group = "${user.userName}"; }; };
        "${user.homeDir}/files/screencaps/" = { d = { mode = "0755"; user = "${user.userName}"; group = "${user.userName}"; }; };
        "${user.homeDir}/files/wallpapers/" = { d = { mode = "0755"; user = "${user.userName}"; group = "${user.userName}"; }; };
        "${user.homeDir}/files/webms/" = { d = { mode = "0755"; user = "${user.userName}"; group = "${user.userName}"; }; };
      };
      "local_bin" = {
        "${user.homeDir}/.local/bin/" = { d = { mode = "0755"; user = "${user.userName}"; group = "${user.userName}"; }; };
      };
    };
  };

  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY="wayland-1";
      DISPLAY = ":0";
    }; 
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  services.gnome.gnome-keyring.enable = true;
  # security.pam.services.swaylock = {}; # for swaylock 
  security.pam.services.hyprlock = {};
  security.polkit.enable = true; # for sway using home manager 
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.groups.${user.userName} = {};
  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.${user.userName} = {
     isNormalUser = true;
     extraGroups = [ "wheel" "seat" "libvirtd" "kvm" "docker" "${user.userName}" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       tree
     ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBy6dndQ0tozrcJYpYXNGFqd9BQHTtgnBaVdnX9PGoLn portable key" ];
   };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    openssl
    curl
    stdenv.cc.cc
    glibc
  ];

  environment.localBinInPath = true;
  environment.sessionVariables = rec {
    EDITOR = "hx";
    BROWSER = "brave";
    NIXOS_OZONE_WL = "1";
		GRIM_DEFAULT_DIR = "${user.homeDir}/files/screencaps";
    # WLR_NO_HARDWARE_CURSORS = "1";
  };

  # programs.firefox.enable = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.virtiofsd
  ];

  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # stylix = {
  #   enable = true;
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
  # };

  # dark mode by default part 1/2
  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  }];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      powerline-symbols
      font-awesome
      nerd-fonts.fira-code
      roboto
      # nerd-fonts."m+" # 200mb nip coding fonts
      nerd-fonts.symbols-only
      nerd-fonts.mononoki
      
      noto-fonts
      # nip font
      noto-fonts-cjk-sans
      dejavu_fonts
      ipafont
      kochi-substitute
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono" "IPAGothic" ];
        sansSerif = [ "DejaVu Sans" "IPAPGothic" ];
        serif = [ "DejaVu Serif" "IPAPMincho" ];
      };
    };
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

