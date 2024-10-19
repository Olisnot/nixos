{ ... }:

{
  programs.waybar.style = ''
    * {
      font-family: 'Font Awesome 6 Free', 'Font Awesome 6 Brands';
      font-weight: bold;
      font-size: 15px;
      border-radius: 10px;
    }

    window#waybar {
      background-color: transparent;
      color: #fffafa;
    }

#workspaces {
  font-family: 'Material Design Icons';
  margin-left: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}

#workspaces button.active {
  font-family: 'Material Design Icons';
  background-color: #fffafa;
  color: #100c08;
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
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}

#tray {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}

#pulseaudio {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}

#custom-power {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
  font-size: 50px;
}

#custom-reboot {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}

#custom-suspend {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}

#custom-logout {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}

#clock {
  font-family: 'Cascadia Code';
  padding-right: 10px;
  padding-left: 10px;
  margin-left: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}
'';
}
