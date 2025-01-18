```sh
sudo mkfs.vfat -F 32 /dev/sda
#   use lsblk to know your usb name, for exapmle /dev/sda
sudo dd if=archlinux-2025.01.01-x86_64.iso of=/dev/sda bs=4M status=progress && sync
sudo udisksctl power-off -b /dev/sda
```
