# new cmd: nix-build '<nixpkgs/nixos>' -A config.system.build.kexec_tarball -I nixos-config=./configuration.nix -Q -j 4

{ lib, pkgs, config, ... }:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix>
    ./kexec.nix
  ];

  # boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub.enable = false;
  boot.kernelParams = [
    "console=ttyS0,115200"          # allows certain forms of remote access, if the hardware is setup right
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];
  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];
  networking.hostName = "kexec";
  # example way to embed an ssh pubkey into the tar
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDRWzFETtjX6Q/g5FOib5prYcq050atyvyIEnx5FmBP8BbzkJ2vZa7P01GI3HFCuG4911nIYDKafxl2498it6AyXiScRXBIISjoI+lm2To2CjhMozf10ccCOQIpH+dVVRhB2WpkE0KW7K/TqCfEDFGcWSHg5NvTMYsdxPuO6ikEJlbJv9JKJYpsM1uXM5cCTyRmObKcSXRNvX+oOsTXgz7aY5MJRXJ+Bo9bN8opnLkEu1smLgxsbM4EeVmJbQ5mU1jTHWYJEY6aMS5hfrBGiV/uZAr4SjhUraeYqJpGEDHgsbZbQycnifXh/BjSejGOhBFnsJZEJNDn+W1cfkzckHH" ];
}
