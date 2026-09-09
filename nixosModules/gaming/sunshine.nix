{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.gaming.sunshine;
  steam = lib.getExe config.programs.steam.package;
  setsid = lib.getExe' pkgs.util-linux "setsid";
in
{
  options.gaming.sunshine = {
    enable = lib.mkEnableOption "Sunshine game streaming host";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open Sunshine and Moonlight ports in the firewall.";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start Sunshine with the graphical user session.";
    };

    capSysAdmin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Grant Sunshine CAP_SYS_ADMIN for DRM/KMS capture.";
    };

    steamBigPicture.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.gaming.steam.enable;
      defaultText = lib.literalExpression "config.gaming.steam.enable";
      description = "Expose Steam Big Picture as a Sunshine application.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.steamBigPicture.enable || config.gaming.steam.enable;
        message = "gaming.sunshine.steamBigPicture.enable requires gaming.steam.enable.";
      }
    ];

    services.sunshine = {
      enable = true;
      openFirewall = cfg.openFirewall;
      autoStart = cfg.autoStart;
      capSysAdmin = cfg.capSysAdmin;

      settings.csrf_allowed_origins = "https://sunshine.opmsonline.org";

      applications.apps = lib.mkIf cfg.steamBigPicture.enable [
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
        {
          name = "Steam Big Picture";
          detached = [
            "${setsid} ${steam} steam://open/bigpicture"
          ];
          prep-cmd = [
            {
              do = "";
              undo = "${setsid} ${steam} steam://close/bigpicture";
            }
          ];
          image-path = "steam.png";
        }
      ];
    };
  };
}
