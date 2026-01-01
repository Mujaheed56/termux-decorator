#!/bin/bash

# colors for making stuff look nice
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# backup file location incase somthing goes wrong
BACKUP_FILE="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"

clear
echo -e "${GREEN}"
figlet "Decorator" 2>/dev/null || echo "TERMUX DECORATOR"
echo -e "${NC}"
sleep 0.5

# function to show menu cause i dont wanna repeat code lol
show_menu() {
    echo ""
    echo -e "${CYAN}=== Termux Decorator v2.0 ===${NC}"
    echo "1) Setup new decoration"
    echo "2) Restore backup"
    echo "3) Remove decoration"
    echo "4) Exit"
    echo ""
    read -p "choose option: " choice
}

# install stuff we need, silently so it dont spam terminal
install_packages() {
    echo -e "${YELLOW}[+] installing packages... this might take a min${NC}"
    pkg install figlet toilet lolcat termux-api -y > /dev/null 2>&1
    
    # check if figlet actually installed
    if ! command -v figlet &> /dev/null; then
        echo -e "${RED}[!] figlet didnt install properly, try again maybe?${NC}"
        exit 1
    fi
}

# backup function so we dont loose users stuff
backup_bashrc() {
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$BACKUP_FILE"
        echo -e "${GREEN}[✓] backed up .bashrc to $BACKUP_FILE${NC}"
    fi
}

# restore from backup if user messed up
restore_backup() {
    echo ""
    echo -e "${YELLOW}Available backups:${NC}"
    ls -1 "$HOME"/.bashrc.backup.* 2>/dev/null || echo "no backups found :("
    echo ""
    read -p "enter backup file name (or 'q' to cancel): " backup_choice
    
    if [ "$backup_choice" = "q" ]; then
        return
    fi
    
    if [ -f "$backup_choice" ]; then
        cp "$backup_choice" "$HOME/.bashrc"
        echo -e "${GREEN}[✓] restored sucessfully!${NC}"
    else
        echo -e "${RED}[!] backup file not found bro${NC}"
    fi
}

# remove all decorations and make bashrc clean again
remove_decoration() {
    backup_bashrc
    echo "# bashrc" > ~/.bashrc
    echo -e "${GREEN}[✓] decoration removed, terminal is clean now${NC}"
}

# let user pick what color they want
choose_color() {
    echo ""
    echo "pick a color:"
    echo "1) red"
    echo "2) green"
    echo "3) yellow"
    echo "4) blue"
    echo "5) purple"
    echo "6) cyan"
    read -p "enter number: " color_choice
    
    case $color_choice in
        1) echo "\033[0;31m";;
        2) echo "\033[0;32m";;
        3) echo "\033[1;33m";;
        4) echo "\033[0;34m";;
        5) echo "\033[0;35m";;
        6) echo "\033[0;36m";;
        *) echo "\033[0;32m";; # default green if they put wrong number
    esac
}

# show available fonts cause figlet has bunch of them
choose_font() {
    echo ""
    echo "choose banner style:"
    echo "1) standard (default)"
    echo "2) slant"
    echo "3) banner"
    echo "4) digital"
    echo "5) bubble"
    echo "6) script"
    read -p "enter number: " font_choice
    
    case $font_choice in
        1) echo "standard";;
        2) echo "slant";;
        3) echo "banner";;
        4) echo "digital";;
        5) echo "bubble";;
        6) echo "script";;
        *) echo "standard";;
    esac
}

# main setup function where the magic happens
setup_decoration() {
    install_packages
    backup_bashrc
    
    echo ""
    read -p "enter your banner text: " banner_name
    
    # choose font style
    selected_font=$(choose_font)
    
    # choose banner color
    echo ""
    echo "banner color:"
    banner_color=$(choose_color)
    
    # choose message color
    echo ""
    echo "welcome message color:"
    msg_color=$(choose_color)
    
    echo ""
    read -p "enter welcome message: " welcome_msg
    
    # ask if they want system info stuff
    echo ""
    read -p "show system info? (battery, date, etc) [y/n]: " show_info
    
    # ask bout the voice thing cause not everyone wants it
    echo ""
    read -p "enable voice greeting? (needs termux:api) [y/n]: " enable_tts
    
    # now we write evrything to bashrc
    echo "# termux decorator config - dont edit manually unless u know what ur doing" > ~/.bashrc
    echo "clear" >> ~/.bashrc
    
    # add the banner with chosen font
    if [ "$selected_font" = "standard" ]; then
        echo "echo -e \"${banner_color}\"" >> ~/.bashrc
        echo "figlet -c \"$banner_name\"" >> ~/.bashrc
    else
        echo "echo -e \"${banner_color}\"" >> ~/.bashrc
        echo "figlet -f $selected_font -c \"$banner_name\"" >> ~/.bashrc
    fi
    
    echo "echo -e \"${NC}\"" >> ~/.bashrc
    
    # system info if user wanted it
    if [ "$show_info" = "y" ] || [ "$show_info" = "Y" ]; then
        echo "echo -e \"${CYAN}┌─────────────────────────────┐${NC}\"" >> ~/.bashrc
        echo "echo -e \"${CYAN}│${NC} Date: \$(date '+%Y-%m-%d %H:%M')\"" >> ~/.bashrc
        echo "echo -e \"${CYAN}│${NC} User: \$USER\"" >> ~/.bashrc
        # battery only works if termux-api installed
        echo "if command -v termux-battery-status &> /dev/null; then" >> ~/.bashrc
        echo "    battery=\$(termux-battery-status 2>/dev/null | grep percentage | awk '{print \$2}' | tr -d ',')" >> ~/.bashrc
        echo "    echo -e \"${CYAN}│${NC} Battery: \${battery}%\"" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
        echo "echo -e \"${CYAN}└─────────────────────────────┘${NC}\"" >> ~/.bashrc
    fi
    
    # add welcome message
    echo "echo -e \"${msg_color}$welcome_msg${NC}\"" >> ~/.bashrc
    
    # add tts if they want it
    if [ "$enable_tts" = "y" ] || [ "$enable_tts" = "Y" ]; then
        echo "if command -v termux-tts-speak &> /dev/null; then" >> ~/.bashrc
        echo "    termux-tts-speak \"$welcome_msg\" 2>/dev/null &" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
    
    echo "" >> ~/.bashrc
    
    echo ""
    echo -e "${GREEN}[✓] setup complete! restart termux to see changes${NC}"
    echo -e "${YELLOW}[i] backup saved to: $BACKUP_FILE${NC}"
}

# main loop
while true; do
    show_menu
    
    case $choice in
        1)
            setup_decoration
            ;;
        2)
            restore_backup
            ;;
        3)
            remove_decoration
            ;;
        4)
            echo -e "${GREEN}bye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}invalid option bro, try again${NC}"
            sleep 1
            ;;
    esac
    
    echo ""
    read -p "press enter to continue..."
    clear
done
