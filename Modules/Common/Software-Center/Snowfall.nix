{ config, pkgs, lib, ... }:

let
  # --- THE FIX ---
  # Use a clean 'bootstrap' pkgs for fetching to avoid recursion.
  bootstrapPkgs = import <nixpkgs> {};

  # 1. Adwaita fix overlay
  adwaita-fix-overlay = final: prev: {
    gnome = prev.gnome // {
      adwaita-icon-theme = final.adwaita-icon-theme;
    };
  };

  # 2. Source for the software center (fetched cleanly)
  nsc-source = bootstrapPkgs.fetchFromGitHub {
    owner = "snowfallorg";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  };

  # 3. Overlay to add the package to 'pkgs'
  nsc-overlay = final: prev: {
    nix-software-center = import nsc-source {
      pkgs = final; # 'final' is the correct, non-recursive pkgs to use here
    };
  };

in
{
  # This file provides the overlays
  nixpkgs.overlays = [
    nsc-overlay
    adwaita-fix-overlay
  ];
}
