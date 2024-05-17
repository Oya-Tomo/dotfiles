#!/usr/bin/zsh

rm -rf ~/.config/nvim
rm -rf ~/.config/wezterm
rm -rf ~/.zshrc

cp -r ./nvim ~/.config/
cp -r ./wezterm ~/.config/
cp ./.zshrc ~/

echo "Replaced dotfiles."

chmod +x ~/.config/wezterm/alias/ide.sh

echo "Updated successfully."