{
  buildPythonApplication,
  click,
  setuptools,
  fetchFromGitHub,
  yubikey-manager,
  wtype,
  wl-clipboard,
}:
buildPythonApplication (finalAttrs: {
  pname = "yubikey-oath-dmenu";
  version = "0.14.0-unstable-2025-12-11";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "emlun";
    repo = "yubikey-oath-dmenu";
    rev = "aa110c2b2c23ee472155d259204b98b5bf655b11";
    hash = "sha256-LzEa9jIr3zvp1E3qSDs5G4VOLkYN3FC6Tn2gRtvlrY4=";
  };

  build-system = [ setuptools ];
  dependencies = [
    click
    yubikey-manager
    wtype
    wl-clipboard
  ];

  meta.mainProgram = "yubikey-oath-dmenu";
})
