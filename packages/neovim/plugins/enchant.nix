{
  pkgs,
  ...
}:
let
  enchant' = pkgs.symlinkJoin {
    name = "enchant-wrapped";
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    paths = [ pkgs.enchant ];
    postBuild = ''
      for bin in $out/bin/*; do
        [[ -x "$bin" ]] || continue
        wrapProgram "$bin" \
          --set VOIKKO_DICTIONARY_PATH "${pkgs.voikko-fi}/share/voikko-fi"
      done
    '';
  };

  vimchant = pkgs.vimUtils.buildVimPlugin {
    name = "vimchant";
    src = pkgs.fetchFromGitHub {
      owner = "vim-scripts";
      repo = "Vimchant";
      tag = "1.1";
      hash = "sha256-jcGet5octGQm8MW90GriYHXNkrsmg9RfchKjJ0G9Yis=";
    };
    configurePhase = ''
      substituteInPlace autoload/vimchant.vim plugin/vimchant.vim \
        --replace-fail enchant "${enchant'}/bin/enchant-2"
    '';
  };
in
{
  extraPlugins = [
    vimchant
  ];

  extraConfigLua = ''
    vim.g.vimchant_spellcheck_lang = "fi"
  '';
}
