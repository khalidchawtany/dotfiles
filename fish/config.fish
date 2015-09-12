#. ~/.config/fish/aliases.fish
. ~/dotfiles/fish/aliases.fish

# Fish prompt/color config {{{

#set fish_color_hostname 'a67523'
set -gx fish_greeting ''

function fish_prompt
    set last_status $status

    echo ' '

    set user (whoami)

    set_color magenta
    printf '%s' $user
    set_color normal
    printf ' at '

    set_color yellow
    printf '%s' (hostname -s)
    set_color normal
    printf ' in '

    set_color $fish_color_cwd
    printf '%s' (echo $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||')
    set_color normal

    git_prompt
    virtualenv_prompt

    set_color normal
    printf ' (%s)' (date +%H:%M)
    echo

    #if test $last_status -eq 0
    #    set_color white -o
    #    printf '><((°> '
    #else
    #    set_color red -o
    #    printf '><((ˣ> '
    #    set_color white -o
    #    printf '[%d] ' $last_status
    #end

    if test $last_status -ne 0
        set_color white -o
        printf '[%d] ' $last_status
        set_color normal
    end
    printf '$ '

    set_color normal
end

function demo-mode
    function fish_prompt
        set last_status $status
        printf '$ '
    end
end

function git_current_branch -d 'Prints a human-readable representation of the current branch'
  set -l ref (git symbolic-ref HEAD ^/dev/null; or git rev-parse --short HEAD ^/dev/null)
  if test -n "$ref"
    echo $ref | sed -e s,refs/heads/,,
    return 0
  end
end

function git_prompt
    if git rev-parse --show-toplevel >/dev/null 2>&1
        set_color normal
        printf ' on '
        set_color magenta
        printf '%s' (git_current_branch)
        set_color green
        #git_prompt_status
        set_color normal
    end
end

function virtualenv_prompt
    if [ -n "$VIRTUAL_ENV" ]
        printf ' inside '
        set_color yellow
        printf '%s ' (basename "$VIRTUAL_ENV")
        set_color normal
    end
end

#function orig_fish_prompt
#    set_color white
#    echo -n (whoami)
#    set_color normal
#    echo -n @
#    set_color $fish_color_hostname
#    echo -n (hostname -s)
#    #set_color normal
#    echo -n ' % '
#end

#function fish_right_prompt
#    set_color $fish_color_cwd
#    echo -n (prompt_pwd)
#end

# }}}

# Globals
set -gx EDITOR vim
#set -gx PIP_DOWNLOAD_CACHE ...

# Auto push/pop of directories {{{

#
# Unfortunately, fish's pushd/popd behaviour seems a little buggy, and since
# pushd uses "cd" under the covers, I'm unable to alias cd to be pushd under
# the hood, so I've reimplemented this myself, using the $dirprev env variable.
#
function po --description 'Pop back to previous directory on the dir stack'
    set -l last $dirprev[-1]

    # "Pop" the last one off
    set -e dirprev[-1]

    # Switch to the last dir
    cd $last

    # Then discard this switch (which gets recorded in the dir history)
    set -e dirprev[-1]
end

# }}}

# Key bindings {{{

function fish_user_key_bindings
    bind \ec append-copy
    bind \ep prepend-paste
    bind \ev prepend-vim
    bind \ey 'commandline -b | pbcopy'
    bind \e'>' 'commandline -a -- "| shiftr"'
    bind \e'<' 'commandline -a -- "| shiftl"'
    bind \es 'git st'
    bind \ed 'git di'
    bind \ex 'git x'
end

# }}}

# Interactive/login shells {{{

if status --is-login
    . ~/.config/fish/env.fish
end

if status --is-interactive
    set CDPATH . ~/Projects/yesgraph ~/Projects ~/Dropbox/Scans
end

# }}}

set -gx __fish_initialized 1

#eval (direnv hook fish)


. ~/dotfiles/fish/theme.fish
#. ~/dotfiles/zsh/aliases.zsh



