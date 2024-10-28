{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };

        size = lib.mkDefault 10;
      };

      colors = {
        primary = {
          foreground = "#e7edf7";
          background = "#262626";
        };
        normal = {
          black = "#282c34";
          red = "#e06c75";
          green = "#84D649";
          yellow = "#e5c07b";
          blue = "#61afef";
          magenta = "#be5046";
          cyan = "#56b6c2";
          white = "#979eab";
        };
      };

      cursor = {
        style = {
          shape = "Underline";
          blinking = "On";
        };
      };
    };
  };
}
