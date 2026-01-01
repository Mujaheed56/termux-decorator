# Termux Decorator Tool v2.0

make your termux terminal look sick with custom banners, colors, and system info. now with way more features and safer backup system!

## New Features ✨

- **6 different figlet fonts** - choose from standard, slant, banner, digital, bubble, and script
- **color customization** - pick colors for banner and messages (6 colors available)
- **system info display** - shows date, time, user, and battery status
- **automatic backups** - your .bashrc gets backed up before any changes
- **restore function** - easily restore from backups if something breaks
- **optional tts** - you can now disable voice greeting if you dont want it
- **menu system** - easy navigation with options to setup, restore, or remove
- **remove decoration** - clean uninstall option built in

## Features

- custom ascii banner using figlet
- personalized welcome message with colors
- optional voice greeting with termux-tts-speak
- system information display (battery, date, user)
- automatic backup system (timestamps included)
- multiple font styles to choose from
- color picker for banners and messages
- safe restoration from backups

## Installation

```bash
pkg update && pkg upgrade
pkg install git -y
git clone https://github.com/Mujaheed56/termux-decorator
cd termux-decorator
bash decorator.sh
```

the script will automatically install figlet, toilet, lolcat, and termux-api when you run it.

## Requirements

- android device with termux installed
- internet connection for package installation
- termux:api app (optional, only for voice and battery info)

download termux:api from f-droid: [https://f-droid.org/en/packages/com.termux.api/](https://f-droid.org/en/packages/com.termux.api/)

## How to Use

when you run `bash decorator.sh` you'll see a menu:

1. **setup new decoration** - create your custom terminal look
2. **restore backup** - go back to a previous .bashrc backup
3. **remove decoration** - completely remove all decorations
4. **exit** - quit the tool

### setting up decoration

1. choose your banner text
2. pick a font style (6 options)
3. select banner color
4. select message color
5. enter welcome message
6. decide if you want system info
7. decide if you want voice greeting

all your choices get saved and applied automatically!

## Voice Setup (Optional)

if you want voice greeting:

1. install the termux:api app from f-droid
2. give microphone permission in android settings
3. run `termux-setup-storage` in termux
4. test with: `termux-tts-speak "hello"`

the script will ask if you want tts enabled so its totally optional now.

## Backup System

every time you make changes, the tool creates a backup with timestamp like:
```
.bashrc.backup.20260101_143022
```

you can restore any backup using option 2 in the menu. backups are stored in your home directory.

## removing decoration

just run the script and choose option 3 "remove decoration". it will backup your current setup then clean your .bashrc file.

## Author

**Phantom**

## License

MIT
