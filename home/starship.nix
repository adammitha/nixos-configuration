{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      hostname = {
        ssh_symbol = " 🌐";
        format = "[$hostname$ssh_symbol]($style)in ";
      };
      nix_shell = {
        heuristic = true;
      };
      username = {
        format = "[$user]($style) @ ";
      };
    };
  };
}
