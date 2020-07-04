# .bashrc

#if not running interactively, don't do anything
[[ $- == *i* ]] || return

# User specific aliases and functions
source ~/.aliases

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

export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH

# This is to have the git branch in my prompt
if [ -f ~/bin/git-prompt.sh ]; then
    . ~/bin/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWCOLORHINTS=true
    GIT_PS1_UNTRACKEDFILES=true
fi

#if [ -f .profile ]; then
#    . .profile
#fi

source ~/.prompt

#export CDPATH='.:~:/net/chihq-share-01/home_dirs/edwin.chen/linux'
export EDITOR=vim
export HISTCONTROL=ignorespace
export NCURSES_NO_UTF8_ACS=1
export ONE_TICK_CONFIG=/opt/1tick/one_tick_config.txt
export PATH=".:~/bin:~/linux/depot_tools:$PATH"
#export CXX=/usr/bin/g++
#export CC=/usr/bin/gcc
export RLM_LICENSE=/home/edwin.chen/linux/Volar/volar-cal-cur-pri-xrtrading_20180901.lic
#export VALGRIND_LIB=~echen/bin

# Set Putty to use utf-8 characters as well.  This fixes weird gcc weird characters when printing errors export LANG=en_US.utf-8

export LESS='-R'

pskill()
{
        local pid

        pid=$(ps ax | grep $1 | grep -v grep | awk '{ print $1 }')
 #       echo -n "killing $1 (process $pid)..."
        /bin/kill -s SIGTERM $pid
        /bin/kill -s SIGKILL $pid
        echo "slaughtered."
}

gclone()
{
    #git clone git@devtools:id/"$1".git
    git clone ssh://git@hq-stash.lnx.xrtrading.local:7999/snap/"$1".git
}

clonesnap() 
{
    git clone ssh://git@hq-stash.lnx.xrtrading.local:7999/snap/snap.git "$1"
    cd "$1"
    /bin/ls
    git checkout -b "$1"
    git status
}

mergemaster()
{
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git checkout master
    git pull --rebase
    git checkout $BRANCH
    git merge -m 'merge with master' master
}

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
export LC_ALL=C

#source ~/merge_history.bash
HISTSIZE=500000
HISTFILESIZE=500000

#export LBM_MONITOR_INTERVAL=5
#export LBM_MONITOR_TRANSPORT=lbm

#for N in `seq 78 106`; do HOST=ng$N; echo -n $HOST ""; ssh $HOST grep ^SELINUX= /etc/selinux/config; done

function bpftp() {
  export SSHPASS='f1r$t0rd3r'
  sshpass -e sftp idev@sftp.maystreet.com
  export SSHPASS=
}

function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

function rg() {
  grep -r --exclude=\*/.svn/\* --exclude=\*.swp --include $2 $1 .
}

function u() {
  uncrustify -c ~/utils/uncrustify.cfg -l CPP --replace $1
}

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out=${info[2]}" "$out"] ("$free" free on "$fs")"
        echo -e $out
    done
}

function my_ip() # Get IP adress on ethernet.
{
    MY_IP=$(/sbin/ifconfig bond0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${MY_IP:-"Not connected"}
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${BRed}$HOST"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free
    echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}

function l()
{
  exa -alhmF --git --group-directories-first  --color-scale $1
  p=`realpath ${1:-.}`
  echo -e "`realpath $p/..`/\e$BBlue`basename $p`\e$Color_Off"
}

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

