{ ... }: {
  imports = [ ./git-aliases.nix ];

  programs.git = {
    userName = "Marco Munizaga";
    userEmail = "git@marcopolo.io";
  };

}
