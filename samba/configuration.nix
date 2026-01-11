# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "beverburcht"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    # Main non-samba user for managing the server
    samba = {
      isNormalUser = true;
      description = "samba";
      initialPassword = "nixos"; # Default password (changeable on first login)
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        kdePackages.kate
        git
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3sC4F5aGEHJyssbcPsm8PrRmvoke0OvJ1GCh6M76DDUYHWMRREsChsTRkaxmwsE5SLer3MeUd3NdUB3Eqi8SjqKa7sLHtnVl3XfkS21VMEyWIag7W0CWGpT3pdznb/Il5afMsR40UGwWsCYF1CQ+ccOb2K9K7fNHly7sTLGMDwvUM5vH31eT4XDZZGFpUB/LwXUy7/zR1MyxaRYw1HABVD0D70TUZoDrtuE9CyVSl2J+K8XalcHIYGzLP96EgHM+9ixphjQ2TdYPtm5rBZKPqA/gYYhuMRwFUMCe9Z0MO0zrRdS4MCkB4Prga/xtTGh2DECHEf+AQFU9kxsr/kWDoOhsr0hVkTqblQ0m/XH74Xf7he/APmRfE6bGQluPtbiNpgMEbiYdWZOQVqZA0WbJ+wdiX/N0qFtBKTLcAhskp3I1LD0xaBzvO28Nn7UBEp9RmYaXfcl/JtEC1Af+1VHrtv68FeGXK3n16XaLuuyOfgJ6gzWNEXTvRvoY/AZ0S69RZ4ocmGjh3ExskQiDIfOtItt0vJzP8qSde5X/lRZ+BsPKIYsYWFLnl3fXRpwnMG9O6sQoSzGtTx/RW/LU+kRdh0DoOs9UfaOR9+hDXb/yiSrUPc4fbMyc8pkIxtkN4Z+enUXc2gF0aT/DksyaNg8wQvlxwFUhM/KGAivId1lrrHQ== merlijn"
      ];
    };

    # Need their passwords set via
    # sudo smbpasswd -a name
    sonos = {
      isNormalUser = true;
    };
    ulrich = {
      isNormalUser = true;
    };
    eva = {
      isNormalUser = true;
    };
    merlijn = {
      isNormalUser = true;
    };
    fabian = {
      isNormalUser = true;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    samba
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # NOTES:
  # Remember to add users with `smbpasswd`.
  # This includes guest access user:
  #   sudo smbpasswd -an smb-guest # [a]dd user with [n]ull password
  # To check for users already in smbpasswd database:
  #   sudo tdbtool /var/lib/samba/private/passdb.tdb keys | sed -n 's/.*USER_\(.*\)/\1/p'
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "security" = "user";
        "wins support" = "yes";
        "server string" = "Wintervoorraad samba";
        "client smb encrypt" = "desired";
        # Lock the service to local network only
        # Allowlist takes precedence
        "allow hosts" = "192.168.0.";
        "deny hosts" = "ALL";
        "create mask" = "0700"; #Remove r bit from group and others
        "force create mode" = "0770"; #Add x bit only to group and others

        ### TODO set up a cronjob to remove old files
        # # Enable recycling bin
        # "vfs object" = "recycle";
        # "recycle:repository" = "/warehouse/.recycle";
        # "recycle:keeptree" = "yes";
        # "recycle:versions" = "yes";
        # "recycle:touch" = "yes";
        # "recycle:exclude_dir" = "/tmp /TMP /temp /TEMP /public /cache /CACHE";
        # "recycle:exclude" = "*.TMP *.tmp *.temp ~$* *.log *.bak";
      };
      wintervoorraad = {
        description = "Beverburcht De Dam";
        path = "/beverburcht/Seagate";
       	"read only" = "no";
        browseable = "yes";
        writeable = "yes";
        "valid users" = "ulrich merlijn eva fabian";
      };
      muziek = {
        path = "/beverburcht/Seagate/Music";
        public = "no";
        browseable = "yes";
        writeable = "no";
        "valid users" = "sonos ulrich merlijn eva fabian";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
