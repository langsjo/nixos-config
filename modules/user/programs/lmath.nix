{ pkgs }:
let
  pname = "lmath";
  version = "r1.10.11";
  src = pkgs.fetchurl {
    url = "https://github.com/lehtoroni/lmath-issues/releases/download/${version}/LMath_Linux_${version}-release.AppImage";
    sha256 = "sha256-w2/0WUZ2AzpFtwlvn3zXBNQxKN3JY/OXomZtWkSlf4I=";
  };

in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications

      cat > $out/share/applications/lmath.desktop <<EOF
      [Desktop Entry]
      Name=L'Math
      Exec=$out/bin/${pname}
      Type=Application
      Categories=Utility;
      Terminal=false
      EOF
    '';
  }
