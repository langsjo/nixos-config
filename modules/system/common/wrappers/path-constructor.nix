{
  runCommand,
  lib,
  wrapperName ? "wrapper",
}:
envVar: manifest:
let
  manifestArrayItems = lib.pipe manifest [
    (lib.mapAttrsToList (path: def: ''["${path}"]="${def.source}"''))
    (lib.concatStringsSep " ")
  ];

  drvName = "${wrapperName}-${envVar}";
in
runCommand drvName { } ''
  printerr() {
    echo "${drvName}: $1"
  }

  set -eu
  declare -A manifest
  manifest+=( ${manifestArrayItems} )

  for path in "''${!manifest[@]}" ; do
    target=$(realpath -m "$out/$path")
    # Check if the real path is outside $out
    if [[ ! ( "$target" == "$out" || "$target" == "$out"/* ) ]] ; then
      printerr "Attempting to place a file into $target, but files must go in $out"
      printerr "Error caused by specifying path $path"
      exit 1
    fi

    source="''${manifest["$path"]}"
    # check that the source is accessible during build
    if ! realsource=$(realpath -e "$source" 2> /dev/null) ; then
      printerr "The specified source $source does not exist or is a dangling symlink or symlink chain"
      printerr "Specified in the '${wrapperName}' wrapper under ${envVar}, as source for $path"
      printerr "NOTE: the path, symlink, or symlink chain must be valid during build time"
      exit 1
    fi

    if [[ -d "$realsource" ]] ; then
      mkdir -p "$target"
      cp -rs "$realsource"/* "$target"
    else
      dirname=''${target%/*}
      mkdir -p "$dirname"
      ln -s "$realsource" "$target"
    fi
  done
''
