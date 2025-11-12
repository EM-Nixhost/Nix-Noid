{ config, pkgs, lib, ... }:

let
  # 1. Define the fix overlay
  adwaita-fix-overlay = final: prev: {
    gnome = prev.gnome // {
      adwaita-icon-theme = final.adwaita-icon-theme;
    };
  };
  nsc-source = pkgs.fetchFromGitHub {
    owner = "snowfallorg";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  };
  nsc-pkgs-with-fix = import pkgs.path { # pkgs.path is the path to the main nixpkgs source
    system = pkgs.system;
    overlays = [
      adwaita-fix-overlay
    ];
  };

  nix-software-center = import nsc-source {
    pkgs = nsc-pkgs-with-fix; # Pass the fixed package set to the imported module
  };

in
{
  environment.systemPackages =
    with pkgs; [
      nix-software-center # Use the fixed instance
      adwaita-icon-theme
      adwaita-icon-theme-legacy
    ];
}
