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
    sudo apt-get clean
    sudo apt-get update --fix-missing
    sudo apt install -y nano dpkg dbus-x11 tasksel openbox tint2 htop firefox nitrogen gedit \
    tigervnc-standalone-server tigervnc-common rofi ubuntu-wallpapers lightdm \
    gnome-software nautilus gvfs-backends unzip xinit lxappearance neovim xorg xserver-xorg \
    build-essential dkms linux-headers-$(uname -r) 
    # obmenu install 
    sudo apt install -y obmenu || { echo "obmenu installation failed, skipping"; sleep 2; }
    # lightdm fix from 0.1.7-1.7
    echo "/usr/sbin/lightdm" | sudo tee /etc/X11/default-display-manager
    sudo dpkg-reconfigure -f noninteractive lightdm
    sudo sed -i '/pam_kwallet5.so/d' /etc/pam.d/lightdm 2>/dev/null
    sudo dpkg-reconfigure -f noninteractive lightdm
    # gpu accel
    sudo gpasswd -a $USER video
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
    # Oh My Posh install
    cp -f config/bashrc ~/.bashrc
    mkdir -p ~/.config/ohmyposh
cp -f config/ohmyposh/mytheme.omp.json ~/.config/ohmyposh/mytheme.omp.json
    # Starting configuration file copying.
    clear
    echo "Installation complete, copying configuration files"
    sleep 1
    # This overwrites the current .bashrc, xstartup and .config user file. Backup your files.
    cp -f config/bashrc ~/.bashrc
    sudo cp -f config/openbox/openbox.desktop /usr/share/xsessions/
    sudo chmod 644 /usr/share/xsessions/openbox.desktop
    mkdir -p ~/.vnc
    cp -f config/xstartup ~/.vnc/xstartup
    cp -f config/starship/starship.toml ~/.config/starship.toml
    cp -rf config/openbox ~/.config
    cp -rf config/tint2 ~/.config
    cp -rf config/rofi ~/.config
    # another perms fix
    sudo chown -R $USER:$USER /home/$USER
    chmod +x ~/.config/openbox/autostart
    rm -f ~/.Xauthority
    rm -f ~/.ICEauthority
    # install done
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




