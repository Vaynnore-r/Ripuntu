#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
## This is ripuntu installer.
## Do chmod +x ripuntu.sh and run ./ripuntu.sh with sudo to prevent install issues.
echo
echo "Install will start soon please be shure that you are on sudo user other than root"
echo
sleep 1
echo
echo "You will be asked for password and consent to install programs"
echo
sleep 1
echo "Continue? (y/n)"
read -n 1 answer
echo "" 

if [ "$answer" = "y" ]; then
    echo "Installing"
    sudo apt update && sudo apt full-upgrade -y
    sudo apt install lxterminal curl -y
    sudo apt install software-properties-common -y
    sudo add-apt-repository -y universe
    sudo add-apt-repository -y multiverse
    sudo apt update -y
    sudo apt install nano dpkg dbus-x11 tasksel openbox openbox-menu tint2 htop firefox obmenu nitrogen gedit tigervnc-standalone-server tigervnc-common rofi ubuntu-wallpapers lightdm gnome-software nautilus gvfs gvfs-afp gvfs-smb -y
    # Install starship part will be fixed later.
    curl -sS https://starship.rs/install.sh | sh
    sudo systemctl enable lightdm 
    echo "Installation compleate, system will reboot in 3 seconds"
    sleep 3
    sudo reboot
else
    echo "Canceled."
fi




