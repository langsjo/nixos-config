{
  runCommand,
  lib,
  wrapperName ? "wrapper",
}:
envVar: manifest:
let
  drvName = "${wrapperName}-${envVar}";
in
runCommand drvName { } ''
  printerr() {
    echo "${drvName}: $1"
  }

  set -eu

  link() {
    local relative_target="$1"
    local source="$2"
    local executable="$3"

    local target
    # Don't resolve symlinks, as errors get confusing if $out is a symlink
    target=$(realpath -m --no-symlinks "$out"/"$relative_target")

    # Check if the real path is outside $out
    if [[ ! ( "$target" == "$out" || "$target" == "$out"/* ) ]] ; then
      printerr "Attempting to place a file into $target, but files must go in $out"
      printerr "Error caused by specifying path $relative_target"
      exit 1
    fi

    # check that the source is accessible during build
    local realsource
    if ! realsource=$(realpath -e "$source" 2> /dev/null) ; then
      printerr "The specified source $source does not exist or is a dangling symlink or symlink chain"
      printerr "Specified in the '${wrapperName}' wrapper under ${envVar}, as source for $relative_target"
      printerr "NOTE: the path, symlink, or symlink chain must be valid during build time"
      exit 1
    fi

    if [[ -d "$realsource" ]] ; then
      if ! mkdir -p "$target" ; then
        printerr "Tried to create directories up to $target,"
        printerr "but either the final directory or one of the parent directories is an existing non-directory"
        exit 1
      fi

      if ! cp -rs --update=none-fail "$realsource"/* "$target" ; then
        # cp prints an err message
        printerr "File collisions encountered while copying $source to $target, see above" 
        exit 1
      fi
    else
      local dirname=''${target%/*}
      if ! mkdir -p "$dirname" ; then
        printerr "Tried to create directories up to $dirname, but either the final directory"
        printerr "or one of the parent directories is an existing non-directory"
        exit 1
      fi

      # If the file needs to be executable and the source file isn't,
      # it must be copied over instead of symlinked
      if [[ "$executable" == "1" && ! -x "$realsource" ]] ; then
        if ! cp --update=none-fail "$realsource" "$target" ; then
          printerr "Attempting to copy $source to $target but $target already exists"
          exit 1
        fi
        chmod +x "$target"

      elif ! ln -s "$realsource" "$target" ; then
        printerr "Attempting to link $source to $target but $target already exists"
        exit 1
        fi
    fi
  }

  ${lib.concatMapAttrsStringSep "\n" (
    target: def: "link '${target}' '${def.source}' '${toString def.executable}'"
  ) manifest}
''
