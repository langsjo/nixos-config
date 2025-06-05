{
  fetchurl,
  appimageTools,
}:
let
  pname = "lmath";
  version = "1.10.13";
  src = fetchurl {
    url = "https://github.com/lehtoroni/lmath-issues/releases/download/r${version}/LMath_Linux_r${version}-release.AppImage";
    sha256 = "sha256-/41wZreUB5x33wmweDe0Dr5asgxv6W+cRQm0DIAy+8s=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/lmath.desktop $out/share/applications/${pname}.desktop
    install -Dm 444 ${appimageContents}/lmath.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';
}
