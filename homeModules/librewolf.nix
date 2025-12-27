{ lib, config, pkgs, ... }:

{
  options.librewolf.enable = lib.mkEnableOption "librewolf web browser";

  config = lib.mkIf config.librewolf.enable {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf-bin;
      profiles."default" = {
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            vimium
            bitwarden
            youtube-recommended-videos
            libredirect
            proton-vpn
          ];
        };
      };
    };

    stylix.targets.librewolf = {
      enable = true;
      profileNames = [ "default" ];
    };
  };
}
