#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
## This is ripuntu installer.
## Do chmod +x ripuntu.sh and run ./ripuntu.sh without sudo to prevent install issues.
clear
echo
echo "WARNING: This script will overwrite your current desktop environment. Please backup your data before proceeding."
echo
sleep 3
echo "Install will start soon please be sure that you are on sudo user other than root"
echo
echo "You will be asked for password and consent to install programs"
echo
sleep 1
echo "Continue? (y/n)"
read -n 1 answer
echo "" 

if [[ "$answer" =~ ^[Yy]$ ]]; then
    # Desktop environment and software installation.
    clear
    echo "Installing"
    sudo apt update && sudo apt full-upgrade -y
    sudo apt install lxterminal curl -y
    sudo apt install software-properties-common -y
    sudo add-apt-repository -y universe
    sudo add-apt-repository -y multiverse
    sudo apt update -y
    sudo apt install nano dpkg dbus-x11 tasksel openbox tint2 htop firefox nitrogen gedit tigervnc-standalone-server tigervnc-common rofi ubuntu-wallpapers lightdm gnome-software nautilus gvfs-backends unzip -y
    # Starship installation.
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    mkdir -p ~/.local/share/fonts
    curl -Lso font.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -oq font.zip -d ~/.local/share/fonts
    rm -f font.zip
    fc-cache -f > /dev/null
    mkdir -p ~/.config
    touch ~/.config/starship.toml
    sudo systemctl enable lightdm
    # Starting configuration file copying.
    clear
    echo "Installation complete, copying configuration files"
    sleep 1
    # This overwrites the current .bashrc, xstartup and .config user file. Backup your files.
    cp -f config/bashrc ~/.bashrc
    mkdir -p ~/.vnc
    cp -f config/xstartup ~/.vnc/xstartup
    cp -f config/starship/starship.toml ~/.config/starship.toml
    cp -rf config/openbox ~/.config
    cp -rf config/tint2 ~/.config
    cp -rf config/rofi ~/.config
    clear
    cat config/Rip.txt
    sleep 5
    clear
    echo "Copying complete, system will reboot in 3 seconds"
    sleep 3
    sudo reboot
else
    echo "Canceled."
fi




