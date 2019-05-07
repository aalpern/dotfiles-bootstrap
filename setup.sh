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

echo "==> Installing Homebrew utilities..."
brew install wget tree

echo "==> Installing Homebrew dev tools..."
brew install git go node source-highlight jq jo protobuf python@3

echo "==> Installing Homebrew virtualization tools..."
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
else
    echo "==> Skipping global python env"
fi

source $HOME/dev/python/bin/activate

pip install --upgrade pip
pip install --upgrade b2       # Backblaze B2 CLI
pip install --upgrade awscli   # Amazon Web Services CLI

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

#
# OSX Apps
#

echo "==> Downloading OS X Apps..."
mkdir -p $HOME/tmp
cd $HOME/tmp
wget https://github.com/MacDownApp/macdown/releases/download/v0.7.1/MacDown.app.zip
wget https://emacsformacosx.com/emacs-builds/Emacs-26.2-universal.dmg
wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
wget https://iterm2.com/downloads/stable/latest -O iterm.zip
wget https://freemacsoft.net/downloads/AppCleaner_3.5.zip
wget https://central.github.com/deployments/desktop/desktop/latest/darwin -O GithubDesktop.zip
unzip *.zip

open $HOME/tmp
