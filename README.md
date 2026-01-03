# Modular NixOS config using flakes and Home manager

This config defined custom options to modify what gets configured and how, documentation on the NixOS options can be found in [`OPTIONS.md`](/OPTIONS.md)

## Config

The entry to the system config goes as follows:
- A `nixosSystem` defined under `nixosConfigurations` in [`flake.nix`](/flake.nix) imports the hosts `configuration.nix` from [`hosts/`](hosts/)
  - `inputs` and `pkgs-unstable` should be passed in `specialArgs`
- The `configuration.nix` should
  - import the `hardware-configuration.nix`, [`modules/`](modules/)
  - define values for custom options (see [`OPTIONS.md`](/OPTIONS.md)) which determine how the system gets configured
  - set `networking.hostName` and `system.stateVersion`
  - do other extra configuration as necessary, that isn't part of defined modules
