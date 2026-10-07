#!/bin/zsh
# Developer input preferences. Reopen apps or log out/in after applying.
set -eu
backup_dir="$HOME/.config/terminal-setup/backups/macos-input-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
keys=(ApplePressAndHoldEnabled KeyRepeat InitialKeyRepeat com.apple.mouse.scaling com.apple.swipescrolldirection)
for key in "${keys[@]}"; do
  if defaults read -g "$key" > "$backup_dir/$key.txt" 2>/dev/null; then
    print -r -- "$key: $(cat "$backup_dir/$key.txt")"
  else
    print -r -- 'unset' > "$backup_dir/$key.txt"
    print -r -- "$key: system default"
  fi
done
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g com.apple.mouse.scaling -float 2.5
defaults write -g com.apple.swipescrolldirection -bool false
# Apply to connected devices immediately as well as saving login preferences.
hidutil property --matching keyboard --set '{"HIDKeyRepeat":33333333,"HIDInitialKeyRepeat":250000000}'
hidutil property --matching mouse --set '{"HIDPointerAcceleration":163840}'
print -r -- "Previous values saved in $backup_dir"
print -r -- 'Enabled held-key repeat, fast repeat, short repeat delay, faster mouse tracking, and traditional scrolling.'
