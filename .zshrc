# Set up the prompt

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

C_RED=$'\001\e['${RED}'m\002'
C_L_RED=$'\001\e['${L_RED}'m\002'

C_GREEN=$'\001\e['${GREEN}'m\002'
C_L_GREEN=$'\001\e['${L_GREEN}'m\002'

C_YELLOW=$'\001\e['${YELLOW}'m\002'
C_L_YELLOW=$'\001\e['${L_YELLOW}'m\002'

C_BLUE=$'\001\e['${BLUE}'m\002'
C_L_BLUE=$'\001\e['${L_BLUE}'m\002'

C_PURPLE=$'\001\e['${PURPLE}'m\002'
C_L_PURPLE=$'\001\e['${L_PURPLE}'m\002'

C_CYAN=$'\001\e['${CYAN}'m'
C_L_CYAN=$'\001\e['${L_CYAN}'m\002'

C_WHITE=$'\001\e['${WHITE}'m\002'
C_L_WHITE=$'\001\e['${L_WHITE}'m\002'

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

print_pre_prompt() {
	compensate=12
	printf "%*s\r%s\n" "$(($COLUMNS+${compensate}))" "$(time_prompt)" "$(left_prompt)"
}

update_ps1() {
	PS1="%{$(print_pre_prompt)%}%{${NEW_LINE}%}%{${F_BOLD}%}%{${C_CYAN}%}\$%{${NO_FORMAT}%} "
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