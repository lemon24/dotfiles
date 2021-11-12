source ~/.shrc

export LESS=-R

HISTSIZE=10000000
SAVEHIST=10000000

# BEGIN direnv

eval "$(direnv hook zsh)"

setopt PROMPT_SUBST

show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV)) "
  fi
}
PS1='$(show_virtual_env)'$PS1

# END direnv


# BEGIN zsh-completions

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
fi

# END zsh-completions


# BEGIN zoxide
eval "$(zoxide init zsh)"
# END zoxide


PS1='$(show_virtual_env)%1~ %(#.#.$) '


test -e ~/.zshrc.local && source ~/.zshrc.local
