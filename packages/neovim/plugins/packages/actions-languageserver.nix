{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  npm-lockfile-fix,
  jq,
}:
buildNpmPackage (finalAttrs: {
  pname = "actions-languageserver";
  version = "0.3.58";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "languageservices";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-Vsfo+OwqRvgbhyQheaFIbStIq7jtg7WPmVOPOzZuolc=";
    postFetch = ''
      substituteInPlace $out/package-lock.json $out/languageservice/package.json \
        --replace-fail '"rest-api-description": "github:github/rest-api-description",' ""
      ${lib.getExe jq} 'del(.packages."node_modules/rest-api-description")' \
        $out/package-lock.json > tmp; mv tmp $out/package-lock.json
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };
  npmWorkspace = "languageserver";

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-i6dykkj96g/5+ibQe1OuGHFkFtEFrMOJejijfBfviGs=";

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
