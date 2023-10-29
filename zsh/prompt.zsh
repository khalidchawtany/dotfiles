
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1)/p'
}

# COLOR_DEF=$'%f'
# COLOR_USR=$'%F{243}'
# COLOR_DIR=$'%F{197}'
# COLOR_GIT=$'%F{39}'
# setopt PROMPT_SUBST
# export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF} $ '

PROMPT='$PR_BOLD_YELLOW⌘ $PR_GREEN%c $PR_BOLD_BLUE$(parse_git_branch)$PR_BOLD_YELLOW» $PR_WHITE'
