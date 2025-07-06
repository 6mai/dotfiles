
{ lib, pkgs, config, user, ... }:

{

  programs.mpv = {
    enable = true;
    package = pkgs.mpv-unwrapped.wrapper {
      mpv = pkgs.mpv-unwrapped.override {
        ffmpeg = pkgs.ffmpeg-full;

      #   libplacebo = pkgs.libplacebo.overrideAttrs (oldAttrs: rec {
      #     version = "7.349.0";

      #     src = pkgs.fetchFromGitLab {
      #       domain = "code.videolan.org";
      #       owner = "videolan";
      #       repo = "libplacebo";
      #       tag = "v${version}";
      #       hash = "sha256-mIjQvc7SRjE1Orb2BkHK+K1TcRQvzj2oUOCUT4DzIuA=";
      #     };
      #   });
        };

      scripts = with pkgs.mpvScripts; [
        mpris
        uosc
        thumbfast
        mpv-subtitle-lines
        autoload
        mpv-webm
        manga-reader
      ];
    };

	  config = {
      sub-visibility = false;
      sub-auto = "fuzzy";
      alang = "jpn,jp,en";
      slang = "jpn,jp,en";
      audio-file-auto = "fuzzy";
      save-position-on-quit = true;
      autofit-larger = "100%x100%";
      geometry = "50%:50%";
      screenshot-template = "%f %p";
      # hwdec = "auto-safe";
      # vo = "gpu";
      gpu-context = "wayland";
    };

    bindings = {
      "WHEEL_UP" = "add volume 2";
      "WHEEL_DOWN" = "add volume -2";
      "Ctrl+f" = "script-binding subtitle_lines/list_subtitles";
      "Ctrl+F" = "script-binding subtitle_lines/list_secondary_subtitles";
    };
    # https://github.com/donovanglover/nix-config/blob/master/home/mpv.nix
  };

  xdg.configFile = {
  
    "mpv/script-opts/webm.conf".text = ''
      # default config
      # https://github.com/ekisu/mpv-webm/releases/download/latest/webm.conf
      keybind=W
      output_directory=${user.homeDir}/files/webms/
      run_detached=no
      output_template=%F-[%s-%e]%M
      scale_height=720
      fps=-1
      target_filesize=4000
      strict_filesize_constraint=no
      strict_bitrate_multiplier=0.95
      strict_audio_bitrate=64
      output_format=webm-vp8
      twopass=yes
      apply_current_filters=yes
      write_filename_on_metadata=no
      threads=4
      crf=10
      display_progress=auto
      font_size=28
      margin=10
      message_duration=5
      gif_dither=2
      force_square_pixels=no
    '';
  };
}
