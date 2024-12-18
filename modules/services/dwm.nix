{ pkgs, lib, config, ... }: {

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = pkgs.fetchFromGitHub {
	owner = "bizrr";
	repo  = "dwm";
	rev   = "6d7794abf522562010a2625c2df8fb7225b9a8f7";
	hash  = "iudfhgiuadfgriuaeguhuaehufguihafiughiuad";
      };
    };
  };
}
