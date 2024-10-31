{ ... }:
 
{
  
  imports = [ 
    ./personal.nix
    ./work.nix
  ];
  programs.floorp.enable = true;
}
