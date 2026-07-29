{
  writeShellApplication,
  stdenvNoCC,
  wl-clipboard,
  zbar,
  libnotify,
  yubikey-manager,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  script = writeShellApplication {
    name = "yubikey-add-totp";
    runtimeInputs = [
      wl-clipboard
      zbar
      yubikey-manager
      libnotify
    ];
    derivationArgs = {
      nativeBuildInputs = [ copyDesktopItems ];
      desktopItems = [
        (makeDesktopItem {
          name = "hey";
          desktopName = "hey hi";
          exec = "yubikey-add-totp";
        })
      ];
    };
    text = ''
      set -euo pipefail
      log() {
        if [[ -t 2 ]]; then
          echo "$*" >&2
        else
          notify-send "yubikey-add-totp" "$*" || true
        fi
      }
      die() {
        log "fatal: $*"
        exit 1
      }

      clip_types_str=$(wl-paste --list-types)
      mapfile -t clip_types <<< "$clip_types_str"

      chosen_type=""
      for type in "''${clip_types[@]}"; do
        [[ "$type" == image/* ]] || continue
        chosen_type="$type"
        break
      done
      [[ -n "$chosen_type" ]] || die "no image on clipboard"

      decoded=$(wl-paste --type "$chosen_type" | zbarimg --raw --oneshot --quiet -) \
        || die "failed to decode QR code"

      [[ "$decoded" == otpauth://* ]] || die "decoded string is not an otpauth:// uri"
      label="''${decoded%%\?*}"
      label="''${label##*/}"
      log "Adding TOTP to YubiKey for: $label"

      ykman oath accounts uri --touch "$decoded"
    '';
  };
in
stdenvNoCC.mkDerivation {
  name = "yubikey-add-totp-full";
  dontUnpack = true;
  nativeBuildInputs = [ copyDesktopItems ];
  desktopItems = [
    (makeDesktopItem {
      name = "yubikey-add-totp-desktop";
      desktopName = "Add TOTP to YubiKey";
      exec = "yubikey-add-totp";
    })
  ];
  buildPhase = ''
    mkdir -p $out/bin
    cp ${script}/bin/* $out/bin/
  '';
}
