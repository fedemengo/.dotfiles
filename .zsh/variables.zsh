export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/vim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export MONITOR="eDP1"
export BROWSER=/usr/bin/firefox
export TERMINAL=/usr/bin/termite
export ZSH=$HOME/.oh-my-zsh
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.app/MatLab/bin

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

export RUBYOPT="-W:no-deprecated"
export RUBY_VERSION="ruby-2.7.1"
export PATH="${PATH}:${HOME}/.rvm/rubies/${RUBY_VERSION}/bin:${HOME}/.gem/${RUBY_VERSION}/bin"
## Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:${HOME}/.gem/ruby/2.7.0/bin"

export EDITOR="$(which vim)"

# python local stuff
PYTHON_LOC="${HOME}/.local/bin"
export PATH="${PATH}:${PYTHON_LOC}"

# Just for testing algo-and-ds repo
export PATH="${PATH}:${HOME}/projects/algorithms-and-data-structures"

export IP_TOKEN="4c202ad50e5741"

export FM=${HOME}

export ANDROID_HOME="$HOME/.Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export PATH="${PATH}:${HOME}/.app/android-studio/bin/studio.sh"

export JAVA_HOME="${HOME}/.jdk/jdk-11.0.4"
export JDK_HOME="${JAVA_HOME}"
export JRE_HOME="${JAVA_HOME}/jre"

export PATH="${PATH}:${JAVA_HOME}/bin"

export PATH="${PATH}:${HOME}/.cargo/bin"

export PATH="${PATH}:${HOME}/.npm-global/bin"
