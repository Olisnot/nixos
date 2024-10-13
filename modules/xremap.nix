{ inputs , ... }:

{
  imports = [
    inputs.xremap.nixosModules.default
  ];

  services.xremap = {
    withHypr = true;
    userName = "oliver";
    yamlConfig = /* yaml */ ''
    modmap:
      - name: main
        remap:
          CapsLock: LeftMeta
    '';
  };
}
