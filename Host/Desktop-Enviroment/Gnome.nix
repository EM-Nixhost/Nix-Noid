{ config, pkgs, lib, ... }:

 {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
    
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
   environment.systemPackages = [
    pkgs.gnomeExtensions.dash-in-panel
    pkgs.gnomeExtensions.fly-pie
    pkgs.gnomeExtensions.arcmenu
    pkgs.gnomeExtensions.just-perfection
    pkgs.gnomeExtensions.vitals
    pkgs.gnomeExtensions.tilingnome
    pkgs.gnomeExtensions.bottom-panel
    pkgs.gnome-connections
  ];
  
 }
