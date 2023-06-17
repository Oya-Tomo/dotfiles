#!/usr/bin/zsh

rm -rf ./nvim
rm -rf ./wezterm

mkdir ./nvim
mkdir ./wezterm

cp ~/.zshrc ./
cp -r ~/.config/nvim/* ./nvim/
cp -r ~/.config/wezterm/* ./wezterm/
