{ ... }:

{
  programs.waybar.style = ''
    * {
      font-family: 'SF Mono', sans-serif;
      font-weight: bold;
      font-size: 15px;
      border-radius: 10px;
    }

    window#waybar {
      background-color: transparent;
      color: #ebdbb2;
    }

#workspaces {
  background-color: #16161D;
  color: #C8C093;
  margin-left: 10px;
  border: 1px solid #C8C093;
}

#workspaces button.active {
  background-color: #C8C093;
  color: #282828;
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
  color: #C8C093;
  background-color: #16161D;
  border: 1px solid #C8C093;
}

#tray {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  color: #C8C093;
  background-color: #16161D;
  border: 1px solid #C8C093;
}

#pulseaudio {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  color: #C8C093;
  background-color: #16161D;
  border: 1px solid #C8C093;
}

#custom-power {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  color: #C8C093;
  background-color: #16161D;
  border: 1px solid #C8C093;
}

#custom-reboot {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  color: #C8C093;
  background-color: #16161D;
  border: 1px solid #C8C093;
}

#custom-suspend {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  color: #C8C093;
  background-color: #16161D;
  border: 1px solid #C8C093;
}

#custom-logout {
  padding-right: 10px;
  padding-left: 10px;
  margin-right: 10px;
  color: #C8C093;
  background-color: #16161D;
  border: 1px solid #C8C093;
}

#clock {
  padding-right: 10px;
  padding-left: 10px;
  margin-left: 10px;
  background-color: #16161D;
  color: #C8C093;
  border: 1px solid #C8C093;
}
'';
}
