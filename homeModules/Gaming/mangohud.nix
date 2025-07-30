{ lib, config, ... }:

{
  options = {
    gaming.mangohud.enable = lib.mkEnableOption "Enable mangohud";
  };

  config = lib.mkIf config.gaming.mangohud.enable {
    stylix.targets.mangohud.enable = false;
    programs.mangohud = { enable = true; };
    home.file.".config/mangohud/mangohud.conf".text = ''
    legacy_layout=false
    round_corners=10
    background_alpha=0.8
    background_color=1E1E2E
    table_columns=3

    font_size=24
    text_color=CDD6F4
    text_outline_color=313244

    gpu_text=GPU
    gpu_stats
    gpu_temp
    gpu_color=A6E3A1
    gpu_load_change
    gpu_load_color=CDD6F4,FAB387,F38BA8

    cpu_text=CPU
    cpu_stats
    cpu_temp
    cpu_color=89B4FA
    cpu_load_change
    cpu_load_color=CDD6F4,FAB387,F38BA8

    ram
    ram_color=F5C2E7

    engine_color=F38BA8

    fps
    fps_color_change=F38BA8,F9E2AF,A6E3A1

    wine
    wine_color=F38BA8

    frame_timing
    frametime_color=A6E3A1

    arch
    fps_limit_method=early
    toggle_fps_limit=Shift_L+F1
    '';
  };
}
