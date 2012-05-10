# Lines configured by zsh-newuser-install
typeset -U path
path=(~/bin /usr/local/bin /usr/bin /bin /opt/bin $path)

if [ -r /etc/profile ] ; then
    source /etc/profile
fi

## If already set, do not reset.
##
(( ${+USER} ))      || export USER=$USERNAME
(( ${+HOSTNAME} ))  || export HOSTNAME=$HOST
(( ${+EDITOR} ))    || export EDITOR=`which vim`
(( ${+VISUAL} ))    || export VISUAL=`which vim`
(( ${+PAGER} ))     || export PAGER=`which less`
(( ${+LESSOPEN} ))  || export LESSOPEN='| lesspipe.sh %s'



HISTFILE=~/.zsh/histfile
HISTSIZE=4096
SAVEHIST=4096

setopt appendhistory 
setopt autocd 
setopt notify
# setopt correctall
setopt hist_ignore_all_dups
setopt nobeep
setopt nocheckjobs             # don't warn me about bg processes when exiting
setopt nohup                   # and don't kill them, either
setopt listpacked              # compact completion lists
setopt alwaystoend		# alert me if something's failed
setopt printexitvalue 
setopt share_history           # _all_ zsh sessions share the same history files
setopt nobgnice			# bg processes aren't niced.
setopt automenu

autoload -U colors && colors
autoload -U promptinit && promptinit
autoload -U zsh-mime-setup && zsh-mime-setup
autoload -Uz vcs_info
autoload -Uz compinit && compinit

bindkey -e					# Use emacs style
bindkey '^i' expand-or-complete-prefix # Tab completion
# History Completion on up and down arrow
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey ' ' magic-space 			# also do history expansion on space

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/zen/.zshrc'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select

# This can probably be toggled... Somewhere...
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true



## I'm so close to my kickass dev box.
#  Just have to remove autocomplete from vim.
#  Remove those stupid tags which keep getting in my way.
#
# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        (( $ahead )) && gitstatus+=( "${c3}+${ahead}${c2}" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( "${c4}-${behind}${c2}" )

        hook_com[branch]="${hook_com[branch]} [${remote} ${(j:/:)gitstatus}]"
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+=" (${stashes} stashed)"
    fi
}

#zstyle ':vcs_info:*' actionformats \
#    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
#zstyle ':vcs_info:*' formats       \
#    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

precmd()    { 
    vcs_info
}
# PS1='%F{5}[%F{2}%n%F{5}] %F{3}%3~ ${vcs_info_msg_0_}%f%# '

SMILE="%(?,%{$fg[blue]%}%B=%)%{$reset_color%},%{$fg[red]%}=(%b%{$reset_color%})" 
RPROMPT="${vcs_info_msg_0_}"
 #RPROMPT+="(%!%) %T" 

PROMPT="%B-%b%{$fg[green]%}%~"$'\n'
PROMPT+="%{$fg[white]%}%B%b%{$fg[green]%}%n%{$reset_color%}%B<%b${SMILE}%{$reset_color%}%B>%b "  #'\n'
# PROMPT+=$TPROMPT'\n'$LPROMPT

## Aliases
if [ -f ~/.zsh/zalias ]; then
    source ~/.zsh/zalias
fi

## Functions
if [ -f ~/.zsh/zfunc ]; then
    source ~/.zsh/zfunc
fi
