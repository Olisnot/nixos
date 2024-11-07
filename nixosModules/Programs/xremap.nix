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
      # YAML indentation matters
      yamlConfig = /* yaml */ ''
      modmap:
      - name: main
        remap:
          CapsLock: LeftMeta
      '';
    };
  };
}
