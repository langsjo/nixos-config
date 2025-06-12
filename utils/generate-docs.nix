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

  docs = nixosOptionsDoc {
    inherit options;
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
    sed -Ei 's/(file:\/\/)?\/nix\/store\/[^/]*([^])]*\.nix)/.\2/g' $out # Change nix store path to relative path in files that end in .nix
    sed -Ei 's/(file:\/\/)?\/nix\/store\/[^/]*([^])]*)/.\2\/default.nix/g' $out # Same thing in leftover paths, but add '/default.nix' to the end
                                                                                # These options were imported from default.nix files
  ''
