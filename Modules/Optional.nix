{ config, pkgs, lib, ... }:

{
  imports =
    (lib.optional (builtins.pathExists ./Optional/Proton-Suite.nix)
      ./Optional/Proton-Suite.nix) ++
    (lib.optional (builtins.pathExists ./Optional/Gaming.nix)
      ./Optional/Gaming.nix) ++
    (lib.optional (builtins.pathExists ./Optional/VM.nix)
      ./Optional/VM.nix);
}
