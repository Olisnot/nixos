{ ... }:
 
{
  
  imports = [ 
    ./Personal.nix
  ];
  programs.firefox = { 
    enable = true;
  };
}
