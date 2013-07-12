HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
zstyle :compinstall filename '/home/malvault/.zshrc'

export PROMPT=$'%{\e[0;34m%}\U250C\U2500[%{\e[0;37m%}vlamy@%m%{\e[0;34m%}]\U2500\U2500[%{\e[0;37m%}%/%{\e[0;34m%}]\U2500\U2500(%{\e[0;37m%}%*%{\e[0;34m%})\n\U2514\U2500\U2500\U2500[%{\e[0;37m%}[%y zsh%{\e[0;34m%}]%#%{\e[0;37m%} '
#export PROMPT=$'\n%{\e[0;36m%}vlamy@%m[%/](%*)\n%{\e[0;36m%}%{\e[0m%}[%y zsh]%# '
#
##\[\033[0;34m\]

autoload -Uz compinit
compinit

#execute custom configuration
export VLAM_SBIN=/vlam/sbin
. $VLAM_SBIN/setenv
. $VLAM_SBIN/aliases

