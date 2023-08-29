{ pkgs, ... }:
{
  # Enable experimental nix commands and flakes
  # This is to avoid putting long cli flags when building the system with a flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Put your ssh public key here to be able to connect via ssh
  # It's the content of ~/.ssh/id_rsa.pub
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa ..."
  ];

  # Ensure some basic programs are installed in the resulting environment
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];
}
