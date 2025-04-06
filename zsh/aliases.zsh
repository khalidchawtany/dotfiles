setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# alias neovim_upgrade="cd /Users/juju/Development/Applications/neovim && git checkout master && git pull upstream master && git rebase master fold && make distclean && make CMAKE_BUILD_TYPE=Release MACOSX_DEPLOYMENT_TARGET=10.13 DEPS_CMAKE_FLAGS=\"-DCMAKE_CXX_COMPILER=$(xcrun -find c++)\" && make install && popd"
alias neovim_upgrade="cd /Users/juju/Development/Applications/neovim && git checkout master && git pull upstream master && git rebase master fold && make distclean && make CMAKE_BUILD_TYPE=Release && make install && popd"

# alias neovim_qt_build='cd ~/Development/Applications/neovim-qt/neovim-qt/ && rm -fr ~/Development/Applications/neovim-qt/neovim-qt/build/* && export PATH="/usr/local/opt/qt@5/bin:$PATH" && export LDFLAGS="-L/usr/local/opt/qt@5/lib" && export CPPFLAGS="-I/usr/local/opt/qt@5/include" && export PKG_CONFIG_PATH="/usr/local/opt/qt@5/lib/pkgconfig" && cmake -B ./build -DCMAKE_INSTALL_PREFIX=/Users/juju/Development/Applications/neovim-qt/neovim-qt/build/ -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ && cmake --build /Users/juju/Development/Applications/neovim-qt/neovim-qt/build/'
alias neovim_qt_build='cd ~/Development/Applications/neovim-qt/neovim-qt/ && rm -fr ~/Development/Applications/neovim-qt/neovim-qt/build/* && export PATH="/usr/local/opt/qt@6/bin:$PATH" && export LDFLAGS="-L/usr/local/opt/qt@6/lib" && export CPPFLAGS="-I/usr/local/opt/qt@6/include" && export PKG_CONFIG_PATH="/usr/local/opt/qt@6/lib/pkgconfig" && cmake -B ./build -DCMAKE_INSTALL_PREFIX=/Users/juju/Development/Applications/neovim-qt/neovim-qt/build/ -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DWITH_QT=Qt6 && cmake --build /Users/juju/Development/Applications/neovim-qt/neovim-qt/build/'

alias tomcat=JRE_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/jre" JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home" catalina run


# colorize man {{{
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


# I don't know what they do :) {{{
function copydir {
  pwd | tr -d "\r\n" | pbcopy
}

function copyfile {
  [[ "$#" != 1 ]] && return 1
  local file_to_copy=$1
  cat $file_to_copy | pbcopy
}


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

# }}}


# Pipes {{{

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

#}}} _Pipes


# Changing/making/removing directory{{{

  # Push and pop directories on directory stack
  alias pu='pushd'
  alias po='popd'

  # List direcory contents


  # eza (better 'ls')
  alias l="eza --icons"
  alias ls="eza --icons"
  alias ll="eza -lg --icons"
  alias la="eza -lag --icons"
  alias lt="eza -lTg --icons"
  alias lt1="eza -lTg --level=1 --icons"
  alias lt2="eza -1Tg --level=2 --icons"
  alias lt3="eza -lTg --level=3 --icons"
  alias lta="eza -lTag --icons"
  alias lta1="eza -lTag --level=1 --icons"
  alias lta2="eza -lTag --level=2 --icons"
  alias lta3="eza -lTag --level=3 --icons"

  alias md='mkdir -p'
  alias rd=rmdir
  alias cp='cp -i'
  alias mv='mv -i'
  alias rm='rm -i'
  alias d='dirs -v | head -10'


  # Basic directory navigation
  alias cdc='cd ~/.config/'
  alias cdv='cd ~/.config/nvim'
  alias cd.='cd ~/dotfiles/'
  alias cdz='cd ~/dotfiles/zsh'
  alias cdd='cd ~/Desktop/'
  alias cda='cd ~/Development/Applications/'
  alias cdp='cd ~/Projects'
  alias cdpp='cd ~/Projects/PHP'
  alias cdpy='cd ~/Projects/python'
  alias cdpj='cd ~/Projects/js'
  alias cdpg='cd ~/Projects/go'
  alias cds='cd ~/Development/Sites'
  alias cdu24='cd /Volumes/Data/Universities/University_2023_2024/'
  alias cdph='cd /Volumes/Data/Universities/University_2023_2024/Phd'
  alias cdq='cd /Volumes/Data/Universities/University_2023_2024/Quarto'

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


