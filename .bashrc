# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Include SHELL scripts
for file in ~/.shell/*
do
    source $file
done

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

# If this is an xterm set the title to user @ host in dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u @ \h in \w\a\]$PS1"
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

# Load Rust/Cargo env variables
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi