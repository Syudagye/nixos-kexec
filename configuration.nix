{ pkgs, ... }:
{
  # Make it use predictable interface names starting with eth0
  boot.kernelParams = [ "net.ifnames=0" ];

  # Network configuration
  # Usually needed if you want to use this on a remote server
  # networking = {
  #   defaultGateway = "10.0.0.1";
  #   # Use quad9 dns
  #   nameservers = [ "9.9.9.9" ];
  #   interfaces.eth0.ipv4.addresses = [
  #     {
  #       address = "10.0.0.207";
  #       prefixLength = 16;
  #     }
  #   ];
  # };

  # Put your ssh public key here to be able to connect via ssh
  # It's the content of ~/.ssh/id_rsa.pub
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa ..."
  ];
}
