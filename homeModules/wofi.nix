{ config, lib, ... }:

{
  options = { wofi.enable = lib.mkEnableOption "wofi"; };

  config = lib.mkIf config.wofi.enable {
    stylix.targets.wofi.enable = true;
    programs.wofi = {
      enable = true;

      settings = {
        allow_images = true;
        hide_scroll = true;
        no_actions = false;
      };

      style = ''
        /* The name of the window itself */
        #window {
          border-radius: 1rem;
          font-size: 1.2rem;
        }
        #window #outer-box #input {
          border-radius: 1rem 1rem 0 0;
        }

        row:nth-child(even) {
            background-color: #2e2e3e;
        }
      '';
    };
  };
}
