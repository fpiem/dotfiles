function zvm_before_init() {
  zvm_bindkey viins '^[[A' history-substring-search-up
  zvm_bindkey viins '^[[B' history-substring-search-down
  zvm_bindkey vicmd '^[[A' history-substring-search-up
  zvm_bindkey vicmd '^[[B' history-substring-search-down
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# TODO: honestly at this point there's no reason to use OhMyZsh or Prezto.
# Just get the plugins we want from OMZ and Pr's repositories and install them
# with zinit. Will probably be faster.
zmodload zsh/zprof
setopt clobber

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Disable prezto command autocorrect (seriously fuck off)
unsetopt correct

# Set Neovim as default editor
alias nvim=${HOME}/.local/bin/nvim.appimage

alias oni2=${HOME}/personal-projects/oni2/_release/Onivim2-x86_64.AppImage

# >>> conda initialize >>>
__conda_setup="$('/home/francesco/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/francesco/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/francesco/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/francesco/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> gcloud >>>
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/francesco/google-cloud-sdk/path.zsh.inc' ]; then . '/home/francesco/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/francesco/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/francesco/google-cloud-sdk/completion.zsh.inc'; fi
# <<< gcloud <<<

# direnv
export DIRENV_LOG_FORMAT=
eval "$(direnv hook zsh)"

# set fzf default look
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'

# Utility command for copying Mackup backups to gdrive (saving dotfiles to
# gdrive directly was too slow).
alias update-dotfiles="rsync -a --exclude=".git" ${HOME}/apps-and-plugins/Mackup /${HOME}/gdrive-personal -v"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# Starship prompt
# Currently giving me latency issues, not sure why, shame because I love it
# eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Needed to get dead keys to work in VSCodeNeoVim
dbus-send --bus="`ibus address`" --print-reply --dest=org.freedesktop.IBus /org/freedesktop/IBus org.freedesktop.DBus.Properties.Set string:org.freedesktop.IBus string:EmbedPreeditText variant:boolean:false > /dev/null

# >>> zinit >>>
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

# lucid <-> plugins are loaded AFTER the prompt is drawn
# => faster zsh startup
# zinit wait lucid for \
zinit light-mode for \
    OMZ::plugins/autojump/autojump.plugin.zsh \
    OMZ::plugins/thefuck/thefuck.plugin.zsh \
    OMZ::lib/clipboard.zsh \
    OMZ::plugins/copypath/copypath.plugin.zsh \
    zsh-users/zsh-autosuggestions \
    esc/conda-zsh-completion \
    Tarrasch/zsh-bd \
    jeffreytse/zsh-vi-mode \
    zsh-users/zsh-history-substring-search

zinit load agkozak/zsh-z

# zsh-users/zsh-history-substring-search \
# These parameters must be set before the zsh-nvm plugin is loaded
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
zinit light lukechilds/zsh-nvm

# powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# <<< zinit <<<

alias 'FUCK'='fuck --yeah'

# TODO: some completers seem to work without this,
# which might mean we have redundant compinit calls
autoload -Uz compinit
compinit

# >>> zsh vi mode >>>
ZVM_KEYTIMEOUT=0.001
ZVM_ESCAPE_KEYTIMEOUT=0.001

# Always starting with insert mode for each command line
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

ZVM_VI_SURROUND_BINDKEY="s-prefix"
# <<< zsh vi mode <<<

# >>> cuda stuff
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}$
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# <<< cuda stuff

alias 'upupa'='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y'
alias 'tf'='terraform'

eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init -)"

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="$HOME/apps-and-plugins/tfenv/bin:$PATH"

# nala autocomplete
source /usr/share/bash-completion/completions/nala

export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# >>> linuxbrew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
# <<< linuxbrew

# >>> Personal aliases
alias gpod="git pull origin dev"
alias gpgg="git pull && git gone"
alias gsd="git switch dev"
# <<< Personal aliases
