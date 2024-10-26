{ inputs, ... }:

{
  home-manager = {
                #backupFileExtension = "backup45";
		extraSpecialArgs = {inherit inputs;};
                useGlobalPkgs = true;
  };
}
