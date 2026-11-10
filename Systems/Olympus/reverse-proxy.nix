{ ... }:

{
  # Import only the proxy, not Zeus's desktop/media/service module collection.
  imports = [ ../../nixosModules/services/caddy.nix ];

  caddyReverseProxy = {
    enable = true;
    openFirewall = true;
    waf.enable = true;

    hosts = {
      "jellyfin.opmsonline.org" = {
        upstream = "127.0.0.1:8096";
        waf.mode = "DetectionOnly";
        readyFile = "/var/lib/caddy/public-ready/jellyfin";
      };
      "seerr.opmsonline.org" = {
        upstream = "127.0.0.1:5055";
        waf.mode = "DetectionOnly";
        readyFile = "/var/lib/caddy/public-ready/seerr";
      };
    };
  };
}
