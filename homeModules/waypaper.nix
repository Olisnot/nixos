{ inputs, config, lib, ... }:

{
  options = {
    waypaper.enable = lib.mkEnableOption "Enable waypaper";
  };

  config = lib.mkIf config.waypaper.enable {
    home.file."waypaper_config" = {
      enable = true;
      target = ".config/waypaper/config.ini";
      text = /* TOML */''
      [Settings]
      language = en
      folder = ${inputs.wallpapers}
      monitors = All
      backend = swww
      fill = fill
      sort = name
      color = #ffffff
      subfolders = True
      show_hidden = False
      show_gifs_only = False
      post_command =
      number_of_columns = 3
      swww_transition_type = any
      swww_transition_step = 90
      swww_transition_angle = 0
      swww_transition_duration = 2
      swww_transition_fps = 60
      use_xdg_state = False
      '';
    };
  };
}
