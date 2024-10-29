{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
################
### MONITORS ###
################

# See https://wiki.hyprland.org/Configuring/Monitors/
monitor= [ 
  "DP-3,1920x1080,0x1080,1"
  "DP-4,1920x1080,19200x1080,1"
  "eDP-1,1920x1080,192000x0,1"
  "Unknown-1, disable"
];


###################
### MY PROGRAMS ###
###################

# See https://wiki.hyprland.org/Configuring/Keywords/

# Set programs that you use
"$terminal" = "alacritty";
"$fileManager" = "alacritty --command ranger";
"$menu" = "wofi --show run";


#################
### AUTOSTART ###
#################

# Autostart necessary processes (like notifications daemons, status bars, etc.)
# Or execute your favorite apps at launch like this:

# exec-once = $terminal
# exec-once = nm-applet &
exec-once = [ 
  "swww-daemon & dunst" 
  "waybar"
  "hyprctl dispatch exec \"[workspace 1; fullscreen]\" alacritty"
  "firefox"
  "webcord"
  "steam"
  "thunderbird"
];

#############################
### ENVIRONMENT VARIABLES ###
#############################

# See https://wiki.hyprland.org/Configuring/Environment-variables/

#env = [ 
  #"XCURSOR_SIZE,16"
  #"XCURSOR_THEME,\"${pkgs.graphite-cursors}\""
#];


#####################
### LOOK AND FEEL ###
#####################

# Refer to https://wiki.hyprland.org/Configuring/Variables/

# https://wiki.hyprland.org/Configuring/Variables/#general
general = {
  gaps_in = 5;
  gaps_out = 20;

  border_size = 1;

    # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
    "col.active_border" = "rgba(fffafaaa)";
    "col.inactive_border" = "rgba(595959aa)";

    # Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false;

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false;

    layout = "dwindle";
  };

# https://wiki.hyprland.org/Configuring/Variables/#decoration
decoration = {
  rounding = 10;

    # Change transparency of focused and unfocused windows
    active_opacity = 1.0;
    inactive_opacity = 1.0;

    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";

    # https://wiki.hyprland.org/Configuring/Variables/#blur
    blur = {
      enabled = true;
      size = 3;
      passes = 1;

      vibrancy = 0.1696;
    };
  };

# https://wiki.hyprland.org/Configuring/Variables/#animations
animations = {
  enabled = true;

    # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

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

# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
dwindle = {
  pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
  preserve_split = true; # You probably want this
};

# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
#master {
    #new_is_master = true
#}

# https://wiki.hyprland.org/Configuring/Variables/#misc
misc = {
  force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
  disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
  };


#############
### INPUT ###
#############

# https://wiki.hyprland.org/Configuring/Variables/#input
input = {
  kb_layout = "us, us";
  kb_variant = ", dvorak";
  kb_options = "grp:alt_shift_toggle";

  follow_mouse = 0;

  sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

  touchpad = {
    natural_scroll = false;
  };
};

# https://wiki.hyprland.org/Configuring/Variables/#gestures
gestures = {
  workspace_swipe = false;
};

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
device = {
  name = "epic-mouse-v1";
  sensitivity = -0.5;
};


####################
### KEYBINDINGSS ###
####################

# See https://wiki.hyprland.org/Configuring/Keywords/
"$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = [
  "$mainMod, return, exec, $terminal"
  "$mainMod, C, killactive,"
  "$mainMod, M, exit,"
  "$mainMod, E, exec, $fileManager"
  "$mainMod, V, togglefloating,"
  "$mainMod, Space, exec, $menu"
  "$mainMod, P, pseudo, # dwindle"
  "$mainMod, J, togglesplit," # dwindle
  "$mainMod, F, fullscreen"
  "$mainMod, L, exec, hyprlock"

# Screen Capture
"$mainMod SHIFT, S, exec, \"slurp | grim -g - screenshot.png\""

# Move focus with mainMod + arrow keys
"$mainMod, left, movefocus, l"
"$mainMod, right, movefocus, r"
"$mainMod, up, movefocus, u"
"$mainMod, down, movefocus, d"

# Move window with mainMod + Shift + arrow keys
"$mainMod SHIFT, left, movewindow, l"
"$mainMod SHIFT, right, movewindow, r"
"$mainMod SHIFT, up, movewindow, u"
"$mainMod SHIFT, down, movewindow, d"

# Resize window with mainMod + Alt + arrow keys
"$mainMod ALT, right, resizeactive, 10 0"
"$mainMod ALT, left, resizeactive, -10 0"
"$mainMod ALT, up, resizeactive, 0 -10"
"$mainMod ALT, down, resizeactive, 0 10"

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

# Example special workspace (scratchpad)
"$mainMod, S, togglespecialworkspace, magic"
"$mainMod SHIFT, S, movetoworkspace, special:magic"

# Scroll through existing workspaces with mainMod + scroll
#bind = $mainMod, mouse_down, workspace, e+1
#bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging


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

# Example special workspace (scratchpad)
"$mainMod, S, togglespecialworkspace, magic"
"$mainMod SHIFT, S, movetoworkspace, special:magic"

# Scroll through existing workspaces with mainMod + scroll
#bind = $mainMod, mouse_down, workspace, e+1
#bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
];

bindm = [
  "$mainMod, mouse:272, movewindow"
  "$mainMod, mouse:273, resizewindow"
  "$mainMod, mouse:272, movewindow"
  "$mainMod, mouse:273, resizewindow"
];
##############################
### WINDOWS AND WORKSPACES ###
##############################

# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
# See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

# Example windowrule
# windowrule = float, ^(kitty)$

# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

windowrule= [ 
  "workspace 8,title:Spotify Premium"
  "float, ^(honkers-railway-launcher)$"
];

windowrulev2 = [ 
  "suppressevent maximize, class:.* "
  "workspace 2 silent, class:firefox"
  "workspace 4 silent, class:obsidian"
  "workspace 5 silent, class:steam"
  "workspace 5 silent, class:Lutris"
  "workspace 7 silent, class:thunderbird"
  "workspace 9 silent, class:vesktop"
];

workspace= [ 
  "1,monitor:DP-1"
  "2,monitor:DP-1"
  "3,monitor:DP-1"
  "4,monitor:DP-1"
  "5,monitor:DP-1"
  "6,monitor:HDMI-A-1"
  "7,monitor:HDMI-A-1"
  "8,monitor:HDMI-A-1"
  "9,monitor:HDMI-A-1"
  "10,monitor:eDP-1"
];
  };
};
}
