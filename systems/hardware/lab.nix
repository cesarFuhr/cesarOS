{ config, lib, pkgs, modulesPath, ... }:

let
  nverStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nverBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;
  nvidiaPackage =
    if (lib.versionOlder nverBeta nverStable)
    then config.boot.kernelPackages.nvidiaPackages.stable
    else config.boot.kernelPackages.nvidiaPackages.beta;
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvidia" "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];

  services.fstrim.enable = lib.mkDefault true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    package = nvidiaPackage;

    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = true;
  };

  # Prevent lid from suspending.
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitch = "ignore";

  hardware.enableAllFirmware = true;
}

