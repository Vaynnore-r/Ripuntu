#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
## This is ripuntu installer.
## Do chmod +x ripuntu.sh and run ./ripuntu.sh without sudo to prevent install issues.
clear
echo
echo "WARNING: This script will overwrite your current desktop environment. Please backup your data before proceeding."
echo
echo "Install will start soon please be sure that you are on sudo user other than root"
echo
echo "You will be asked for password and consent to install programs"
echo
echo "Continue? (y/n)"
read -n 1 answer
echo ""
if [[ "$answer" =~ ^[Yy]$ ]]; then
    clear
    echo "Choose desktop environment:"
    echo "1) Openbox"
    echo "2) i3"
    read -n 1 -p "Enter 1 or 2: " de_choice
    echo ""
    if [[ "$de_choice" != "1" && "$de_choice" != "2" ]]; then
        echo "Invalid choice. Please enter 1 or 2."
        sleep 1
	./ripuntu.sh
    fi
    clear
    echo "Installing"
    if [[ "$de_choice" == "1" ]]; then
        sudo apt install lxterminal curl -y
        sudo apt install software-properties-common -y
        sudo add-apt-repository -y universe
        sudo add-apt-repository -y multiverse
        sudo apt update -y
        sudo apt-get clean
        sudo apt-get update --fix-missing
        sudo apt install -y nano dpkg dbus-x11 openbox tint2 htop nitrogen gedit \
        rofi ubuntu-wallpapers lightdm firefox tigervnc-standalone-server tigervnc-common \
        nautilus gvfs-backends unzip xinit lxappearance neovim xorg xserver-xorg lightdm-gtk-greeter \
        build-essential dkms 
        sudo apt install -y obmenu || { echo "obmenu installation failed, skipping"; sleep 2; }
	DESKTOP=openbox
    elif [[ "$de_choice" == "2" ]]; then
        sudo apt install lxterminal curl -y
        sudo apt install software-properties-common -y
        sudo add-apt-repository -y universe
        sudo add-apt-repository -y multiverse
        sudo apt update -y
        sudo apt-get clean
        sudo apt-get update --fix-missing
        sudo apt install -y nano dpkg dbus-x11 i3-wm i3blocks i3status htop nitrogen gedit \
        ubuntu-wallpapers lightdm firefox tigervnc-standalone-server tigervnc-common \
        nautilus gvfs-backends unzip xinit lxappearance neovim xorg xserver-xorg lightdm-gtk-greeter \
        build-essential dkms 
        DESKTOP=i3
    fi
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
    mkdir -p ~/.local/bin
    curl -sSL https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh-linux-amd64 -o ~/.local/bin/oh-my-posh
    chmod +x ~/.local/bin/oh-my-posh
    export PATH="$HOME/.local/bin:$PATH"
        # Installing github cli (FIXED)
    type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://github.com | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://github.com stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
    # Starting configuration file copying
    clear
    echo "Installing programs complete, copying configuration files"
    sleep 1
    # This overwrites the current .bashrc, xstartup and .config user file. Backup your files.
    cp -f config/bashrc ~/.bashrc
    mkdir -p ~/.config/ohmyposh
    cp -f config/ohmyposh/mytheme.omp.json ~/.config/ohmyposh/mytheme.omp.json
    mkdir -p ~/.vnc
    cp -f config/starship/starship.toml ~/.config/starship.toml
    cp -rf config/rofi ~/.config
    if [[ "$DESKTOP" == "openbox" ]]; then
        sudo cp -f config/openbox/openbox.desktop /usr/share/xsessions/
        sudo chmod 644 /usr/share/xsessions/openbox.desktop
        cp -rf config/openbox ~/.config
        cp -rf config/tint2 ~/.config
        cp -f config/i3/xstartup ~/.vnc/xstartup
    elif [[ "$DESKTOP" == "i3" ]]; then
    cp -f config/openbox/xstartup ~/.vnc/xstartup
        sudo cp -f config/i3/i3.desktop /usr/share/xsessions/
        sudo chmod 644 /usr/share/xsessions/i3.desktop
        cp -rf config/i3 ~/.config
    fi
    # another perms fix
    sudo chown -R $USER:$USER /home/$USER
    if [[ "$DESKTOP" == "openbox" ]]; then
        chmod +x ~/.config/openbox/autostart
    fi
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
