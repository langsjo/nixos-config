{ programs, ... }: {
  programs.git = {
    enable = true;
    userName = "langsjo";
    userEmail = "104687438+langsjo@users.noreply.github.com";

    aliases = {
      co = "checkout";
    };

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
    };
	
  };
}
