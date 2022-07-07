{ config, ... }:

{
  # Rofi configuration.
  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "window,drun,ssh";
      combi-modi = "window,drun";

      show-icons = true;
      icon-theme = "papirus";

      window-format = "● {c}    {t}";
      combi-display-format = "  {text}";
      display-combi = "";

      drun-display-format = "{name}";
    };

    theme = "./theme.rasi";
  };

  # Load the theme in the config folder.
  xdg.configFile."rofi/theme.rasi".source = ./theme.rasi;
}
