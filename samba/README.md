## To build proxmox VMA (proxmox backup file, they go in root@proxmox:/var/lib/vz/dump and are used as a bootstrapping mechanism for new vms)
This method uses nixos-generators, it's integrated into the flake so you can use the following flake command:
- `nix build .#proxmox`

If successful, a `*.vma` file will be generated under `./result`. Simply copy this to your proxmox vz dump folder.

## On System:

### To build and switch:
- `sudo nixos-rebuild switch --flake .#beverburcht`
### To check:
- `sudo nixos-rebuild test --flake .#beverburcht`

### To check entire flake:
 - `nix --extra-experimental-features 'nix-command flakes' flake check`

### Setting up samba
 - Change the configuration.nix to your preferences
 - Set user passwords with `sudo smbpasswd -a user`
