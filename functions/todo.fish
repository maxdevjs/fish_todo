function todo
    set -l todo_file $HOME/.config/fish/todo.txt

    switch "$argv[1]"
        case add
            if test (count $argv) -lt 2
                echo "Usage: todo add 'Your task here'"
                return 1
            end
            # echo $argv[2..-1] >>$todo_file
            set -l task (string replace -r '^add\s+' '' -- "$argv")
            echo $task >>$todo_file
            # Yup, I love emojis
            echo "📝 Task added!"
        case clear
            echo -n "" >$todo_file
            echo "🧹 Todo list cleared!"
        case copy
            if not test -s $todo_file
                echo "🎉 No pending tasks to copy!"
                return 0
            end

            sed -i '/^\s*$/d' $todo_file

            # Using a dynamic subshell that flushes the selection to TTY explicitly, 
            # breaking Kitty's OSC 52 clipboard waiting lockup.
            # Thanks Gemini for finding the solution to a problem 
            # that probably did not exist at all.
            sh -c "selected=\$(fzf --height=40% --layout=reverse --prompt='⚡ Select task to copy: ' < $todo_file); if [ -n \"\$selected\" ]; then echo -n \"\$selected\" | wl-copy 2>/dev/null; echo \"📋 Copied to clipboard: \\\"\$selected\\\"\" >/dev/tty; else echo \"🚫 Copy canceled.\" >/dev/tty; fi"

        case del
            if test (count $argv) -lt 2
                echo "Usage: todo del [line_number]"
                return 1
            end

            # Is input a valid number?
            set -l line_num "$argv[2]"
            if not string match -qr '^[0-9]+$' -- "$line_num"
                echo "Error: Please provide a valid line number."
                return 1
            end

            # Empty lines are not welcomed in the file
            if test -f $todo_file
                sed -i '/^\s*$/d' $todo_file
            end

            # How many lines (tasks/todos) we do have currently?
            set -l total_tasks (wc -l < $todo_file | string trim)

            # Delete the task at that specific line number
            if test $line_num -le $total_tasks; and test $line_num -gt 0
                sed -i ""$line_num"d" $todo_file
                echo "❌ Task #$line_num deleted!"
            else
                echo "Error: Invalid line number. Use 'todo' to see valid numbers."
                return 1
            end
        case ""
            set -l tasks (cat $todo_file | string match -r '\S+')
            if test (count $tasks) -gt 0
                echo "⚠️  Your pending tasks:"
                cat $todo_file | awk '{print "- " $0}'
            else
                echo "🎉 No pending tasks!"
            end
        case *
            echo "Usage: todo [add 'task' | clear | copy | del 'number']"
    end
end
