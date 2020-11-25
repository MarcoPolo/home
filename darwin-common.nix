{ lib, pkgs, ... }: {
  home.activation = {
    linkVSCodeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              $DRY_RUN_CMD ln -s $VERBOSE_ARG \
                  ${
      builtins.toPath ./vscode/settings/settings.json
      } "$HOME/Library/Application Support/Code/User/settings.json" || true
    '';
    linkVSCodeRemoteExtension = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ln -s $VERBOSE_ARG \
          ${pkgs.vscode-extensions.ms-vscode-remote.remote-ssh}/share/vscode/extensions/ms-vscode-remote.remote-ssh "$HOME/.vscode/extensions/" || true
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
  };
}
