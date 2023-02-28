#!/bin/zsh

wezterm cli split-pane --top --percent 70 && clear
wezterm cli split-pane --left --percent 30 && clear
wezterm cli split-pane --left --percent 50 && clear

wezterm cli activate-pane-direction Up && clear
wezterm cli split-pane --right --percent 50 && clear
