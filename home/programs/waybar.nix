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
      modules-right = [
        "tray"
        "custom/sep"
        "cpu"
        "custom/sep"
        "memory"
        "custom/sep"
        "disk"
        "custom/sep"
        "network"
        "custom/sep"
        "pulseaudio"
        "custom/sep"
        "sway/language"
        "custom/sep"
        "clock"
        "battery"
      ];

      pulseaudio = {
        format = "V {volume}%";
        format-muted = "V Mute";
      };

      network = {
        format = "{ifname} ↑{bandwidthUpBytes} ↓{bandwidthDownBytes}";
        interval = 30;
      };

      tray = {
        icon-size = 21;
        spacing = 10;
        passive = true;
      };

      "cpu" = {
        format = "CPU {usage}%";
      };

      "memory" = {
        format = "MEM {percentage}%";
      };

      "disk" = {
        format = "FS {percentage_used}%";
      };

      "custom/sep" = {
        format = " | ";
        tooltip = false;
      };

      "custom/logo" = {
        format = "";
        tooltip = false;
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
        format = "  {shortDescription}";
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
    font-size: 13px;
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
