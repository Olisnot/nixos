{ lib, config, ... }:

{
  options = {
    hyprlockConfig.enable = lib.mkEnableOption "Enable hyprlock config";
  };

  config = lib.mkIf config.hyprlockConfig.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        input-field = {
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          fade_on_empty = true;
          fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
          placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;
          rounding = -1; # -1 means complete rounding (circle/oval)
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
          fail_transition = 300; # transition time in ms between normal outer_color and fail_color
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false; # change color if numlock is off
          swap_font_color = false; # see below
          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        label = [ {
    #clock
    text = "cmd[update:1000] echo \"$TIME\"";
    font_size = 55;
    font_family = "Fira Semibold";
    position = "-100, 70";
    halign = "right";
    valign = "bottom";
    shadow_passes = 5;
    shadow_size = 10;
  }

  {
    text = "$USER";
    font_size = 20;
    font_family = "Fira Semibold";
    position = "-100, 160";
    halign = "right";
    valign = "bottom";
    shadow_passes = 5;
    shadow_size = 10;
  }

];

  };
};
};
}
