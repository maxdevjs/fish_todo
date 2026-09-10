if not test -f $HOME/.config/fish/todo.txt
    touch $HOME/.config/fish/todo.txt
end

# Login Reminder
if status is-interactive
    if test -s $HOME/.config/fish/todo.txt
        if test (cat $HOME/.config/fish/todo.txt | string trim | count ) -gt 0
            echo ""
            todo
            echo ""
        end
    end
end

# Periodic Reminder (Every 20 commands)
function alert_todo_periodic --on-event fish_postexec
    if test -s $HOME/.config/fish/todo.txt
        set -l periodic_tasks (cat $HOME/.config/fish/todo.txt | string match -r '\S+')
        if test (count $periodic_tasks) -eq 0
            return
        end
    end
    if not set -q todo_cmd_count
        set -g todo_cmd_count 0
    end

    set todo_cmd_count (math $todo_cmd_count + 1)

    if test $todo_cmd_count -ge 20
        echo ""
        echo "🔔 [Periodic Reminder]"
        todo
        echo ""
        set -g todo_cmd_count 0
    end
end
