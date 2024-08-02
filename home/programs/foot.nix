{ config, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=15";
      };

      cursor = {
        style = "underline";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
