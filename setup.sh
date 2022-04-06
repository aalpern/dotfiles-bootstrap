#!/bin/sh

export EDITOR=emacs

#
# Shell and SSH
#

echo "==> Changing shell to ZSH..."
chsh -s /bin/zsh

#
# Core software install
#

if [ -z `which brew` ]; then
    echo "==> Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "==> Skipping brew"
fi

echo "==> Installing MacOS apps.."
brew install --cask emacs
brew install --cask iterm2
brew install --cask github
brew install --cask appcleaner

echo "==> Installing MacOS fonts..."
brew tap homebrew/cask-fonts
brew install font-hack
brew install font-anonymous-pro
brew install font-inconsolata

echo "==> Installing utilities..."
brew install wget tree rclone xz

echo "==> Installing dev tools..."
brew install git go node source-highlight jq jo protobuf python@3 gdub

echo "==> Installing virtualization tools..."
brew cask install virtualbox
brew install docker docker-machine docker-compose

echo "==> Creating default docker machine..."
docker-machine create \
               --driver virtualbox \
               --virtualbox-memory "2048" \
               --virtualbox-disk-size "40000"  \
               default

if [ ! -d "$HOME/dev/python/bin" ]; then
    echo "==> Bootstrapping python env..."
    mkdir -p $HOME/dev
    python3 -m venv $HOME/dev/python
    source $HOME/dev/python/bin/activate
    pip install --upgrade pip
    pip install --upgrade b2
    pip install --upgrade awscli
else
    echo "==> Skipping global python env"
fi

if [ -z `which homesick` ]; then
    echo "==> Installing homesick..."
    sudo gem install homesick
fi

#
# Configuration
#

echo "==> Configuring git..."
git config --global user.name "Adam Alpern"
git config --global user.email "adam.alpern@gmail.com"
git config --global credential.helper osxkeychain
git config --global color.ui "auto"
git config --global push.default simple
git config --global url."git@github.com:".insteadOf "https://github.com/"

if ! [ -d "$HOME/.homesick/repos/dotfiles" ]; then
    echo "==> Cloning dotfiles..."
    homesick clone git@github.com:aalpern/dotfiles.git dotfiles
    homesick link dotfiles
else
    echo "==> Dotfiles already set up"
fi
