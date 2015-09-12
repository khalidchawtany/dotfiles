
#function pcommand() { echo -ne "\x1b[38;2;255;200;0m⌘ \x1b[0m" }
#function parrow() { echo -ne "\x1b[38;2;255;95;28m»\x1b[0m" }

#setopt PROMPT_SUBST

#PROMPT= '$(print_prompt)'
#PROMPT='$(pcommand) %c $(parrow) '
#export PS1='$PR_YELLOW%B %c '
## ls colors
#autoload -U colors && colors
#export LSCOLORS="Gxfxcxdxbxegedabagacad"

## Enable ls colors
#if [ "$DISABLE_LS_COLORS" != "true" ]
#then
  ## Find the option for using colors in ls, depending on the version: Linux or BSD
  #if [[ "$(uname -s)" == "NetBSD" ]]; then
    ## On NetBSD, test if "gls" (GNU ls) is installed (this one supports colors);
    ## otherwise, leave ls as is, because NetBSD's ls doesn't support -G
    #gls --color -d . &>/dev/null 2>&1 && alias ls='gls --color=tty'
  #elif [[ "$(uname -s)" == "OpenBSD" ]]; then
    ## On OpenBSD, test if "colorls" is installed (this one supports colors);
    ## otherwise, leave ls as is, because OpenBSD's ls doesn't support -G
    #colorls -G -d . &>/dev/null 2>&1 && alias ls='colorls -G'
  #else
    #ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
  #fi
#fi

##setopt no_beep
#setopt auto_cd
#setopt multios
#setopt cdablevars

#if [[ x$WINDOW != x ]]
#then
    #SCREEN_NO="%B$WINDOW%b "
#else
    #SCREEN_NO=""
#fi

## Apply theming defaults
#PS1="%n@%m:%~%# "

## git theming default: Variables for theming the git info prompt
#ZSH_THEME_GIT_PROMPT_PREFIX="git:("         # Prefix at the very beginning of the prompt, before the branch name
#ZSH_THEME_GIT_PROMPT_SUFFIX=")"             # At the very end of the prompt
#ZSH_THEME_GIT_PROMPT_DIRTY="*"              # Text to display if the branch is dirty
#ZSH_THEME_GIT_PROMPT_CLEAN=""               # Text to display if the branch is clean

## Setup the prompt with pretty colors
#setopt prompt_subst




##Solve slow git dirs for oh-my-zsh
#function git_prompt_info() {
    #ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    ## echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"

    ##use this if using robbyrussel zsh theme
    #echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
#}





#if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
#local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"



## color vars
#eval my_gray='$FG[237]'
#eval my_orange='$FG[214]'

##PROMPT= printf "\x1b[38;2;255;200;0m⌘ \x1b[0m "
#PROMPT='$fg[yellow]⌘ %{$reset_color%}$FG[032]%c \
#$FG[105]%(!.#.»)%{$reset_color%} '
#PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
#RPS1='${return_code}'



## right prompt
#if type "virtualenv_prompt_info" > /dev/null
#then
   ##RPROMPT='$(virtualenv_prompt_info)$my_gray%n@%m%{$reset_color%}%'
   #RPROMPT='$(virtualenv_prompt_info)$my_gray$(git_prompt_info)%{$reset_color%}%'
#else
   #RPROMPT='$my_gray%n@%m%{$reset_color%}%'
#fi

## git settings
#ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075](:"
#ZSH_THEME_GIT_PROMPT_CLEAN=""
#ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

