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

      no_fast=false
      dir=""
      passthru=()

      while [[ $# -gt 0 ]]; do
        case "$1" in
          --no-fast)
            no_fast=true
            shift
            ;;
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
        echo "'flake.nix' not found in directory"
        exit 1
      fi

      # Add all files with intent to add so flake finds them
      git add -AN

      # Shows your changes
      git diff -U0 '*.nix'

      # May not be able to use --fast if flake inputs have updated, since --fast skips
      # rebuilding Nix itself, which may break things if the system expects a different version.
      # This will still use --fast if the changes have been committed
      # Can also pass --no-fast to not use --fast
      if $no_fast; then
        FAST_FLAG=""
        echo "--no-fast given, omitting --fast"
      elif git diff --quiet -- 'flake.lock' && git diff --staged --quiet -- 'flake.lock'; then 
          FAST_FLAG="--fast" # No changes, use --fast
          echo "No changes in 'flake.lock', rebuilding with '--fast'"
      else
          FAST_FLAG="" # Changes, don't use --fast
          echo "Changes in 'flake.lock', omitting '--fast'"
      fi

      # Ask sudo first
      sudo -v

      sudo nixos-rebuild switch \
          --log-format internal-json \
          $FAST_FLAG "''${passthru[@]}" \
          --flake . |& nom --json
    '';
}
