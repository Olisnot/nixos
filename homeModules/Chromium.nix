{ pkgs, builtins, lib, ...}:

{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;

    extensions =
      let
        createChromiumExtensionFor = browserVersion: { id, version }:
        {
          inherit id;
          crxPath = builtins.fetchurl {
            url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
            name = "${id}.crx";
          };
          inherit version;
        };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
      in
      [
        (createChromiumExtension {
      # ublock origin
      id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      version = "1.59.0";
    })
    (createChromiumExtension {
      # Bitwarden
      id = "nngceckbapebfimnlniiiahkandclblb";
      version = "2024.9.1";
    })
  ];
  };
}
