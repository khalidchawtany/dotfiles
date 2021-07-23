#Respecting .gitignore, .hgignore, and svn:ignore
#=================================================

# Setting ag as the default source for fzf
# Now fzf (w/o pipe) will use ag instead of find
#export FZF_DEFAULT_COMMAND='ag -l -g ""'

# --files: List files that would be searched but do not search
# # --no-ignore: Do not respect .gitignore, etc...
# # --hidden: Search hidden files and folders
# # --follow: Follow symlinks
# # --glob: Additional conditions for search (in this case ignore everything in
# the .git/ folder)
#
 export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="--history=/Users/juju/.fzf_history --bind 'Ú:jump,‰:jump-accept'"


alias fzalias='alias | fzf -x --cycle'
alias ja=fzalias

alias jfasd='cd $(fasd | fzf | awk {'"'"'print $2'"'"'})'


# Opening Files {{{
    # fe [FUZZY PATTERN] - Open the selected file with the default editor
    #   - Bypass fuzzy finder if there's only one match (--select-1)
    #   - Exit if there's no match (--exit-0)
    je() {
      local file
      file=$(fzf --query="$1" --select-1 --exit-0)
      [ -n "$file" ] && ${EDITOR:-vim} "$file"
    }

    # Modified version where you can press
    #   - CTRL-O to open with `open` command,
    #   - CTRL-E or Enter key to open with the $EDITOR
    jeo() {
      local out file key
      out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
      key=$(head -1 <<< "$out")
      file=$(head -2 <<< "$out" | tail -1)
      if [ -n "$file" ]; then
        [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
      fi
    }
# Open Files }}}

# Changing directory {{{
    # fd - cd to selected directory
    jcdd() {
      local dir
      dir=$(find ${1:-*} -path '*/\.*' -prune \
                      -o -type d -print 2> /dev/null | fzf +m) &&
      cd "$dir"
    }

    jcd() {
      local dir=$(
        find . -path '*/\.*' -prune -o -type d -print |
        sed '1d;s/^..//' | fzf-tmux +m) && cd "$dir"
    }

    # fda - including hidden directories
    jcda() {
      local dir
      dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
    }

    # cdf - cd into the directory of the selected file
    jcdf() {
      local file
      local dir
      file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
    }

# Changing directory }}}

# Serachin File Contenet{{{
    alias jg='grep --line-buffered --color=never -r "" * | fzf'

    # with ag - respects .agignore and .gitignore
    alias jag='ag --nobreak --nonumbers --noheading . | fzf'

# Serachin File Contenet }}}

# history {{{
    # fh - repeat history
    jhe() {
      eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
    }

    # fh - repeat history
    jh() {
      print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
    }
# history }}}

# kill {{{
    # fkill - kill process
    jk() {
      pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

      if [ "x$pid" != "x" ]
      then
        kill -${1:-9} $pid
      fi
    }
    alias fzk=fzkill

#kill }}}

# Git {{{

    # fbr - checkout git branch
    jgco() {
      local branches branch
      branches=$(git branch) &&
      branch=$(echo "$branches" | fzf +m) &&
      git checkout $(echo "$branch" | sed "s/.* //")
    }

    # fbr - checkout git branch (including remote branches)
    jgcO() {
      local branches branch
      branches=$(git branch --all | grep -v HEAD) &&
      branch=$(echo "$branches" |
              fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
      git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    }

    # fco - checkout git branch/tag
    jgcot() {
      local tags branches target
      tags=$(
        git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
      branches=$(
        git branch --all | grep -v HEAD             |
        sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
        sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
      target=$(
        (echo "$tags"; echo "$branches") |
        fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
      git checkout $(echo "$target" | awk '{print $2}')
    }


    jgd(){
      local files file_modified file_deleted file_stage file_new

      file_modified=$(git ls-files --modified ) &&
      if [ "$file_modified" = "" ]; then file_modified=""; else file_modified="\e[32m$file_modified\n"; fi &&
      file_stage=$(git diff --cached --name-only ) &&
      if [ "$file_stage" = "" ]; then file_stage=""; else file_stage="\e[33m$file_stage\n"; fi &&
      file_deleted=$(git ls-files --deleted ) &&
      if [ "$file_deleted" = "" ]; then file_deleted=""; else file_deleted="\e[31m$file_deleted\n"; fi &&
      file_new=$(git ls-files --others --exclude-standard ) &&
      if [ "$file_new" = "" ]; then file_new=""; else file_new="\e[34m$file_new"; fi &&
      files="$file_modified$file_stage$file_deleted$file_new"

      echo -e $files | fzf --reverse --ansi \
       --bind 'Ctrl-u:execute: git reset -q HEAD {} && echo "Untrack: {}"' \
       --bind 'Ctrl-a:execute: git add {} && echo "Track: {}"' \
       --bind 'Ctrl-l:execute: git diff --color=always HEAD {} | diff-so-fancy' \
       --header "^a:add,^u:del,^l:diff" \
       --color dark \
       --preview-window right:50% \
       --preview 'git diff  --color=always HEAD $@ {} | diff-so-fancy'
    }



    # fcoc - checkout git commit
    jgcoc() {
      local commits commit
      commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
      commit=$(echo "$commits" | fzf --tac +s +m -e) &&
      git checkout $(echo "$commit" | sed "s/ .*//")
    }

    # fcoc - show git commit
    jgs() {
      local commits commit
      commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
      commit=$(echo "$commits" | fzf --ansi --no-sort --reverse --tiebreak=index --tac +s +m -e) &&
      git show $(echo "$commit" | sed "s/ .*//")
    }

    # fshow - git commit browser
    jgl() {
      git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --header "Press CTRL-S to toggle sort" \
        --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
      xargs -I % sh -c 'git show --color=always % | head -$LINES'" \
        --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
      xargs -I % sh -c 'nvim fugitive://\$(git rev-parse --show-toplevel)/.git//% < /dev/tty'"
      #xargs -I % sh -c 'nvim -c \"e fugitive://\$(git rev-parse --show-toplevel)/.git//% < /dev/tty\"'"
    }

    # fshow - git commit browser
    jglo() {
      local out sha q
      while out=$(
          git log --decorate=short --graph --oneline --color=always |
          fzf --ansi --multi --no-sort --reverse --query="$q" --print-query); do
        q=$(head -1 <<< "$out")
        while read sha; do
          [ -n "$sha" ] && git show --color=always $sha | less -R
        done < <(sed '1d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
      done
    }

    # fcs - get git commit sha
    # example usage: git rebase -i `fcs`
    jgsha() {
      local commits commit
      commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
      commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
      echo -n $(echo "$commit" | sed "s/ .*//")
    }

#}}} _Git

# Tags {{{

    # ftags - search ctags
    jt() {
      local line
      [ -e tags ] &&
      line=$(
        awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
        cut -c1-80 | fzf --nth=1,2
      ) && $EDITOR $(cut -f3 <<< "$line") -c "set nocst" \
                                          -c "silent tag $(cut -f2 <<< "$line")"
    }

#}}}

# Tmux {{{

    # fs [FUZZY PATTERN] - Select selected tmux session
    #   - Bypass fuzzy finder if there's only one match (--select-1)
    #   - Exit if there's no match (--exit-0)
    jts() {
      local session
      session=$(tmux list-sessions -F "#{session_name}" | \
        fzf --query="$1" --select-1 --exit-0) &&
      tmux switch-client -t "$session"
    }
    # ftpane - switch pane
    jtp () {
      local panes current_window target target_window target_pane
      panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
      current_window=$(tmux display-message  -p '#I')

      target=$(echo "$panes" | fzf) || return

      target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
      target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

      if [[ $current_window -eq $target_window ]]; then
        tmux select-pane -t ${target_window}.${target_pane}
      else
        tmux select-pane -t ${target_window}.${target_pane} &&
        tmux select-window -t $target_window
      fi
    }


#tmux }}}

# z {{{

    #unalias z 2> /dev/null
    #z() {
      #if [[ -z "$*" ]]; then
        #cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
      #else
        #_z "$@"
      #fi
    #}


    j() {
      if [[ -z "$*" ]]; then
        cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
      else
        _last_z_args="$@"
        _z "$@"
      fi
    }

    jj() {
			   if [ "$1" != "" ]
    then
      cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q $1)"
    else
      cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf )"
    fi

    }
#z }}}

# chrome history {{{
    # c - browse chrome history
    fhc() {
      local cols sep
      cols=$(( COLUMNS / 3 ))
      sep='{{::}}'

      # Copy History DB to circumvent the lock
      # - See http://stackoverflow.com/questions/8936878 for the file path
      cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h

      sqlite3 -separator $sep /tmp/h \
        "select substr(title, 1, $cols), url
        from urls order by last_visit_time desc" |
      awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
      fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
    }

# chrome history }}}

# locate {{{
    # ALT-I - Paste the selected entry from locate output into the command line
    fzf-locate-widget() {
      local selected
      if selected=$(locate / | fzf -q "$LBUFFER"); then
        LBUFFER=$selected
      fi
      zle redisplay
    }
    #zle     -N    fzf-locate-widget
    #bindkey '\ei' fzf-locate-widget



# locate }}}

# vagrant {{{

      vs(){
        #List all vagrant boxes available in the system including its status, and try to access the selected one via ssh
        cd $(cat ~/.vagrant.d/data/machine-index/index | jq '.machines[] | {name, vagrantfile_path, state}' | jq '.name + "," + .state  + "," + .vagrantfile_path'| sed 's/^"\(.*\)"$/\1/'| column -s, -t | sort -rk 2 | fzf | awk '{print $3}'); vagrant ssh
      }

# vagrant }}}

# do a Ag then FZF and then open that line in vim {{{
  #jag(){
    #local line
    #line=`ag --nocolor "$1" | fzf` \
      #&& : e $(cut -d':' -f1 <<< "$line") +$(cut -d':' -f2 <<< "$line")
  #}
#}}}
##Browsing
## fzf-fs
## https://github.com/D630/fzf-fs
#% [.] fzf-fs [<ARG>]



## Readline
## CTRL-X-1 - Invoke Readline functions by name
#__fzf_readline ()
#{
    #builtin eval "
        #builtin bind ' \
            #\"\C-x3\": $(
                #builtin bind -l | command fzf +s +m --toggle-sort=ctrl-r
            #) \
        #'
    #"
#}

#builtin bind -x '"\C-x2": __fzf_readline';
#builtin bind '"\C-x1": "\C-x2\C-x3"'

#export FZF_DEFAULT_OPTS='
  #--extended
  #--bind ctrl-f:page-down,ctrl-b:page-up
  #--color fg:252,bg:233,hl:67,fg+:252,bg+:235,hl+:81
  #--color info:144,prompt:161,spinner:135,pointer:135,marker:118
#'
bindkey "Ú" fzf-history-widget

    fzf-find-widget() {
      local selected
      if selected=$(ag -l -g "" | fzf -q "$LBUFFER"); then
        LBUFFER=$selected
      fi
      zle redisplay
    }
    zle     -N    fzf-find-widget
    bindkey '^r' fzf-find-widget



    alias jga='ga $(jgd)'
