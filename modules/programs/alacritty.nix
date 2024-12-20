{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      general.import = [
	../../dotfiles/alacritty-catppuccin-mocha.toml
      ];

      terminal.shell = "${pkgs.zsh}/bin/zsh";
      env.TERM = "xterm-256color";
      window = {
	decorations = "none";
	dynamic_padding = false;
	opacity = 1;
      };

      font = {
	size = 9.0;
	bold = {
	  family = "MesloLGM Nerd Font";
	  style = "Heavy";
	};

	bold_italic = {
	  family = "MesloLGM Nerd Font";
	  style = "Heavy Italic";
	};

	italic = {
	  family = "MesloLGM Nerd Font";
	  style = "Medium Italic";
	};

	normal = {
	  family = "MesloLGM Nerd Font";
	  style = "Medium";
	};
      };

      colors.normal = {
	green = "#00AA00";
	red = "#FF0000";
	yellow = "#DDDD00";
	blue = "#1144CC";
	magenta = "#AA00AA";
	cyan = "#00AAAA";
	white = "#DDDDDD";
      };
    };
  };
}
