{
  lib,
  config,
  ...
}:
let
  providerType = lib.types.submodule {
    options = {
      program = lib.mkOption {
        description = "The executable providing this feature";
        type = lib.types.str;
      };

      desktop = lib.mkOption {
        description = "Desktop file name";
        type = lib.types.str;
      };
    };
  };

  mkProviderOption =
    feature:
    lib.mkOption {
      description = "Provider for ${feature}";
      type = providerType;
    };

  cfg = config.custom.providers;
in
{
  options.custom.providers = {
    enable = lib.mkEnableOption "setting providers and mimetypes" // {
      default = true;
    };

    browser = mkProviderOption "browser";
    terminal = mkProviderOption "terminal";
    editor = mkProviderOption "editor";
    fileManager = mkProviderOption "fileManager";
    imageViewer = mkProviderOption "imageViewer";
    videoPlayer = mkProviderOption "videoPlayer";
    pdfViewer = mkProviderOption "pdfViewer";

    dwmLocker = mkProviderOption "dwmLocker";
  };

  config = lib.mkIf cfg.enable {
    xdg.mime.enable = true;
    xdg.mime.defaultApplications = {
      "text/html" = cfg.browser.desktop;
      "x-scheme-handler/http" = cfg.browser.desktop;
      "x-scheme-handler/https" = cfg.browser.desktop;

      "text/*" = cfg.editor.desktop;
      "application/json" = cfg.editor.desktop;
      "text/markdown" = cfg.editor.desktop;

      "inode/directory" = cfg.fileManager.desktop;

      "image/*" = cfg.imageViewer.desktop;
      "video/*" = cfg.videoPlayer.desktop;

      "application/pdf" = cfg.pdfViewer.desktop;
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ cfg.terminal.desktop ];
    };
    environment.sessionVariables = {
      TERMINAL = cfg.terminal.program;
      EDITOR = cfg.editor.program;
      VISUAL = cfg.editor.program;
    };
  };
}
