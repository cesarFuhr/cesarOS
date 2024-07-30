{ config, pkgs, ... }:
let
  hdmiOut = "HDMI-A-1";
  edpOut = "eDP-1";
in
{
  programs.waybar.enable = true;

  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 26;
      output = [
        hdmiOut
        edpOut
      ];

      modules-left = [ "custom/logo" "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "sway/language" "clock" "battery" ];

      "custom/logo" = {
        format = "";
        tooltip = false;
        on-click = ''bemenu-run --accept-single  -n -p "Launch" --hp 4 --hf "#ffffff" --sf "#ffffff" --tf "#ffffff" '';
      };

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        persistent_workspaces = {
          "0" = [ hdmiOut ];
          "1" = [ hdmiOut ];
          "2" = [ hdmiOut ];
          "3" = [ hdmiOut ];
          "4" = [ hdmiOut ];
          "5" = [ edpOut ];
        };
        disable-click = false;
      };

      "sway/mode" = {
        tooltip = false;
      };

      "sway/language" = {
        format = "{shortDescription}";
        tooltip = false;
        on-click = ''swaymsg input "1:1:AT_Translated_Set_2_keyboard" xkb_switch_layout next'';
      };

      "clock" = {
        interval = 60;
        format = "{:%a %d/%m %I:%M}";
      };

      "battery" = {
        tooltip = false;
      };
    };
  };

  programs.waybar.style = ''
  
  * {
    border: none;
    border-radius: 0;
    padding: 0;
    margin: 0;
    font-size: 11px;
  }

  window#waybar {
    background: #292828;
    color: #ffffff;
  }
  
  #custom-logo {
    font-size: 18px;
    margin: 0;
    margin-left: 7px;
    margin-right: 12px;
    padding: 0;
    font-family: NotoSans Nerd Font Mono;
  }
  
  #workspaces button {
    margin-right: 10px;
    color: #ffffff;
  }
  #workspaces button:hover, #workspaces button:active {
    background-color: #292828;
    color: #ffffff;
  }
  #workspaces button.focused {
    background-color: #383737;
  }

  #language {
    margin-right: 7px;		
  }

  #battery {
    margin-left: 7px;
    margin-right: 3px;
  }
  '';
}
