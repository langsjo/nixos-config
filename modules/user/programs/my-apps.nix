{ pkgs, inputs, ... }: 
pkgs.stdenv.mkDerivation {
  name = "my-apps";
  src = inputs.my-apps;

  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin/
    find $out/bin/ -maxdepth 1 -type f ! -name "*.*" -exec chmod +x {} \;
  '';
}

