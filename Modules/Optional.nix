{ config, pkgs, lib, ... }:

{
  imports =
    (lib.optional (builtins.pathExists ./Optional/Proton-suite.nix)
      ./Optional/Proton-suite.nix) ++

    (lib.optional (builtins.pathExists ./Optional/Gaming.nix)
      ./Optional/Gaming.nix);
}
