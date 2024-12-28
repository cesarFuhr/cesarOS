{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ inputs.ghostty.packages.${pkgs.system}.default ];

  home.file.".config/ghostty/config".text = ''
    command = ${pkgs.zsh}/bin/zsh

    window-decoration = false

    font-size = 15
    background = #262626
    cursor-style = underline
  '';
}
