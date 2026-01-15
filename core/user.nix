{ pkgs, username, secrets, ... }:

{
  users.mutableUsers = false;
  users.users.${username} = {
    createHome = true;
    home = "/home/${username}";
    hashedPassword = secrets.user.password;
    group = "users";
    extraGroups = [ "wheel" "disk" "networkmanager" "video" "audio" "input" "docker" "vboxusers" "wireshark" "libvirtd" "adbusers" "kvm" "nordvpn" ];
    isNormalUser = true;
    uid = 1000;
    useDefaultShell = true;
    shell = pkgs.zsh;
  };

  security.sudo-rs.enable = true;
}
