# .bashrc

#if not running interactively, don't do anything
[[ $- == *i* ]] || return

if [ -f /home/edwin.chen ]; then
    USER_EDWIN=edwin.chen
else
    USER_EDWIN=edwinchenloo
fi

# User specific aliases and functions
source /home/${USER_EDWIN}/.aliases

# Aliases are available on non interactive shells
shopt -s expand_aliases

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f /mnt/local/opt/qt55/bin/qt55-env.sh ]; then
    source /mnt/local/opt/qt55/bin/qt55-env.sh
fi

if [ -f /opt/qt55/bin/qt55-env.sh ]; then
    source /opt/qt55/bin/qt55-env.sh
fi

ldpathedit -p '/home/${USER_EDWIN}/.local/gcc/lib64'
ldpathedit -p '.'

# This is to have the git branch in my prompt
if [ -f /home/${USER_EDWIN}/.git-prompt.sh ]; then
    . /home/${USER_EDWIN}/.git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWCOLORHINTS=true
    GIT_PS1_UNTRACKEDFILES=true
fi

if [ ! -z "$TERMCAP" ] && [ "$TERM" == "screen" ]; then
    export TERMCAP=$(echo $TERMCAP | sed -e 's/Co#8/Co#256/g')
fi

source /home/${USER_EDWIN}/.prompt

export CDPATH='.:/lhome/snap/ext/monorepo/cpp/apps:/lhome/snap/ext/monorepo/cpp/:/lhome/trader-repo/options/rocket'
export APCA_API_KEY_ID="PKBMQX8OFO3GN85F6E9Z"
export APCA_API_SECRET_KEY="4HJOEe9g7KFVmBAQvRxes7J2Yin0pqoOY4Q8Y2fp"
export APCA_API_BASE_URL="https://paper-api.alpaca.markets"
export APCA_API_DATA_URL="https://data.alpaca.markets"
export EDITOR=vim
export HISTCONTROL=ignorespace
export NCURSES_NO_UTF8_ACS=1
export ONE_TICK_CONFIG=/opt/1tick/one_tick_config.txt
export PATH=".:/home/${USER_EDWIN}/bin:/home/${USER_EDWIN}/bin/nvim/bin:/usr/local/bin:$PATH"
#export CXX=/usr/bin/g++
#export CC=/usr/bin/gcc
#export VALGRIND_LIB=~echen/bin
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#PATH
pathedit -p '~${USER_EDWIN}/.local/gcc/bin'
pathedit -p '~${USER_EDWIN}/.local/bin'
pathedit -p '~${USER_EDWIN}/bin/nvim/bin'
pathedit -p '~${USER_EDWIN}/bin'
pathedit -p '.'

# Set Putty to use utf-8 characters as well.  This fixes weird gcc weird characters when printing errors export LANG=en_US.utf-8

export LESS='-R -Q'

#LS_COLORS base
LS_COLORS="no=00:fi=00:di=01;33:ln=01;36:pi=40;33:so=01;35:bd=44;32:cd=44;33:ex=01:or=01;05;37;41:mi=01;05;37;41"

# executables (bright green)
LS_COLORS="${LS_COLORS}:*.cmd=01;32"
LS_COLORS="${LS_COLORS}:*.exe=01;32"
LS_COLORS="${LS_COLORS}:*.com=01;32"
LS_COLORS="${LS_COLORS}:*.btm=01;32"
LS_COLORS="${LS_COLORS}:*.bat=01;32"

# archives and compression (dark cyan)
LS_COLORS="${LS_COLORS}:*.tar=36"
LS_COLORS="${LS_COLORS}:*.tgz=36"
LS_COLORS="${LS_COLORS}:*.rpm=36"
LS_COLORS="${LS_COLORS}:*.deb=36"
LS_COLORS="${LS_COLORS}:*.arj=36"
LS_COLORS="${LS_COLORS}:*.taz=36"
LS_COLORS="${LS_COLORS}:*.lzh=36"
LS_COLORS="${LS_COLORS}:*.zip=36"
LS_COLORS="${LS_COLORS}:*.z=36"
LS_COLORS="${LS_COLORS}:*.Z=36"
LS_COLORS="${LS_COLORS}:*.gz=36"
LS_COLORS="${LS_COLORS}:*.rar=36"
LS_COLORS="${LS_COLORS}:*.jar=36"

