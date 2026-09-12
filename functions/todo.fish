#!/usr/bin/env fish
function add_due_date
    read -P "Add a due date? [y/N] " answer

    if not string match -qri '^(y|yes)$' -- "$answer"
        return 0
    end

    read -P "Due in how many units? " amount
    read -P "Unit (minutes, hours, days, weeks, months, years, lustres, decades, centuries): " unit

    if not string match -qr '^[1-9][0-9]*$' -- "$amount"
        echo "Amount must be a positive integer." >&2
        return 1
    end

    switch $unit
        case minute minutes
            set unit minutes
        case hour hours
            set unit hours
        case day days
            set unit days
        case week weeks
            set unit weeks
        case month months
            set unit months
        case year years
            set unit years
        case lustre lustres
            set amount (math "$amount * 5")
            set unit years
        case decade decades
            set amount (math "$amount * 10")
            set unit years
        case century centuries
            set amount (math "$amount * 100")
            set unit years
        case '*'
            echo "Unknown time unit: $unit" >&2
            return 1
    end

    set -l due_date (date -d "+$amount $unit" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)

    if test $status -ne 0; or test -z "$due_date"
        echo "Could not calculate that due date." >&2
        return 1
    end

    echo $due_date
end

function center_text
    set width (tput cols)
    set lines (string split \n -- "$argv")

    set first_width (string length -- "$lines[1]")
    set padding (math "max(0, floor(($width - $first_width) / 2))")

    set index 1

    for line in $lines
        if test (count $lines) -ge 2
            printf '%*s%s%s\n' $padding '' "$index) " "$line"
            set index (math $index + 1)
        else
            printf '%*s%s\n\n' $padding '' "$line"
        end
    end
end

function copy
    switch "$XDG_SESSION_TYPE"
        case wayland
            if command -q wl-copy
                wl-copy >/dev/null 2>&1 &
                return
            end

        case x11
            if command -q xclip
                xclip -selection clipboard
                return
            else if command -q xsel
                xsel --clipboard --input
                return
            end
    end

    # Fallbacks when XDG_SESSION_TYPE is missing
    if test -n "$WAYLAND_DISPLAY"; and command -q wl-copy
        wl-copy >/dev/null 2>&1 &
        return
    else if test -n "$DISPLAY"; and command -q xclip
        xclip -selection clipboard
        return
    else if test -n "$DISPLAY"; and command -q xsel
        xsel --clipboard --input
        return
    end

    echo "No graphical clipboard available." >&2
    return 1
end

function todo
    set -l todo_file $HOME/.config/fish/todo.txt

    switch "$argv[1]"
        case add
            if test (count $argv) -lt 2
                echo "Usage: todo add 'Your task here'"
                return 1
            end
            # set -l total_lines_num (math (wc -l < $todo_file \
            # | tr -s '[:space]' ' ' | cut -d ' ' -f 1) + 1)
            set -l timestamp (date '+%Y-%m-%d %H:%M:%S')
            set -l task (string replace -r '^add\s+' '' -- "$argv")

            set -l due_date (add_due_date)
            echo $due_date

            if test -n "$due_date"
                set task "$task (due $due_date)"
                echo $due
            end
            echo $task "(added $timestamp) " >>$todo_file
            # Yup, I love emojis
            center_text "📝 Task added!"
        case clear nukeall
            echo -n "" >$todo_file
            center_text "🧹 Todo list cleared!"
        case copy
            if not test -s $todo_file
                center_text "🎉 No pending tasks to copy!"
                return 0
            end

            sed -i '/^\s*$/d' $todo_file

            # Using a dynamic subshell that flushes the selection to TTY explicitly, 
            # breaking Kitty's OSC 52 clipboard waiting lockup.
            # Thanks Gemini for finding the solution to a problem 
            # that probably did not exist at all.
            # sh -c "selected=\$(fzf --height=40% --layout=reverse --prompt='⚡ Select task to copy: ' < $todo_file); if [ -n \"\$selected\" ]; then echo -n \"\$selected\" | wl-copy 2>/dev/null; echo \"📋 Copied to clipboard: \\\"\$selected\\\"\" >/dev/tty; else echo \"🚫 Copy canceled.\" >/dev/tty; fi"

            set -l selected (
              fzf \
                  --height=40% \
                  --layout=reverse \
                  --prompt='⚡ Select task to copy: ' \
                  < "$todo_file"
            )

            if test -n "$selected"
                printf '%s' "$selected" | copy
                if test -e /dev/tty
                    center_text "📋 Copied to clipboard: $selected" >/dev/tty
                else
                    center_text "📋 Copied to clipboard: $selected" >&2
                end
            else
                # printf '%s\n' '🚫 Copy canceled.' >/dev/tty
                center_text '🚫 Copy canceled.' >/dev/tty
            end
        case del delete nuke
            set -l argument_count (count $argv)

            if test $argument_count -ne 2; and test $argument_count -ne 3
                center_text "Usage:"
                center_text "todo delete NUMBER"
                center_text "todo delete START END"
                return 1
            end

            set -l first $argv[2]
            set -l last $first

            if test $argument_count -eq 3
                set last $argv[3]
            end

            if not string match -qr '^[1-9][0-9]*$' -- "$first"; or not string match -qr '^[1-9][0-9]*$' -- "$last"
                echo "Task numbers must be positive integers."
                return 1
            end

            if test $first -gt $last
                echo "START must not be greater than END."
                return 1
            end

            set -l total (wc -l < "$todo_file" | string trim)

            if test $last -gt $total
                echo "Task range exceeds the number of tasks ($total)."
                return 1
            end

            set -l temp_file (mktemp)

            awk -v first="$first" -v last="$last" \
                'NR < first || NR > last' \
                "$todo_file" >"$temp_file"

            mv "$temp_file" "$todo_file"

            if test $first -eq $last
                center_text "🗑️ Task $first deleted!"
            else
                center_text "🗑️ Tasks $first–$last deleted!"
            end
        case edit
            "$EDITOR" $todo_file
        case ""
            set -l tasks (cat $todo_file | string match -r '\S+')
            if test (count $tasks) -gt 0
                center_text "⚠️ Your pending tasks:"
                center_text (awk '{ print }' "$todo_file" | string collect)
            else
                center_text "🎉 No pending tasks!"
            end
        case *
            center_text "Usage: todo [add task | clear/nukeall | copy | del/nuke number | edit]"
    end
end
