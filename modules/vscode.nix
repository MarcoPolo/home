{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.vscode;

  vscodePname = if (cfg.package == null) then cfg.pname else cfg.package.pname;

  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};

  extensionDir = {
    "vscode" = "vscode";
    "vscode-insiders" = "vscode-insiders";
    "vscodium" = "vscode-oss";
  }.${vscodePname};

  configFilePath = if pkgs.stdenv.hostPlatform.isDarwin then
    "Library/Application Support/${configDir}/User/settings.json"
  else
    "${config.xdg.configHome}/${configDir}/User/settings.json";

  keybindingsPath = if pkgs.stdenv.hostPlatform.isDarwin then
    "Library/Application Support/${configDir}/User/keybindings.json"
  else
    "${config.xdg.configHome}/${configDir}/User/keybindings.json";

  # TODO: On Darwin where are the extensions?
  extensionPath = ".${extensionDir}/extensions";

in {
  options = {
    programs.vscode = {
      enable = mkEnableOption "Visual Studio Code";

      package = mkOption {
        type = types.nullOr types.package;
        default = pkgs.vscode;
        example = literalExample "pkgs.vscode";
        description = ''
          Version of Visual Studio Code to install.
        '';
      };

      pname = mkOption {
        type = types.nullOr types.str;
        default = pkgs.vscode;
        example = literalExample "pkgs.vscode";
        description = ''
          If package is null. (You are managing vscode outside of
          home-manager), set this to the VS Code's installed name. For
          default VS Code installation, that's "vscode". For others look at
          your config location.
        '';
      };

      userSettings = mkOption {
        type = types.attrs;
        default = { };
        example = literalExample ''
          {
            "update.channel" = "none";
            "[nix]"."editor.tabSize" = 2;
          }
        '';
        description = ''
          Configuration written to Visual Studio Code's
          <filename>settings.json</filename>.
        '';
      };

      userSettingsJSONFilePath = mkOption {
        type = types.path;
        default = "";
        description = ''
          Configuration file written to
          <filename>settings.json</filename>.
        '';
      };

      userKeybindingsJSONFilePath = mkOption {
        type = types.path;
        default = "";
        description = ''
          Configuration file written to
          <filename>keybindings.json</filename>.
        '';
      };

      extensions = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExample "[ pkgs.vscode-extensions.bbenoist.Nix ]";
        description = ''
          The extensions Visual Studio Code should be started with.
          These will override but not delete manually installed ones.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    #  disable using vscode from nixpkgs
    home.packages = mkIf (cfg.package != null) [ cfg.package ];

    # Adapted from https://discourse.nixos.org/t/vscode-extensions-setup/1801/2
    home.file = let
      toPaths = path:
        # Links every dir in path to the extension path.
        mapAttrsToList
        (k: v: { "${extensionPath}/${k}".source = "${path}/${k}"; })
        (builtins.readDir path);
      toSymlink = concatMap toPaths cfg.extensions;
    in foldr (a: b: a // b) {
      "${configFilePath}" = if (cfg.userSettings != { }) then {
        text = builtins.toJSON cfg.userSettings;
      } else
        mkIf (cfg.userSettingsJSONFilePath != null) {
          text = builtins.readFile cfg.userSettingsJSONFilePath;
        };
      "${keybindingsPath}" = mkIf (cfg.userKeybindingsJSONFilePath != null) {
        text = builtins.readFile cfg.userKeybindingsJSONFilePath;
      };
    } toSymlink;
  };
}
