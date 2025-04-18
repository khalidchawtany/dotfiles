#set -o vi
#bindkey -v

#{{{__________________________PATH_________________________________________

      export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
      # export MANPATH="/usr/local/man:$MANPATH"

      #export PATH="$PATH:~/Development/Libraries/ContinuousTests/OpenIDE.binaries"
      export EDITOR='nvim'
      export PATH="$PATH:~/bin"
      export PATH="$PATH:~/.local/bin"
      export PATH="$PATH:~/.composer/vendor/bin"
      export PATH="$PATH:~/Library/Developer/Xamarin/android-sdk-macosx/platform-tools"
      export PATH="/usr/local/sbin:$PATH"
      export PATH=$PATH:/usr/local/opt/go/libexec/bin
      export PATH="#PATH:/Users/juju/Development/Libraries/zf/zig-out/bin/"


      export GOPATH=$HOME/go
      export PATH=$PATH:$GOPATH/bin

      #export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#}}} _PATH

#{{{_________________________FUNCTIONS________________________________________
      #ctrl-z suspends _and_ resumes
      fancy-ctrl-z () {
         if [[ $#BUFFER -eq 0 ]]; then
               fg
               zle redisplay
         else
               zle push-input
         fi
      }

      zle -N fancy-ctrl-z


      mkcd () {
         mkdir -p "$*"
         cd "$*"
      }


      pwd_restore_cmd () {

         #zle push-line;
         zle push-input
         zle -U " `pwd`"
         #zle kill-whole-line
      }

      zle -N pwd_restore_cmd
      bindkey " " pwd_restore_cmd
      bindkey "" pwd_restore_cmd

      #bindkey -s ' ' 'pwd'

      zman() {
         PAGER="less -g -s '+/^       "$1"'" man zshall
      }


      function git_diff() {
         git diff --no-ext-diff -w "$@" | NVIM_LISTEN_ADDRESS=/tmp/nv_socket nvim -R -
      }

      #Solve slow git dirs for oh-my-zsh
      function git_prompt_info() {
         ref=$(git symbolic-ref HEAD 2> /dev/null) || return
         # echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"

         #use this if using robbyrussel zsh theme
         echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
      }

      #========================================================================
      #==> FZF
      #========================================================================
      # fe [FUZZY PATTERN] - Open the selected file with the default editor
      #   - Bypass fuzzy finder if there's only one match (--select-1)
      #   - Exit if there's no match (--exit-0)
      fedit() {
         local file
         file=$(fzf --query="$1" --select-1 --exit-0)
         [ -n "$file" ] && ${EDITOR:-vim} "$file"
      }

      # fd - cd to selected directory
      fdir() {
         local dir
         dir=$(find ${1:-*} -path '*/\.*' -prune \
                        -o -type d -print 2> /dev/null | fzf +m) &&
         cd "$dir"
      }

      # fkill - kill process
      fkill() {
         ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
      }

      # fh - repeat history
      fhelp() {
         eval $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s | sed 's/ *[0-9]* *//')
      }

#}}} _Functions

#{{{___________________________KeyBinings__________________________________________

      bindkey '^p' up-line-or-search
      bindkey '^n' down-line-or-search
      bindkey '^?' backward-delete-char
      #bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-word
      #bindkey '^r' history-incremental-search-backward
      bindkey -s '^[3' \#
      bindkey '^Z' fancy-ctrl-z

      autoload edit-command-line
      zle -N edit-command-line
      bindkey '^Xe' edit-command-line
      bindkey '^X^e' edit-command-line

#}}} _KeyBinding

#{{{__________________________Source_________________________________________

      source ~/dotfiles/funs/testnet.sh

      #source ~/bin/tmuxinator.zsh

      # source ~/dotfiles/funcs/git_reset.sh

      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

      [ -f ~/.profile  ] && source ~/.profile

      #source /usr/local/etc/autojump.zsh
      [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

#}}} _Source

#{{{_________________________TMUX________________________________________

      tmux attach &> /dev/null

      if [[ ! $TERM =~ screen ]]; then
               exec tmux
      fi

#}}} _Tmux

#{{{_________________________VirtualEnvironment________________________________________

#Allow global pip to be run using gpip, since pip is disabled
#to be used as a global package manager
    gpip(){
      PIP_REQUIRE_VIRTUALENV="" pip "$@"
    }

# pip should only run if there is a virtualenv currently activated
    #export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
    #export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

#}}} _VirtualEnv

#{{{__________________________Alias_________________________________________


      [ -z "$NVIM_LISTEN_ADDRESS" ] || alias :='~/dotfiles/funcs/nvimex.py'


      eval "$(fasd --init auto)"
      alias x='fasd_cd -d'
      alias xx='fasd_cd -d -i'

      alias timebenchmark="time /usr/local/bin/zsh -c "

      #alias update_all_gems="gem update `gem list | cut -d ' ' -f 1`"

      alias tmuxrs="~/.tmux/session.sh"

      alias oiv='/usr/local/bin/python ~/dotfiles/funcs/vcmd.py ":e `pwd`/"'

      alias oi="~/Development/Libraries/ContinuousTests/OpenIDE.binaries/oi"

      alias git_update_reset_to_match_online="git fetch origin && git reset --hard origin/master"

      alias lg="ls | grep -i"
      alias lag="ls -a | grep -i"
      #eval "$(fasd --init posix-alias zsh-hook)"

      alias github_get_user_repos=' curl -s https://api.github.com/users/`echo $aUser`/repos | ruby -rubygems -e '\''require "json"; JSON.load(STDIN.read).each {|repo| %x[git clone #{repo["git_url"]} ]}'\'' '

      alias github_get_organization_repos=' curl -s https://api.github.com/orgs/`echo $aUser`/repos | ruby -rubygems -e '\''require "json"; JSON.load(STDIN.read).each {|repo| %x[git clone #{repo["git_url"]} ]}'\'' '

      alias enable_root_user='dsenableroot'

      export MYSQL_HOME=/usr/local/Cellar/mysql/5.6.21
      alias start_mysql='sudo $MYSQL_HOME/bin/mysqld_safe &'
      alias stop_mysql='sudo $MYSQL_HOME/bin/mysqladmin shutdown'

      alias start_mysql='sudo mysql.server start'

      alias start_mysql_fix='sudo chown -R mysql /usr/local/var/mysql/'

      alias stop_mysql='sudo mysql.server shutdown'
      alias restart_mysql='sudo mysql.server restart'
      alias mysql_fix_pid_error_generic='mysql_install_db --verbose --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp'
      alias mysql_fix_pid_error='unset TMPDIR && mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp'

      alias start_apache='sudo apachectl start'
      alias stop_apache='sudo apachectl stop'
      alias restart_apache='sudo apachectl restart'

   # Generator Stuff
      alias g:m="php artisan generate:model"
      alias g:c="php artisan generate:controller"
      alias g:v="php artisan generate:view"
      alias g:se="php artisan generate:seed"
      alias g:mi="php artisan generate:migration"
      alias g:r="php artisan generate:resource"
      alias g:p="php artisan generate:pivot"
      alias g:s="php artisan generate:scaffold"
      alias g:f="php artisan generate:form"
      alias g:db="php artisan db:"

      alias bootstrap_docs='cd ~/Development/Libraries/bootstrap && open -a safari http://0.0.0.0:9001 && jekyll serve '
      alias angular_js_example='cd  ~/Development/Libraries/angular-phonecat && npm start'

      alias adb='~/Library/Developer/Xamarin/android-sdk-macosx/platform-tools/adb'

      alias updatedb='sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist'
      alias ql='qlmanage -p "$@" >& /dev/null'
      #alias ql='qlmanage -p "$@"'
      alias cscr='~/bin/cscreen -l | perl -lane "print $F[0] if $F[1] == 2" | xargs -I id ~/bin/cscreen -i id -p'
      alias zz='exit'
      #alias nunit='/Library/Frameworks/Mono.framework/Versions/Current/bin/nunit-console4'
      #alias nunit-console.exe='/Library/Frameworks/Mono.framework/Versions/Current/bin/nunit-console4'

      alias neovim.as='/opt/homebrew-cask/Caskroom/atom-shell/0.19.5/Atom.app/Contents/MacOS/Atom ~/Development/Libraries/neovim.as'
      alias updatedb='/usr/libexec/locate.updatedb'

      alias nv='NVIM_TUI_ENABLE_CURSOR_SHAPE=1 NVIM_TUI_ENABLE_TRUE_COLOR=1  NVIM_LISTEN_ADDRESS=/tmp/nv_socket nvim'
      alias nva='mkdir -p /tmp/neovim && NVIM_TUI_ENABLE_CURSOR_SHAPE=1 NVIM_TUI_ENABLE_TRUE_COLOR=1  NVIM_LISTEN_ADDRESS=/tmp/neovim/neovim581 nvim'
#}}} _Alias

# vim:ft=zsh:
