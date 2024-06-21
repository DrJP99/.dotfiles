# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# COLORS
NO_FORMAT=$'\001\e[0m\002'
F_BOLD=$'\001\e[1m\002'
F_DIM=$'\001\e[2m\002'

# COLORS
# C_RED=$'\001\e[38;5;1m\002'
# C_ORANGE=$'\001\e[38;5;172m\002'
# c_GREY=$'\001\e[38;5;95m\002'
# C_GREEN=$'\001\e[38;5;41m\002'
# C_BLUE=$'\001\e[38;5;14m\002'
# C_YELLOW=$'\001\e[38;5;214m\002'
# C_PURPLE=$'\001\e[${L_PURPLE}m\002'

# Terminal Colors
# SIMPLE CODES
BLACK='30'
GREY='38;5;8'

RED='31'
L_RED='38;5;9'

GREEN='32'
L_GREEN='38;5;10'

YELLOW='33'
L_YELLOW='38;5;11'

BLUE='34'
L_BLUE='38;5;12'

PURPLE='35'
L_PURPLE='38;5;13'

CYAN='36'
L_CYAN='38;5;14'

WHITE='37'
L_WHITE='38;5;15'

# FULL CODES
C_BLACK=$'\001\e[${BLACK}m\002'
c_GREY=$'\001\e[${GREY}m\002'

C_RED=$'\001\e[${RED}m\002'
C_L_RED=$'\001\e[${L_RED}m\002'

C_GREEN=$'\001\e[${GREEN}m\002'
C_L_GREEN=$'\001\e[${L_GREEN}m\002'

C_YELLOW=$'\001\e[${YELLOW}m\002'
C_L_YELLOW=$'\001\e[${L_YELLOW}m\002'

C_BLUE=$'\001\e[${BLUE}m\002'
C_L_BLUE=$'\001\e[${L_BLUE}m\002'

C_PURPLE=$'\001\e[${PURPLE}m\002'
C_L_PURPLE=$'\001\e[${L_PURPLE}m\002'

C_CYAN=$'\001\e[${CYAN}m\002'
C_L_CYAN=$'\001\e[${L_CYAN}m\002'

C_WHITE=$'\001\e[${WHITE}m\002'
C_L_WHITE=$'\001\e[${L_WHITE}m\002'

GIT_PS1_SHOWDIRTYSTATE=yes
GIT_PS1_SHOWSTASHSTATE=yes
GIT_PS1_SHOWUNTRACKEDFILES=yes
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=yes

PROMPT_COMMAND=update_ps1

# Prompt
if [ "$color_prompt" = yes ]; then

    # git_branch() {
    #     git symbolic-ref --short HEAD 2> /dev/null
    # }

    # git_m() {
    #     # echo "$(git_branch) `echo -n $(git_branch) | wc -m`"
    #     if [ `echo -n $(git_branch) | wc -m` -gt 0 ]; then
    #         echo -e " ${F_BOLD}${F_DIM}(${NO_FORMAT}${F_BOLD}${C_ORANGE}$(git_branch)${NO_FORMAT}${F_BOLD}${F_DIM})${NO_FORMAT}"
    #     fi
    # }

    # # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u @ \h in \[\033[00m\]\[\033[01;34m\]\w \n\[\033[00m\]\$ '

    left_prompt() {
        echo -e "${F_BOLD}${C_RED}\u${NO_FORMAT} ${F_BOLD}${F_DIM}${C_GREY}@${NO_FORMAT} ${F_BOLD}${C_YELLOW}\h${NO_FORMAT} ${F_BOLD}${F_DIM}${C_GREY}in${NO_FORMAT} ${F_BOLD}${C_PURPLE}\w${NO_FORMAT}\$(__git_ps1 ' (%s)') "
    }
    
    # LEFT_PROMPT="${F_BOLD}${C_RED}\u${NO_FORMAT} ${F_BOLD}${F_DIM}${C_GREY}@${NO_FORMAT} ${F_BOLD}${C_ORANGE}\h${NO_FORMAT} ${F_BOLD}${F_DIM}${C_GREY}in${NO_FORMAT} ${F_BOLD}${C_BLUE}\w${NO_FORMAT}\$(__git_ps1 ' (%s)') "

    left_prompt_size() {
        echo -n $(left_prompt) | wc -m
    }

    time_prompt() {
        echo -e "${F_DIM}${C_GREY}$(date '+%H:%M:%S') ${NO_FORMAT}"
    }

    print_pre_prompt() {
        compensate=12
        printf "%*s\r%s\n" "$(($COLUMNS+${compensate}))" "$(time_prompt)" "$(left_prompt)"
    }
    
    # PS1="${debian_chroot:+($debian_chroot)}$(left_prompt)| $(time_prompt)\n${F_BOLD}${C_GREEN}\$${NO_FORMAT} "
    update_ps1() {
        PS1="${debian_chroot:+($debian_chroot)}$(print_pre_prompt)\n${F_BOLD}${C_CYAN}\$${NO_FORMAT} "
    }

    PS2="${F_BOLD}${C_CYAN}\$${NO_FORMAT} "

