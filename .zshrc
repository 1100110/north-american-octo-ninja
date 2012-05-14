#!/usr/bin/zsh

# Lines configured by zsh-newuser-install
typeset -U path
path=(~/bin /usr/local/bin /usr/bin /bin /opt/bin $path)
fpath=(~/.zsh ~/.zsh/plugins ~/.zsh/lib ~/.zsh/themes ~/.zsh/themes $fpath)

if [[ -r /etc/profile ]] ; then
    source /etc/profile
fi


## MOVE THIS INTO zenv
## If already set, do not reset.
##
(( ${+USER} ))      || export USER=$USERNAME
(( ${+HOSTNAME} ))  || export HOSTNAME=$HOST
(( ${+EDITOR} ))    || export EDITOR=`which vim`
(( ${+VISUAL} ))    || export VISUAL=`which vim`
(( ${+PAGER} ))     || export PAGER=`which less`

HISTFILE=~/.zsh/histfile
HISTSIZE=4096
SAVEHIST=4096


setopt appendhistory            # Good default
setopt autocd                   # Do not have to type 'cd'
setopt autopushd                # Old cwd is pushed to the stack
# setopt correctall
setopt hist_ignore_all_dups     # No duplicates, I assume you got it the first time?
setopt nobeep                   # thank god...
# setopt nocheckjobs              # don't warn me about bg processes when exiting
# setopt nohup                    # and don't kill them, either
setopt listpacked               # compact completion lists
setopt alwaystoend		        # alert me if something's failed
setopt printexitvalue           # Well? what happened?
setopt share_history            # _all_ zsh sessions share the same history files
setopt nobgnice                 # bg processes aren't niced.
setopt automenu                 # Funny, haven't seen the menu
setopt promptsubst             # Necessary for Git 


autoload -U colors          && colors
autoload -U promptinit      && promptinit
autoload -U zsh-mime-setup  && zsh-mime-setup
autoload -Uz compinit       && compinit
#autoload -Uz vcs_info       && vcs_info

#autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
#add-zsh-hook chpwd chpwd_recent_dirs

bindkey -e					    # Use emacs style
bindkey '^i' expand-or-complete-prefix # Tab completion                                # History Completion on up and down arrow
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey ' ' magic-space 		# also do history expansion on space


# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/zen/.zshrc'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:cdr:*:*' menu selection

# This can probably be toggled... Somewhere...
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*+*:*' debug true


# SMILE="%(?,%{$fg[blue]%}%B=%)%{$reset_color%},%{$fg[red]%}=(%b%{$reset_color%})" 
# ERRCODE="%{$fg[red]%}%!"

#RPROMPT="%B[][%b%{$fg[green]%}%~%{$fg[white]%}%B]%b" #$'\n'
#RPROMPT+="%{$fg[white]%}%B[%b%{$fg[green]%}%n%{$reset_color%}%B|%{$fg[red]%}%b%{$fg[white]%}%B|%b%{$reset_color%}%B]>%b "
#RPROMPT='\n'^"nada"
#PROMPT+=$TPROMPT'\n'$LPROMPT
#PS1='%F{5}[%F{2}%n%F{5}] %F{3}%3~ ${vcs_info_msg_0_}%f%# '


## Prompts
if [[ -f ~/.zsh/tools/git-prompt.sh ]]; then
    source ~/.zsh/tools/git-prompt.sh
fi

## Aliases
if [[ -f ~/.zsh/zalias ]]; then
    source ~/.zsh/zalias
fi

## Functions
if [[ -f ~/.zsh/zfunc ]]; then
    source ~/.zsh/zfunc
fi

##  Oh-My-Zsh
#   All of the plugins will be sourced here.
# plugins=(git github)
local reset white gray green red
reset="%{${reset_color}%}"
white="%{$fg[white]%}"
gray="%{$fg_bold[black]%}"
green="%{$fg_bold[green]%}"
red="%{$fg[red]%}"
yellow="%{$fg[yellow]%}"


local -a infoline
local i_width
local i_filler
local filler

# function uleftp()   {

# get the length of the terminal
# i_width=${(S)infoline//\%\{*\%\}}
# i_width=${#${(%)i_width}}

# i_filler=$(( $COLUMNS - $i_width ))
# filler="${gray}${(l:${i_filler}::.:)}${reset}"


# infoline+=("[")
# See if the local directory is writable or not.
# [[ -w $PWD ]] && infoline+=( ${green} ) || infoline+=( ${yellow} )
# infoline+=("%~ "])
# infoline[2]=( "${infoline[2]} ${filler} " )

# }



local ERRCODE="%{$fg[red]%}%!"
local SMILE="%(?,%{$fg[blue]%}%B=%)%{$reset_color%},%{$fg[red]%}=(%b%{$reset_color%})"
local GIT_SYM='±'
local llcorner="┕"
local ulcorner="┍"
local bvertical="│"
local bhorizontal="━"
PROMPT='${ulcorner%}$(git_super_status)${bhorizontal%}[%{$fg[blue]%}%~ ${white%}]${bhorizontal}๛   '$'\n'
PROMPT+="${llcorner%}[%{$fg[green]%}%n%{$fg[white]%}]${bhorizontal%}๛   "

# RPROMPT='[%{$fg[yellow]%}$(date)%{$fg[white]%}]'
# RPROMPT="[$SMILE][$ERRCODE]"

#
# PROMPT='%B%m%~%b$(git_super_status) %# '
