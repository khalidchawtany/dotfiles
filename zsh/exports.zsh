# Setup terminal, and turn on colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad


# set react native editor to neovim-qt
export REACT_EDITOR="nvr"

export XDEBUG_CONFIG="idekey=VSCODE"

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'
# export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
export EDITOR='nvim'

# For luarocks not loading
export DYLD_LIBRARY_PATH=/usr/local/lib

#export NODE_PATH=/opt/github/homebrew/lib/node_modules
#export PYTHONPATH=/usr/local/lib/python2.6/site-packages
# CTAGS Sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE=C

# export MANPATH="/usr/local/man:$MANPATH"
# export PATH="$PATH:~/Development/Libraries/ContinuousTests/OpenIDE.binaries"

export PYTHONPATH="/usr/local/Cellar/llvm/HEAD-d9a1d02/lib/python2.7/site-packages/lldb:$PYTHONPATH"
# Virtual Environment Stuff
#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVIM_QT_STYLESHEET=~/.config/nvim/style.qss

export _Z_DATA=~/dotfiles/temp/z_jump

export GOPATH=$HOME/go

export ANDROID_SDK_ROOT="/Users/juju/Library/Android/sdk"
export  ANDROID_HOM="/Users/juju/Library/Android"

export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:/Users/juju/.composer/vendor/squizlabs/php_codesniffer/bin"
export PATH="$PATH:/Users/juju/.composer/vendor/bin"
export PATH="$PATH:/Users/juju/.local/bin"
export PATH="$PATH:/Users/juju/local/bin"
export PATH="$PATH:/Users/juju/bin"
export PATH="$PATH:/opt/X11/bin"
export PATH="$PATH:/usr/local/opt/go/libexec/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/Users/juju/go/bin"
export PATH="$PATH:/Users/juju/.cargo/bin"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
# export PATH="$PATH:/Users/juju/.config/nvim_lua/lsp/phpactor/bin"
export PATH="$PATH:/Users/juju/.config/nvim_lua/lsp/phpactor/bin"
export PATH="$PATH:/Users/juju/Library/Android/sdk/emulator/"


# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
