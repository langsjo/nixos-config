{
  writeShellApplication,
  yubikey-manager,
  libnotify,
  wtype,
  wl-clipboard,
}:
writeShellApplication {
  name = "yubikey-oath-dmenu";
  runtimeInputs = [
    yubikey-manager
    libnotify
    wtype
    wl-clipboard
  ];
  text = ''
    set -euo pipefail

    log() {
      if [[ -t 2 ]]; then
        echo "$*" >&2
      else
        notify-send "yubikey-oath-dmenu" "$*"
      fi
    }
    die() {
      log "fatal: $*"
      exit 1
    }

    dmenu_cmd=""
    while [[ "$#" -gt 0 ]]; do
      case "$1" in
        --dmenu-cmd) dmenu_cmd="$2"; shift 2 ;;
      esac
    done

    [[ -n "$dmenu_cmd" ]] || die "must pass --dmenu-cmd"

    accounts=$(ykman oath accounts list) || die "failed to list OATH accounts"
    choice=$(eval "$dmenu_cmd" <<< "$accounts") || die "no choice was made"
    code=$(ykman oath accounts code -s "$choice") || die "failed to generate code"

    wl-copy "$code"
    wtype "$code"
  '';
}
