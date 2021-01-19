{ pkgs, config, lib, ... }:
let
  extraZsh = ''
    source ~/.bash_profile
    source ~/.bashrc
    export GOPRIVATE=git.corp.stripe.com
  '';
in
{
  imports = [ ./git-aliases.nix (import ./common.nix { extraZsh = extraZsh; }) ./darwin-common.nix ];
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
  home.packages = with pkgs; [ nix-index htop cacert nixFlakes nixpkgs-fmt ];
}
