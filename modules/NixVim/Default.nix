{ pkgs, inputs, ... }: 

{
    imports = [ inputs.nixvim.nixosModules.nixvim ];
    programs.nixvim = {
        enable = true;
        enableMan = true;
        colorscheme = "kanagawa";
    };
}
