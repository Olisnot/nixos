{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkOption types mkEnableOption mkIf concatStringsSep optionalAttrs
    listToAttrs mapAttrsToList escapeShellArg;
  cfg = config.webapps;

  mkApp = id: app:
    let
      name = app.name or (lib.toUpper (lib.substring 0 1 id)
        + lib.substring 1 (lib.stringLength id - 1) id);
      url = app.url;
      extraArgs = app.extraArgs or [ ];
      profileDir = if app.profileDir == null then "${config.xdg.dataHome}/webapps/${id}" else app.profileDir;
      categories = app.categories or [ "Network" "Utility" ];
      argsStr =
        concatStringsSep " \\\n          " (cfg.commonArgs ++ extraArgs);
      browserBin = "${cfg.browserPackage}/bin/${cfg.browserBinary}";
      script = pkgs.writeShellScriptBin "${id}-webapp" ''
        exec ${browserBin} \
          --app=${url} \
          --user-data-dir=${escapeShellArg profileDir} \
          --class=${escapeShellArg name} \
          --name=${escapeShellArg name} \
          ${argsStr} \
          "$@"
      '';
      desktopBase = {
        name = name;
        comment = "${name} web app";
        exec = "${id}-webapp";
        terminal = false;
        type = "Application";
        categories = categories;
        settings = { startupWMClass = name; };
      } // optionalAttrs (app.icon != null) { icon = app.icon; };
    in {
      inherit script;
      desktopEntry = {
        name = id;
        value = desktopBase;
      };
      iconDataFile = if app.iconDataFilePath or null != null then {
        name = "icons/${id}.${app.iconDataFileExt or "png"}";
        source = app.iconDataFilePath;
      } else
        null;
    };

  built = mapAttrsToList mkApp cfg.apps;

  # collect icon data files, skipping nulls
  iconFiles = lib.filter (x: x != null) (map (a: a.iconDataFile) built);

in {
  options.webapps = {
    enable =
      mkEnableOption "site-specific webapps via Chromium-style app windows";

    browserPackage = mkOption {
      type = types.package;
      default = pkgs.chromium;
      description =
        "Browser package to use (e.g., pkgs.chromium or pkgs.ungoogled-chromium).";
    };

    browserBinary = mkOption {
      type = types.str;
      default =
        "chromium"; # matches pkgs.chromium; change to "chromium-browser" if you must
      description = "Executable name inside the browser package.";
    };

    commonArgs = mkOption {
      type = types.listOf types.str;
      default = [
        "--no-first-run"
        "--disable-crash-reporter"
        # Wayland niceties; remove if you’re on X11:
        "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
        "--ozone-platform=wayland"
        # Keyring choices (uncomment what you use):
        # "--password-store=gnome"
        # "--password-store=kwallet"
        # "--password-store=basic"
      ];
      description = "Flags applied to all web apps.";
    };

    apps = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Human name for the app window and WM matching.";
          };
          url = mkOption {
            type = types.str;
            description = "App URL.";
          };
          extraArgs = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Extra flags for this specific app.";
          };
          profileDir = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Optional override for per-app profile directory.";
          };
          categories = mkOption {
            type = types.listOf types.str;
            default = [ "Network" "Utility" ];
            description = "Desktop entry categories.";
          };
          icon = mkOption {
            type = types.nullOr types.str;
            default = null;
            description =
              "Absolute path to icon to reference in .desktop (must exist).";
          };
          iconDataFilePath = mkOption {
            type = types.nullOr types.path;
            default = null;
            description =
              "Optional file to install into XDG data dir as icons/<id>.<ext>.";
          };
          iconDataFileExt = mkOption {
            type = types.str;
            default = "png";
            description = "Extension used if iconDataFilePath is set.";
          };
        };
      });
      default = { };
      description =
        "Attribute set of web apps keyed by an id, each with settings.";
    };
  };

  config = mkIf cfg.enable {
    # Scripts for all apps
    home.packages = map (a: a.script) built;

    # Desktop entries for all apps
    xdg.desktopEntries = listToAttrs (map (a: a.desktopEntry) built);

    # Optional: ship icons into ~/.local/share if provided
    xdg.dataFile = listToAttrs (map (f: {
      name = f.name;
      value = { source = f.source; };
    }) iconFiles);
  };
}

