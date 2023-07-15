#!/usr/bin/bash

read -p "Do you want to proceed? (y/n): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "Proceeding..."  | pv -qL 25
    
    echo "Installing dependencies" | pv -qL 25
    sudo pacman -S --needed git base-devel
    
    echo "Installing yay aur helper" | pv -qL 25
    cd
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    
    
    read -p "Which rice would you like to install? ("mountain" is the only option for now): " rice
    rice=${rice,,}
    case $rice in
        mountain)
            echo "Ah, so you have chosen minimalism..." | pv -qL 25
            #installing my disired packages
            yay -S bspwm sxhkd rofi polybar dunst kitty mate-polkit nitrogen vscodium-bin neovim htop rofi-screenshot-git ttf-nerd-fonts-symbols-common ttf-noto-nerd otf-firamono-nerd ttf-jetbrains-mono-nerd ttf-kascadia cantarell-fonts  noto-fonts-emoji ttf-dejavu siji-ttf ly ttf-unifont otf-unifont thunar lxappearance rofi-calc rofi-emoji zip unzip
            #moving config files and fonts to correct directories
            cd ~/dots/mountain
            mv config .config
            me=$(whoami)
            mv -f .config /home/$me
            mv -f fonts /home/$me/.local/share/fonts/
            unzip themes.zip
            cd /themes
            mkdir ~/.themes
            mv mountain ~/.themes
            #detecting the existing display manager, and adjusting accordingly
            if pgrep -x "gdm" > /dev/null; then
                sudo systemctl disable gdm
            elif pgrep -x "lightdm" > /dev/null; then
                sudo systemctl disable lightdm
            elif pgrep -x "sddm" > /dev/null; then
                sudo systemctl disable sddm
            elif pgrep -x "xdm" > /dev/null; then
                sudo systemctl disable xdm
            elif pgrep -x "ly" > /dev/null; then
                echo "Great, you're already using the ly display manager! The setup is complete!" | pv -qL 25
                sleep 5
                exit 0
            else
                echo "You are either not using a display manager, or using an obscure one, we will try to just enable ly."
            fi
            sudo systemctl enable ly
            echo "The script has been successful. Exiting..." | pv -qL 25
            exit 0
            ;;
        *)
            echo "You have not chosen a valid rice."
            echo "Exiting..."
            sleep 3
            exit 0
    esac
else
    echo "Exiting..."
    exit 0
fi
