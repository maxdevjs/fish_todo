complete -c todo -f

complete -c todo -n __fish_use_subcommand \
    -a 'a add' \
    -d 'Add a task'

complete -c todo -n __fish_use_subcommand \
    -a 'del delete nuke' \
    -d 'Delete a specific task at provided index'

complete -c todo -n __fish_use_subcommand \
    -a 'clear nukeall' \
    -d 'Delete all tasks'

complete -c todo -n __fish_use_subcommand \
    -a copy \
    -d 'Copy tasks'

complete -c todo -n '__fish_seen_subcommand_from copy' \
    -a 't task' \
    -d 'Copy one task'

complete -c todo -n '__fish_seen_subcommand_from copy' \
    -a 'a all' \
    -d 'Copy all tasks'

# complete -c todo \
#     -n '__fish_seen_subcommand_from del delete nuke' \
#     -a '(__todo_complete_tasks)' \
#     -d 'Task number or range'

# complete -c todo -n '__fish_seen_subcommand_from del delete nuke' \
#     -a 'n...n' \
#     -d 'Debug completion'

# function __todo_complete_tasks
#     todo list --ids 2>/dev/null
# end
