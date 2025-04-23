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
      nvimconfig = "nvim -c ':cd ~/.config/nvim'";

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

      renv = "nix develop --profile /tmp/\${\${PWD//\\//:}:1} --command $SHELL";
      renvimpure = "nix develop --impure --profile /tmp/\${\${PWD//\\//:}:1} --command zsh";
      senv = "nix develop /tmp/\${\${PWD//\\//:}:1} --command zsh";

      # Notes/Todo system
      na = "notes .";
      nn = "notes 0-Inbox";
      td = "todo .";
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

      # vi mode
      set -o vi

      # Accept autosuggestions with Ctrl+;
      bindkey '^ ' autosuggest-accept
    '';
  };
}
