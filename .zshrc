# {{{ Start configuration added by Zim install
# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# Initialize modules
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# zsh-history-substring-search
zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Needed to get dead keys to work in VSCodeNeoVim
dbus-send --bus="`ibus address`" --print-reply --dest=org.freedesktop.IBus /org/freedesktop/IBus org.freedesktop.DBus.Properties.Set string:org.freedesktop.IBus string:EmbedPreeditText variant:boolean:false > /dev/null

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

eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init -)"

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="$HOME/apps-and-plugins/tfenv/bin:$PATH"

export NVM_DIR="$HOME/.nvm"

# >>> linuxbrew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
# <<< linuxbrew

# >>> Personal aliases
alias gpod="git pull origin dev"
alias gpgg="git pull && git gone"
alias gsd="git switch dev"

alias 'FUCK'='fuck --yeah'
alias 'upupa'='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y'
alias 'tf'='terraform'
# <<< Personal aliases
