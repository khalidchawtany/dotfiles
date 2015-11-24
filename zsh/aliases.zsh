setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus


#{{{ colorize man
man() {
      env \
      	  LESS_TERMCAP_mb=$(printf "\e[1;31m") \
	  LESS_TERMCAP_md=$(printf "\e[1;31m") \
	  LESS_TERMCAP_me=$(printf "\e[0m") \
	  LESS_TERMCAP_se=$(printf "\e[0m") \
	  LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
	  LESS_TERMCAP_ue=$(printf "\e[0m") \
	  LESS_TERMCAP_us=$(printf "\e[1;32m") \
	  			   man "$@"
}
#}}} colorize man


function copydir {
  pwd | tr -d "\r\n" | pbcopy
}

function copyfile {
  [[ "$#" != 1 ]] && return 1
  local file_to_copy=$1
  cat $file_to_copy | pbcopy
}


#Show progress while file is copying

# Rsync options are:
#  -p - preserve permissions
#  -o - preserve owner
#  -g - preserve group
#  -h - output in human-readable format
#  --progress - display progress
#  -b - instead of just overwriting an existing file, save the original
#  --backup-dir=/tmp/rsync - move backup copies to "/tmp/rsync"
#  -e /dev/null - only work on local files
#  -- - everything after this is an argument, even if it looks like an option

alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"






# Pipes {{{

  alias CA='2>&1 | cat -A'
  alias LL='2>&1 | less'
  alias NE='2> /dev/null'
  alias NUL='> /dev/null 2>&1'
  alias P='2>&1| pygmentize -l pytb'
  alias RED='RAILS_ENV=development'
  alias REP='RAILS_ENV=production'
  alias RET='RAILS_ENV=test'

#}}} _Pipes



# Advanced Aliases.
# Use with caution
#

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'

alias zshrc='vim ~/.zshrc' # Quick access to the ~/.zshrc file

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

# because typing 'cd' is A LOT of work!!
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias cdd='cd ~/dotfiles/'
alias cdv='cd ~/.config/nvim'

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
# alias j='jobs'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'

