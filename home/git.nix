{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Adam Mitha";
    userEmail = "adam.mitha@gmail.com";
    extraConfig = {
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
        ssh = {
          allowedSignersFile = "/home/adam/.config/git/allowed_signers";
        };
      };
      init.defaultBranch = "main";
      pull = {
        autosetupremote = true;
        rebase = true;
      };
      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAB/AenixWNi2t7mPamUlXvq7jcVH3PaLHXo6OAYpc8d adam.mitha@gmail.com";
    };
  };
}

