{ pkgs, lib, config, ... }:

{
  options = {
    hyprlandConfig.enable = lib.mkEnableOption "Enable hyprland configuration";
  };

  config = lib.mkIf config.hyprlandConfig.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # plugins = with pkgs.hyprlandPlugins; [ hyprscrolling ];
      settings = {
        monitor = [ ",preffered,auto,auto" "Unknown-1, disable" ];

        ###################
        ### MY PROGRAMS ###
        ###################

        "$terminal" = "ghostty";
        "$fileManager" = "nautilus";
        "$menu" = "wofi --show drun -a --prompt select";

        #################
        ### AUTOSTART ###
        #################

        exec-once = [
          "swww-daemon & dunst"
          "nm-applet"
          "blueman-applet"
          "waybar"
          "kdeconnect-indicator"
          "altus"
          ''hyprctl dispatch exec "[workspace 3]" ghostty''
          ''hyprctl dispatch exec "[workspace 4]" tutanota-desktop''
        ];

        xwayland = { force_zero_scaling = true; };

        general = {
          gaps_in = 5;
          gaps_out = 20;

          border_size = 1;

          resize_on_border = false;
          allow_tearing = false;
          layout = "scrolling";
        };

        decoration = {
          rounding = 10;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          blur = {
            enabled = true;
            size = 3;
            passes = 2;

            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        input = {
          kb_layout = "us, us";
          kb_variant = ", dvorak";

          follow_mouse = 0;

          sensitivity = 0;

          touchpad = { natural_scroll = false; };
        };

        gestures = { workspace_swipe = false; };

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, return, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, Space, exec, $menu"
          "$mainMod ALT, Space, exec, power_menu"
          "$mainMod, J, togglesplit,"
          "$mainMod, F, fullscreen"
          "$mainMod SHIFT, return, exec, hyprlock"
          "$mainMod, W, exec, waypaper"
          "$mainMod, Z, exec, pwvucontrol"
          "$mainMod, B, exec, blueman-manager"
          "$mainMod, M, exec, tutanota-desktop"

          "$mainMod SHIFT ALT, M, exit,"

          # Screen Capture
          "$mainMod, S, exec, hyprshot -m region -o ~/Pictures/Screenshots"

          # Move focus with mainMod + arrow keys
          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          # Move window with mainMod + Shift + arrow keys
          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, l, movewindow, r"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, j, movewindow, d"

          # "$mainMod SHIFT, h, layoutmsg, movewindowto l"
          # "$mainMod SHIFT, l, layoutmsg, movewindowto r"
          # "$mainMod SHIFT, k, layoutmsg, movewindowto u"
          # "$mainMod SHIFT, j, layoutmsg, movewindowto d"

          # Resize window with mainMod + Alt + arrow keys
          "$mainMod ALT, l, resizeactive, 10 0"
          "$mainMod ALT, h, resizeactive, -10 0"
          "$mainMod ALT, k, resizeactive, 0 -10"
          "$mainMod ALT, j, resizeactive, 0 10"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Pin floating window
          "$mainMod, P, pin"

          "$mainMod SHIFT, P, exec, rmpc togglepause"
          "$mainMod SHIFT, N, exec, rmpc next"
          "$mainMod SHIFT, T, exec, rmpc prev"

          ##############################
          ### WINDOWS AND WORKSPACES ###
          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # "$mainMod, R, layoutmsg, colresize +conf"
          # "$mainMod SHIFT, F, layoutmsg, colresize 1.0"
        ];

        bindl = [
          ''
            , switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"''
          ''
            , switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preffered, 0x0, 1"''
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        windowrulev2 = [
          "suppressevent maximize, class:.* "
          "workspace 1 silent, class:obsidian"
          "workspace 2 silent, class:zen-beta"
          "workspace 3 silent, class:dev.zed.Zed"
          "workspace 4 silent, class:vesktop"
          "workspace 5 silent, class:steam"
          "workspace 5 silent, class:heroic"
          "workspace 5 silent, class:lutris"
          "float, class:waypaper"
          "float, class:com.saivert.pwvucontrol"
          "float, class:.blueman-manager-wrapped"
          "float, class:localsend_app"
        ];

        workspace = [
          "1,monitor:HDMI-A-1"
          "2,monitor:HDMI-A-1"
          "3,monitor:HDMI-A-1"
          "4,monitor:HDMI-A-1"
          "5,monitor:HDMI-A-1"
          "6,monitor:HDMI-A-1"
          "7,monitor:HDMI-A-1"
          "8,monitor:HDMI-A-1"
          "9,monitor:HDMI-A-1"
          "10,monitor:eDP-1"
        ];
      };
    };
    services.hyprpolkitagent.enable = true;
    home.packages = with pkgs; [ hyprshot ];
  };
}
