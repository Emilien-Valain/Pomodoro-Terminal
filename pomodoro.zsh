# 🕒 Pomodoro timer
# Requires: timer, notification daemon, lolcat

# Initialize pomodoro durations with a simple approach that works reliably in zsh
pomo_get_duration() {
    case "$1" in
        "work") echo 25 ;;
        "break") echo 5 ;;
        "longbreak") echo 15 ;;
        *) echo "" ;;
    esac
}

pomodoro () {
    clear
    local val=$1
    local duration=$(pomo_get_duration "$1")
    
    if [[ -n "$1" && -n "$duration" ]]; then
        echo "$val session started for $duration minutes" | lolcat
        timer "${duration}m"
        paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null || true
        notify-send "Pomodoro" "'$val' session completed 🎉"
    else
        echo "Usage: pomodoro [work|break|longbreak]" | lolcat
        echo "Available sessions:"
        echo "  work: $(pomo_get_duration work) minutes"
        echo "  break: $(pomo_get_duration break) minutes"  
        echo "  longbreak: $(pomo_get_duration longbreak) minutes"
    fi
}

pomo_loop () {
    clear
    local state="work"
    local work_sessions=0
    
    echo "🍅 Pomodoro loop started! Press Ctrl+C to stop." | lolcat
    echo "Tip: If Ctrl+C doesn't work, open another terminal and run: pkill -f timer" | lolcat
    
    # Set up signal handling
    trap 'echo "\n🛑 Pomodoro loop stopped by user"; pkill -f timer 2>/dev/null; exit 0' INT TERM
    
    while true; do
        echo "\n▶️  Starting $state session..." | lolcat
        pomodoro "$state"
        
        # Toggle between work and break
        if [[ "$state" == "work" ]]; then
            work_sessions=$((work_sessions + 1))
            
            # Long break every 4 work sessions
            if (( work_sessions % 4 == 0 )); then
                state="longbreak"
                echo "Time for a long break! (${work_sessions} sessions completed)" | lolcat
            else
                state="break"
            fi
        else
            state="work"
        fi
        
        # Small pause between sessions with countdown
        echo "Next session in 3 seconds... (Ctrl+C to stop)" | lolcat
        sleep 1
        echo "2..." | lolcat
        sleep 1  
        echo "1..." | lolcat
        sleep 1
    done
}

# Enhanced version with session counter and statistics
pomo_stats () {
    local state="work"
    local work_sessions=0
    local start_time=$(date +%s)
    
    echo "🍅 Pomodoro session with stats started!" | lolcat
    echo "Press Ctrl+C to stop and see statistics." | lolcat
    
    # Trap Ctrl+C to show stats before exiting
    trap 'pomo_show_stats $work_sessions $start_time; pkill -f timer 2>/dev/null; exit 0' INT TERM
    
    while true; do
        echo "\n▶️  Starting $state session..." | lolcat
        pomodoro "$state"
        
        if [[ "$state" == "work" ]]; then
            work_sessions=$((work_sessions + 1))
            echo "✅ Work session #$work_sessions completed!" | lolcat
            
            if (( work_sessions % 4 == 0 )); then
                state="longbreak"
                echo "🎉 Time for a long break! (${work_sessions} sessions completed)" | lolcat
            else
                state="break"
            fi
        else
            state="work"
        fi
        
        # Pause with ability to interrupt
        echo "Next session in 3 seconds... (Ctrl+C to stop)" | lolcat
        sleep 1
        echo "2..." | lolcat  
        sleep 1
        echo "1..." | lolcat
        sleep 1
    done
}

pomo_show_stats () {
    local sessions=$1
    local start_time=$2
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local hours=$((duration / 3600))
    local minutes=$(((duration % 3600) / 60))
    
    echo "\n📊 Pomodoro Session Statistics:" | lolcat
    echo "Work sessions completed: $sessions"
    echo "Total time: ${hours}h ${minutes}m"
    echo "Focus time: $((sessions * 25)) minutes"
    notify-send "Pomodoro Stats" "Completed $sessions work sessions in ${hours}h ${minutes}m"
}

# Function to stop all running timers
pomo_stop () {
    pkill -f timer 2>/dev/null && echo "🛑 All pomodoro timers stopped" | lolcat || echo "No running timers found" | lolcat
}

# Quick time check
pomo_time () {
    local session_type=${1:-work}
    local duration=$(pomo_get_duration "$session_type")
    
    if [[ -n "$duration" ]]; then
        echo "⏰ $session_type session duration: $duration minutes" | lolcat
    else
        echo "❌ Unknown session type: $session_type" | lolcat
        echo "Available: work, break, longbreak" | lolcat
    fi
}

# Aliases
alias wo="pomodoro work"
alias br="pomodoro break"
alias lb="pomodoro longbreak"
alias pomoloop="pomo_loop"
alias pomostats="pomo_stats"
alias pomostop="pomo_stop"
alias pomotime="pomo_time"
alias pomohelp='echo "🍅 Pomodoro Commands:\n  wo - work session (25min)\n  br - break session (5min)\n  lb - long break (15min)\n  pomoloop - continuous pomodoro\n  pomostats - pomodoro with statistics\n  pomostop - stop all running timers\n  pomotime [type] - check session duration\n  pomohelp - show this help" | lolcat'