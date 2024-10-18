{ pkgs, ... }:

let
  font-logos = pkgs.callPackage ./packages/font-logos.nix { inherit pkgs; };
in
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    font-awesome
    nerdfonts
    material-design-icons
    cascadia-code
    font-logos
  ];

}
