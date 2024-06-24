{ pkgs, inputs, ... }: 

{
    environment.systemModules = [
        (nixvim.legacyPackages."${pkgs.system}".makeNixvim {
         colorschemes.kanagawa.enable = true;
         })
    ];
}
