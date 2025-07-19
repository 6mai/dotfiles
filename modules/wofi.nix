# cibbed from https://github.com/maxhu08/dotfiles/tree/master/wofi/.config/wofi

{ lib, pkgs, config, user, inputs, ... }:
let
    col = config.colorScheme.palette;
in
{
  programs.wofi = {
    enable = true;
    settings = {
      location = "center";
      normal_window = true;
      insensiteve = true;
      allow_markup = true;
      allow_images = true;
      image_size = 32;
      halign = "fill";
      content_halign = "fill";
      gtk-dark = true;
      prompt = "Search...";
      width = "40%";
      height = "50%";
      always_parse_args = true;
    };

    style = ''
      window {
        /* background-color: #171717; */
        background: #${col.base01};
      }

      * {
        font-family: "Jetbrains Mono";
        color: #${col.base06};
      }

      #scroll {
        padding: 0.5rem;
      }

      #input {
        /* background-color: #262626; */
        background-color: #${col.base02};
        outline: none;
        box-shadow: none;
        border: 0;
        border-radius: 0;
        font-size: 1rem;
        padding-left: 1rem;
        padding-right: 1rem;
        padding-top: 0.5rem;
        padding-bottom: 0.5rem;
      }

      #inner-box {
        margin: 0.5rem;
        font-size: 1rem;
      }

      #img {
        margin: 10px 10px;
      }

      #entry {
        border-radius: 0.5rem;
      }

      #entry:selected {
        background-color: #${col.base0C};
        outline: none;
      }
    '';
  };
}
