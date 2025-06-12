{
  lib,
  runCommandLocal,
  nixosOptionsDoc,
  gnused,
}:
let
  modules = [
    { _module.check = false; }
    ../modules
  ];

  options = lib.evalModules { inherit modules; } |> (m: removeAttrs m.options [ "_module" ]);

  # Recursively update value named `key` based on function `fun` in `attrset`
  walkAttrs = key: fun: attrset:
    attrset
    |> builtins.mapAttrs (k: v:
      if k == key then fun v
      else if builtins.isAttrs v then walkAttrs key fun v
      else v
    );

  # If a path ends in a .nix file, do nothing, otherwise add string '/default.nix'
  # This is because options defined in default.nix files show as being defined just in the directory
  addDefaultNix = path:
    if lib.hasSuffix ".nix" path then path
    else "${path}/default.nix";

  # Map list of store paths to relative paths, that still start with / not ./
  storeToRelativePath = paths:
    paths
    |> map (path:
      let
        matches = builtins.match "^/nix/store/[^/]+(.*)" path;
      in
        if matches == [] then path else addDefaultNix (builtins.head matches));

  # Replace all attributes with key 'declarations' with that path in relative form
  # This way the docs don't show /nix/store paths that can change even though the options don't change themself
  transformedOptions = walkAttrs "declarations" storeToRelativePath options;

  docs = nixosOptionsDoc {
    options = transformedOptions;
  };
in
runCommandLocal "option-docs"
  {
    nativeBuildInputs = [
      gnused
    ];
  }
  ''
    { \
      echo "# NOTE: This file does not contains documentation of Home manager options"; \
      cat ${docs.optionsCommonMark}; \
    } > $out
    sed -i 's/file:\/\///' $out # Remove 'file://' prefix from links
  ''
