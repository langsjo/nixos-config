{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  npm-lockfile-fix,
}:
let
  rest-api-description = fetchFromGitHub {
    owner = "github";
    repo = "rest-api-description";
    tag = "v2.1.0";
    hash = "sha256-v6mxxWymrj+yfj8hscNj9/1+mSv18tnDXYyBB1a9oyk=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "actions-languageserver";
  version = "0.3.58";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "languageservices";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-9GcL7bB1JroXb0JHjdfEcOzwnfwMJmkxKMAh6ec0nAY=";
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
      substituteInPlace $out/package-lock.json $out/languageservice/package.json \
      --replace-fail '"rest-api-description": "github:github/rest-api-description",' ""
    '';
  };

  npmWorkspace = "languageserver";

  npmDepsHash = "sha256-fx1R0YLcYoxVEmODjhT8ftCYlC5Ht0ShGK6S4idqJns=";

  preBuild = ''
    cp -r "${rest-api-description}" node_modules/rest-api-description
    patchShebangs .
    npm run build --workspace=expressions
    npm run build --workspace=workflow-parser
    npm run build --workspace=languageservice
  '';

  # Copy workspace packages to output to fix symlinks
  postInstall = ''
    cp -r expressions workflow-parser languageservice languageserver $out/lib/node_modules/actions-languageservices/
  '';

  meta = {
    homepage = "https://github.com/actions/languageservices";
    description = "Language server for GitHub Actions";
    changelog = "https://github.com/actions/languageservices/releases/tag/release-v${finalAttrs.version}";

    mainProgram = "actions-languageserver";
    maintainers = with lib.maintainers; [ keirlawson ];
    license = with lib.licenses; [ mit ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
})
