OS=$(uname -s)
ARCH=$(uname -p)

export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR="$(which nvim)"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
#export BROWSER=/usr/bin/firefox
export BROWSER=open
export ZSH=$HOME/.oh-my-zsh
export LESS_OPT="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS -r"
export PAGER="less"
export LS_COLORS="di=38;5;38:ex=38;5;82"

PATH="$PATH:$HOME/bin:/usr/local/bin:/usr/bin"
PATH="$PATH:$HOME/.app/MatLab/bin"
PATH="$PATH:$HOME/.dotfiles/bin"
PATH="$PATH:$HOME/.dotfiles/bin/utils"
PATH="$PATH:$HOME/.roswell/bin/"

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

# homebrew
if [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "i386" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [[ "$ARCH" == "arm" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
elif [[ "$OS" == "Linux" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# go
export GOPATH="${HOME}/.go"
export GOROOT="/usr/local/go"
# sudo chown fedemengo /usr/local/go/bin/
export GOBIN=$GOROOT/bin
export GOPROXY="direct"
export GOSUMDB="sum.golang.org"
PATH="$PATH:$GOPATH/bin:$GOBIN"

# ruby
#export RUBYOPT="-W:no-deprecated"
#RUBY_VERSION="ruby-2.6.10"
#PATH="${PATH}:${HOME}/.rvm/rubies/${RUBY_VERSION}/bin:${HOME}/.gem/${RUBY_VERSION}/bin"
### Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:$HOME/.rvm/bin:${HOME}/.gem/ruby/2.7.0/bin"
#export GEM_HOME="$HOME/.gem"
#PATH="$PATH:$GEM_HOME/bin"

#eval "$(rbenv init - zsh)"

# java
export JAVA_HOME="/usr/local/opt/openjdk@20/"
export JDK_HOME="${JAVA_HOME}"
export JRE_HOME="/usr/local/opt/openjdk/bin:$PATH"
PATH="${PATH}:${JAVA_HOME}/bin"

# rust
PATH="${PATH}:${HOME}/.cargo/bin"

# javascript
export NPM_PACKAGES="$HOME/.npm-packages"
PATH="${PATH}:$NPM_PACKAGES/bin"
PATH="${PATH}:${HOME}/.npm-global/bin"

# python
PYTHON_LOC="${HOME}/.local/bin"
PATH="${PATH}:${PYTHON_LOC}"
PATH="${PATH}:${HOME}/Library/Python/3.9/bin"

. "$HOME/.cargo/env" 2>/dev/null

PATH="${PATH}:/usr/local/opt/llvm/bin:/usr/local/opt/binutils/bin"
PATH="${PATH}:${HOME}/.google-cloud-sdk/bin"
PATH="${PATH}:${KREW_ROOT:-$HOME/.krew}/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
PATH="$PATH:$HOME/.rvm/bin"
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH
export VIMRC=${HOME}/.dotfiles/.config/nvim/

# this is a piece of trash that prefix its own config to PATH
# so tools like python are resolved within them - kmn
echo "setting up free surfer"
ORIGINAL_PATH=$PATH
export FREESURFER_HOME=/Applications/freesurfer/7.4.1
source "$FREESURFER_HOME/SetUpFreeSurfer.sh"
PATH=$ORIGINAL_PATH:$PATH
echo "done with free surfer"

export DIPY_HOME="${HOME}/.dipy"

export NILEARN_DATA="${HOME}/.nilearn/data"

