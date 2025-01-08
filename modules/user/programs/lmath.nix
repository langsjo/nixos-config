{ pkgs }:
let
  pname = "lmath";
  version = "r1.10.10";
  src = pkgs.fetchurl {
    url = "https://github.com/lehtoroni/lmath-issues/releases/download/${version}/LMath_Linux_${version}-release.AppImage";
    sha256 = "sha256-2ZF+vpj5M/HPrG3Lno4DSnceiz9Oo1fDGoKA2IyG4xg=";
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
