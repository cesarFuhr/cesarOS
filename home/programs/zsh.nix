{ ... }:

{
  # Zsh configuration.
  programs.zsh = {
    enable = true;

    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;

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

      ls = "exa";
      ll = "exa -l";
      la = "exa -la";
      lg = "exa -la --git";
      tree = "exa --tree";

      gits = "git status";
      gitc = "git commit -m";
      gitlog = "git log --oneline --graph -n 10";

      dotf = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
    };

    initExtra = ''
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
    '';
  };
}
