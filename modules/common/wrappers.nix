{ lib, ... }:
{
  options.custom.wrappers = lib.mkOption {
    description = "Defined wrappers and their possible overrides";
    type = with lib.types; attrsOf package;
    default = { };
    example = {
      zsh = lib.literalExpression "inputs.self.packages.\${pkgs.stdenv.hostPlatform.system}.zsh-wrapped.override { autostartTmux = true; }";
    };
  };
}
