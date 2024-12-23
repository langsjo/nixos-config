{ ... }: {
  imports = [
    ./dwm.nix
    ./keyd.nix
  ];

  # small configs go here
  services = {
    openssh.enable = true;
  };
}
