vcmd(){
    local $*;
    #Check if tmux is running
    if [ "$TMUX" != "" ]; then

        vim_target='nvim'
        if [[ -n "$target" ]]; then; vim_target=$target; fi;

        #Hold the id of the vim running session:window.pane
        vid=`tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}' | grep "$vim_target" | cut -d' ' -f1`
        window_id=`tmux list-panes -a -F '#{window_index} #{pane_current_command}' | grep "$vim_target" | cut -d' ' -f1`

        #if a command is not specified then send all
        if [[ -z "$cmd" ]]; then; cmd=$@; fi;

        #Should we send Enter after the command
        send_cr=''
        if [[ -n "$cr" ]]; then; send_cr=$cr; fi;

        #Check if vim is running inside tmux
        if  [ ${vid:+1} ]; then

                #Activate the tmux window containing VIM
                tmux select-window -t ${window_id}

                tmux send-keys -t ${vid} 'C-[' $cmd $send_cr

        else
            nv $cmd $send_cr
        fi

    fi
}

