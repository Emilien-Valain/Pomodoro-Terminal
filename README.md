# 🍅 Pomodoro Terminal Timer

A simple and elegant Pomodoro timer for your terminal, designed for Arch Linux with Hyprland and zsh.

![Pomodoro Demo](https://img.shields.io/badge/Shell-Zsh-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)
![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?style=flat-square)

## ✨ Features

- **Simple Commands**: `wo` (work), `br` (break), `lb` (long break)
- **Pomodoro Loop**: Continuous work/break cycles with automatic long breaks every 4 sessions
- **Statistics**: Track your productivity with session counters and time tracking
- **Visual Feedback**: Colorful terminal output with lolcat
- **Audio Notifications**: System sounds and desktop notifications
- **Easy Control**: Stop timers with Ctrl+C or dedicated stop command

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/pomodoro-terminal-timer.git

# Add to your shell configuration
cat pomodoro-terminal-timer/pomodoro.zsh >> ~/.zshrc

# Reload your shell
source ~/.zshrc

# Start your first pomodoro!
wo
```

## 📋 Prerequisites

Install the required dependencies on Arch Linux:

```bash
# Required
sudo pacman -S timer lolcat

# Optional (for notifications and sound)
sudo pacman -S libnotify pulseaudio-utils
```

## 🎯 Usage

### Basic Commands
```bash
wo          # Start 25-minute work session
br          # Start 5-minute break
lb          # Start 15-minute long break
```

### Advanced Features
```bash
pomoloop    # Start continuous pomodoro loop
pomostats   # Pomodoro loop with statistics tracking
pomostop    # Stop all running timers
pomotime    # Check default session duration
pomohelp    # Show all available commands
```

### Example Session
```bash
$ wo
work session started for 25 minutes
# Timer runs for 25 minutes...
# 🔔 Sound notification + desktop notification
# "work session completed 🎉"

$ br
break session started for 5 minutes
# Timer runs for 5 minutes...
```

### Pomodoro Loop
The `pomoloop` command follows the classic Pomodoro Technique:
- 25 minutes work → 5 minutes break (repeat 4 times)
- After 4 work sessions → 15 minutes long break
- Cycle repeats automatically

## ⚙️ Configuration

Customize session durations by editing the `pomo_get_duration()` function in `pomodoro.zsh`:

```bash
pomo_get_duration() {
    case "$1" in
        "work") echo 25 ;;      # Default: 25 minutes
        "break") echo 5 ;;      # Default: 5 minutes
        "longbreak") echo 15 ;; # Default: 15 minutes
        *) echo "" ;;
    esac
}
```

## 🛠️ Installation

### Method 1: Manual Installation
1. Download the `pomodoro.zsh` file
2. Copy the content to your `.zshrc` file:
   ```bash
   nano ~/.zshrc
   # Paste the content of pomodoro.zsh at the end
   ```
3. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

## 🐛 Troubleshooting

### Timer won't stop with Ctrl+C
```bash
# Use the stop command
pomostop

# Or manually kill timer processes
pkill -f timer
```

### Commands not found after installation
```bash
# Reload your shell configuration
source ~/.zshrc

# Check if functions are loaded
type pomo_get_duration
```

### No sound notifications
```bash
# Test audio
paplay /usr/share/sounds/freedesktop/stereo/message.oga

# Check if pulseaudio is running
pulseaudio --check
```

### No desktop notifications
```bash
# Test notifications
notify-send "Test" "This is a test notification"

# Install libnotify if missing
sudo pacman -S libnotify
```

## 📊 Commands Reference

| Command | Description | Duration |
|---------|-------------|----------|
| `wo` | Work session | 25 minutes |
| `br` | Break session | 5 minutes |
| `lb` | Long break | 15 minutes |
| `pomoloop` | Continuous pomodoro | Auto-cycling |
| `pomostats` | Loop with statistics | Auto-cycling |
| `pomostop` | Stop all timers | Instant |
| `pomotime` | Show durations | - |
| `pomohelp` | Show help | - |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License 

## 🙏 Acknowledgments

- Inspired by the [Bashbunni's Project](https://youtu.be/GfQjJBtO-8Y?si=uqYvHAkiMiYcmiTO)
- Built for the Arch Linux and Hyprland community
- Uses the excellent `timer` utility and `lolcat` for colorful output

---

⭐ **If you find this useful, please give it a star!** ⭐
