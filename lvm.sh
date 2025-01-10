
# ┌────────────────────┬───────────────┬──────────────────┐
# │     Partition      │     Size      │       Type       │
# ├────────────────────┼───────────────┼──────────────────┤
# │  /dev/nvme0n1p1    │     512M      │   EFI System     │
# │  /dev/nvme0n1p2    │     Rest      │   Linux LVM      │
# └────────────────────┴───────────────┴──────────────────┘

pvcreate /dev/nvme0n1p2
vgcreate main /dev/nvme0n1p2
lvcreate -L 50G -n root main
lvcreate -L 16G -n swap main
lvcreate -L 50G -n home main

mkfs.vfat /dev/nvme0n1p1
mkfs.ext4 /dev/main/root
mkfs.ext4 /dev/main/home
mkswap    /dev/main/swap

mount  /dev/main/root /mnt
mkdir  /mnt/{home,efi}
mount  /dev/main/home /mnt/home
mount  /dev/nvme0n1p1 /mnt/efi
swapon /dev/main/swap

pacstrap -K /mnt base linux linux-firmware  base-devel \
    intel-ucode grub efibootmgr vim reflector \
    networkmanager lvm2 openssh
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

vim /etc/mkinitcpio.conf
#   HOOKS=(base udev ... block lvm2 filesystems)
mkinitcpio -P
grub-install --efi-directory=/efi --bootloader-id=GRUB
#   by default: --target=x86_64-efi
vim /etc/default/grub
#   GRUB_PRELOAD_MODULES="part_gpt part_msdos lvm"
grub-mkconfig -o /boot/grub/grub.cfg

passwd

exit
umount -R /mnt
swapoff -a
reboot

