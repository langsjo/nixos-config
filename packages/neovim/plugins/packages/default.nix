{
  pkgs,
}:
let
  callPackage = pkgs.newScope packages;
  packages = {
    openvox-lint = callPackage ./openvox-lint/package.nix { };
    puppet-editor-services = callPackage ./puppet-editor-services/package.nix { };
    actions-languageserver = callPackage ./actions-languageserver.nix { };
  };
in
packages
