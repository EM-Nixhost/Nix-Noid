{ config, pkgs, lib, ... }:
let
  unstable-pkgs = import <unstable> {
    config = config.nixpkgs.config;
  };
in
{
  imports = [
    ./Modules/Common.nix
    ./Modules/Optional.nix
    # REQUIRED: Local Host Configuration
    ./Host/Host.nix
  ];
  programs.git.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
