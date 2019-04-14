export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/vim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/firefox
export TERMINAL="termite"
export ZSH=$HOME/.oh-my-zsh
export PATH=$HOME/bin:/usr/local/bin:$PATH

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

export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"
export LS_COLORS="di=38;5;38:ex=38;5;82"

export GOPATH="${HOME}/.go"
export GOROOT="/usr/lib/go"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"
export GO111MODULE=on

export RUBY_VERSION="2.6.0"
export PATH="${PATH}:${HOME}/.gem/ruby/${RUBY_VERSION}/bin"

export EDITOR="$(which vim)"

# python local stuff
PYTHON_LOC="${HOME}/.local/bin"
export PATH="${PATH}:${PYTHON_LOC}"

# Just for testing algo-and-ds repo
export PATH="${PATH}:${HOME}/projects/algorithms-and-data-structures"

export IP_TOKEN="4c202ad50e5741"

export FM=${HOME}

