{ config, pkgs, ... }:

let
  rofi = import ./programs/rofi.nix;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cesar";
  home.homeDirectory = "/home/cesar";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Session Env Vars
  home.sessionVariables.FZF_DEFAULT_COMMAND = "rg --files -uu -g '!.git'";

  # Golang setup
  programs.go = {
    enable = true;
    goBin = "go/bin";
    goPath = "go";
  };

  # Rofi
  programs.rofi = rofi;

  # Zsh
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

      # SyntaxHighlighting
      typeset -A ZSH_HIGHLIGHT_STYLES

      ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
      ZSH_HIGHLIGHT_STYLES[command]='fg=blue'
      ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
      ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
    '';
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}

