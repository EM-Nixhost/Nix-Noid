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

nixpkgs.config.packageOverrides = pkgs: {
    winboat = pkgs.winboat.overrideAttrs (oldAttrs: {
      npmFlags = (oldAttrs.npmFlags or []) ++ [ "--legacy-peer-deps" "--no-audit" ];
            makeCacheWritable = true;
    });
  };

  }

