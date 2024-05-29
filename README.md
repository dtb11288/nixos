Update system
```
sudo nixos-rebuild switch --flake '.#pc'
```

Clean up
```
sudo nix-collect-garbage -d
nix-collect-garbage -d
sudo /run/current-system/bin/switch-to-configuration boot
```
