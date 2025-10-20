{
  pkgs,
  ...
}:
{
  wrappers.git = {
    install = true;
    expose = false;

    env.paths.GIT_CONFIG_GLOBAL."/" = {
      generate = {
        format = pkgs.formats.gitIni { };
        value = {
          user = {
            name = "langsjo";
            email = "104687438+langsjo@users.noreply.github.com";
          };

          alias = {
            amend = "commit --amend --no-edit"; # Just add staged files to previous commit
            reword = "commit --amend --only"; # Just reword previous commit

            co = "checkout";
            s = "status";
            d = "diff";
            ds = "diff --staged";

            rb = "rebase";
            rbi = "rebase -i";
            rbc = "rebase --continue";
            rba = "rebase --abort";
          };

          rerere.enabled = true;
          init.defaultBranch = "main";
          core.editor = "nvim";
          pull.rebase = true;
          merge.tool = "nvimdiff";
        };
      };
    };
  };
}
