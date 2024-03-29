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
  home.file.".config/rofi/theme.rasi".text = ''
    /******************************************************************************
     * ROFI SQUARED THEME USING THE NORD PALETTE 
     * User                 : LR-Tech               
     * Theme Repo           : https://github.com/lr-tech/rofi-themes-collection
     *******************************************************************************/

    * {
        font:   "Fira Code Nerd Font Mono 12";

        bg0:     #2E3440;
        bg1:     #3B4252;
        fg0:     #D8DEE9;

        accent-color:     #4698AF;
        urgent-color:     #EBCB8B;

        background-color:   transparent;
        text-color:         @fg0;

        margin:     0;
        padding:    0;
        spacing:    0;
    }

    window {
        location:   center;
        width:      800;
        y-offset:   0;

        background-color:   @bg0;
    }

    inputbar {
        spacing:    8px; 
        padding:    8px;

        background-color:   @bg1;
    }

    prompt, entry, element-icon, element-text {
        vertical-align: 0.5;
    }

    prompt {
        text-color: @accent-color;
    }

    textbox {
        padding:            8px;
        background-color:   @bg1;
    }

    listview {
        padding:    4px 0;
        lines:      8;
        columns:    1;

        fixed-height:   false;
    }

    element {
        padding:    8px;
        spacing:    8px;
    }

    element normal normal {
        text-color: @fg0;
    }

    element normal urgent {
        text-color: @urgent-color;
    }

    element normal active {
        text-color: @accent-color;
    }

    element selected {
        text-color: @bg0;
    }

    element selected normal, element selected active {
        background-color:   @accent-color;
    }

    element selected urgent {
        background-color:   @urgent-color;
    }

    element-icon {
        size:   0.8em;
    }

    element-text {
        text-color: inherit;
    }'';
}