#}}} _Changing/making/removing directory


# Find / Grep {{{

  alias afind='ack-grep -il'
  # alias fdd='find . -type d -name'
  alias ff='find . -type f -name'

  alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
  alias hgrep="fc -El 0 | grep"

#}}} _Find


# Utils {{{

  alias zshrc='nv ~/.zshrc' # Quick access to the ~/.zshrc file

  alias start_mysql='sudo mysql.server start'
  alias restart_mysql='sudo mysql.server restart'
  alias stop_mysql='sudo mysql.server shutdown'
  alias start_mysql_fix='sudo chown -R mysql /usr/local/var/mysql/'
  alias mysql_fix_pid_error='unset TMPDIR && mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp'
  alias mysql_fix_pid_error_generic='mysql_install_db --verbose --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp'


  alias angular_js_example='cd  ~/Development/Libraries/angular-phonecat && npm start'
  alias bootstrap_docs='cd ~/Development/Libraries/bootstrap && open -a safari http://0.0.0.0:9001 && jekyll serve '

  alias neovim.as='/opt/homebrew-cask/Caskroom/atom-shell/0.19.5/Atom.app/Contents/MacOS/Atom ~/Development/Libraries/neovim.as'

  alias cscr='~/bin/cscreen -l | perl -lane "print $F[0] if $F[1] == 2" | xargs -I id ~/bin/cscreen -i id -p'

  alias lnvim="NVIM_LISTEN_ADDRESS=127.0.0.1:6666  NVIM_APPNAME=nvim_lazy nvim"
  alias nviml="NVIM_LISTEN_ADDRESS=127.0.0.1:6666  NVIM_APPNAME=nvim_lazy nvim"
  alias nvl="NVIM_LISTEN_ADDRESS=127.0.0.1:6666  NVIM_APPNAME=nvim_lazy nvim"

  alias open_excel_personal_macro="open 'Library/Group Containers/UBF8T346G9.Office/User Content.localized/Startup.localized/Excel/PERSONAL.XLSB'"

  function nvr { nvr --servername 127.0.0.1:6666 $@ }

  alias use_go12='export PATH="/usr/local/opt/go@1.20/bin:$PATH"'


  alias use_php72='export PATH="/usr/local/opt/php@7.2/bin:$PATH" && export PATH="/usr/local/opt/php@7.2/sbin:$PATH"'
  alias use_php73='export PATH="/usr/local/opt/php@7.3/bin:$PATH" && export PATH="/usr/local/opt/php@7.3/sbin:$PATH"'
  alias use_php74='export PATH="/usr/local/opt/php@7.4/bin:$PATH" && export PATH="/usr/local/opt/php@7.4/sbin:$PATH"'
  alias use_php80='export PATH="/usr/local/opt/php@8.0/bin:$PATH" && export PATH="/usr/local/opt/php@8.0/sbin:$PATH"'
  alias use_php81='export PATH="/usr/local/opt/php@8.1/bin:$PATH" && export PATH="/usr/local/opt/php@8.1/sbin:$PATH"'
  alias use_php82='export PATH="/usr/local/opt/php@8.2/bin:$PATH" && export PATH="/usr/local/opt/php@8.2/sbin:$PATH"'

  alias mycomposer="COMPOSER_MEMORY_LIMIT=-1 ./vendor/composer/composer/bin/composer"

  alias pv="php --version"

  alias rebase_erp="git rebase l7 master && gco dist && git rebase master -Xours"

 alias valet_restart="rm ~/.config/valet/valet.sock && valet restart"
 alias clean_ds="find . -name '.DS_Store' -type f -delete"



#}}} _Utils

# Python & Django {{{
  alias p3='~/venv/bin/python3 '
  alias pa='source ~/venv/bin/activate  && export PATH="$PATH:/Users/juju/venv/bin/"'

  alias dj='python3 ./manage.py'
  alias djr='python3 ./manage.py runserver 0.0.0.0:8000'
  alias djlr='python3 ./manage.py livereload 0.0.0.0:8000'
  alias djm='django-admin'
  alias dja='django-admin'
  alias djs='python3 ./manage.py shell'
