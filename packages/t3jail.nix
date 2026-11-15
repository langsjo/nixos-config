{
  writeShellApplication,
}:
writeShellApplication {
  name = "t3jail";
  text = ''
    export TERM=xterm-256color
    nix run --option tarball-ttl 86400 github:langsjo/t3jail#default -- "$@"
  '';
}
