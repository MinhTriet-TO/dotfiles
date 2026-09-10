# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew. Its installer only writes this to .zprofile, which a .zshrc linked
# from the dotfiles repo can't count on — without it, mise/lsd/nvim aren't on
# PATH on a fresh machine. Guarded, so it's a no-op where brew isn't installed.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Standalone-installed tools land here: uv, uvx, poetry, claude.
# Losing this line silently removes all of them from PATH.
export PATH="$HOME/.local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
 zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%d/%m/%Y %H:%m"
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias myip="curl http://ipecho.net/plain; echo"
alias python=python3

alias hf='history -f | awk '\''{printf "\n\033[1;34m%s) \033[1;32m%s \033[38;5;214m%s\n\033[0m", $1, $2, $3; for (i=4; i<=NF; i++) printf "%s ", $i; print ""}'\'''

alias vim=nvim
# remap Ctrl+w which was delete one word backward (we use alt+backspace)
alias ls="lsd --group-dirs first --oneline"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PSQL_EDITOR=nvim

# nvm removed — mise manages node (and everything else) now.

# Function to interactively choose AWS account and export env var
aws_configure() {
    export AWS_PROFILE=$(aws configure list-profiles | grep -v default | sort | fzf)
    export ENVIRONMENT=$(echo $AWS_PROFILE | cut -d'-' -f3)
    export AWS_ACCOUNT="$(echo $AWS_PROFILE | cut -d'-' -f1)-$(echo $AWS_PROFILE | cut -d'-' -f2)"
    export TF_VAR_environment=$(echo $AWS_PROFILE | cut -d'-' -f3)
    export TF_VAR_aws_account="$(echo $AWS_PROFILE | cut -d'-' -f1)-$(echo $AWS_PROFILE | cut -d'-' -f2)"
    export TF_VAR_environment=$(echo $AWS_PROFILE | cut -d'-' -f3)
    export TF_VAR_aws_account="$(echo $AWS_PROFILE | cut -d'-' -f1)-$(echo $AWS_PROFILE | cut -d'-' -f2)"
    echo "export AWS_PROFILE=$AWS_PROFILE" > ~/.aws/aws_profile
    echo "export ENVIRONMENT=$(echo $AWS_PROFILE | cut -d'-' -f3)" >> ~/.aws/aws_profile
    echo "export AWS_ACCOUNT=$(echo $AWS_PROFILE | cut -d'-' -f1)-$(echo $AWS_PROFILE | cut -d'-' -f2)" >> ~/.aws/aws_profile
}
# Read the file to export AWS env var. Guarded because aws_configure is what
# creates it — on a fresh machine it doesn't exist yet, and an unguarded source
# makes every new shell open with an error.
[ -f ~/.aws/aws_profile ] && source ~/.aws/aws_profile


# machine-local secrets (registry tokens, credentials) — never committed
# copy .zsh_secrets.example to ~/.zsh_secrets and fill it in
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets

export SKIP_ASDF_INSTALL=1
# SLACK_USERID moved to ~/.zsh_secrets — it identifies an account, and it
# differs between a work and a personal machine.


export MANPAGER='nvim +Man!'

eval "$(mise activate zsh)"