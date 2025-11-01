{ pkgs }:

pkgs.writeShellApplication {
  name = "power_menu";
  text = # bash
    ''
      choice=$(printf "⏻ Shutdown\n Reboot" | wofi --show dmenu --prompt "" -W 15% -H 20%)
      action=""

      case "$choice" in
          "⏻ Shutdown")
              action="systemctl poweroff"
              ;;
          " Reboot")
              action="systemctl reboot"
              ;;
          "󰤄 Suspend")
              action="systemctl suspend"
              ;;
          *)
              exit 0
              ;;
      esac

      confirmation=$(printf "No\nYes" | wofi --show dmenu --prompt "Confirm?" -W 10% -H 10%)
      case "$confirmation" in
          No)
              exit 0
              ;;
          Yes)
              $action
              ;;
      esac
    '';
}
