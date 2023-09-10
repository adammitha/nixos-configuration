# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
      extraPools = [ "kitsilano" ];
    };
  };

  # Networking
  networking = {
    hostId = "161f8e1d";
    hostName = "adams-nixos-desktop";
    networkmanager.enable = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure the desktop environment
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      # Disable autosuspend
      autoSuspend = false;
    };
    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";
    xkbOptions = "ctrl:swapcaps";
  };

  # Disable autosuspend
  security.polkit.extraConfig = ''
  polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.login1.suspend" ||
          action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
          action.id == "org.freedesktop.login1.hibernate" ||
          action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
      {
          return polkit.Result.NO;
      }
  });
  '';

  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adam = {
    isNormalUser = true;
    description = "Adam Mitha";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAB/AenixWNi2t7mPamUlXvq7jcVH3PaLHXo6OAYpc8d adam.mitha@gmail.com"
    ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
    shell = pkgs.fish;
  };
  users.users.timemachine = {
    isNormalUser = true;
    description = "Time Machine";
  };
  security.sudo.wheelNeedsPassword = false;
  programs.fish = {
    enable = true;
  };

  # Home manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.adam = import ./home.nix;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # editors
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    # archives
    zip
    unzip
    xz
    zstd

    # networking
    aria2 # Download utility
    dnsutils
    socat
    wget

    # Utilities
    bat
    du-dust
    fd
    file
    hyperfine
    jq
    pciutils
    plocate
    ripgrep
    tree

    # dev tools
    tmux
    git
    fzf
    alacritty
    gh
    starship

    # monitoring
    btop
    config.boot.kernelPackages.perf
    htop
    lsof
    neofetch
    smartmontools
    sysstat

    # Storage
    zfs

    # GUI
    google-chrome

    # Documentation (disabled because of prohibitive man-cache rebuild times
    # linux-manual
    # man-pages
    # man-pages-posix
  ];

  environment.shells = with pkgs; [ fish ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # Oprograms.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # System-wide program configuration
  programs = {
    git = {
      enable = true;
      config = {
        user = {
	  name = "NixOS System User";
	  email = "adam.mitha@gmail.com";
	};
      };
    };
  };

  # List services that you want to enable:
  services = {
    avahi = {
      enable = true;
      extraServiceFiles = {
        samba = ''
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">%h</name>
  <service>
    <type>_smb._tcp</type>
    <port>445</port>
  </service>
  <service>
    <type>_device-info._tcp</type>
    <port>0</port>
    <txt-record>model=TimeCapsule8,119</txt-record>
  </service>
  <service>
    <type>_adisk._tcp</type>
    <txt-record>dk0=adVN=timemachine,adVF=0x82</txt-record>
    <txt-record>sys=waMa=0,adVF=0x100</txt-record>
  </service>
</service-group>
	'';
      };
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
    openssh.enable = true;
    tailscale.enable = true;
    locate.enable = true;
    smartd.enable = true;
    samba = {
      enable = true;
      extraConfig = ''
        fruit:aapl = yes
	fruit:nfs_aces = no
	fruit:copyfile = no
	fruit:model = MacSamba
	multicast dns register = no
      '';
      openFirewall = true;
      shares = {
        Videos = {
	  comment = "Videos";
	  path = "/mnt/media/Videos";
	  "read only" = "no";
	  "browsable" = "yes";
	};
	timemachine = {
	  "vfs objects" = "catia fruit streams_xattr";
	  "fruit:time machine" = "yes";
	  "fruit:time machine max size" = "600G";
	  comment = "TimeMachine Backup";
	  path = "/mnt/backups";
	  available = "yes";
	  "valid users" = "timemachine";
	  "read only" = "no";
	  "browsable" = "yes";
	  "guest ok" = "no";
	};
      };
    };
    sysstat = {
      enable = true;
      collect-args = "1 1 -S XALL";
    };
    zfs = {
      autoScrub.enable = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "23.05";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      flake = "/home/adam/src/nixos-configuration";
      flags = [ "--update-input" "nixpkgs" "--update-input" "home-manager" ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "04:00";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    optimise.automatic = true;
  };

  virtualisation.docker.enable = true;

  # documentation = {
  #   dev.enable = true;
  # };
}
