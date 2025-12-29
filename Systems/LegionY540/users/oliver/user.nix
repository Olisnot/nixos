{ inputs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.oliver = {
    isNormalUser = true;
    description = "Oliver";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    backupFileExtension = "backup";
    backupCommand = pkgs.writeShellScript "hm-backup" ''
    # $1 is the path to the existing file
    backup="$1.backup"

    # Remove any previous backup
    rm -f "$backup"

    # Move the existing file out of the way
    mv "$1" "$backup"
    '';
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = { "oliver" = import ./home.nix; };
  };
}
