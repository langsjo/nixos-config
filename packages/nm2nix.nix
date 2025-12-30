{
  writeShellScriptBin,
}:
writeShellScriptBin "nm2nix" ''
  function start_attr() {
      local attrname=''${1#*[}
      attrname=''${attrname%%]*}
      echo "$attrname = {"
  }

  function end_attr() {
      echo -e "};\n"
  }

  function write_value() {
      local key value
      IFS="=" read key value <<< "$1"
      echo "''${indent}$key = \"$value\";"
  }

  file=$1
  indent="  "

  if [[ -z "$file" ]] ; then
      echo "Usage: $0 <nmconnection file>" >&2
      exit 1
  fi

  if [[ ! -r "$file" ]] ; then
      echo "File $file does not exist or is not readable" >&2
      exit 1
  fi

  while read -r line ; do
      if [[ ''${line:0:1} == "[" ]] ; then
          start_attr "$line"
      elif [[ -z "$line" ]] ; then
          end_attr
      else
          write_value "$line"
      fi
  done < "$file"
''
