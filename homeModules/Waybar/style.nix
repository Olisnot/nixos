{ config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
  {
    programs.waybar.style = ''
    * {
      font-family: FiraCode Nerd Font Propo;
      font-size: 16px;
      color: #d8dee9;
    }

#tray menu,
window#waybar {
  background: rgba(30, 30, 46, 0.8);
}

.modules-left,
.modules-right {
  padding-right: 10px;
  padding-left: 10px;
}

#workspaces {
  padding-left: 5px;
  padding-right: 5px;
}

#custom-poweroff:hover,
#custom-restart:hover,
#custom-nixos:hover,
#workspaces button:hover {
  background: #45475a;
  border-radius: 20px;
}

#clock {
  font-size: 14px;
}

#clock,
#tray,
#group-power,
#custom-poweroff,
#custom-restart,
#custom-nixos,
#window,
#workspaces {
  padding-right: 10px;
  padding-left: 10px;
}
'';
}
