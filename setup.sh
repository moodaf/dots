#!/usr/bin/bash

read -p "Do you want to proceed? (y/n): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "Proceeding..."
    
    echo "Installing dependencies"
    sleep 3
    sudo pacman -S --needed git base-devel
    
    echo "Installing yay aur helper"
    sleep 3
    cd
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    
    
    read -p "Which configuration would you like to install? (mountain/dynamic): " config
    
    #stores name of user
    me=$(whoami)
    
    case $config in
        mountain)
            move_config_font_files mountain

            #installing required packages
            yay -S bspwm sxhkd rofi polybar dunst picom-jonaburg-git betterlockscreen kitty fish mate-polkit nitrogen neovim htop ly rofi-screenshot-git thunar lxappearance rofi-calc rofi-emoji zip unzip ttf-noto-nerd otf-firamono-nerd ttf-jetbrains-mono-nerd ttf-dejavu siji-ttf  ttf-unifont otf-unifont    
            
            #making "ly" the display manager
            display_manager_changer ly

            #making fish default shell
            chsh -s /bin/fish
            
            echo "These changes will have an effect after a reboot."
            read -p "Do you want to reboot now? (y/n): " yesorno
            if [[ $yesorno == "y" || $yesorno == "Y" ]]; then
                reboot
            else
                exit 0
            fi

            
            exit 0
            ;;
        dynamic)            
            move_config_font_files dynamic
            #installing required packages
            yay -S bspwm sxhkd rofi polybar dunst picom-jonaburg-git kitty fish mate-polkit nitrogen neovim htop ly rofi-screenshot-git thunar lxappearance rofi-calc rofi-emoji zip unzip ttf-noto-nerd otf-firamono-nerd ttf-jetbrains-mono-nerd ttf-dejavu siji-ttf  ttf-unifont otf-unifont
            yay -S python-pywal python-pywalfox pywal-discord-git

            #making "ly" the display manager
            display_manager_changer ly

            #making fish default shell
            chsh -s /bin/fish
            
            echo "These changes will have an effect after a reboot."
            read -p "Do you want to reboot now? (y/n): " yesorno
            if [[ $yesorno == "y" || $yesorno == "Y" ]]; then
                reboot
            else
                exit 0
            fi
            ;;
        *)
            echo "You have not chosen a valid configuration. Exiting..."
            sleep 3
            exit 0
    esac
else
    echo "Exiting..."
    exit 0
fi

move_config_font_files() {
    # "$1" is the name of the config folder, and should be specified when calling the function
    cd ~/dots/$1
    mkdir /home/$me/.config/
    mv -f config/* /home/$me/.config/
    mv -f fonts/* /home/$me/.local/share/fonts/
    mkdir /home/$me/.themes
    chmod +x /home/$me/.config/bspwm/bpsmwrc
    mkdir /home/$me/Pictures/Wallpapers
    mv wallpapers/* /home/$me/Pictures/Wallpapers
    unzip themes.zip
    mkdir /home/$me/.themes
    mv /themes/* ~/.themes
}

#obscure display managers will be mistaken for not existing, however this is not really an issue as others are extremely uncommon
#wont be a usecase where it would be necessary to detect other display managers so not worth coding
detect_display_manager() {
    local display_manager
    
    if pgrep -x "gdm" > /dev/null; then
        display_manager="gdm"
    elif pgrep -x "lightdm" > /dev/null; then
        display_manager="lightdm"
    elif pgrep -x "sddm" > /dev/null; then
        display_manager="sddm"
    elif pgrep -x "xdm" > /dev/null; then
        display_manager="xdm"
    elif pgrep -x "ly" > /dev/null; then
        display_manager="ly"
    elif pgrep -x "lxdm" > /dev/null; then
        display_manager="lxdm"
    else
        display_manager="unknown"
    fi
    
    echo $display_manager
}

#syntax: display_manager_changer (name of desired display manager)
display_manager_changer() {
    display_manager=$(detect_display_manager)
    if [[ $display_manager="unknown" || $display_manager=$1 ]]; then
        sudo systemctl enable $1
    else                
        sudo systemctl disable $display_manager
        sudo systemctl enable $1
    fi
}
