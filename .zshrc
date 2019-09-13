source ~/.zplug/init.zsh

#----------------------------------------
# Zplug
#----------------------------------------
zplug 'clvv/fasd', as:command

zplug "lib/history", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh

zplug "djui/alias-tips"

zplug "supercrabtree/k"

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2


zplug check || zplug install
zplug load


#----------------------------------------
# Others
#----------------------------------------

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
