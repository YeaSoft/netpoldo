#!/bin/bash
if [ -f /etc/profile.d/gentoo-prompt.sh ]; then
	. /etc/profile.d/gentoo-prompt.sh
fi
alias edalias='nano ~/.bash_aliases; unalias -a; source ~/.bash_aliases'
alias apt-purge='apt-get --purge remove'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -alF'
alias la='ls $LS_OPTIONS -A'
alias l='ls $LS_OPTIONS -CF'
