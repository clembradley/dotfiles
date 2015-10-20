function __git_prompt {
  local DIRTY="%{$fg[yellow]%}"
  local CLEAN="%{$fg[green]%}"
  local UNMERGED="%{$fg[red]%}"
  local RESET="%{$terminfo[sgr0]%}"
  git rev-parse --git-dir >& /dev/null
  if [[ $? == 0 ]]
  then
    if [[ `git ls-files -u >& /dev/null` == '' ]]
    then
      git diff --quiet >& /dev/null
      if [[ $? == 1 ]]
      then
        echo -n $DIRTY
      else
        git diff --cached --quiet >& /dev/null
        if [[ $? == 1 ]]
        then
          echo -n $DIRTY
        else
          echo -n $CLEAN
        fi
      fi
    else
      echo -n $UNMERGED
    fi
    ref=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ -n $ref ]]; then
      echo -n " ${ref#refs/heads/}"
    fi
    echo -n $RESET
  fi
}

setopt promptsubst
export PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%c%{$reset_color%}$(__git_prompt) %# '

# load our own completion functions
fpath=(~/.zsh/completion $fpath)

# completion
autoload -U compinit
compinit

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/bin:$PATH"

function pkg {
  PKGNAME=$(pkgver $1)
  ln -s $1 $PKGNAME
  tar -czhvf $PKGNAME.tar.gz $PKGNAME
  echo "Done. Now run:\npkgup $PKGNAME.tar.gz"
}

# need to be on the office network or VPN for this to work
# # in case of usage of the http proxy thru a ssh tunnel run (change the port if needed)
# #  export http_proxy="http://localhost:3132"
function pkgup {
  curl --upload-file $1 http://config.snc1/package/
}

function pkgver {
  echo "$1-$(date +%Y.%m.%d_%H.%M)"
}

function gendate {
  date +%Y.%m.%d_%H.%M
}

# load rbenv if available
if which rbenv &>/dev/null ; then
  eval "$(rbenv init - --no-rehash)"
fi

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

# add Go variables
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# set editor when calling `bundle open [GEM]`
export BUNDLER_EDITOR=mvim

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
ulimit -n 4096

function perf {
  curl -o /dev/null  -s -w "%{http_code}; %{time_connect} + %{time_starttransfer} = %{time_total}\n" "$1" -k
}

# install script
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
# source: https://github.com/creationix/nvm#install-script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
