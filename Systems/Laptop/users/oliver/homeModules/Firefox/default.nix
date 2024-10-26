{ ... }:
 
{
  
  imports = [ 
    ./personal.nix
    ./work.nix
  ];
  programs.firefox = { 
    enable = true;
  };
}