# images (bright magenta)
LS_COLORS="${LS_COLORS}:*.jpg=01;35"
LS_COLORS="${LS_COLORS}:*.gif=01;35"
LS_COLORS="${LS_COLORS}:*.bmp=01;35"
LS_COLORS="${LS_COLORS}:*.xbm=01;35"
LS_COLORS="${LS_COLORS}:*.xpm=01;35"
LS_COLORS="${LS_COLORS}:*.tif=01;35"

# video (dark magenta)
LS_COLORS="${LS_COLORS}:*.mpg=01;35"
LS_COLORS="${LS_COLORS}:*.avi=01;35"

# sound (bright blue)
LS_COLORS="${LS_COLORS}:*.mp3=01;34"
LS_COLORS="${LS_COLORS}:*.wav=01;34"
LS_COLORS="${LS_COLORS}:*.au=01;34"
LS_COLORS="${LS_COLORS}:*.mid=01;34"
LS_COLORS="${LS_COLORS}:*.voc=01;34"
LS_COLORS="${LS_COLORS}:*.mod=01;34"
LS_COLORS="${LS_COLORS}:*.aiff=01;34"

# text (bright white)
LS_COLORS="${LS_COLORS}:*.csv=01"
LS_COLORS="${LS_COLORS}:*.txt=01"
LS_COLORS="${LS_COLORS}:*.html=01"
LS_COLORS="${LS_COLORS}:*.htm=01"
LS_COLORS="${LS_COLORS}:*.doc=01"
LS_COLORS="${LS_COLORS}:*.ps=01"
LS_COLORS="${LS_COLORS}:*.pdf=01"
LS_COLORS="${LS_COLORS}:*.lyx=01"
LS_COLORS="${LS_COLORS}:*README=01"
LS_COLORS="${LS_COLORS}:*Makefile=01"
LS_COLORS="${LS_COLORS}:*.pro=01"
LS_COLORS="${LS_COLORS}:*.pri=01"
LS_COLORS="${LS_COLORS}:*.prf=01"

# code (bright red)
LS_COLORS="${LS_COLORS}:*.c=01;31"
LS_COLORS="${LS_COLORS}:*.cc=01;31"
LS_COLORS="${LS_COLORS}:*.icc=01;31"
LS_COLORS="${LS_COLORS}:*.cpp=01;31"
LS_COLORS="${LS_COLORS}:*.pas=01;31"
LS_COLORS="${LS_COLORS}:*.tcl=01;31"
LS_COLORS="${LS_COLORS}:*.asm=01;31"
LS_COLORS="${LS_COLORS}:*.scm=01;31"
LS_COLORS="${LS_COLORS}:*.pl=01;31"
LS_COLORS="${LS_COLORS}:*.sh=01;31"
LS_COLORS="${LS_COLORS}:*.csh=01;31"
LS_COLORS="${LS_COLORS}:*.java=01;31"
LS_COLORS="${LS_COLORS}:*.ml=01;31"
LS_COLORS="${LS_COLORS}:*.pm=01;31"

# headers (dark red)
LS_COLORS="${LS_COLORS}:*.hh=00;31"
LS_COLORS="${LS_COLORS}:*.h=00;31"

# binaries (dark green)
LS_COLORS="${LS_COLORS}:*.o=32"
LS_COLORS="${LS_COLORS}:*.so=32"
LS_COLORS="${LS_COLORS}:*.obj=32"
LS_COLORS="${LS_COLORS}:*.class=32"

# libraries (light green)
LS_COLORS="${LS_COLORS}:*.a=92"
LS_COLORS="${LS_COLORS}:*.lib=92"

export LS_COLORS

# Avoid weird characters when gcc outputs warnings
#export LC_ALL=C

#source ~/merge_history.bash
HISTSIZE=500000
HISTFILESIZE=500000

#export LBM_MONITOR_INTERVAL=5
#export LBM_MONITOR_TRANSPORT=lbm

#for N in `seq 78 106`; do HOST=ng$N; echo -n $HOST ""; ssh $HOST grep ^SELINUX= /etc/selinux/config; done

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

# Default permissions
#umask 113                               # file      u=rw, g=rw, o=r
#alias mkdir='mkdir -m u=rwx,g=rwx,o-x'  # directory u=rwx,g=wrx,o=rx

# Need this for Backspace to work properly
stty erase ^?


export LIBGL_ALWAYS_INDIRECT=1
