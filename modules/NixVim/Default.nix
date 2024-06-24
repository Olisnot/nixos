{ pkgs, inputs, ... }: 

{
    programs.nixvim = {
        enable = true;
        enableMan = true;
        colorscheme = "kanagawa";

        servers = {
            bash-language-server.enable = true;
        };
    };
}
