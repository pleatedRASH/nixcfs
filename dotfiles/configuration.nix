# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {

  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # It's strongly recommended you take a look at
    # https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware.

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # You can also split up your configuration and import pieces of it here.
  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Remove if you wish to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;

  # FIXME: Add the rest of your current configuration
  

  # x11
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    videoDrivers = [ "intel" ];
    libinput.enable = true;
    layout = "us";
    displayManager = {
      defaultSession = "none+herbstluftwm";
    };
  };

  services.xserver.windowManager.herbstluftwm.enable = true;

  # SOUND
  sound.enable = true;
   hardware.pulseaudio = {
     enable = true;
     package = pkgs.pulseaudioFull;
    };


  # TODO: Set your hostname
  networking.hostName = "nasty";

  # boot shit 
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    cuckboi = {
      isNormalUser = true;
      Home = "/home/cuckboi"
      createHome = true;
      shell = "/run/current-system/sw/bin/fish";
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" "adm" "video" "audio" "networkmanager" "storage" ];
    };
  };



  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
