{ lib, config, ... }:

{
  options = {
    starship.enable = lib.mkEnableOption "Enable starship cross shell prompt";
  };

  config = lib.mkIf config.starship.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[](base03)"
          "$os"
          "$directory"
          "$git_branch"
          "$nix_shell"
          "$c"
          "$python"
          "$golang"
          "$rust"
          "$zig"
          "$haskell"
          "$dotnet"
          "[ ](bg:base01)"
          "[](base01)"
          "$line_break"
          "$character"
        ];

        os = {
          format = "[$symbol]($style)";
          style = "bg:base03";
          disabled = false;
        };

        os.symbols = {
          NixOS = " ";
          Arch = " ";
          Gentoo = " ";
          Debian = " ";
          Ubuntu = " ";
          Mint = " ";
          Fedora = " ";
          FreeBSD = " ";
          Kali = " ";
          Macos = " ";
          Windows = " ";
        };

        directory = {
          style = "bg:base03";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "";
        };

        git_branch = {
          symbol = "";
          style = "bg:base01";
          format = "[ $symbol $branch ]($style)";

        };

        character = {
          success_symbol = "[](base06)";
          error_symbol = "[](base08)";
        };

        nix_shell = {
          format = "[ $symbol $state ]($style)";
          style = "bg:base01";
          impure_msg = "Nix Shell";
          pure_msg = "Nix Shell";
          symbol = "";
        };

        c = {
          format = "[ $symbol $name $version]($style)";
          symbol = "";
          style = "bg:base01";
        };

        golang = {
          format = "[ $symbol $version]($style)";
          symbol = "";
          style = "bg:base01";
        };

        python = {
          format = "[ $symbol $version]($style)";
          symbol = "";
          style = "bg:base01";
        };

        rust = {
          format = "[ $symbol $version]($style)";
          symbol = "";
          style = "bg:base01";
        };

        zig = {
          format = "[ $symbol $version]($style)";
          symbol = "";
          style = "bg:base01";
        };

        haskell = {
          format = "[ $symbol $version]($style)";
          symbol = "";
          style = "bg:base01";
        };

        dotnet = {
          format = "[ $symbol $version]($style)";
          symbol = "";
          style = "bg:base01";
        };
      };
    };
  };
}
