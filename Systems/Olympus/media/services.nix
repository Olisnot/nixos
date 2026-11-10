{
  config,
  lib,
  pkgs,
  ...
}:

let
  ports = import ./ports.nix;
  vpnAddress = config.wireguardLink.address;
  # Flat Qt INI keys allow the upstream module and this merge to share settings.
  qbittorrentDefaults =
    (pkgs.formats.ini { }).generate "qbittorrent-defaults.ini"
      config.services.qbittorrent.serverConfig;
  mergeQbittorrentConfig = pkgs.writeScript "merge-qbittorrent-config" ''
    #!${pkgs.python3}/bin/python3
    import configparser
    import os
    import tempfile

    target = "${config.services.qbittorrent.profileDir}/qBittorrent/config/qBittorrent.conf"
    def parser():
        result = configparser.ConfigParser(interpolation=None, strict=False, delimiters=("=",))
        result.optionxform = str
        return result
    existing, defaults = parser(), parser()
    existing.read(target)
    defaults.read("${qbittorrentDefaults}")
    for section in defaults.sections():
        if not existing.has_section(section):
            existing.add_section(section)
        for key, value in defaults.items(section):
            existing.set(section, key, value)
    # Preserve runtime credentials and other UI settings; never print the config.
    fd, temporary = tempfile.mkstemp(dir=os.path.dirname(target))
    try:
        with os.fdopen(fd, "w") as output:
            existing.write(output, space_around_delimiters=False)
        os.replace(temporary, target)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)
  '';
in
{
  services = {
    jellyfin = {
      enable = true;
      group = "media";
      openFirewall = false;
      # All metadata, logs and transcoding/cache remain local.
      dataDir = "/var/lib/jellyfin";
      cacheDir = "/var/cache/jellyfin";
    };
    seerr = {
      enable = true;
      stateRevision = 1;
      openFirewall = false;
      port = 5055;
    };
    sonarr = {
      enable = true;
      group = "media";
      openFirewall = false;
      settings.server = {
        port = ports.sonarr;
        bindaddress = vpnAddress;
      };
    };
    radarr = {
      enable = true;
      group = "media";
      openFirewall = false;
      settings.server = {
        port = ports.radarr;
        bindaddress = vpnAddress;
      };
    };
    prowlarr = {
      enable = true;
      openFirewall = false;
      settings.server = {
        port = ports.prowlarr;
        bindaddress = vpnAddress;
      };
    };
    bazarr = {
      enable = true;
      group = "media";
      openFirewall = false;
      settings.general = {
        port = ports.bazarr;
        ip = vpnAddress;
      };
    };
    qbittorrent = {
      enable = true;
      group = "media";
      openFirewall = false;
      webuiPort = ports.qbittorrent;
      # No public inbound torrent port is opened; outbound connections still work.
      torrentingPort = 51413;
      serverConfig = {
        BitTorrent = {
          "Session\\DefaultSavePath" = "/srv/media/downloads/torrents/complete";
          "Session\\TempPath" = "/srv/media/downloads/torrents/incomplete";
          "Session\\TempPathEnabled" = true;
          "Session\\LSDEnabled" = false;
        };
        Preferences = {
          "WebUI\\Address" = vpnAddress;
          "WebUI\\LocalHostAuth" = true;
          "WebUI\\AuthSubnetWhitelistEnabled" = false;
          "WebUI\\CSRFProtection" = true;
          "WebUI\\HostHeaderValidation" = true;
          "WebUI\\ServerDomains" = "10.77.0.1;localhost;127.0.0.1";
          "Connection\\UPnP" = false;
        };
      };
    };
    sabnzbd = {
      enable = true;
      group = "media";
      configFile = null;
      allowConfigWrite = true;
      openFirewall = false;
      settings.misc = {
        host = vpnAddress;
        port = ports.sabnzbd;
        host_whitelist = "olympus, localhost, 127.0.0.1, 10.77.0.1";
        inet_exposure = "api+web (auth needed)";
        download_dir = "/srv/media/downloads/usenet/incomplete";
        complete_dir = "/srv/media/downloads/usenet/complete";
        permissions = "0770";
      };
    };
    # API helper only: no human-facing UI and no inbound firewall allowance.
    flaresolverr = {
      enable = true;
      openFirewall = false;
    };
  };

  # The native qBittorrent module otherwise overwrites runtime passwords on each
  # start when serverConfig is used. Merge public defaults instead.
  systemd.services.qbittorrent.serviceConfig.ExecStartPre = lib.mkForce "${mergeQbittorrentConfig}";
  systemd.services.seerr.environment = {
    HOST = "127.0.0.1";
    LOG_LEVEL = "warn";
  };
  systemd.services.flaresolverr.environment = {
    HOST = "127.0.0.1";
    LOG_LEVEL = "warn";
    LOG_HTML = "false";
  };

  # Seed loopback binding and trusted proxy addresses on first start only;
  # subsequent settings are owned by Jellyfin's UI. The firewall is the second
  # boundary if a future app version or UI change alters listener behaviour.
  systemd.services.jellyfin.preStart = lib.mkBefore ''
    if [ ! -e ${config.services.jellyfin.configDir}/network.xml ]; then
      cat > ${config.services.jellyfin.configDir}/network.xml <<'EOF'
    <?xml version="1.0" encoding="utf-8"?>
    <NetworkConfiguration>
      <EnableIPv4>true</EnableIPv4>
      <EnableIPv6>false</EnableIPv6>
      <InternalHttpPort>8096</InternalHttpPort>
      <EnableHttps>false</EnableHttps>
      <RequireHttps>false</RequireHttps>
      <LocalNetworkAddresses><string>127.0.0.1</string></LocalNetworkAddresses>
      <KnownProxies><string>127.0.0.1</string><string>::1</string></KnownProxies>
      <EnableUPnP>false</EnableUPnP>
    </NetworkConfiguration>
    EOF
    fi
  '';
}
