#!/usr/bin/zsh

rm -rf ~/.config/nvim
rm -rf ~/.config/wezterm
rm -rf ~/.config/lazygit
rm -rf ~/.zshrc

cp -r ./nvim ~/.config/
cp -r ./wezterm ~/.config/
cp -r ./lazygit ~/.config/
cp ./.zshrc ~/
cp ./starship.toml ~/.config/

echo "Replaced dotfiles."

chmod +x ~/.config/wezterm/alias/ide.sh

echo "Updated successfully."
