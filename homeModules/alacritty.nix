{ ... }:

{
	programs.alacritty = {
		enable = true;
		settings = {
			colors.bright = {
                          black     = "#1e1e1e";
                          red       = "#ff5f5f";
                          green     = "#f7f7f7";
                          yellow    = "#efef00";
                          blue      = "#338fff";
                          magenta   = "#ff66ff";
                          cyan      = "#00eff0";
                          white     = "#989898";
			};

			colors.normal = {
                          black     = "#000000";
                          red       = "#ff5f59";
                          green     = "#f7f7f7";
                          yellow    = "#d0bc00";
                          blue      = "#2fafff";
                          magenta   = "#feacd0";
                          cyan      = "#00d3d0";
                          white     = "#ffffff";
			};

			colors.primary = {
                          background   = "#000000";
                          foreground   = "#ffffff";
			};

                        window = {
                          opacity = 0.7;
                        };

                        font = {
                          bold = {
                            family = "cascadia-mono";
                            style = "Bold";
                          };
                          bold_italic = {
                            family = "cascadia-mono";
                            style = "Bold Italic";
                          };
                          italic = {
                            family = "cascadia-mono";
                            style = "Italic";
                          };
                          normal = {
                            family = "cascadia-mono";
                            style = "Regular";
                          };
                        };

		};
	};
}
