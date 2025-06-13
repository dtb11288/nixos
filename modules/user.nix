{ pkgs, username, secrets, ... }:

{
  users.mutableUsers = false;
  users.users.${username} = {
    createHome = true;
    home = "/home/${username}";
    hashedPassword = secrets.password;
    group = "users";
    extraGroups = [ "wheel" "disk" "networkmanager" "video" "audio" "input" "docker" "vboxusers" "wireshark" "libvirtd" "adbusers" "kvm" ];
    isNormalUser = true;
    uid = 1000;
    useDefaultShell = true;
    shell = pkgs.zsh;
  };

  security.sudo.enable = true;
}
