{
  stdenv,
  fetchFromGitHub,
  xorg,
}:
let
  inherit (xorg) libX11 libXinerama libXcursor;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "sxwm";
    version = "1.5";

    src = fetchFromGitHub {
      owner = "uint23";
      repo = finalAttrs.pname;
      rev = "v${finalAttrs.version}";
      hash = "sha256-CMqVAHrW5oluTmB/DHg65wf8NCSX5fksH/L+GQXZV+o=";
    };

    buildInputs = [
      libX11
      libXinerama
      libXcursor
    ];

    makeFlags = [
      "PREFIX=${placeholder "out"}"
    ];
  })

