```sh
systemctl enable NetworkManager
systemctl start NetworkManager

timedatectl set-timezone Region/City
timedatectl set-ntp 1
hwclock --systohc

localectl set-locale LANG=en_US.UTF-8
localectl set-keymap us
hostnamectl hostname yourhostname

reflector -c Country -p https -a 12 -l 7 --sort rate \
    --save /etc/pacman.d/mirrorlist
#   -c - country or countries separated by commas
#   -p - protocols separated by commas: http, hppts, ftp
#   -a - last synchronization time (hours)
#   -l - max amount
vim /etc/pacman.conf # ParallelDownloads
pacman -Syu

passwd
useradd -m -s /bin/bash username
passwd username
EDITOR=vim visudo

mkdir ~/src && cd ~/src
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/dmenu
git clone https://git.suckless.org/slstatus

# Backup LUKS header (if using encryption)
# Add NukeKey

systemctl --user enable --now pipewire
# must run without sudo

sudo vim /etc/xdg/reflector/reflector.conf
udo systemctl enable reflector.timer
sudo systemctl start reflector.timer



```
