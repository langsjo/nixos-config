{ ... }: {
  programs.git = {
    enable = true;
    userName = "langsjo";
    userEmail = "104687438+langsjo@users.noreply.github.com";

    aliases = {
      co = "checkout";
    };

    extraConfig = {
      rerere.enabled = true;
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
    };

    includes = [
      {
        contents.user.name = "langsjo";
        contents.user.email = "104687438+langsjo@users.noreply.github.com";
        condition = "gitdir:~/Kurssit/**";
      }
    ];
        
  };
}
