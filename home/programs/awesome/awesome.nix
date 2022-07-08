{ config, ... }:

{
  xsession.windowManager.awesome = {
    enable = true;
  };

  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
}

