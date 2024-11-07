{ inputs, ... }:

{
  imports = [
    inputs.xremap.nixosModules.default
  ];

  services.xremap = {
    userName = "oliver";
    yamlConfig = /* yaml */ ''
    modmap:
    - name: main
      remap:
        CapsLock: LeftMeta
    '';
  };
}
