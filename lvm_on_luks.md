```sh
# ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
# │                                              nvme0n1                                               │
# ├─────────────┬─────────────┬────────────────────────────────────────────────────────────────────────┤
# │  nvme0n1p1  │  nvme0n1p2  │                          nvme0n1p3 crypt                               │
# │    512M     │    1024M    ├──────────────────────────┬─────────────────────┬───────────────────────┤
# │    /efi     │    /boot    │  main-swap  16G  [SWAP]  │  main-root  50G  /  │ main-home  50G  /home │
# └─────────────┴─────────────┴──────────────────────────┴─────────────────────┴───────────────────────┘

# ┌────────────────────┬───────────────┬──────────────────┐
# │     Partition      │     Size      │       Type       │
# ├────────────────────┼───────────────┼──────────────────┤
# │  /dev/nvme0n1p1    │     512M      │   EFI System     │
# │  /dev/nvme0n1p2    │     1024M     │ Linux Filesystem │
# │  /dev/nvme0n1p3    │     Rest      │ Linux Filesystem │
# └────────────────────┴───────────────┴──────────────────┘

cryptsetup luksFormat /dev/nvme0n1p3
cryptsetup luksOpen /dev/nvme0n1p3 CheeryChest
#   can be any name instead of “CheeryChest”

pvcreate /dev/mapper/CheeryChest
vgcreate main /dev/mapper/CheeryChest
#   can be any name instead of “main”
lvcreate -L 50G -n root main
lvcreate -L 16G -n swap main
lvcreate -L 50G -n home main

mkfs.vfat -F 32 /dev/nvme0n1p1
mkfs.ext4 -T small /dev/nvme0n1p2
mkfs.ext4 /dev/main/root
mkfs.ext4 /dev/main/home
mkswap    /dev/main/swap

mount  /dev/main/root /mnt
mkdir  /mnt/{home,boot,efi}
mount  /dev/main/home /mnt/home
mount  /dev/nvme0n1p1 /mnt/efi
mount  /dev/nvme0n1p2 /mnt/boot
swapon /dev/main/swap

pacstrap -K /mnt base linux linux-firmware  base-devel \
    intel-ucode grub efibootmgr vim reflector \
    networkmanager lvm2 cryptsetup openssh
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

vim /etc/mkinitcpio.conf
#   HOOKS=(base udev ... block encrypt lvm2 filesystems)
mkinitcpio -P
grub-install --efi-directory=/efi --bootloader-id=GRUB
#   by default: --target=x86_64-efi
vim /etc/default/grub
#   use blkid to know /dev/nvme0n1p3 UUID
#   GRUB_CMDLINE_LINUX="cryptdevice=UUID=<...>:CheeryChest"
#   GRUB_PRELOAD_MODULES="part_gpt part_msdos lvm"
#   GRUB_ENABLE_CRYPTODISK=y
grub-mkconfig -o /boot/grub/grub.cfg

passwd
#   Otherwise, you may not be able to log in after booting

exit
umount -R /mnt
swapoff -a
reboot
```
