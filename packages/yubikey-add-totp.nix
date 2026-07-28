{
  writeShellApplication,
  wl-clipboard,
  zbar,
  yubikey-manager,
}:
writeShellApplication {
  name = "yubikey-add-totp";
  runtimeInputs = [
    wl-clipboard
    zbar
    yubikey-manager
  ];
  text = ''
    set -euo pipefail

    die() {
      echo "fatal: $*" >&2
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

    echo "Successfully got otpauth URI:" >&2
    echo "$decoded" >&2
    echo "Adding to YubiKey" >&2
    ykman oath accounts uri --touch "$decoded"
  '';
}
