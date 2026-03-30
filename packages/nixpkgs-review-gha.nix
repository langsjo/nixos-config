{
  writeShellApplication,
  gh,
  getopt,
}:
writeShellApplication {
  name = "nixpkgs-review-gha";
  runtimeInputs = [
    gh
    getopt
  ];
  text = ''
    die() {
      echo "fatal: $*" >&2
      exit 1
    }

    short_opts="af:"
    long_opts="approve,field:"
    PARSED_OPTS=$(getopt --options="$short_opts" --longoptions="$long_opts" --name "$0" -- "$@") \
                || die "invalid args"
    eval set -- "$PARSED_OPTS"

    pr=""
    field_args=()
    while true; do
      case "$1" in
        -a|--approve)
          field_args+=("-f" "on-success=approve")
          shift
          ;;

        -f|--field)
          field_args+=("-f" "$2")
          shift 2
          ;;

        --)
          shift
          break
          ;;
      esac
    done

    [[ -n "''${1:-}" ]] || die "No positional parameter given for PR number"
    pr="$1"
    shift

    exec gh workflow --repo langsjo/nixpkgs-review-gha run review.yml \
      -f pr="$pr" \
      "''${field_args[@]}" \
      "$@"
  '';
}
