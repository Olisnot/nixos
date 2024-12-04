{ pkgs, lib, config, ... }:

let
  colors = config.lib.stylix.colors;
in
{
  options = {
    fish.enable = lib.mkEnableOption "Enable friendly interactive shell";
  };

  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
      set fish_greeting # Disable greeting
      '';

      shellAliases = {
        c = "clear";
        sudovim = "sudo -E nvim .";
        vim = "nvim .";
        tb = "cd /mnt/1tb";
      };
      plugins = [
        { name = "bobthefish"; src = pkgs.fishPlugins.bobthefish.src; }
      ];
    };

    home.file."bobthefish.fish" = {
      enable = true;
      target = ".config/fish/conf.d/bobthefish.fish";
      text = /* fish */''
      set -g theme_display_git_dirty no
      set -g theme_display_git_default_branch yes
      set -g theme_display_nix yes
      function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'
        __bobthefish_colors base16-dark

        set -l base00 ${colors.base00}
        set -l base01 ${colors.base01}
        set -l base02 ${colors.base02}
        set -l base03 ${colors.base03}
        set -l base04 ${colors.base04}
        set -l base05 ${colors.base05}
        set -l base06 ${colors.base06}
        set -l base07 ${colors.base07}
        set -l base08 ${colors.base08}
        set -l base09 ${colors.base09}
        set -l base0A ${colors.base0A}
        set -l base0B ${colors.base0B}
        set -l base0C ${colors.base0C}
        set -l base0D ${colors.base0D}
        set -l base0E ${colors.base0E}
        set -l base0F ${colors.base0F}

        set -l colorfg $base02

        set -x color_initial_segment_exit     $base01 $base08 --bold
        set -x color_initial_segment_private  $base01 $base04 --bold
        set -x color_initial_segment_su       $base01 $base0B --bold
        set -x color_initial_segment_jobs     $base01 $base0D --bold

        set -x color_path                     $base02 $base05
        set -x color_path_basename            $base02 $base06 --bold
        set -x color_path_nowrite             $base02 $base09
        set -x color_path_nowrite_basename    $base02 $base09 --bold

        set -x color_repo                     $base0B $colorfg
        set -x color_repo_work_tree           $base02 $colorfg --bold
        set -x color_repo_dirty               $base08 $base05
        set -x color_repo_staged              $base09 $colorfg

        set -x color_vi_mode_default          $base03 $base05 --bold
        set -x color_vi_mode_insert           $base0B $colorfg --bold
        set -x color_vi_mode_visual           $base09 $colorfg --bold

        set -x color_vagrant                  $base0C $colorfg --bold
        set -x color_k8s                      $base08 $base05 --bold
        set -x color_aws_vault                $base0D $colorfg --bold
        set -x color_aws_vault_expired        $base0D $base08 --bold
        set -x color_username                 $base02 $base0D --bold
        set -x color_hostname                 $base02 $base0D
        set -x color_rvm                      $base08 $base05 --bold
        set -x color_nvm                      $base0B $colorfg --bold
        set -x color_virtualfish              $base0D $colorfg --bold
        set -x color_virtualgo                $base0D $colorfg --bold
        set -x color_desk                     $base0D $colorfg --bold
        set -x color_nix                      $base0D $colorfg --bold
      end
      '';
    };
  };
}

