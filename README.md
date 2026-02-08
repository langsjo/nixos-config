# Modular NixOS config using flakes
## Config

The entry to the system config goes as follows:
- A `nixosSystem` defined under `nixosConfigurations` in [`flake.nix`](/flake.nix) imports the hosts `configuration.nix` from [`hosts/`](hosts/)
  - `inputs` should be passed in `specialArgs`
- The `configuration.nix` should
  - import the `hardware-configuration.nix`, [`modules/`](modules/)
  - define values for custom options which determine how the system gets configured
  - set `networking.hostName` and `system.stateVersion`
  - do other extra configuration as necessary, that isn't part of defined modules
