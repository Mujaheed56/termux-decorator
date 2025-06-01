#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

clear
echo -e "${GREEN}[*] Termux Decorator Tool${NC}"
sleep 1

echo -e "${GREEN}[+] Installing required packages...${NC}"
pkg install figlet toilet termux-api -y > /dev/null 2>&1

if ! command -v termux-tts-speak &> /dev/null; then
    echo -e "${RED}[!] termux-api not working. Make sure you installed Termux:API from F-Droid and gave permissions.${NC}"
fi

read -p "Enter your banner name: " banner_name
read -p "Enter your welcome message: " welcome_msg

echo "clear" > ~/.bashrc
echo "figlet -c \"$banner_name\"" >> ~/.bashrc
echo "echo -e \"\033[1;32m$welcome_msg\033[0m\"" >> ~/.bashrc
echo "termux-tts-speak \"$welcome_msg\"" >> ~/.bashrc

echo -e "${GREEN}[✓] Setup complete! Open a new Termux session to see your custom decoration.${NC}"
