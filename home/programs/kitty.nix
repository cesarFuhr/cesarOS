{ config, ... }:

{
  # Kitty terminal configuration.
  programs.kitty = {
    enable = true;

    font = {
      name = "Mononoki Nerd Font Mono";
      size = 15;
    };

    keybindings = {
      "kitty_mod+n" = "new_os_window_with_cwd";
      "cmd+n" = "new_os_window";
    };

    settings = {
      enable_audio_bell = "no";
    };

    extraConfig = ''
      include ./themes/CesarDark.conf
    '';
  };

  xdg.configFile."kitty/themes/CesarDark.conf".text = ''
    # CesarTheme
    # Slightly modded OneDark

    foreground #e7edf7
    background #202020
    cursor #cccccc
    color0 #282c34
    color1 #e06c75
    color2 #84D649
    color3 #e5c07b
    color4 #61afef
    color5 #be5046
    color6 #56b6c2
    color7 #979eab
    color8 #393e48
    color9 #d19a66
    color10 #56b6c2
    color11 #e5c07b
    color12 #61afef
    color13 #be5046
    color14 #56b6c2
    color15 #abb2bf
    selection_foreground #282c34
    selection_background #979eab
  '';
}
