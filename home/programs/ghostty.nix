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
    cursor-style=underline
    font-size=15

    background=#262626
    window-decoration=false
  '';
}
