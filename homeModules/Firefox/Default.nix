{ ... }:
 
{
  
  imports = [ 
    ./Personal.nix
    ./Work.nix
  ];
  programs.firefox = { 
    enable = true;
  };
}
