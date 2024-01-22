{ config, ... }:

{
  xsession.windowManager.awesome = {
    enable = true;
  };

  home.file.".config/awesome/rc.lua".source = ./rc.lua;
  home.file.".config/awesome/lain".source = ./lain;
}

