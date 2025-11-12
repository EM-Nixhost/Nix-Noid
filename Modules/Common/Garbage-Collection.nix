{ config, pkgs, lib, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "Daily";
    options = "--delete-older-than 14d --max-delete-generations 5";
  };
}
