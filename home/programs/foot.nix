{ config, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      font = "JetBrainsMono Nerd Font Mono:size=15";
    };
  };
}
