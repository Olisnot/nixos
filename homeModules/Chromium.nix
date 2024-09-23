{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;

    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } #Ublock origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } #Bitwarden
    ];
  };
}
