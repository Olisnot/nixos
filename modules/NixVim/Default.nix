{ pkgs, inputs, ... }: 

{
    programs.nixvim = {
        enable = true;
        enableMan = true;
        colorscheme = "kanagawa";

        bash-language-server.enable = true;
    };
}
