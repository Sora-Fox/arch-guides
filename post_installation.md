```sh
systemctl enable NetworkManager
systemctl start NetworkManager

timedatectl set-timezone Region/City
timedatectl set-ntp 1
hwclock --systohc

localectl set-locale LANG=en_US.UTF-8
localectl set-keymap us
hostnamectl hostname yourhostname

reflector -c Country -p https --sort rate --save \
    /etc/pacman.d/mirrorlist
vim /etc/pacman.conf # Color, ParallelDownloads, [multilib]
pacman -Syu

passwd
useradd -m -s /bin/bash username
passwd username
EDITOR=vim visudo

pacman -S \
    xorg xorg-server xorg-xinit \
    alsa-utils pulseaudio pavucontrol \
    telegram-desktop firefox qutebrowser tor tor-browser \
    alacritty zsh ranger bat eza ripgrep htop btop fastfetch \
    vim vi neovim clang llvm cmake git valgrind gtest boost python nodejs \
    docker qemu qemu-kvm virt-manager libvirt \
    gvfs gvfs-mtp tlp \
    libreoffice-fresh mpv keepassxc nemo
```
