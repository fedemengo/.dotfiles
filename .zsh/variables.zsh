export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR="$(which nvim)"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
#export BROWSER=/usr/bin/firefox
export BROWSER=open
export ZSH=$HOME/.oh-my-zsh
export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS -r"
export PAGER=$LESS
export LS_COLORS="di=38;5;38:ex=38;5;82"

PATH="$PATH:$HOME/bin:/usr/local/bin:/usr/bin"
PATH="$PATH:$HOME/.app/MatLab/bin"
PATH="$PATH:$HOME/.dotfiles/bin"
PATH="$PATH:$HOME/.dotfiles/bin/utils"

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# go
export GO111MODULE=on
export GOPATH="${HOME}/.go"
#export GOROOT="/usr/lib/go"
export GOROOT="/usr/local/go"
export GOPROXY=direct
PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

# ruby
#export RUBYOPT="-W:no-deprecated"
#export RUBY_VERSION="ruby-2.7.1"
#export PATH="${PATH}:${HOME}/.rvm/rubies/${RUBY_VERSION}/bin:${HOME}/.gem/${RUBY_VERSION}/bin"
### Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:$HOME/.rvm/bin:${HOME}/.gem/ruby/2.7.0/bin"
export GEM_HOME="$HOME/.gem"
PATH="$PATH:$GEM_HOME/bin"

# java
export JAVA_HOME="${HOME}/.jdk/jdk-11.0.4"
export JDK_HOME="${JAVA_HOME}"
export JRE_HOME="${JAVA_HOME}/jre"
PATH="${PATH}:${JAVA_HOME}/bin"

# rust
PATH="${PATH}:${HOME}/.cargo/bin"

# javascript
export NPM_PACKAGES="$HOME/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
PATH="${PATH}:${HOME}/.npm-global/bin"

# python
PYTHON_LOC="${HOME}/.local/bin"
PATH="${PATH}:${PYTHON_LOC}"
PATH="${PATH}:${HOME}/Library/Python/3.9/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/federico.mengozzi/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/federico.mengozzi/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/federico.mengozzi/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/federico.mengozzi/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

PATH="${PATH}:/usr/local/opt/llvm/bin:/usr/local/opt/binutils/bin"
PATH="${PATH}:${HOME}/.google-cloud-sdk/bin"
export $PATH

export VIMRC=${HOME}/.config/nvim/init.vim

