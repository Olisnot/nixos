{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Olisnot";
        email = "oliver@opmsonline.org";
      };
    };
  };

  programs.fish.shellAliases = {
    gd = "git diff";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gu = "git pull";
    gl = "git log";
    gb = "git branch";
    gcl = "git clone";
  };
}

