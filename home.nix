{ config, pkgs, ... }:

{
  disabledModules = [ (<home-manager> + "/modules/programs/vscode.nix") ];
  imports = [ ./modules/vscode.nix ];
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
  home.packages = with pkgs; [ zola ];
  nixpkgs.config.allowUnfree = true;

  # For pure zsh
  # environment.pathsToLink = [ "/share/zsh" ];

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
      # Edit command in vim
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd v edit-command-line


      bindkey '^R' history-incremental-search-backward

      # Setup nix
      ${if builtins.currentSystem == "x86_64-darwin" then ''
        . /Users/marcomunizaga/.nix-profile/etc/profile.d/nix.sh
      '' else
        ""}

      # Better command not found
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

    '';
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
        # will source zsh-autosuggestions.plugin.zsh
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

  # Not sure how I want to do this...
  # I want vs code to still be able to edit it's own config. Maybe just a symlink would be better?
  programs.vscode = {
    enable = false;
    # Don't let home-manager manage vscode
    package = null;
    pname = "vscode";
    # userSettings = {
    #   "C_Cpp.updateChannel" = "Insiders";
    #   "[javascript]" = {
    #     "editor.defaultFormatter" = "vscode.typescript-language-features";
    #   };
    #   "[markdown]" = {
    #     "editor.quickSuggestions" = false;
    #     "editor.rulers" = [ 80 ];
    #     "editor.wordWrap" = "on";
    #     "rewrap.autoWrap.enabled" = true;
    #   };
    #   "[nix]" = { "editor.defaultFormatter" = "brettm12345.nixfmt-vscode"; };
    #   "[typescript]" = {
    #     "editor.defaultFormatter" = "vscode.typescript-language-features";
    #   };
    #   "[typescriptreact]" = {
    #     "editor.defaultFormatter" = "vscode.typescript-language-features";
    #   };
    #   "calva.paredit.defaultKeyMap" = "original";
    #   "clock.alignment" = "Right";
    #   "clock.iconName" = "none";
    #   "editor.minimap.enabled" = false;
    #   "editor.tabSize" = 2;
    #   "eslint.format.enable" = true;
    #   "go.formatTool" = "goimports";
    #   "go.useLanguageServer" = true;
    #   "nightswitch.autoSwitch" = true;
    #   "nightswitch.location" = "34.052235, -118.243683";
    #   "nightswitch.themeDay" = "Material Theme Lighter";
    #   "nightswitch.themeNight" =
    #     "Community Material Theme Palenight High Contrast";
    #   "nixfmt.path" = "/Users/marcomunizaga/.nix-profile/bin/nixfmt";
    #   "rust.clippy_preference" = "on";
    #   "terminal.integrated.shell.osx" = "/bin/zsh";
    #   "vim.normalModeKeyBindingsNonRecursive" = [
    #     {
    #       after = [ ];
    #       before = [ "u" ];
    #       commands = [{
    #         args = [ ];
    #         command = "undo";
    #       }];
    #     }
    #     {
    #       after = [ "cmd+'" ];
    #       before = [[ "c" "p" "p" ]];
    #     }
    #     {
    #       after = [ ];
    #       before = [ "<C-r>" ];
    #       commands = [{
    #         args = [ ];
    #         command = "redo";
    #       }];
    #     }
    #   ];
    #   "vscode-neovim.neovimPath" = "/usr/local/bin/nvim";
    #   # for neovim
    #   # "editor.scrollBeyondLastLine" = false;
    #   "vsonline.authentication.accountProvider" = "Microsoft";
    #   "window.zoomLevel" = 1;
    #   "workbench.activityBar.visible" = true;
    #   "workbench.colorTheme" = "Material Theme Lighter";
    #   "workbench.statusBar.visible" = true;
    # };
    userSettingsJSONFilePath = ./vscode/settings/settings.json;
    userKeybindingsJSONFilePath = ./vscode/settings/keybindings.json;
    # extensions = [
    #   "aeschli.vscode-css-formatter"
    #   "angelo-breuer.clock"
    #   "asvetliakov.vscode-neovim"
    #   "ban.spellright"
    #   "bbenoist.Nix"
    #   "betterthantomorrow.calva"
    #   "borkdude.clj-kondo"
    #   "brettm12345.nixfmt-vscode"
    #   "bungcip.better-toml"
    #   "clptn.code-paredit"
    #   "CoenraadS.bracket-pair-colorizer-2"
    #   "dbaeumer.vscode-eslint"
    #   "eamodio.gitlens"
    #   "EditorConfig.EditorConfig"
    #   "Equinusocio.vsc-community-material-theme"
    #   "Equinusocio.vsc-material-theme"
    #   "equinusocio.vsc-material-theme-icons"
    #   "gharveymn.nightswitch-lite"
    #   "Hyzeta.vscode-theme-github-light"
    #   "jdinhlife.gruvbox"
    #   "kanitw.vega-vscode"
    #   "lkytal.pomodoro"
    #   "mitaki28.vscode-clang"
    #   "mrmlnc.vscode-scss"
    #   "ms-azuretools.vscode-docker"
    #   "ms-python.python"
    #   "ms-vscode-remote.remote-containers"
    #   "ms-vscode-remote.remote-ssh"
    #   "ms-vscode-remote.remote-ssh-edit"
    #   "ms-vscode.cmake-tools"
    #   "ms-vscode.cpptools"
    #   "ms-vscode.Go"
    #   "ms-vsliveshare.vsliveshare"
    #   "ms-vsonline.vsonline"
    #   "Orta.vscode-jest"
    #   "pedrorgirardi.vscode-cljfmt"
    #   "RandomFractalsInc.vscode-vega-viewer"
    #   "rust-lang.rust"
    #   "Shan.code-settings-sync"
    #   "shardulm94.trailing-spaces"
    #   "sibiraj-s.vscode-scss-formatter"
    #   "stkb.rewrap"
    #   "syler.sass-indented"
    #   "sysoev.vscode-open-in-github"
    #   "vscodevim.vim"
    #   "vsls-contrib.codetour"
    #   "vsls-contrib.gistfs"
    #   "xaver.clang-format"
    # ];

  };
}
