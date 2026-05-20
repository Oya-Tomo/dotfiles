#!/bin/zsh

wezterm cli split-pane --bottom --percent 30 && clear
wezterm cli split-pane --right --percent 66 && clear
wezterm cli split-pane --right --percent 50 && clear

wezterm cli activate-pane-direction Up && clear
