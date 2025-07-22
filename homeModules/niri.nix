{ lib, config, ... }:

{
  options = {
    niri.config.enable = lib.mkEnableOption "enable niri configuration";
  };

  config = lib.mkIf config.niri.config.enable {
    home.file."config.kdl" = {
      enable = true;
      target = "/home/oliver/.config/niri/config.kdl";
      text = ''
      workspace "media"
      workspace "browser"
      workspace "terminal"
      workspace "obsidian"
      workspace "gaming"
      workspace "social"
      workspace "extern-monitor" {
              open-on-output "HDMI-A-1"
      }

      input {
          keyboard {
              xkb {
              }
          }

          touchpad {
              tap
              natural-scroll
          }

          mouse {
          }

          trackpoint {
          }
      }

      output "eDP-1" {
          off
      }

      output "DP-1" {
          mode "1920x1080@60"
          scale 1
      }

      output "HDMI-A-1" {
          mode "1920x1080@60"
          scale 1
      }

      cursor {
          xcursor-theme "Capitaine Cursors"
          xcursor-size 24
      }

      layout {
          gaps 16

          center-focused-column "never"

          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }

          default-column-width { proportion 0.5; }
          focus-ring {
              width 4
              active-color "#4c4c4c"
              inactive-color "#505050"
          }

          border {
              off
              width 4
              active-color "#ffc87f"
              inactive-color "#505050"
          }

          shadow {
              softness 30
              spread 5
              offset x=0 y=5
              color "#0007"
          }

          struts {
          }
      }

      spawn-at-startup "swww-daemon"
      spawn-at-startup "xwayland-satellite"
      spawn-at-startup "waybar"
      spawn-at-startup "zen-beta"
      spawn-at-startup "ghostty"
      spawn-at-startup "obsidian"
      spawn-at-startup "tidal-hifi"
      spawn-at-startup "steam"

      environment {
          DISPLAY ":0"
      }

      prefer-no-csd

      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      window-rule {
          match app-id=r#"ghostty$"# at-startup=true
          default-column-width {}
          open-on-workspace "terminal"
          open-maximized true
      }

      // miru rule
      window-rule {
          match app-id=r#"Miru$"#
          open-on-workspace "media"
              open-maximized true
      }

      // miru rule
      window-rule {
          match app-id=r#"tidal-hifi$"# at-startup=true
          open-on-workspace "media"
              open-maximized true
      }

      // Librewolf rules
      window-rule {
          match app-id=r#"zen-beta$"#
          open-on-workspace "browser"
      }

      window-rule {
          match app-id=r#"zen-beta$"# at-startup=true
          open-on-workspace "browser"
          open-maximized true
      }

      window-rule {
          match app-id=r#"zen-beta$"# title="^Picture-in-Picture$"
          open-floating true
      }

      //obsidian rule
      window-rule {
          match app-id=r#"obsidian$"#
          open-on-workspace "obsidian"
              open-maximized true
      }

      // steam rule
      window-rule {
          match app-id=r#"steam$"#
          open-on-workspace "gaming"
              open-maximized true
      }

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+return { spawn "ghostty"; }
          Mod+Space { spawn "anyrun"; }
          Super+Alt+L { spawn "gtklock"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
          XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

          Mod+C { close-window; }

          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-down; }
          Mod+K     { focus-window-up; }
          Mod+L     { focus-column-right; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Down  { move-window-down; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+H     { move-column-left; }
          Mod+Ctrl+J     { move-window-down; }
          Mod+Ctrl+K     { move-window-up; }
          Mod+Ctrl+L     { move-column-right; }

          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }

          Mod+Shift+Left  { focus-monitor-left; }
          Mod+Shift+Down  { focus-monitor-down; }
          Mod+Shift+Up    { focus-monitor-up; }
          Mod+Shift+Right { focus-monitor-right; }
          Mod+Shift+H     { focus-monitor-left; }
          Mod+Shift+J     { focus-monitor-down; }
          Mod+Shift+K     { focus-monitor-up; }
          Mod+Shift+L     { focus-monitor-right; }

          Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+U              { focus-workspace-down; }
          Mod+I              { focus-workspace-up; }
          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
          Mod+Ctrl+U         { move-column-to-workspace-down; }
          Mod+Ctrl+I         { move-column-to-workspace-up; }

          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Shift+Page_Up   { move-workspace-up; }
          Mod+Shift+U         { move-workspace-down; }
          Mod+Shift+I         { move-workspace-up; }

          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight      { focus-column-right; }
          Mod+WheelScrollLeft       { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft  { move-column-left; }

          Mod+Shift+WheelScrollDown      { focus-column-right; }
          Mod+Shift+WheelScrollUp        { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

          Mod+1 { focus-workspace "media"; }
          Mod+2 { focus-workspace "browser"; }
          Mod+3 { focus-workspace "terminal"; }
          Mod+4 { focus-workspace "obsidian"; }
          Mod+5 { focus-workspace "gaming"; }
          Mod+6 { focus-workspace  "social"; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+0 { focus-workspace "extern-monitor"; }
          Mod+Shift+1 { move-column-to-workspace "media"; }
          Mod+Shift+2 { move-column-to-workspace "browser"; }
          Mod+Shift+3 { move-column-to-workspace "terminal"; }
          Mod+Shift+4 { move-column-to-workspace "obsidian"; }
          Mod+Shift+5 { move-column-to-workspace "gaming"; }
          Mod+Shift+6 { move-column-to-workspace  "social"; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+Shift+9 { move-column-to-workspace 9; }
          Mod+Shift+0 { move-column-to-workspace "extern-monitor"; }

          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          Mod+Comma  { consume-window-into-column; }
          Mod+Period { expel-window-from-column; }

          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }

          Mod+Ctrl+F { expand-column-to-available-width; }

          Mod+Q { center-column; }

          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }

          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          Mod+V       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }

          Mod+W { toggle-column-tabbed-display; }

          Mod+Shift+S { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }

          Mod+Shift+P { spawn "playerctl" "play-pause"; }
          Mod+Shift+N { spawn "playerctl" "next"; }
          Mod+Shift+T { spawn "playerctl" "previous"; }

          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

          Mod+Shift+E { quit; }
          Ctrl+Alt+Delete { quit; }

          Mod+Shift+Y { power-off-monitors; }
      }
        '';
      };
  };
  }
