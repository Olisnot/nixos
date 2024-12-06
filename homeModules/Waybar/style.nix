{ ... }:

{
  programs.waybar.style = ''
    * {
      font-weight: bold;
      font-size: 15px;
    }

    window#waybar {
      background-color: transparent;
      color: #fffafa;
    }

#workspaces {
  margin-left: 10px;
}

#workspaces button.active {
}

.modules-left {
  padding-left: 10px;
  padding-right: 10px;
}

.modules-right {
  padding-right: 10px;
  padding-left: 10px;
}

.modules-center {
}

#battery {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
}

#tray {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
}

#pulseaudio {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
}

#custom-power {
  padding-left: 10px;
  font-size: 18px;
}

#clock {
  padding-right: 10px;
  padding-left: 10px;
  margin-left: 10px;
}
'';
}
