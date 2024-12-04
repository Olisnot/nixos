{ ... }:

{
  programs.waybar.style = ''
    * {
      font-family: 'Font Awesome 6 Free', 'Font Awesome 6 Brands';
      font-weight: bold;
      font-size: 15px;
    }

    window#waybar {
      background-color: transparent;
      color: #fffafa;
    }

#workspaces {
  font-family: 'Material Design Icons';
  margin-left: 10px;
}

#workspaces button.active {
  font-family: 'Material Design Icons';
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
  font-family: 'Cascadia Code';
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
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  font-size: 30px;
}

#clock {
  font-family: 'Cascadia Code';
  padding-right: 10px;
  padding-left: 10px;
  margin-left: 10px;
}
'';
}