alias whereami=display_info

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# zsh is able to auto-do some kungfoo
# depends on the SUFFIX :)
if [ ${ZSH_VERSION//\./} -ge 420 ]; then
  # open browser on urls
  _browser_fts=(htm html de org net com at cx nl se dk dk php)
  for ft in $_browser_fts ; do alias -s $ft=$BROWSER ; done

  _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
  for ft in $_editor_fts ; do alias -s $ft=$EDITOR ; done

  _image_fts=(jpg jpeg png gif mng tiff tif xpm)
  for ft in $_image_fts ; do alias -s $ft=$XIVIEWER; done

  _media_fts=(ape avi flv mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
  for ft in $_media_fts ; do alias -s $ft=mplayer ; done

  #read documents
  alias -s pdf=acroread
  alias -s ps=gv
  alias -s dvi=xdvi
  alias -s chm=xchm
  alias -s djvu=djview

  #list whats inside packed file
  alias -s zip="unzip -l"
  alias -s rar="unrar l"
  alias -s tar="tar tf"
  alias -s tar.gz="echo "
  alias -s ace="unace l"
fi

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'



# Changing/making/removing directory{{{

  # Basic directory navigation
  alias -- -='cd -'
  alias ..='cd ..'
  alias ...='cd ../..'
  alias cd..='cd ..'
  alias cd...='cd ../..'
  alias cd....='cd ../../..'
  alias cd.....='cd ../../../..'
  alias cd/='cd /'

  alias 1='cd -'
  alias 2='cd -2'
  alias 3='cd -3'
  alias 4='cd -4'
  alias 5='cd -5'
  alias 6='cd -6'
  alias 7='cd -7'
  alias 8='cd -8'
  alias 9='cd -9'

  cd () {
    if   [[ "x$*" == "x..." ]]; then
      cd ../..
    elif [[ "x$*" == "x...." ]]; then
      cd ../../..
    elif [[ "x$*" == "x....." ]]; then
      cd ../../../..
    elif [[ "x$*" == "x......" ]]; then
      cd ../../../../..
    elif [ -d ~/.autoenv ]; then
      source ~/.autoenv/activate.sh
      autoenv_cd "$@"
    else
      builtin cd "$@"
    fi
  }

  # Push and pop directories on directory stack
  alias pu='pushd'
  alias po='popd'



  # Show history
  if [ "$HIST_STAMPS" = "mm/dd/yyyy" ]
  then
      alias history='fc -fl 1'
  elif [ "$HIST_STAMPS" = "dd.mm.yyyy" ]
  then
      alias history='fc -El 1'
  elif [ "$HIST_STAMPS" = "yyyy-mm-dd" ]
  then
      alias history='fc -il 1'
  else
      alias history='fc -l 1'
  fi


  # List direcory contents
  alias l='ls -lFh'
  alias l='ls -lah'
  alias ll='ls -l'
  alias ll='ls -lh'
  alias la='ls -lAh'
  alias la='ls -lAFh'
  alias lS='ls -1FSsh'
  alias lrt='ls -1Fcrt'
  alias lart='ls -1Fcart'
  alias lr='ls -tRFh'
  alias ldot='ls -ld .*'
  alias ls='ls -G'
  alias lsa='ls -lah'
  alias lt='ls -ltFh'
  alias lag='ls -a | grep -i'
  alias lg='ls | grep -i'

  alias md='mkdir -p'
  alias rd=rmdir
  alias cp='cp -i'
  alias mv='mv -i'
  alias rm='rm -i'
  alias d='dirs -v | head -10'

#}}} _Changing/making/removing directory


# Find {{{

alias afind='ack-grep -il'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

#}}} _Find


# Utils {{{

  alias start_apache='sudo apachectl start'

  alias start_mysql='sudo mysql.server start'

  alias start_mysql_fix='sudo chown -R mysql /usr/local/var/mysql/'

  alias stop_apache='sudo apachectl stop'

  alias stop_mysql='sudo mysql.server shutdown'

  alias adb=/Volumes/Home/Library/Developer/Xamarin/android-sdk-macosx/platform-tools/adb


  alias angular_js_example='cd  ~/Development/Libraries/angular-phonecat && npm start'

  alias bootstrap_docs='cd ~/Development/Libraries/bootstrap && open -a safari http://0.0.0.0:9001 && jekyll serve '

  alias mysql_fix_pid_error='unset TMPDIR && mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp'

  alias mysql_fix_pid_error_generic='mysql_install_db --verbose --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp'

  alias neovim.as='/opt/homebrew-cask/Caskroom/atom-shell/0.19.5/Atom.app/Contents/MacOS/Atom ~/Development/Libraries/neovim.as'

  alias cscr='/Volumes/Home/bin/cscreen -l | perl -lane "print $F[0] if $F[1] == 2" | xargs -I id /Volumes/Home/bin/cscreen -i id -p'

  alias restart_apache='sudo apachectl restart'

  alias restart_mysql='sudo mysql.server restart'

#}}} _Utils


# Laravel {{{

  alias artisan='php artisan'
  alias la4='php artisan'
  alias la4cache='php artisan cache:clear'
  alias la4dump='php artisan dump-autoload'
  alias la4routes='php artisan routes'
  alias bob='php artisan bob::build'
  alias g:c='php artisan generate:controller'
  alias g:db='php artisan db:'
  alias g:f='php artisan generate:form'
  alias g:m='php artisan generate:model'
  alias g:mi='php artisan generate:migration'
  alias g:p='php artisan generate:pivot'
  alias g:r='php artisan generate:resource'
  alias g:s='php artisan generate:scaffold'
  alias g:se='php artisan generate:seed'
  alias g:v='php artisan generate:view'

#}}} _Laravel


# Composer {{{

  alias c=composer
  alias ccp='composer create-project'
  alias cdu='composer dump-autoload'
  alias ci='composer install'
  alias csu='composer self-update'
  alias cu='composer update'
  alias cget='curl -s https://getcomposer.org/installer | php'

#}}} _Composer


# Git {{{

  # git
  alias g=git
  alias gs='git status -s'
  alias gcl='git config --list'

  # add
  alias ga='git add'
  alias gaa='git add .'
  alias gap='git add --patch'
  alias gi='git add -pi'

  # branch
  alias gb='git branch'
  alias gba='git branch -a'
  alias gbr='git branch --remote'

  # commit
  alias gc='git commit -v'
  alias 'gc!'='git commit -v --amend'
  alias gc!='git commit --amend'
  alias gca='git commit -v -a'
  alias 'gca!'='git commit -v -a --amend'
  alias gcs='git commit -S'
  alias gcm='git commit -m'
  alias gcm!='git commit --amend -m'

  # checkout
  alias gcom='git checkout master'
  alias gco='git checkout'

  # diff
  alias gd='git diff'
  alias gdc='git diff --cached'
  alias gdt='git difftool'

  # log
  alias gl='git log --oneline --graph --decorate --all'
  alias glg='git log --stat --max-count=10'
  alias glgg='git log --graph --max-count=10'
  alias glgga='git log --graph --decorate --all'
  alias glo='git log --oneline --decorate --color'
  alias glog='git log --oneline --decorate --color --graph'
  alias glp=_git_log_prettily
  alias gcount='git shortlog -sn'

  # alias gclean='git reset --hard && git clean -dfx'
  alias grmo='git merge --strategy=ours master && git checkout master && git rebase '
  alias gml2c='git reset --soft "HEAD^" && git commit --amend'
  alias gcp='git cherry-pick'
  alias gg='git gui citool'
  alias gga='git gui citool --amend'
  alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
  alias ggpull='git pull origin $(current_branch)'
  alias ggpur='git pull --rebase origin $(current_branch)'
  alias ggpush='git push origin $(current_branch)'
  alias gignore='git update-index --assume-unchanged'
  alias gignored='git ls-files -v | grep "^[[:lower:]]"'


  alias gl='git pull'
  alias gp='git push'
  alias gpo='git push origin'
  alias gr='git remote'
  alias gres='git remote set-url'
  alias gpl='git pull --rebase'
  alias gplo='git pull --rebase && git push'
  alias gpls='git stash -u && git pull --rebase && git stash pop'
  alias gst='git stash'
  alias gstd='git stash -u && git stash drop'
  alias gstl='git stash -u && git pull --rebase && git stash pop'
  alias gcl='git clone'
  alias gr='git rebase'
  alias grc='git rebase --continue'
  alias gra='git rebase --abort'
  alias gb='git branch'
  alias grh='git reset HEAD'

  alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

  alias git_update_reset_to_match_online='git fetch origin && git reset --hard origin/master'

  alias github_get_organization_repos=' curl -s https://api.github.com/orgs/`echo $aUser`/repos | ruby -rubygems -e '\''require "json"; JSON.load(STDIN.read).each {|repo| %x[git clone #{repo["git_url"]} ]}'\'' '

  alias github_get_user_repos=' curl -s https://api.github.com/users/`echo $aUser`/repos | ruby -rubygems -e '\''require "json"; JSON.load(STDIN.read).each {|repo| %x[git clone #{repo["git_url"]} ]}'\'' '

  alias gk='gitk --all --branches'
  alias gm='git merge'
  alias gmt='git mergetool --no-prompt'
  alias gp='git push'
  alias gpoat='git push origin --all && git push origin --tags'
  alias gr='git remote'
  alias grba='git rebase --abort'
  alias grbc='git rebase --continue'
  alias grbi='git rebase -i'
  alias grep='grep --color'
  alias grh='git reset HEAD'
  alias grhh='git reset HEAD --hard'
  alias grmv='git remote rename'
  alias grrm='git remote remove'
  alias grset='git remote set-url'
  alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
  alias grup='git remote update'
  alias grv='git remote -v'
  alias gsd='git svn dcommit'
  alias gsps='git show --pretty=short --show-signature'
  alias gsr='git svn rebase'
  alias gss='git status -s'
  alias gst='git status'
  alias gsta='git stash'
  alias gstd='git stash drop'
  alias gstp='git stash pop'
  alias gsts='git stash show --text'
  alias gts='git tag -s'
  alias gunignore='git update-index --no-assume-unchanged'
  alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
  alias gup='git pull --rebase'
  alias gvt='git verify-tag'
  alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'
  alias gwip='git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--"'

#}}} _Git


# Gem {{{

alias gemb='gem build *.gemspec'
alias gemp='gem push *.gem'
alias sgem='sudo gem'

#}}} _Gem


# rsync {{{

  alias rsync-copy='rsync -avz --progress -h'
  alias rsync-move='rsync -avz --progress -h --remove-source-files'
  alias rsync-synchronize='rsync -avzu --delete --progress -h'
  alias rsync-update='rsync -avzu --progress -h'

#}}} _rsync

#alias g='grep -in'

# Super user
alias _='sudo'
alias please='sudo'

#alias -='cd -'
#alias ..='cd ../'
#alias ...='cd ../../'
#alias ....='cd ../../../'
#alias .....='cd ../../../../'


#alias nunit=/Library/Frameworks/Mono.framework/Versions/Current/bin/nunit-console4
#alias nunit-console.exe=/Library/Frameworks/Mono.framework/Versions/Current/bin/nunit-console4
alias nv='nvim'
alias nv_profile='cd ~/dotfiles/nvim/vim-plugins-profile-master/ && sh vim-plugins-profile.sh && open . && popd'

alias nval='mkdir -p /tmp/neovim && NVIM_LISTEN_ADDRESS=/tmp/neovim/neovim581 nvim | atom --include-deprecated-apis .'
alias nva='mkdir -p /tmp/neovim && NVIM_LISTEN_ADDRESS=/tmp/neovim/neovim581 nvim'
alias oi=/Volumes/Home/Development/Libraries/ContinuousTests/_Console_OI/oi
alias autotest=/Volumes/Home/Development/Libraries/ContinuousTests/ContinuousTests.Console.Binaries/AutoTest.Console.exe


alias :='~/dotfiles/nvim/nvimex.py'

alias autoTestCSharp='MONO_MANAGED_WATCHER=false /Volumes/Home/Development/Libraries/ContinuousTests/_Console_OI/oi process  start /Volumes/Home/Development/Libraries/ContinuousTests/ContinuousTests.Console.Binaries/AutoTest.Console.exe `pwd`'


alias ct='autoTestCSharp | gawk -f /Volumes/Home/dotfiles/nvim/testnet.awk'

alias android_kitchen='export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" && cd ~/Development/Android/Development/Android-Kitchen && ./menu'

alias tmuxrs='~/.tmux/session.sh'
alias zz=exit
alias timebenchmark='time /usr/local/bin/zsh -c '

#alias a='fasd -a'
#alias sd='fasd -sid'
#alias s='fasd -si'
#alias f='fasd -f'
#alias d='fasd -d'
#alias sf='fasd -sif'
#alias x='fasd_cd -d'
#alias xx='fasd_cd -d -i'
#alias z='fasd_cd -d'


# alias rails=_rails_command
# alias rake_refresh=_rake_refresh
# alias rc='rails console'
# alias rd='rails destroy'
# alias rdb='rails dbconsole'
# alias rdc='rake db:create'
# alias rdd='rake db:drop'
# alias rdm='rake db:migrate'
# alias rdmtc='rake db:migrate db:test:clone'
# alias rdr='rake db:rollback'
# alias rds='rake db:seed'
# alias rdtc='rake db:test:clone'
# alias rdtp='rake db:test:prepare'
# alias rfind='find . -name "*.rb" | xargs grep -n'
# alias rg='rails generate'
# alias rgm='rails generate migration'
# alias rlc='rake log:clear'
# alias rn='rake notes'
# alias rp='rails plugin'
# alias rr='rake routes'
# alias rs='rails server'
# alias rsd='rails server --debugger'
# alias ru='rails runner'
# alias jimweirich=rake
# alias srake='noglob sudo rake'
# alias rvm-restart='rvm_reload_flag=1 source '\''/Volumes/Home/.rvm/scripts/rvm'\'
# alias sc='ruby script/console'
# alias sg='ruby script/generate'
# alias sp='ruby script/plugin'
# alias sr='ruby script/runner'
# alias ssp='ruby script/spec'



alias t='tail -f'

alias brews='brew list -1'
alias bubu='brew update && brew upgrade && brew cleanup'
alias colorize=colorize_via_pygmentize
alias devlog='tail -f log/development.log'
alias dud='du -d 1 -h'
alias duf='du -sh *'
alias enable_root_user=dsenableroot
alias help=man
alias hgrep='fc -El 0 | grep'
alias p='ps -f'
alias prodlog='tail -f log/production.log'
alias ql='qlmanage -p "$@" >& /dev/null'
alias zshrc='nv ~/.zshrc'
alias updatedb=/usr/libexec/locate.updatedb
alias run-help=man
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
alias sortnr='sort -n -r'
alias ss='thin --stats "/thin/stats" start'
alias testlog='tail -f log/test.log'
alias unexport=unset
alias whereami=display_info
alias which-command=whence



# alias annotate=bundled_annotate
# alias be='bundle exec'
# alias bi=bundle_install
# alias bl='bundle list'
# alias bo='bundle open'
# alias bp='bundle package'
# alias brake='noglob bundle exec rake'
# alias bu='bundle update'
# alias cap=bundled_cap
# alias capify=bundled_capify
# alias cucumber=bundled_cucumber
# alias foodcritic=bundled_foodcritic
# alias guard=bundled_guard
# alias irb=bundled_irb
# # alias jekyll=bundled_jekyll
# alias kitchen=bundled_kitchen
# alias knife=bundled_knife
# alias middleman=bundled_middleman
# alias nanoc=bundled_nanoc
# alias pry=bundled_pry
# alias puma=bundled_puma
# alias rackup=bundled_rackup
# alias rainbows=bundled_rainbows
# alias rake=bundled_rake
# alias rspec=bundled_rspec
# alias sbrake='noglob sudo bundle exec rake'
# alias shotgun=bundled_shotgun
# alias sidekiq=bundled_sidekiq
# alias spec=bundled_spec
# alias spork=bundled_spork
# alias spring=bundled_spring
# alias strainer=bundled_strainer
# alias tailor=bundled_tailor
# alias taps=bundled_taps
# alias thin=bundled_thin
# alias thor=bundled_thor
# alias unicorn=bundled_unicorn
# alias unicorn_rails=bundled_unicorn_rails


# # #############################################################################
#                                 Debug Neovim                                 # 
# ############################################################################## 

alias nvim_coredump="ulimit -c unlimited && nvim"
alias nvim_gdb="gdb nvim"
alias nvim_make_debug="make CMAKE_BUILD_TYPE=Debug"

# # #############################################################################
#                                  Youtube-dl                                  # 
# ############################################################################## 
alias youtube-dl-mp3="youtube-dl --extract-audio --audio-format mp3  --audio-quality  0 "
alias youtube-dl-mp3-process="ffmpeg -v 5 -y -acodec libmp3lame -ac 2 -ab 192k -i "

# # #############################################################################
#                                   SpotLight                                  # 
# ############################################################################## 

# Delete spotlight index
alias spotlight_clean_index_all="sudo mdutil -Ea"
alias spotlight_clean_index="sudo mdutil -E"

# Turn indexing off/on
alias spotlight_indexing_off_all="sudo mdutil -ai off"
alias spotlight_indexing_off="sudo mdutil -i off"
alias spotlight_indexing_on_all="sudo mdutil -ai on"
alias spotlight_indexing_on="sudo mdutil -i on"















#Aliases from seletskey{{{
#unalias -m '*'

alias l='ls'
#alias ls='ls --color=always'
alias ll='ls -al'
alias lt='ls -alt'

alias srm='ssh-keygen -R'

alias -g L='| less'
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g Gi=GI
alias -g T='| tail'
alias -g F='| less -F'
alias -g X='| xclip'
alias -g T1='| tail -n1'
alias -g R='| xargs -n1'
alias -g H='| head'
alias -g H1='| head -n1'

alias w1='watch -n1 '
alias sctl='sudo systemctl'

alias ipa='ip a'

#alias vim='vim --servername vim'

alias d='dirs -v'
alias dt='cd ~/sources/dotfiles'
alias kb='cd ~/sources/kb'

#alias p='pacman'
#alias pp='sudo pacman -S'
#alias ppr='sudo pacman -R'
#alias pqo='sudo pacman -Qo'
#alias ppu='sudo pacman -U'

alias run-help='man'

alias psx='ps axfu'

alias a=alias

alias ma='mplayer -novideo'

alias gob='go build'
alias gog='go get -u'

alias zr='. ~/.zshrc'

for index ({1..9}) alias "$index=cd +${index}"; unset index
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

export KEYTIMEOUT=1
bindkey -v

bindkey -v "^P" history-substring-search-up
bindkey -v "^N" history-substring-search-down
bindkey -v "^A" beginning-of-line

#These two break history
#bindkey -v "^[[A" history-substring-search-up
#bindkey -v "^[[B" history-substring-search-down

#FZF does a better job
#bindkey -v "^R" history-incremental-search-backward
bindkey -v "^[[3~" delete-char
bindkey -v "^Q" push-line
bindkey -v '^A' beginning-of-line
bindkey -v '^E' end-of-line
bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^K' vi-kill-eol
bindkey -v '^[[Z' reverse-menu-complete
bindkey -v '^[d' delete-word

bindkey -a '^[' vi-insert
bindkey -a '^[d' delete-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word
bindkey -a '^[Od' backward-word
bindkey -a '^[Oc' forward-word
bindkey '^H' backward-kill-word

bindkey -a '?' run-help

zle -N prepend-sudo prepend_sudo
#used by FZF
#bindkey "^T" prepend-sudo
function prepend_sudo() {
    if grep -q '^sudo ' <<< "$BUFFER"; then
        CURSOR=$(($CURSOR-5))
        BUFFER=${BUFFER:5}
        return
    fi

    if [ "$BUFFER" ]; then
        BUFFER="sudo "$BUFFER
    else
        BUFFER="sudo "$(fc -ln -1)
    fi
    CURSOR=$(($CURSOR+5))
}

autoload smart-insert-last-word
bindkey "\e." smart-insert-last-word-wrapper
bindkey "\e," smart-insert-prev-word
zle -N smart-insert-last-word-wrapper
zle -N smart-insert-prev-word
function smart-insert-last-word-wrapper() {
    _altdot_reset=1
    smart-insert-last-word
}
function smart-insert-prev-word() {
    if (( _altdot_reset )); then
        _altdot_histno=$HISTNO
        (( _altdot_line=-_ilw_count ))
        _altdot_reset=0
        _altdot_word=-2
    elif (( _altdot_histno != HISTNO || _ilw_cursor != $CURSOR )); then
        _altdot_histno=$HISTNO
        _altdot_word=-1
        _altdot_line=-1
    else
        _altdot_word=$((_altdot_word-1))
    fi

    smart-insert-last-word $_altdot_line $_altdot_word 1

    if [[ $? -gt 0 ]]; then
        _altdot_word=-1
        _altdot_line=$((_altdot_line-1))
        smart-insert-last-word $_altdot_line $_altdot_word 1
    fi
}

bindkey "^[[11^" noop
zle -N noop noop
function noop()  {
}

alias gclm='git-clone-me'
function git-clone-me() {
    local reponame="$1" ; shift
    local clone_path="${1:-$reponame}"

    git clone gh:seletskiy/$reponame ~/sources/$clone_path
    cd ~/sources/$clone_path
}

alias gclg='git-clone-github'
function git-clone-github() {
    local reponame="$1"
    local dirname="${2:-${reponame#*/}}"

    git clone gh:$reponame ~/sources/$dirname
    cd ~/sources/$dirname
}


alias grem='git-remote-add-me'
function git-remote-add-me() {
    if [ "$1" ]; then
        local reponame="$1"; shift
    else
        local reponame=$(git remote show origin -n | awk '/Fetch URL/{print $3}' | cut -f2 -d/)
    fi

    git remote add seletskiy gh:seletskiy/$reponame "${@}"
}

# in case of servers that are know nothing about rxvt-unicode-256color
# better ssh="TERM=xterm ssh" alias
alias ssh='ssh-urxvt'
function ssh-urxvt() {
    # in case of stdin, stdout or stderr is not a terminal, fallback to ssh
    if [[ ! ( -t 0 && -t 1 && -t 2 ) ]]; then
        \ssh "$@"
        return
    fi

    # if there more than one arg (hostname) without dash "-", fallback to ssh
    local hostname=''
    for arg in "$@"; do
        if [ ${arg:0:1} != - ]; then
            if [[ -n $hostname ]]; then
                \ssh "$@"
                return
            fi
            hostname=$arg
        fi
    done

    # check terminal is known, if not, fallback to xterm
    \ssh -t "$@" "infocmp >/dev/null 2>&1 || export TERM=xterm; LANG=$LANG \$SHELL"
}

function _ssh-urxvt() {
    service="ssh" _ssh "${@}"
}

#compdef _ssh-urxvt ssh-urxvt

alias mgp='move-to-gopath'
function move-to-gopath() {
    local directory=${1:-.}
    local site=${2:-github.com}
    local remote=${3:-origin}

    directory=$(readlink -f .)
    cd $directory

    local repo_path=$(git remote show $remote -n | awk '/Fetch URL/{print $3}' | cut -f2 -d:)
    local target_path=$GOPATH/src/$site/$repo_path

    mkdir -p $(dirname $target_path)

    mv $directory $target_path

    ln -sf $target_path $directory

    cd $directory
}

function cd-to-vim-bundle() {
    cd ~/.vim/bundle/$1
}

_cd-to-vim-bundle() {
    cd-to-vim-bundle
    _arguments -C '*:bundles:_directories'
}

#compdef _cd-to-vim-bundle cd-to-vim-bundle
#Aliases from seletskey}}}







alias brew_fix_links='brew linkapps; find ~/Applications -type l | while read f; do osascript -e "tell app \"Finder\" to make new alias file at POSIX file \"/Applications\" to POSIX file \"$(stat -f%Y "$f")\""; rm "$f"; done'
