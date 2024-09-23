{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;

    extensions = [
      { 
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        updateUrl = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=126.0&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26installsource%3Dondemand%26uc";
      } #Ublock origin

      { 
        id = "nngceckbapebfimnlniiiahkandclblb";
        updateUrl = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=126.0&x=id%3Dnngceckbapebfimnlniiiahkandclblb%26installsource%3Dondemand%26uc";
      } #Bitwarden

    ];
  };
}
