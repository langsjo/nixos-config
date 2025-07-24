{
  pkgs,
  config,
  lib,
  ...
}:
let
  specstory = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "specstory-vscode";
      publisher = "SpecStory";
      version = "0.15.0";
      hash = "sha256-lYcYcrCJIRK+62DhLLGsRb069nqb6gLyuI3SHpEITi0=";
    };
  };

  cursor = pkgs.vscode-with-extensions.override {
    vscode = pkgs.code-cursor;
    vscodeExtensions =
      with pkgs.vscode-extensions;
      [
        vscodevim.vim
        ms-python.python
        ms-python.vscode-pylance
      ]
      ++ [
        specstory
      ];
  };

  cfg = config.custom.dev.cursor;
in
{
  options.custom.dev.cursor.enable = lib.mkEnableOption "Enable the Cursor IDE";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cursor
    ];
  };
}
