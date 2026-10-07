#!/bin/zsh
set -eu
repo=${0:A:h}
packages=0 apple=0 macos=0
for arg in "$@"; do
  case "$arg" in
    --packages) packages=1 ;;
    --apple) apple=1 ;;
    --macos) macos=1 ;;
    *) print -u2 'Usage: ./install.zsh [--packages] [--apple] [--macos]'; exit 2 ;;
  esac
done
if (( packages || apple )); then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv zsh)"
  else
    print -u2 'Install Homebrew first: https://brew.sh'; exit 1
  fi
fi
if (( packages )); then
  brew bundle --file="$repo/Brewfile"
  eval "$(fnm env --shell zsh)"
  fnm install --lts
  fnm use lts-latest
  fnm default lts-latest
  npm install -g pnpm
  uv python install
  export PATH="$(brew --prefix rustup)/bin:$PATH"
  rustup default stable
fi
if (( apple )); then
  brew bundle --file="$repo/Brewfile.apple"
fi
backup="$HOME/.local/state/dotfiles/backups/$(date +%Y%m%d-%H%M%S)-$$"
link_file() {
  local src="$repo/$1" dst="$HOME/$2"
  [[ -L "$dst" && "${dst:A}" == "$src" ]] && return 0
  mkdir -p "${dst:h}"
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$backup/${2:h}"
    mv "$dst" "$backup/$2"
  fi
  ln -s "$src" "$dst"
}
link_file shell/zshrc .zshrc
link_file shell/zprofile .zprofile
link_file config/starship.toml .config/starship.toml
link_file config/starship-light.toml .config/starship-light.toml
link_file ghostty/config.ghostty 'Library/Application Support/com.mitchellh.ghostty/config.ghostty'
# Show the most recently changed Git branches first.
git config --global branch.sort -committerdate
if (( macos )); then
  zsh "$repo/macos/development.zsh"
  zsh "$repo/macos/input.zsh"
fi
print 'Terminal files linked. Open a new terminal tab.'
[[ -d "$backup" ]] && print "Previous files saved: $backup"
