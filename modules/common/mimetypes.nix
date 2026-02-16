{
  lib,
  config,
  ...
}:
let
  mkMimetypeOption =
    type:
    lib.mkOption {
      description = "The desktop file to use as a ${type}";
      type = lib.types.str;
      default = null;
    };

  cfg = config.custom.mimetypes;
in
{
  options.custom.mimetypes = {
    enable = lib.mkEnableOption "setting mimetypes" // {
      default = true;
    };

    browser = mkMimetypeOption "browser";
    editor = mkMimetypeOption "editor";
    terminal = mkMimetypeOption "terminal";
    pdfViewer = mkMimetypeOption "PDF viewer";
    fileChooser = mkMimetypeOption "file chooser";
    imageViewer = mkMimetypeOption "image viewer";
    videoPlayer = mkMimetypeOption "video player";
  };

  config = lib.mkIf cfg.enable {
    xdg.mime.enable = true;
    xdg.mime.defaultApplications = {
      "text/html" = cfg.browser;
      "x-scheme-handler/http" = cfg.browser;
      "x-scheme-handler/https" = cfg.browser;

      "text/*" = cfg.editor;
      "application/json" = cfg.editor;
      "text/markdown" = cfg.editor;

      "inode/directory" = cfg.fileChooser;

      "image/*" = cfg.imageViewer;
      "video/*" = cfg.videoPlayer;

      "application/pdf" = cfg.pdfViewer;
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ cfg.terminal ];
    };
  };
}
