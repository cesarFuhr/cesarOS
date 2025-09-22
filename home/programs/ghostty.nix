{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.ghostty ];

  home.file.".config/ghostty/config".text = ''
    command = ${pkgs.zsh}/bin/zsh

    window-decoration = false

    font-size = 15
    background = #262626
    cursor-style = underline

    keybind = ctrl+shift+k=toggle_window_decorations
  '';
}
