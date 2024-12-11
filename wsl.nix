{ variables, pkgs, inputs, config, ... }:
let
  inherit (variables) hostName userName;
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/HJtpzR8Ip/ma38TQSj1Uvl/rvvN3ogYsTbD8ERErL user@wsl-desktop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/ppkYVMKZ+N/BINzfEvO8mWZMtx/UgbrHf5i4wpb77 root@wsl-desktop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeABSDuLTLywoc86FINzl/YsUfJ0yqPhPan4DUzT2ME user@wsl-laptop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZXcr0Kw5hXygTBzIbeh6RkBK+DifY2C8ywiIGC1jdj root@wsl-laptop"
  ];
in
{
  # TODO: Look up timezone with "timedatectl list-timezones"
  time.timeZone = "America/New_York";

  services.openssh = {
    enable = true;
  };

  networking.hostName = "${hostName}";

  programs.fish.enable = true;
  environment.pathsToLink = [ "/share/fish" ];
  environment.shells = [ pkgs.fish ];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.${userName} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      # TODO: uncomment the next line if you want to run docker without sudo
      # "docker"
    ];
    # TODO: add your own hashed password
    # hashedPassword = "";

    openssh.authorizedKeys.keys = keys;
  };

  home-manager.users.${userName} = {
    imports = [ ./home.nix ];
  };

  system.stateVersion = "22.05";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = userName;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  nix = {
    settings = {
      trusted-users = [ userName ];
      # To be able to clone private repos on GitHub, add PAT access-tokens
      access-tokens = [
        # This is the oauth token from Github, not ssh key
        "github.com=${config.age.secrets.github-pat.path}"
      ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixVersions.latest;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
