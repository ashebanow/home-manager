{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix = {
    # package = pkgs.nixFlakes;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules
    ../../users/ashebanow.nix
  ];

  services.nix-daemon.enable = true;

  # set up zsh as default shell
  programs.zsh.enable = true;

  # Yabai tiling window manager
  # yabai.enable = true;
  # skhd.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget. We generally want to keep these system-specific
  # configurations as small as possible and use home manager or shell.nix
  # to install whats needed locally. Because nix uses symbolic links to point
  # to things, no disk space is wasted.
  environment.systemPackages = with pkgs; [
    inputs.ragenix.packages.aarch64-darwin.default
    firefox
    git
    just
    vim
    warp-terminal
    wget
    zsh
  ];

  fonts.fontDir.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = false;
    };
    # Note that the mac apps which auto-update themselves are commented out
    # here. You'll need to uncomment them to get them installed initially on
    # a new mac.
    casks = [
      # "1password-cli"
      "ableton-live-suite"
      "android-studio"
      "app-cleaner"
      # "arc"
      "betterdisplay"
      "devtoys"
      "discord"
      "disk-diet"
      # "google-drive"
      # "intellij-idea"
      # "karabiner-elements"
      # "microsoft-auto-update"
      # "microsoft-office"
      # "monitorcontrol"
      # "native-access"
      "orbstack"
      "parsec"
      "postico"
      "postman"
      "raycast"
      # "retrobatch"
      "sf-symbols"
      # "slack"
      # "soundsource"
      "steam"
      "temurin"
      # "tg-pro"
      # "warp"
      "zed"
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
      show-recents = true;
      mru-spaces = false;
      showhidden = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      QuitMenuItem = true;
    };
    loginwindow = {
      GuestEnabled = false;
      # autoLoginUser = "Andrew Shebanow";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
