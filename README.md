# README

## Instructions for setting up a new machine
1. Clone git repository
2. Update hardware-configuration.nix
3. Backup /etc/nixos to /etc/nixos.bak
4. Run `nixos-rebuild boot --flake .#adams-nixos-desktop`
5. Hard reboot the machine so you boot into the latest kernel
6. Migrate the updated hardware-configuration.nix to the nixos-configuration repository in /home/adam/src/nixos-configuration
7. Symlink /etc/nixos to /home/adam/src/nixos-configuration
8. Run `nixos-rebuild switch` to confirm that you copied everything over correctly
