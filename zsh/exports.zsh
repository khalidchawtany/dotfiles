
# Setup terminal, and turn on colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

export XDEBUG_CONFIG="idekey=VSCODE"

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'
#export EDITOR='subl -w'
#export NVIM_LISTEN_ADDRESS=/tmp/nv_socket
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
export EDITOR='nvim'

#export NODE_PATH=/opt/github/homebrew/lib/node_modules
#export PYTHONPATH=/usr/local/lib/python2.6/site-packages
# CTAGS Sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE=C

#export GH_ISSUE_CREATE_TOKEN=083f60c674d8eb41f98258df9fc8d94cb733218a


export PATH="/usr/local/bin:$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"

# export MANPATH="/usr/local/man:$MANPATH"
#export PATH="$PATH:~/Development/Libraries/ContinuousTests/OpenIDE.binaries"

export PATH="$PATH:~/.cargo/bin"
export PATH="$PATH:~/bin"
export PATH="$PATH:~/.local/bin"
export PATH="$PATH:~/.composer/vendor/bin"
export PATH="/Users/juju/.composer/vendor/squizlabs/php_codesniffer/bin:$PATH"
export PATH="$PATH:~/Library/Developer/Xamarin/android-sdk-macosx/platform-tools"
export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
#export PATH=$PATH:/usr/local/Cellar/php56/5.6.16/bin

export GOPATH=$HOME/Development/go
export PATH=$PATH:$GOPATH/bin

export PYTHONPATH="/usr/local/Cellar/llvm/HEAD-d9a1d02/lib/python2.7/site-packages/lldb:$PYTHONPATH"
# Virtual Environment Stuff
#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=~/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1


export NVIM_QT_STYLESHEET=~/.config/nvim/style.qss

export _Z_DATA=~/dotfiles/temp/z_jump
