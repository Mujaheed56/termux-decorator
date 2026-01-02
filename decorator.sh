#!/bin/bash

# ================= COLORS =================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# ================= BACKUP =================
BACKUP_FILE="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"

clear
echo -e "${GREEN}"
figlet "Decorator" 2>/dev/null || echo "TERMUX DECORATOR"
echo -e "${NC}"
sleep 0.5

# ================= MENU =================
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

# ================= INSTALL =================
install_packages() {
    echo -e "${YELLOW}[+] installing packages...${NC}"
    pkg install figlet toilet lolcat termux-api -y > /dev/null 2>&1

    if ! command -v figlet &>/dev/null; then
        echo -e "${RED}[!] figlet failed to install${NC}"
        exit 1
    fi
}

# ================= BACKUP =================
backup_bashrc() {
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$BACKUP_FILE"
        echo -e "${GREEN}[✓] backup saved: $BACKUP_FILE${NC}"
    fi
}

# ================= RESTORE =================
restore_backup() {
    echo ""
    echo -e "${YELLOW}Available backups:${NC}"
    ls -1 "$HOME"/.bashrc.backup.* 2>/dev/null || echo "no backups found"
    echo ""
    read -p "enter backup filename (or q): " backup_choice

    [ "$backup_choice" = "q" ] && return

    if [ -f "$backup_choice" ]; then
        cp "$backup_choice" "$HOME/.bashrc"
        echo -e "${GREEN}[✓] restored successfully${NC}"
    else
        echo -e "${RED}[!] file not found${NC}"
    fi
}

# ================= REMOVE =================
remove_decoration() {
    backup_bashrc
    echo "# clean bashrc" > ~/.bashrc
    echo -e "${GREEN}[✓] decoration removed${NC}"
}

# ================= COLOR PICKER =================
choose_color() {
    echo "" >&2
    echo "pick a color:" >&2
    echo "1) red" >&2
    echo "2) green" >&2
    echo "3) yellow" >&2
    echo "4) blue" >&2
    echo "5) purple" >&2
    echo "6) cyan" >&2
    read -p "enter number: " color_choice >&2

    case $color_choice in
        1) echo "\033[0;31m";;
        2) echo "\033[0;32m";;
        3) echo "\033[1;33m";;
        4) echo "\033[0;34m";;
        5) echo "\033[0;35m";;
        6) echo "\033[0;36m";;
        *) echo "\033[0;32m";;
    esac
}

# ================= FONT PICKER =================
choose_font() {
    echo "" >&2
    echo "choose banner style:" >&2
    echo "1) standard (default)" >&2
    echo "2) slant" >&2
    echo "3) banner" >&2
    echo "4) digital" >&2
    echo "5) bubble" >&2
    echo "6) script" >&2
    read -p "enter number: " font_choice >&2

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

# ================= SETUP =================
setup_decoration() {
    install_packages
    backup_bashrc

    echo ""
    read -p "enter banner text: " banner_name

    selected_font=$(choose_font)

    echo ""
    echo "banner color:"
    banner_color=$(choose_color)

    echo ""
    echo "welcome message color:"
    msg_color=$(choose_color)

    echo ""
    read -p "enter welcome message: " welcome_msg

    echo ""
    read -p "show system info? (y/n): " show_info

    echo ""
    read -p "enable voice greeting? (y/n): " enable_tts

    echo "# termux decorator config" > ~/.bashrc
    echo "clear" >> ~/.bashrc

    echo "echo -e \"$banner_color\"" >> ~/.bashrc
    if [ "$selected_font" = "standard" ]; then
        echo "figlet -c \"$banner_name\"" >> ~/.bashrc
    else
        echo "figlet -f $selected_font -c \"$banner_name\"" >> ~/.bashrc
    fi
    echo "echo -e \"$NC\"" >> ~/.bashrc

    if [[ "$show_info" =~ ^[Yy]$ ]]; then
        echo "echo -e \"${CYAN}┌─────────────────────────┐${NC}\"" >> ~/.bashrc
        echo "echo -e \"${CYAN}│${NC} Date: \$(date '+%Y-%m-%d %H:%M')\"" >> ~/.bashrc
        echo "echo -e \"${CYAN}│${NC} User: \$USER\"" >> ~/.bashrc
        echo "if command -v termux-battery-status &>/dev/null; then" >> ~/.bashrc
        echo "  battery=\$(termux-battery-status | grep percentage | awk '{print \$2}' | tr -d ',')" >> ~/.bashrc
        echo "  echo -e \"${CYAN}│${NC} Battery: \${battery}%\"" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
        echo "echo -e \"${CYAN}└─────────────────────────┘${NC}\"" >> ~/.bashrc
    fi

    echo "echo -e \"$msg_color$welcome_msg$NC\"" >> ~/.bashrc

    if [[ "$enable_tts" =~ ^[Yy]$ ]]; then
        echo "if command -v termux-tts-speak &>/dev/null; then" >> ~/.bashrc
        echo "  termux-tts-speak \"$welcome_msg\" &>/dev/null &" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi

    echo ""
    echo -e "${GREEN}[✓] setup complete! restart termux${NC}"
    echo -e "${YELLOW}[i] backup: $BACKUP_FILE${NC}"
}

# ================= LOOP =================
while true; do
    show_menu

    case $choice in
        1) setup_decoration ;;
        2) restore_backup ;;
        3) remove_decoration ;;
        4) echo -e "${GREEN}bye 👋${NC}"; exit 0 ;;
        *) echo -e "${RED}invalid option${NC}"; sleep 1 ;;
    esac

    echo ""
    read -p "press enter to continue..."
    clear
done