else
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u in \w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

bind TAB:menu-complete
bind '"\e[Z": menu-complete-backward'
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind "set completion-ignore-case on"

if [ -f ~/.git-prompt.sh ]; then    
    source ~/.git-prompt.sh
else
    __git_ps1 () {
        :
    }
fi

# di = directories
# fi = files
# ln = symbolic link
# pi = named pipe
# so = socket
# bd = blocked device
# cd = character device
# or = orphan symbolic
# mi = missing file
# ex = executable file
# *.x = extension x
# ...

# LS_COLORS="fi=00:di=1;${PURPLE}:ex=1;${L_PURPLE}:"
LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:"
for file in .tar .tgz .arc .arj .taz .lha .lz4 .lzh .lzma .tlz .txz .tzo .t7z .zip .z .dz .gz .lrz .lz .lzo .xz .zst .tzst .bz2 .bz .tbz .tbz2 .tz .deb .rpm .jar .war .ear .sar .rar .alz .ace .zoo .cpio .7z .rz .cab .wim .swm .dwm .esd;
do
    LS_COLORS="${LS_COLORS}*${file}=4;${RED}:";
done

for file in .jpg .jpeg .mjpg .mjpeg .gif .bmp .pbm .pgm .ppm .tga .xbm .xpm .tif .tiff .png .svg .svgz .mng .pcx .mov .mpg .mpeg .m2v .mkv .webm .ogm .mp4 .m4v .mp4v .vob .qt .nuv .wmv .asf .rm .rmvb .flc .avi .fli .flv .gl .dl .xcf .xwd .yuv .cgm .emf .ogv .ogx;
do
    LS_COLORS="${LS_COLORS}*${file}=${L_CYAN}:";
done

# LS_COLORS="fi=00:di=1;${PURPLE}:ex=1;${GREEN}:*.tar=4;${RED}:*.zip=4;${RED}:*.gz=4;${RED}:*.xz=4;${RED}:*.bz2=4;${RED}:*.genozip=4;${RED}:*.lz=4;${RED}:*.lz4=4;${RED}:*.jar=4;${RED}:*.lzma=4;${RED}:*.lzo=4;${RED}:*.rz=4;${RED}:*.sfark=4;${RED}:*.sz=4;${RED}:*.deb=4;${RED}72:*.jpg=${L_CYAN}:*.jpeg=${L_CYAN}:*.png=${L_CYAN}:*.ico=${L_CYAN}:*.log=04"
export PATH=$PATH:/home/jp/.spicetify
export PATH=$PATH:/home/jp/.local/bin
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Interactive cp & mv
alias cp='cp -vi'
alias mv='mv -vi'
alias cpv='rsync -avh --info=progress2'

# Find string in all files in directory
fstr() {
    grep -Rnw "." -e "$1"
}

# sudo last command
s() { # do sudo, or sudo the last command if no argument given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# easy extract
function extract {
 if [ $# -eq 0 ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso|.zst>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 fi
    for n in "$@"; do
        if [ ! -f "$n" ]; then
            echo "'$n' - file doesn't exist"
            return 1
        fi

        case "${n%,}" in
          *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                       tar zxvf "$n"       ;;
          *.lzma)      unlzma ./"$n"      ;;
          *.bz2)       bunzip2 ./"$n"     ;;
          *.cbr|*.rar) unrar x -ad ./"$n" ;;
          *.gz)        gunzip ./"$n"      ;;
          *.cbz|*.epub|*.zip) unzip ./"$n"   ;;
          *.z)         uncompress ./"$n"  ;;
          *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
                       7z x ./"$n"        ;;
          *.xz)        unxz ./"$n"        ;;
          *.exe)       cabextract ./"$n"  ;;
          *.cpio)      cpio -id < ./"$n"  ;;
          *.cba|*.ace) unace x ./"$n"     ;;
          *.zpaq)      zpaq x ./"$n"      ;;
          *.arc)       arc e ./"$n"       ;;
          *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                            extract "$n.iso" && \rm -f "$n" ;;
          *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && \
                            mv ./"$n.tmp" ./"${n%.*zlib}" && rm -f "$n"   ;;
          *.dmg)
                      hdiutil mount ./"$n" -mountpoint "./$n.mounted" ;;
          *.tar.zst)  tar -I zstd -xvf ./"$n"  ;;
          *.zst)      zstd -d ./"$n"  ;;
          *)
                      echo "extract: '$n' - unknown archive method"
                      return 1
                      ;;
        esac
    done
}