{ config, ... }:

{
  # Neomutt, yep I am trying it.
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    checkStatsInterval = 60;
    sidebar = {
      enable = true;
      width = 30;
    };
    settings = {
      mark_old = "no";
      text_flowed = "yes";
      reverse_name = "yes";
    };

    binds = [ ];
    macros = [ ];
  };

  accounts.email.accounts.cesar = {
    primary = true;
    address = "cesar.fuhr.cara@gmail.com";
    flavor = "gmail.com";
    realName = "César Cará";

    gpg = {
      key = "/home/cesar/.gnupg/pubring.kbx";
      signByDefault = true;
    };

    neomutt = {
      enable = true;
      mailboxType = "IMAP";
      extraMailboxes = [ ];
    };

    notmuch = {
      enable = true;
      neomutt.enable = true;
    };

    #imap = {
    #  host = "imap.gmail.com";
    #  port = 993;
    #};
  };
}
