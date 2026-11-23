{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "mistral-bridge";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "langsjo-llm";
    repo = "MistralBridge";
    tag = "v${finalAttrs.version}-english";
    hash = "sha256-6u6+BKIfKlJrLBE98ZmHmaRlWPu/fbXRu9wq9iMjKIs=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 1;

  # CLIProxyAPI plugins are C ABI shared libraries
  buildPhase = ''
    runHook preBuild
    go build -trimpath -buildvcs=false -buildmode=c-shared \
      -ldflags="-s -w -X main.pluginVersion=${finalAttrs.version}" \
      -o mistral-bridge.so .
    runHook postBuild
  '';

  # laid out as a CLIProxyAPI `plugins.dir`
  installPhase = ''
    runHook preInstall
    install -Dm444 mistral-bridge.so \
      $out/${stdenv.hostPlatform.go.GOOS}/${stdenv.hostPlatform.go.GOARCH}/mistral-bridge.so
    runHook postInstall
  '';

  meta = {
    description = "CLIProxyAPI plugin adapting Mistral to OpenAI Chat Completions";
    homepage = "https://github.com/RzMY/MistralBridge";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
