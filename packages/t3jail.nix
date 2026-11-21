{
  symlinkJoin,
  writeShellApplication,
}:
let
  flake = "github:langsjo/t3jail#default";
  nixOptions = "--option tarball-ttl 86400";

  t3jail = writeShellApplication {
    name = "t3jail";
    text = ''
      export TERM=xterm-256color
      exec nix run ${nixOptions} ${flake} -- "$@"
    '';
  };

  # git runs this for t3jail::<repo> remotes. nix shell puts the flake's own
  # git-remote-t3jail first on PATH. Its stdout is git's protocol stream, so
  # nothing else may print there.
  git-remote-t3jail = writeShellApplication {
    name = "git-remote-t3jail";
    text = ''
      exec nix shell ${nixOptions} ${flake} --command git-remote-t3jail "$@"
    '';
  };
in
symlinkJoin {
  name = "t3jail";
  paths = [
    t3jail
    git-remote-t3jail
  ];
  meta.mainProgram = "t3jail";
}
