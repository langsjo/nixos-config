{
  writeShellApplication,
  git,
  nix-output-monitor,
}:
writeShellApplication {
  name = "rebuild";

  runtimeInputs = [
    git
    nix-output-monitor
  ];

  text = # bash
    ''
      set -euo pipefail

      dir=""
      passthru=()

      while [[ $# -gt 0 ]]; do
        case "$1" in
          --)
            shift
            passthru=( "$@" )
            break
            ;;
          -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
          *)
            if [[ -z "$dir" ]]; then
              dir="$1"
              shift
            else
              echo "Unexpected extra argument: $1" >&2
              exit 1
            fi
            ;;
        esac
      done

      if [[ -n "$dir" ]]; then
        if [[ -d "$dir" ]]; then
          cd "$dir"
        else
          echo "Not a directory: $dir" >&2
          exit 1
        fi
      fi

      if [ ! -f 'flake.nix' ]; then
        echo "'flake.nix' not found in directory $dir" >&2
        exit 1
      fi

      # Add all files with intent to add so flake finds them
      git add -AN

      # Shows your changes
      git diff -U0 '*.nix'

      # Ask sudo first
      sudo -v

      sudo nixos-rebuild switch \
          --log-format internal-json \
          "''${passthru[@]}" \
          --flake . |& nom --json
    '';
}
