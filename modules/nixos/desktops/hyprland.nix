{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: {
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    GDK_SCALE = "1.5";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    XCURSOR_SIZE = "24";
    XDG_SESSION_TYPE = "wayland";
  };

  services.xserver.enable = true;
  services.xserver.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-sddm-corners";
    };
    autoLogin = {
      enable = true;
      user = "ashebanow";
    };
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    # not sure if this will work if our hyprland.conf isn't generated
    # catppuccin.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    # systemd.enable = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # enable programs hyprland uses
  programs.thunar.enable = true;

  programs.waybar = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.${system}.waybar;
  };

  # enable services hyprland uses
  services.cliphist.enable = true;
  services.dunst = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.${system}.dunst;
    user = "ashebanow";
  };

  # services.udisks2.enable = true;
  # services.udiskie.enable = true;
  # services.udiskie.tray = "always";

  # for xremap to work with wlroots
  services.xremap.withWlroots = true;

  environment.systemPackages = with pkgs; [
    catppuccin-sddm-corners
    inputs.hyprland-wayland.packages.${system}.dunst
    hyprland
    hypridle
    hyprlock
    hyprpaper
    hyprpicker
    # imv
    libnotify
    meson
    mpv
    pavucontrol
    rofi-wayland
    sddm
    swayimg
    udiskie
    inputs.hyprland-wayland.packages.${system}.new-wayland-protocols
    wayland-utils
    inputs.hyprland-wayland.packages.${system}.wl-clipboard
    inputs.hyprland-wayland.packages.${system}.wlroots
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    zathura
  ];
}
