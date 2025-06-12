{
  lib,
  nixosOptionsDoc,
}:
let
  modules = [
    { _module.check = false; }
    ./modules
  ];

  options = lib.evalModules { inherit modules; }
    |> (m: removeAttrs m.options [ "_module" ]);

  docs = nixosOptionsDoc {
    inherit options;
  };
in
  docs.optionsCommonMark
