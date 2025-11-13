{ config, pkgs, lib, ... }:

{
 environment.systemPackages = with pkgs; [
  docker
  compose2nix
  unstable.winboat
  nh
    ];
    virtualisation.docker.enable = true;
    virtualisation.docker.storageDriver = "btrfs";

  }

