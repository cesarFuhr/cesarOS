{ ... }:

{
  # Zsh configuration.
  programs.zsh = {
    enable = true;

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
      ];
    };

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      e = "$EDITOR";

      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lg = "eza -la --git";
      tree = "eza --tree";

      gits = "git status";
      gitc = "git commit -m";
      gitlog = "git log --oneline --graph -n 10";

      renv = "nix develop --profile /tmp/\${\${PWD//\\//:}:1} --command zsh";
      renvimpure = "NIXPKGS_ALLOW_UNFREE=1 nix develop --impure --profile /tmp/\${\${PWD//\\//:}:1} --command zsh";
      senv = "nix develop /tmp/\${\${PWD//\\//:}:1} --command zsh";
      envup = "if [[ -e /tmp/\${\${PWD//\\//:}:1} ]]; then senv; else if [[ flake_is_proprietary ]]; then renvimpure; else renv; fi; fi";
      envclean = "[[ -e /tmp/\${\${PWD//\\//:}:1} ]] && rm /tmp/\${\${PWD//\\//:}:1}*";

      # Notes/Todo system
      na = "notes .";
      nn = "notes 0-Inbox";
      td = "todo .";

      # Tmux sessions
      tflakesession = "start_tmux_flake_session";
      tsession = "start_tmux_session";

    };

    initContent = ''
      export PROMPT='%(!.%{$fg[red]%}.%{$fg[cyan]%})λ %(!.%{$fg[red]%}.%{$fg[green]%})%2c$(git_prompt_info)%{$reset_color%} '

      export ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}("
      export ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
      export ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}•"
      export ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}•"
      export PATH=$PATH:$(go env GOPATH)/bin

      # SyntaxHighlighting
      typeset -A ZSH_HIGHLIGHT_STYLES

      ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
      ZSH_HIGHLIGHT_STYLES[command]='fg=blue'
      ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
      ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

      # zoxide
      eval "$(zoxide init zsh)"

      # Accept autosuggestions with Ctrl+;
      bindkey '^ ' autosuggest-accept

      flake_is_proprietary() {
        # Check unfree flag
        local unfree=$(nix eval "nixpkgs#$.meta.unfree" 2>/dev/null)
        if [[ "$unfree" == "true" ]]; then
            return 1  # Is proprietary
        fi
        
        # Check if license is marked as free
        local free=$(nix eval "nixpkgs#.meta.license.free" 2>/dev/null)
        if [[ "$free" == "false" ]]; then
            return 1  # Is proprietary
        fi
        
        return 0  # Is free/open source
      }

      start_tmux_flake_session() {
        if [ -n "$1" ]; then
          SESSION="$1"
        else
          SESSION=$(basename "$PWD")
        fi

        WORK_DIR="$PWD"

        # Check if session already exists
        tmux has-session -t "$SESSION" 2>/dev/null

        if [ $? != 0 ]; then
          # Create session with first window, set working directory
          tmux new-session -d -s "$SESSION" -n editor -c "$WORK_DIR"
          tmux send-keys -t "$SESSION:0" 'envup' C-m
          
          # Create second window with same working directory
          tmux new-window -t "$SESSION" -n term -c "$WORK_DIR"
          tmux send-keys -t "$SESSION:1" 'envup' C-m
          
          # Select the first window
          tmux select-window -t "$SESSION:0"
        fi

        # Attach to the session
        tmux attach-session -t "$SESSION"
      }

      start_tmux_session() {
        if [ -n "$1" ]; then
          SESSION="$1"
        else
          SESSION=$(basename "$PWD")
        fi

        WORK_DIR="$PWD"

        # Check if session already exists
        tmux has-session -t "$SESSION" 2>/dev/null

        if [ $? != 0 ]; then
          # Create session with first window, set working directory
          tmux new-session -d -s "$SESSION" -c "$WORK_DIR"
          
          # Create second window with same working directory
          tmux new-window -t "$SESSION:1" -c "$WORK_DIR"
          
          # Select the first window
          tmux select-window -t "$SESSION:0"
        fi

        # Attach to the session
        tmux attach-session -t "$SESSION"
      }
    '';
  };
}
