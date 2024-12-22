{
  programs.nixvim = {
    plugins.nvim-autopairs.enable = true;

    # Add them to functions ( i think )
    extraConfigLua = ''
      require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
    '';
  };
}
