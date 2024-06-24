# Set up the prompt

# Include SHELL scripts
for file in ~/.shell/*
do
    source $file
done

NEW_LINE=$'\n'

GIT_PS1_SHOWDIRTYSTATE=yes
GIT_PS1_SHOWSTASHSTATE=yes
GIT_PS1_SHOWUNTRACKEDFILES=yes
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=yes

left_prompt() {
	echo -e "%${F_BOLD%}${C_RED}%n${NO_FORMAT} ${F_BOLD}${F_DIM}${C_GREY}@${NO_FORMAT} ${F_BOLD}${C_YELLOW}%m${NO_FORMAT} ${F_BOLD}${F_DIM}${C_GREY}in${NO_FORMAT} ${F_BOLD}${C_PURPLE}%~${NO_FORMAT}$(__git_ps1 ' (%s)')"
}


left_prompt_size() {
	echo -n $(left_prompt) | wc -m
}

time_prompt() {
	echo -e "${F_DIM}${C_GREY}$(date '+%H:%M:%S') ${NO_FORMAT}"
}

exit_code() {
    if [ $1 != 0 ]; then 
        echo -e "[${F_BOLD}${C_RED}$1${NO_FORMAT}]"
    fi
}

print_pre_prompt() {
    # The padding ammount has to take into consideration the escape characters too (color and format)
    base_compensate=12

    if [ $1 != 0 ]; then 
        BASE=1
        if [ ${#1} = 1 ]; then
            BASE=2
        elif [ ${#1} = 3 ]; then
            BASE=0
        fi
        compensate=$(($compensate+${#1}+32+$BASE))
    else
        compensate=$base_compensate
    fi

	printf "%*s\r%s\n" "$(($COLUMNS+${compensate}))" "$(exit_code $1) $(time_prompt)" "$(left_prompt)"
}

update_ps1() {
    local EXIT=$?
	PS1="%{$(print_pre_prompt $EXIT)%}%{${NEW_LINE}%}%{${F_BOLD}%}%{${C_CYAN}%}\$%{${NO_FORMAT}%} "
}

PROMPT_COMMAND=update_ps1
prmptcmd() {
	eval "$PROMPT_COMMAND" 
}

# autoload -Uz vcs_info # enable vcs_info
# precmd () { vcs_info } # always load before displaying the prompt
# zstyle ':vcs_info:*' formats ' %s(%b)' # git(main)
precmd_functions=(prmptcmd)


# autoload -Uz promptinit
# promptinit
# prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -v

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


source ~/.git-prompt.sh

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
		sudo $(fc -ln  -1)
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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-history-substring-search z copypath copybuffer)

ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh