{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  npm-lockfile-fix,
}:
buildNpmPackage (finalAttrs: {
  pname = "actions-languageserver";
  version = "0.3.58";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "languageservices";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-t48/ZR7Gw+GS4PYQtg9TlsqGbaJ9zQTQhySso0IDO5E=";
    postFetch = ''
      substituteInPlace $out/package-lock.json $out/languageservice/package.json \
      --replace-fail '"rest-api-description": "github:github/rest-api-description",' ""
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };
  npmWorkspace = "languageserver";

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-OMQKyi44O1P7KJTBs9ZYl62OIQzrfjCDAmc6VUDTG58=";

  preBuild = ''
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
