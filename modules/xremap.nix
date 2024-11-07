{ lib, config, inputs , ... }:

{
  imports = [
    inputs.xremap.nixosModules.default
  ];

  options = {
    xremap.mappings.enable = lib.mkEnableOption "Enable xremap remappings";
  };

  config = lib.mkIf config.xremap.mappings.enable {
    services.xremap = {
      userName = "oliver";
      yamlConfig = /* yaml */ ''
      modmap:
      - name: main
      remap:
      CapsLock: LeftMeta
      '';
    };
  };
}