#}}} _Django

# Laravel {{{

  alias artisan='php artisan'


  function l:ou { php artisan october:up }
  function l:or { php artisan plugin:rollback $@ }

  function l:db { php artisan db:$@ }
  function l:dbs { php artisan db:seed $@ }
  function l:dbsc { php artisan db:seed --class=$@ }
  function l:o { php artisan october:$@ }
  function l:om { php artisan october:migrate $@ }
  function l:m { php artisan make:$@ }
  alias l:mm="php artisan make:migration"
  alias l:mc="php artisan make:controller"
  alias l:mco="php artisan make:component"
  alias l:ma="php artisan make:model"
  function l:mf { php artisan make:filament-$@ }
  function l:mfr { php artisan make:filament-resource  --generate $@ }

  function l:mfrg { php artisan make:filament-resource  --generate $@ }
  function l:mfrv { php artisan make:filament-resource  --view $@ }
  function l:mfrv { php artisan make:filament-resource  --generate --view $@ }

  function l:mfa { l:ma $@ -mRsf --policy}
  function l:mfar { l:ma $@ -mRsf --policy && l:m filament-resource $@  --generate }

  alias l:fcc='php artisan config:clear && php artisan route:clear && php artisan cache:clear && php artisan view:clear && php artisan icons:clear && php artisan filament:clear-cached-components'
  alias l:fco='php artisan config:cache && php artisan route:cache && composer dump-autoload -o && php artisan optimize && php artisan view:cache && php artisan icons:cache && php artisan filament:cache-components'


  function l:p { php artisan plugin:$@ }
  function l: { php artisan $@ }
  # alias la4='php artisan'
  alias l:t='php artisan tinker'
  alias l:mi='php artisan migrate'
  function l:miP { php artisan migrate --path=$@ }
  alias l:mip='php artisan migrate --pretend'
  alias l:mir='php artisan migrate:rollback'
  alias l:mis='php artisan migrate --seed'
  alias l:mb='php artisan make:bread '
  alias l:s='php artisan serve'
  alias l72:s='/usr/local/opt/php@7.2/bin/php artisan serve'
  alias l73:s='/usr/local/opt/php@7.3/bin/php artisan serve'
  alias l74:s='/usr/local/opt/php@7.4/bin/php artisan serve'
  alias l:rs='sudo apachectl stop && sudo php artisan serve --host 0.0.0.0 --port 80'
  alias l:cc='php artisan route:clear && php artisan cache:clear && php artisan view:clear && php artisan debugbar:clear'
  alias l:du='php artisan dump-autoload'
  alias l:rl='php artisan route:list'
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
  alias lm:m='php artisan module:make'
  alias lm:mm='php artisan module:make-model'
  alias lm:mc='php artisan module:make-controller'
  alias lm:mi='php artisan module:make-migration'
  alias lm='php artisan module:'

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


  # Git
  alias g=git
  alias glc='git config --list'
  alias gcl='git clone'


  # Git work-tree
  alias gw='git worktree '
  alias gwa='git worktree add '
  alias gwr='git worktree remove '

  # Add
  alias ga='git add'
  alias gaa='git add .'
  alias gap='git add --patch'
  alias gapi='git add -pi'


  # Branch
  alias gb='git branch'
  alias gba='git branch -a'
  alias gbr='git branch --remote'

  function gbD { git branch -D $@ }
  function gbDo { git push origin --delete $@ }
  function gbDb { git branch -D $@ && git push origin --delete $@ }
  function gbDa { git branch -D $@ && git push origin --delete $@ }
  function gb2t { git checkout $@ && git tag $@ && git checkout master && git branch -D $@ && git push origin --delete $@ }


  # Checkout
  alias gco='git checkout'
  alias gcom='git checkout master'
  alias gcob='git checkout -b '


  # Commit
  alias gc='git commit -v'
  alias gca='git commit -v -a'
  alias gcm='git commit -m'
  alias gcam='git commit -v -a -m'
  alias 'gc!'='git commit -v --amend'
  alias 'gca!'='git commit -v -a --amend'
  alias 'gcm!'='git commit --amend -m'
  alias 'gcam!'='git commit -v -a --amend -m'
  alias 'gcn!'='git commit -v --amend --no-edit'
  alias 'gcan!'='git commit -v -a --amend --no-edit'
  #alias gc     != 'git commit --amend'


  # Diff
  alias gd='git diff'
  alias gdc='git diff --cached'
  alias gdcs='git diff --cached --stat'
  alias gdt='git difftool'

 function gdbb { git diff $1:$3 $2:$3 }

  # GUI
  alias gg='git gui citool'
  alias gga='git gui citool --amend'


  # Ignore
  alias gi='git update-index --assume-unchanged'
  alias giu='git update-index --no-assume-unchanged'


  # Log
  alias gl='git log --oneline --graph --decorate --all'
  alias glc='git log --oneline --decorate --color'
  alias glg='git log --oneline --decorate --color --graph'
  alias gla='git shortlog -sn'
  alias glv='git log --graph --decorate --all'
  alias glvt='git log --stat --max-count=10'
  alias glvtg='git log --graph --max-count=10'


  # Merge
  alias gm='git merge'
  alias gmt='git mergetool --no-prompt'

  alias docker_start='docker-machine start default && eval $(docker-machine env)'


  # Pull
  alias gpl='git pull'
  alias gplr='git pull --rebase'
  alias gplrp='git pull --rebase && git push'

  #Fetch
  alias gf='git fetch'

  # Push
  alias gpu='git push'
  alias gpuo='git push origin'
  alias gpua='git push --all'
  alias gpuf='git push -f'
  alias gpuaf='git push -f --all'


  # Rebase
  alias gr='git rebase'
  alias grc='git rebase --continue'
  alias gra='git rebase --abort'
  alias gri='git rebase -i'


  # Remote
  alias gro='git remote'
  alias grov='git remote -v'
  alias grom='git remote rename'
  alias gror='git remote remove'
  alias gros='git remote set-url'
  alias grou='git remote update'


  # Reset
  alias grh='git reset HEAD'
  alias grhh='git reset HEAD --hard'
  alias gR='git reset '
  alias gRh='git reset --hard '
  alias gcfd='git clean -fd'


  # Stash
  alias gst='git stash'
  alias gstd='git stash drop'
  alias gstp='git stash pop'
  alias gsta='git stash apply'
  alias gsts='git stash show --text'

  alias gpls='git stash -u && git pull --rebase && git stash pop'
  alias gstd='git stash -u && git stash drop'
  alias gstl='git stash -u && git pull --rebase && git stash pop'


  # Status
  alias gs='git status'
  alias gss='git status -s'


  # Tag"
  alias gts='git tag -s'


  # WIP
  alias gwip='git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--"'
  alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'


  # Utils
  alias github_update_recursively='find . -name .git -type d | xargs -n1 -P4 -I% git --git-dir=% --work-tree=%/.. remote update -p'
  alias github_update_reset_to_match_online='git fetch origin && git reset --hard origin/master'
  alias github_get_organization_repos='curl -s https://api.github.com/orgs/`echo $aUser`/repos | ruby -rubygems -e '\''require "json"; JSON.load(STDIN.read).each {|repo| %x[git clone #{repo["git_url"]} ]}'\'' '
  alias github_get_user_repos='curl -s https://api.github.com/users/`echo $aUser`/repos | ruby -rubygems -e '\''require "json"; JSON.load(STDIN.read).each {|repo| %x[git clone #{repo["git_url"]} ]}'\'' '
  # cd in to root
  alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
  alias cdg='cd $(git rev-parse --show-toplevel || echo ".")'
  # rebase master on this branch
  alias git_rebase_master_on='git merge --strategy=ours master && git checkout master && git rebase '
  # merge last two commits
  alias gite_merge_last_2_commits='git reset --soft "HEAD^" && git commit --amend'



  ## alias gclean='git reset --hard && git clean -dfx'
  alias gcp='git cherry-pick'
  alias gcpc='git cherry-pick --continue'
  alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'
  #alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
  #alias ggpull='git pull origin $(current_branch)'
  #alias ggpur='git pull --rebase origin $(current_branch)'
  #alias ggpush='git push origin $(current_branch)'
  #alias gignored='git ls-files -v | grep "^[[:lower:]]"'
  #alias gk='gitk --all --branches'
  #alias gpoat='git push origin --all && git push origin --tags'
  #alias gsps='git show --pretty=short --show-signature'
  #alias gvt='git verify-tag'
  #alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'


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


  #Show progress while file is copying

  alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"
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


#}}} _rsync


alias oi=~/Development/Libraries/ContinuousTests/_Console_OI/oi
alias autotest=~/Development/Libraries/ContinuousTests/ContinuousTests.Console.Binaries/AutoTest.Console.exe
alias autoTestCSharp='MONO_MANAGED_WATCHER=false ~/Development/Libraries/ContinuousTests/_Console_OI/oi process  start ~/Development/Libraries/ContinuousTests/ContinuousTests.Console.Binaries/AutoTest.Console.exe `pwd`'
alias ct='autoTestCSharp | gawk -f ~/dotfiles/nvim/testnet.awk'

alias android_kitchen='export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" && cd ~/Development/Android/Development/Android-Kitchen && ./menu'

alias deploy='rm -f android/app/src/main/assets/index.android.bundle && npx react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res && cd android && ./gradlew clean && ./gradlew assembleRelease && cd ..'

alias specs='python ~/Development/org2opml.py ~/Projects/PHP/ERP\ Docs/Specs/specs.org ~/Projects/PHP/ERP\ Docs/Specs/specs.opml && open ~/Projects/PHP/ERP\ Docs/Specs/specs.opml'

function opml() {
    local filename=$1:t:r
    local filepath=$1:h
    rm -f "/tmp/$filename.opml"
    python ~/Development/org2opml.py "$1" && mv "$filepath/$filename.opml" "/tmp/$filename.opml" && open "/tmp/$filename.opml"
}

alias pp="phpunit"
alias ppf="phpunit --filter="
alias p="./vendor/phpunit/phpunit/phpunit"
alias pf="./vendor/phpunit/phpunit/phpunit --filter="

alias pe="./vendor/bin/pest"
alias pest="./vendor/bin/pest"


alias jest="./node_modules/.bin/jest"

alias zz=exit
alias a=alias
alias h='history'
alias help='man'
alias unexport='unset'
alias whereami=display_info
alias which-command=whence

# Super user
alias _='sudo'
alias please='sudo'
alias enable_root_user=dsenableroot

alias t='tail -f'
alias sortnr='sort -n -r'

# disk usage
alias dud='du -d 1 -h'
alias duf='du -sh *'

alias ql='qlmanage -p "$@" >& /dev/null'
alias updatedb=/usr/libexec/locate.updatedb


# Neovim
# 'NVIM_LISTEN_ADDRESS=127.0.0.1:6666 open -a neovide --args --maximized --title-hidden --frame=buttonless',
alias nv='NVIM_LISTEN_ADDRESS=127.0.0.1:6666 nvim'
alias nvd='NVIM_LISTEN_ADDRESS=127.0.0.1:6666 open -a neovide --args --maximized --title-hidden --frame=buttonless -- --cmd "tcd $(pwd)"'
alias nvi='NVIM_LISTEN_ADDRESS=127.0.0.1:6666 ~/Development/Applications/neovim/neovim/build/bin/nvim'
alias :='~/dotfiles/nvim/nvimex.py'


alias termpdf='~/Development/Applications/termpdf/termpdf'


# Youtube-dl
alias youtube-dl-mp3="youtube-dl --extract-audio --audio-format mp3  --audio-quality  0 "
alias youtube-dl-mp3-process="ffmpeg -v 5 -y -acodec libmp3lame -ac 2 -ab 192k -i "


# SpotLight
# Delete spotlight index
alias spotlight_clean_index_all="sudo mdutil -Ea"
alias spotlight_clean_index="sudo mdutil -E"
# Turn indexing off/on
alias spotlight_indexing_off_all="sudo mdutil -ai off"
alias spotlight_indexing_off="sudo mdutil -i off"
alias spotlight_indexing_on_all="sudo mdutil -ai on"
alias spotlight_indexing_on="sudo mdutil -i on"


# Brew
alias brews='brew list -1'
alias bubu='brew update && brew upgrade && brew cleanup'
alias brew_fix_links='brew linkapps; find ~/Applications -type l | while read f; do osascript -e "tell app \"Finder\" to make new alias file at POSIX file \"/Applications\" to POSIX file \"$(stat -f%Y "$f")\""; rm "$f"; done'


# Temp {{{

##alias g='grep -in'

#alias colorize=colorize_via_pygmentize
#alias devlog='tail -f log/development.log'
#alias prodlog='tail -f log/production.log'
#alias run-help=man
#alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
#alias ss='thin --stats "/thin/stats" start'
#alias testlog='tail -f log/test.log'



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
# alias rvm-restart='rvm_reload_flag=1 source '\''~/.rvm/scripts/rvm'\'
# alias sc='ruby script/console'
# alias sg='ruby script/generate'
# alias sp='ruby script/plugin'
# alias sr='ruby script/runner'
# alias ssp='ruby script/spec'

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
# }}}

#Aliases from seletskey{{{
##unalias -m '*'

#alias l='ls'
##alias ls='ls --color=always'
#alias ll='ls -al'
#alias lt='ls -alt'

#alias srm='ssh-keygen -R'

#alias -g L='| less'
#alias -g G='| grep'
#alias -g GI='| grep -i'
#alias -g Gi=GI
#alias -g T='| tail'
#alias -g F='| less -F'
#alias -g X='| xclip'
#alias -g T1='| tail -n1'
#alias -g R='| xargs -n1'
#alias -g H='| head'
#alias -g H1='| head -n1'

#alias w1='watch -n1 '
#alias sctl='sudo systemctl'

#alias ipa='ip a'

##alias vim='vim --servername vim'

#alias d='dirs -v'
#alias dt='cd ~/sources/dotfiles'
#alias kb='cd ~/sources/kb'

##alias p='pacman'
##alias pp='sudo pacman -S'
##alias ppr='sudo pacman -R'
##alias pqo='sudo pacman -Qo'
##alias ppu='sudo pacman -U'


#alias psx='ps axfu'

#alias a=alias

#alias ma='mplayer -novideo'

#alias gob='go build'
#alias gog='go get -u'

#alias zr='. ~/.zshrc'

#for index ({1..9}) alias "$index=cd +${index}"; unset index
#alias ..='cd ..'
#alias ...='cd ../..'
#alias ....='cd ../../..'
#alias .....='cd ../../../..'

#export KEYTIMEOUT=1
#bindkey -v

#bindkey -v "^P" history-substring-search-up
#bindkey -v "^N" history-substring-search-down
#bindkey -v "^A" beginning-of-line

##These two break history
##bindkey -v "^[[A" history-substring-search-up
##bindkey -v "^[[B" history-substring-search-down

##FZF does a better job
##bindkey -v "^R" history-incremental-search-backward
#bindkey -v "^[[3~" delete-char
#bindkey -v "^Q" push-line
#bindkey -v '^A' beginning-of-line
#bindkey -v '^E' end-of-line
#bindkey -v '^?' backward-delete-char
#bindkey -v '^H' backward-delete-char
#bindkey -v '^W' backward-kill-word
#bindkey -v '^K' vi-kill-eol
#bindkey -v '^[[Z' reverse-menu-complete
#bindkey -v '^[d' delete-word

#bindkey -a '^[' vi-insert
#bindkey -a '^[d' delete-word
#bindkey '^[Od' backward-word
#bindkey '^[Oc' forward-word
#bindkey -a '^[Od' backward-word
#bindkey -a '^[Oc' forward-word
#bindkey '^H' backward-kill-word

#bindkey -a '?' run-help

#zle -N prepend-sudo prepend_sudo
##used by FZF
##bindkey "^T" prepend-sudo
#function prepend_sudo() {
    #if grep -q '^sudo ' <<< "$BUFFER"; then
        #CURSOR=$(($CURSOR-5))
        #BUFFER=${BUFFER:5}
        #return
    #fi

    #if [ "$BUFFER" ]; then
        #BUFFER="sudo "$BUFFER
    #else
        #BUFFER="sudo "$(fc -ln -1)
    #fi
    #CURSOR=$(($CURSOR+5))
#}

#autoload smart-insert-last-word
#bindkey "\e." smart-insert-last-word-wrapper
#bindkey "\e," smart-insert-prev-word
#zle -N smart-insert-last-word-wrapper
#zle -N smart-insert-prev-word
#function smart-insert-last-word-wrapper() {
    #_altdot_reset=1
    #smart-insert-last-word
#}
#function smart-insert-prev-word() {
    #if (( _altdot_reset )); then
        #_altdot_histno=$HISTNO
        #(( _altdot_line=-_ilw_count ))
        #_altdot_reset=0
        #_altdot_word=-2
    #elif (( _altdot_histno != HISTNO || _ilw_cursor != $CURSOR )); then
        #_altdot_histno=$HISTNO
        #_altdot_word=-1
        #_altdot_line=-1
    #else
        #_altdot_word=$((_altdot_word-1))
    #fi

    #smart-insert-last-word $_altdot_line $_altdot_word 1

    #if [[ $? -gt 0 ]]; then
        #_altdot_word=-1
        #_altdot_line=$((_altdot_line-1))
        #smart-insert-last-word $_altdot_line $_altdot_word 1
    #fi
#}

#bindkey "^[[11^" noop
#zle -N noop noop
#function noop()  {
#}

#alias gclm='git-clone-me'
#function git-clone-me() {
    #local reponame="$1" ; shift
    #local clone_path="${1:-$reponame}"

    #git clone gh:seletskiy/$reponame ~/sources/$clone_path
    #cd ~/sources/$clone_path
#}

#alias gclg='git-clone-github'
#function git-clone-github() {
    #local reponame="$1"
    #local dirname="${2:-${reponame#*/}}"

    #git clone gh:$reponame ~/sources/$dirname
    #cd ~/sources/$dirname
#}


#alias grem='git-remote-add-me'
#function git-remote-add-me() {
    #if [ "$1" ]; then
        #local reponame="$1"; shift
    #else
        #local reponame=$(git remote show origin -n | awk '/Fetch URL/{print $3}' | cut -f2 -d/)
    #fi

    #git remote add seletskiy gh:seletskiy/$reponame "${@}"
#}

## in case of servers that are know nothing about rxvt-unicode-256color
## better ssh="TERM=xterm ssh" alias
#alias ssh='ssh-urxvt'
#function ssh-urxvt() {
    ## in case of stdin, stdout or stderr is not a terminal, fallback to ssh
    #if [[ ! ( -t 0 && -t 1 && -t 2 ) ]]; then
        #\ssh "$@"
        #return
    #fi

    ## if there more than one arg (hostname) without dash "-", fallback to ssh
    #local hostname=''
    #for arg in "$@"; do
        #if [ ${arg:0:1} != - ]; then
            #if [[ -n $hostname ]]; then
                #\ssh "$@"
                #return
            #fi
            #hostname=$arg
        #fi
    #done

    ## check terminal is known, if not, fallback to xterm
    #\ssh -t "$@" "infocmp >/dev/null 2>&1 || export TERM=xterm; LANG=$LANG \$SHELL"
#}

#function _ssh-urxvt() {
    #service="ssh" _ssh "${@}"
#}

##compdef _ssh-urxvt ssh-urxvt

#alias mgp='move-to-gopath'
#function move-to-gopath() {
    #local directory=${1:-.}
    #local site=${2:-github.com}
    #local remote=${3:-origin}

    #directory=$(readlink -f .)
    #cd $directory

    #local repo_path=$(git remote show $remote -n | awk '/Fetch URL/{print $3}' | cut -f2 -d:)
    #local target_path=$GOPATH/src/$site/$repo_path

    #mkdir -p $(dirname $target_path)

    #mv $directory $target_path

    #ln -sf $target_path $directory

    #cd $directory
#}

#function cd-to-vim-bundle() {
    #cd ~/.vim/bundle/$1
#}

#_cd-to-vim-bundle() {
    #cd-to-vim-bundle
    #_arguments -C '*:bundles:_directories'
#}

##compdef _cd-to-vim-bundle cd-to-vim-bundle
#Aliases from seletskey}}}

alias svim="rm -f  ~/.config/nvim && ln -s ~/.config/nvim_vimscript ~/.config/nvim && mv ~/.local/share/nvim/site ~/.local/share/nvim/sitex"
alias slua="rm -f  ~/.config/nvim && ln -s ~/.config/nvim_lua ~/.config/nvim && mv ~/.local/share/nvim/sitex ~/.local/share/nvim/site"




# sudo xcode-select --switch /Applications/Xcode.app
# sudo xcode-select --switch /Library/Developer/CommandLineTools


