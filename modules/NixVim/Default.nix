{ pkgs, inputs, ... }: 

{
    programs.nixvim = {
        enable = true;
        enableMan = true;
        colorscheme = "kanagawa";

        plugins = {
            lsp = {
                enable = true;
                servers = {
                    bash-language-server.enable = true;
                };
            };
        };
    };
}
