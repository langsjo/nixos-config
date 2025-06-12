# Modular NixOS config using flakes and Home manager

This config defined custom options to modify what gets configured and how, documentation on the NixOS options can be found in [`OPTIONS.md`](/OPTIONS.md)

## Config

The entry to the system config goes as follows:
- A `nixosSystem` defined under `nixosConfigurations` in [`flake.nix`](/flake.nix) imports the hosts `configuration.nix` from [`hosts/`](hosts/)
  - `inputs` and `pkgs-unstable` should be passed in `specialArgs`
- The `configuration.nix` should
  - import the `hardware-configuration.nix`, [`modules/`](modules/), and optionally `home-manager`
  - define values for custom options (see [`OPTIONS.md`](/OPTIONS.md)) which determine how the system gets configured
  - set `networking.hostName` and `system.stateVersion`
  - do other extra configuration as necessary, that isn't part of defined modules


Configuring a host is done as follows:  
- Define a `nixosSystem` under `nixosConfigurations` in [`flake.nix`](/flake.nix)
- Create a folder for the host in [`/hosts`](/hosts), which holds a `configuration.nix` and `hardware-configuration.nix`
- 

## Structure
```bash
.
├── dotfiles                # dotfiles that are imported in the config
├── hosts                   # different host's configuration.nix and hardware-configuration.nix
│   ├── desktop
│   └── laptop
├── modules                 # config modules, where most configuration is defined
│   ├── system                # modules relating to system configuration, non Home manager
│   │   ├── common              # common configuration of the system like timezones, nix settings, user
│   │   ├── gaming              # gaming related configuration
│   │   ├── gui                 # configuration relating to graphical sessions; window managers, display managers. etc
│   │   ├── hardware            # configuration of hardware related aspects
│   │   ├── programs            # general directory for configuring programs
│   │   │   └── gui               # directory for configuring gui programs
│   │   └── services            # general directory for configuring services
│   └── user                  # user level configuration, basically Home manager
│       ├── programs            # general directory for configuring user programs
│       │   └── neovim          
│       │       ├── plugins
│       │       └── settings
│       └── services            # general directory for configuring user services
├── utils                   # folder for miscellaneous utils, such as generating docs
├── flake.lock
└── flake.nix  
```

