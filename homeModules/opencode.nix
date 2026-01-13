{ lib, config, ... }:

{
  options.opencode.enable =
    lib.mkEnableOption "Enable open code the open AI coding assistant";

  config = lib.mkIf config.opencode.enable { programs.opencode.enable = true; };
}
