{ ... }:

{
  # Import only the proxy, not Zeus's desktop/media/service module collection.
  imports = [ ../../nixosModules/services/caddy.nix ];

  caddyReverseProxy = {
    enable = true;
    openFirewall = true;
    waf.enable = true;

    # Deliberately empty until backends and public exposure are approved.
    # Real candidate hostnames from nixosModules/media/nixarr/reverse-proxy.nix:
    # jellyfin.opmsonline.org and navidrome.opmsonline.org.
    # Do not copy Zeus's 127.0.0.1 upstreams: they are local to Zeus, not Olympus.
    hosts = { };
  };
}
