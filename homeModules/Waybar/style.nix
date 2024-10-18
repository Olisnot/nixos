{ ... }:

{
  programs.waybar.style = ''
    * {
      font-family: 'SF Mono', sans-serif;
      font-weight: bold;
      font-size: 13px;
      border-radius: 10px;
    }

    window#waybar {
      background-color: transparent;
      color: #fffafa;
    }

#workspaces {
  margin-left: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
  font-size: 25px;
}

#workspaces button.active {
  background-color: #fffafa;
  color: #100c08;
  font-size: 25px;
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
  font-size: 20px;
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
  padding-right: 10px;
  padding-left: 10px;
  margin-left: 10px;
  background-color: #100c08;
  color: #fffafa;
  border: 1px solid #fffafa;
}
'';
}
