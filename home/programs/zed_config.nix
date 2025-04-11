{ ... }:

{
  # The only reason Zed configuration is here is to sync between
  # machines.
  home.file.".config/zed/keymap.json".text = ''
    [
      {
        "context": "Workspace",
        "bindings": {
          // "shift shift": "file_finder::Toggle"
        }
      },
      {
        "context": "Editor",
        "bindings": {
          "ctrl-j": null,
          "ctrl-k": null
        }
      },
      {
        "context": "vim_mode == normal && !menu",
        "bindings": {
          "space w": "workspace::Save",
          "space space": "file_finder::Toggle",
          "space f f": "file_finder::Toggle",
          "space f g": "workspace::NewSearch",
          "g r": "editor::FindAllReferences"
        }
      },
      {
        "context": "vim_mode == insert",
        "bindings": {
          "ctrl-j": "editor::ContextMenuNext",
          "ctrl-k": "editor::ContextMenuPrevious"
        }
      }
    ]
  '';

  home.file.".config/zed/settings.json".text = ''
    {
      "vim_mode": true,
      "theme": "One Dark",
      "ui_font_size": 20,
      "buffer_font_size": 18,
      "format_on_save": "on",
      "relative_line_numbers": true
    } 
  '';
}
