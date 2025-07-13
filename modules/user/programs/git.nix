{ ... }:
{
  programs.git = {
    enable = true;
    userName = "langsjo";
    userEmail = "104687438+langsjo@users.noreply.github.com";

    aliases = {
      amend = "commit --amend --no-edit"; # Just add staged files to commit
      reword = "commit --amend --only"; # Just reword last commit

      co = "checkout";
      s = "status";
      d = "diff";

      rbi = "rebase -i";
      rbc = "rebase --continue";
      rba = "rebase --abort";
    };

    extraConfig = {
      rerere.enabled = true;
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
      merge.tool = "nvimdiff";
    };
  };
}
