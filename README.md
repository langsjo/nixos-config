# My NixOS config

NixOS config using flakes and home-manager


## Config structure
```console
.
├── dotfiles
├── hosts
│   ├── common
│   └── default
├── modules
│   ├── system
│   │   ├── programs
│   │   └── services
│   └── user
│       ├── programs
│       │   └── neovim
│       │       └── plugins
│       └── services
├── flake.lock  
└── flake.nix  
```

