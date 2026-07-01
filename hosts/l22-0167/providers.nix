{
  lib,
  config,
  kehvatsu,
  ...
}:
let
  cfg = config.custom.providers;
in
{
  options.custom.providers = kehvatsu.options.custom.providers;

  config = {
    xdg.configFile."mimeapps.list".force = true;
    xdg.mime.enable = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
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
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ cfg.terminal.desktop ];
    };
    home.sessionVariables = {
      TERMINAL = cfg.terminal.program;
      EDITOR = cfg.editor.program;
      VISUAL = cfg.editor.program;
    };
  };
}
