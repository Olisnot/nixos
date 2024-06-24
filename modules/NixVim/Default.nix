{ pkgs, inputs, ... }: 

{
    programs.nixvim = {
        enableMan = true;
        colorscheme = "kanagawa";
    };
}
