#!/usr/bin/zsh

rm -rf ~/.config/nvim
rm -rf ~/.config/wezterm
rm -rf ~/.zshrc

cp -r ./nvim ~/.config/
cp -r ./wezterm ~/.config/
cp ./.zshrc ~/