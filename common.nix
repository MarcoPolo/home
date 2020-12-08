{ pkgs, config, lib, ... }:
let
  nixCfg =
    if (builtins.pathExists ./config.nix) then import ./config.nix else { };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # cacert needed so that nix can talk to the cache server
  home.packages = with pkgs; [ cacert ];
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = { EDITOR = "nvim"; };

  home.file =
    if pkgs.stdenv.hostPlatform.isDarwin then {
      nix-conf = {
        source = ./mac-nix.conf;
        target = ".config/nix/nix.conf";
      };
      config = {
        source = ./mac-nixconfig.nix;
        target = ".config/nixpkgs/config.nix";
      };
    } else
      { };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.direnv.enableNixDirenvIntegration = true;

  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "viins";
    initExtra = ''
      # Any extra work stuff
      ${if builtins.hasAttr "extraWorkZsh" nixCfg then
        nixCfg.extraWorkZsh
      else
        ""}

      # Edit command in vim
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd v edit-command-line

      # Setup nix
      if [[ "$OSTYPE" == "darwin"* ]]; then
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      fi

      # Better command not found
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

      # Radicle
      export PATH="$HOME/.radicle/bin:$PATH"
    '';
    shellAliases = { vim = "nvim"; };
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
      {
        name = "async";
        src = pkgs.fetchFromGitHub {
          owner = "mafredri";
          repo = "zsh-async";
          rev = "v1.8.0";
          sha256 = "02p4ll1f3sibjxbywx3a7ql758ih27vd9sx4nl9j0i64hwkdqfrb";
        };
      }
      {
        name = "history";
        file = "lib/history.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "ohmyzsh";
          repo = "ohmyzsh";
          rev = "b721053c87b4662c65452117a8db35af0154a29d";
          sha256 =
            "sha256:02y6mhvsxamsvfx2bcdrfbbl7g8v1cq8qycjbffn4w3d6aprq5c6";
        };
      }
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.12.0";
          sha256 = "1h04z7rxmca75sxdfjgmiyf1b5z2byfn6k4srls211l0wnva2r5y";
        };
      }
    ];
  };

  programs.neovim = {
    enable = true;
    configure = {
      customRC = ''
        let mapleader = ","
        colorscheme seoul256
        nnoremap <F6> :w<CR>
        nnoremap <F7> :Commentary<CR>
        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        nmap <leader>rn <Plug>(coc-rename)
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        # loaded on launch
        start = [
          vim-plug
          coc-nvim
          # coc-rust-analyzer
          # coc-rename
          # coc-tsserver
          # coc-json
          # coc-pairs
          fugitive
          vim-easymotion
          vim-commentary
          delimitMate
          vim-gitgutter
          vim-nix
          ale
          # ctrlp-smarttabs
          # vim-misc
          # vim-notes

          sky-color-clock-vim

          lightline-vim
          seoul256-vim
          ctrlp-vim
          vim-surround
          vim-eunuch
          vim-fugitive
          vim-abolish
          vim-repeat
          # nerdcommenter
          # Rust
          rust-vim

          # "Plug lambdalisue/suda.vim

        ];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [ ];
      };
    };

  };
}
