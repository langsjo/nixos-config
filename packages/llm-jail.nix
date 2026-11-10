{
  writeShellApplication,
}:
writeShellApplication {
  name = "llm-jail";
  text = ''
    tool=''${1?Usage: $0 <tool> [args...]}; shift
    [[ "$tool" = "cat" ]] && is_cat=1 || is_cat=0

    if [[ "$is_cat" -eq 1 && -n "''${1-}" && "$1" != -* ]]; then
      tool=$1; shift
    fi

    command=(
      nix run "github:langsjo/llm-jail#$tool"
      --option tarball-ttl 86400
      --
      --dangerous
      --disk 50
      --tmpdir "$HOME/.local/share/llm-jail"
      --mem 8000
      --vcpu 8
      --mask .env
      --mask .direnv
      --mask terraform.tfvars
      --mask .terraform/terraform.tfstate
      --allow-domain cache.nixos.org
      --allow-domain channels.nixos.org
      --allow-domain github.com
      --allow-domain githubusercontent.com
    )
    case "$tool" in
      omp)
        command+=(
          --allow-domain search.parallel.ai
        )
        ;;
    esac

    command+=("$@")

    if [[ "$is_cat" -eq 1 ]]; then
      printf "%q " "''${command[@]}"; printf "\n"
      exit 0
    fi

    # fix problems with the jail not having kitty's terminfo
    export TERM=xterm-256color
    exec "''${command[@]}"
  '';
}
