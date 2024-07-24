{ ... }:

{
  programs.nixvim.plugins = {
    vimtex = {
      enable = true;
      settings = {
        vimtex_view_general_viewer = "mupdf";
      };
    };
  };
}
