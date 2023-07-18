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
            
            #installing my disired packages
            yay -S bspwm sxhkd rofi polybar dunst kitty fish mate-polkit nitrogen vscodium-bin neovim htop ly rofi-screenshot-git thunar lxappearance rofi-calc rofi-emoji zip unzip ttf-noto-nerd otf-firamono-nerd ttf-jetbrains-mono-nerd ttf-dejavu siji-ttf  ttf-unifont otf-unifont    
            
            #changing to ly display manager
            display_manager=$(detect_display_manager)
            if [[ $display_manager="unknown" || $display_manager="ly" ]]; then
                sudo systemctl enable ly
            else                
                sudo systemctl display $display_manager
                sudo systemctl enable ly
            fi
            #making fish default shell
            echo "Making fish the default shell." | pv -qL 25
            chsh -s /bin/fish
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

#self explanitory, but this function detects the display manager present
#if an obscure one is being used, it will be mistaken for not having one
#however this is not really an issue as display mangaers, other than these are extremely uncommon
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
