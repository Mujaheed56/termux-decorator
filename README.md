# Termux Decorator Tool

Make your Termux look and sound cooler with a custom banner and welcome message — including voice greeting support!

## Features

- Custom banner using `figlet`
- Personalized welcome message
- Optional voice welcome with `termux-tts-speak`
- Automatically updates `.bashrc`

## Installation

```bash
pkg update && pkg upgrade
pkg install git -y
git clone https://github.com/yourusername/termux-decorator
cd termux-decorator
bash decorator.sh
```

## Requirements

- `figlet`, `toilet`, `termux-api`
- You must install **Termux:API app** from F-Droid for voice to work.

Download Termux:API from: [https://f-droid.org/en/packages/com.termux.api/](https://f-droid.org/en/packages/com.termux.api/)

## Voice Setup (Optional)

If you want the welcome message to be spoken aloud:

1. Install the **Termux:API** app.
2. Grant **Microphone permission** in your phone settings.
3. Run:

```bash
termux-setup-storage
```

4. Test voice:

```bash
termux-tts-speak "Welcome to Termux"
```

## To Reset Termux

If you want to remove the decoration:

```bash
rm ~/.bashrc && termux-reload-settings
```

## Author

**Phantom**

## License

MIT
