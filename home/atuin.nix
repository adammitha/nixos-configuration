{ config, pkgs, ... }:
{
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      sync_address = "http://adams-nixos-desktop.mouse-diatonic.ts.net:8888";
    };
  };
}
