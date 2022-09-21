{
  config,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "sno2wman"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://sno2wman.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "sno2wman.cachix.org-1:JHDNKuz+q1xthbonwirDQzMZtwPrDnwCq3wUX3kmBVU="
      ];
    };
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
  };

  environment.systemPackages = with pkgs; [
    binutils
    bottom
    corectrl
    curl
    direnv
    iputils
    jq
    moreutils
    openssl
    seatd
    sudo
    vim
    wget
    ghq
  ];

  console = {
    font = "7x14";
    keyMap = "jp106";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  time.timeZone = "Asia/Tokyo";
  networking.timeServers = [
    "0.jp.pool.ntp.org"
    "1.jp.pool.ntp.org"
    "2.jp.pool.ntp.org"
    "3.jp.pool.ntp.org"
  ];

  services = {
    chrony = {
      enable = true;
    };
    openssh = {
      enable = true;
      passwordAuthentication = false;
      ports = [22];
    };
  };

  programs = {
    git = {
      enable = true;
      config = {
        safe.directory = ["/etc/nixos"];
      };
    };
  };

  networking.firewall.allowedTCPPorts = config.services.openssh.ports;

  users.users.sno2wman = {
    isNormalUser = true;

    # mkpasswd -m sha-512
    hashedPassword = "$5$o/uYw2SIiX4L5eWU$QH52hV37.vVOekwGsEqufR.Zdv87votcRoQoZlsGd30";

    extraGroups = [
      "wheel" # for sudo
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ02RYFEONAr/5a3fokBYHUFVPqF8G64DxhV5RGu7gtK me@sno2wman.net"
    ];
  };
}
