{ config, ... }:

{
  # Rofi configuration.
  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "window,drun,ssh";
      combi-modi = "window,drun";
    };

    theme = "./spotlight-dark.rasi";
  };
}


