{ config, pkgs, ...}:
{
  xdg = {
    enable = true;
    configFile = {
      gruvbox = {
        source = .config/fish/themes/gruvbox.theme;
	target = "fish/themes/gruvbox.theme";
      };
      allowed_signers = {
        source = .config/git/allowed_signers;
	target = "git/allowed_signers";
      };
    };
    configHome = "${config.home.homeDirectory}/.config";
  };
}
