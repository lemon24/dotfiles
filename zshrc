source ~/.shrc


HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory  
setopt sharehistory
setopt incappendhistory  


function show_virtual_env {
    if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
        echo "($(basename $VIRTUAL_ENV)) "
    fi
}

PS1='$(show_virtual_env)%1~ %(#.#.$) '


export LESS=-R


# BEGIN zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
fi
# END zsh-completions


# BEGIN direnv
if type direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
    setopt PROMPT_SUBST
fi
# END direnv


# BEGIN zoxide
if type zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi
# END zoxide


test -e ~/.zshrc.local && source ~/.zshrc.local
