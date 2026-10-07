# Mac development setup

Personal Zsh, Ghostty, Starship, zoxide, fzf, and Raycast configuration.

With Homebrew installed, run:

```sh
./install.zsh --packages
```

The installer backs up existing terminal files before linking these configs.
It also sorts Git branches by most recent commit first.

Optional flags:

- `--apple`: install Xcode through the App Store.
- `--macos`: apply the selected macOS development and input preferences.

Run without flags to configure the terminal and Git without installing packages.
See [SETUP.txt](SETUP.txt) for Raycast migration and authentication steps.
