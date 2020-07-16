{ config, pkgs, lib, ... }:
let
  secretsPath =
    /Volumes/Keybase/private/marcopolo/home-manager-secrets/secrets.nix;
  certPath =
    "/Volumes/Keybase/private/marcopolo/home-manager-secrets/protonmail-bridge.pem";
  nixCfg = import ./config.nix;
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
  home.packages = with pkgs; [ zola lorri ];
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = { EDITOR = "nvim"; };

  home.file = if pkgs.stdenv.hostPlatform.isDarwin then {
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

  programs.git = {
    enable = true;
    userName = "Marco Munizaga";
    userEmail = "git@marcopolo.io";
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      type = "cat-file -t";
      dump = "cat-file -p";
      lg =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      lga =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      lgd =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -p";
      df = "diff --color --color-words --abbrev";
      d = "difftool";
      up = "!git remote update -p; git merge --ff-only @{u}";
    };

    extraConfig = {
      merge = { conflictstyle = "diff3"; };
      push = { default = "current"; };
      color = {
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = "auto";
      };
    };
  };

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


      bindkey '^R' history-incremental-search-backward

      # Setup nix
      ${if builtins.currentSystem == "x86_64-darwin" then ''
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      '' else
        ""}

      # Better command not found
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
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

  # On one hand it would be nice to have these managed by nix/hm. But on the
  # other, letting vs code manage it's own config is very useful! I got stuff to do
  home.activation = if (builtins.currentSystem == "x86_64-darwin") then {
    linkVSCodeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ln -s $VERBOSE_ARG \
          ${
            builtins.toPath ./vscode/settings/settings.json
          } "$HOME/Library/Application Support/Code/User/settings.json" || true
    '';
    linkVSCodeKeyBindings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ln -s $VERBOSE_ARG \
          ${
            builtins.toPath ./vscode/settings/keybindings.json
          } "$HOME/Library/Application Support/Code/User/keybindings.json" || true
    '';
    # Really slow
    # installVSCodeExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #   $DRY_RUN_CMD cat \
    #       ${
    #         builtins.toPath ./vscode/extensions.meta
    #       } | xargs -I{} code --install-extension {}
    # '';
  } else
    { };

  # programs.neomutt = {
  #   enable = true;
  #   vimKeys = true;
  #   editor = "nvim";
  #   sidebar = { enable = true; };
  # };
  # programs.mbsync.enable = true;

  # accounts.email.maildirBasePath = "Mail";
  # accounts.email.certificatesFile = certPath;

  # accounts.email.accounts.marcopolo = if (builtins.pathExists secretsPath) then
  #   (import secretsPath).accounts.email.accounts.marcopolo
  # else
  #   { };

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
          coc-rust-analyzer
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

  programs.ssh = {
    enable = true;

    matchBlocks = {
      rusty = { hostname = "rusty.marcopolo.io"; };
      "pi4" = {
        hostname = "pi4.local";
        user = "marco";
      };
      "local-nixos" = {
        hostname = "10.211.55.7";
        user = "marco";
      };
      "rex" = {
        hostname = "rex.local";
        user = "marco";
      };
      "dex" = {
        hostname = "dex.local";
        user = "marco";
      };
    };
  };
}
