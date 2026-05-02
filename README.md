# Quick Setup on New Ubuntu PC

Run the automated setup script to install and configure your dev environment:

```bash
curl -fsSL https://raw.githubusercontent.com/baichuan05/dotfiles/master/setup-ubuntu.sh | bash
```

This script will:
1. Install core apt packages: zsh, curl, zoxide, bat, flameshot, yazi
2. Install external tools: VSCode, uv, Ghostty
3. Apply app configurations (e.g. Ghostty theme)
4. Clone your dotfiles and set up Prezto
5. Update `.zshrc` with helper functions (zoxide, bat alias, `y()` for yazi)
6. Set zsh as your default shell

After setup, restart your terminal or run `exec zsh` to reload the shell.

---

# Old
<!-- # Terminal Theme
* Snazzy
  * mac: https://github.com/sindresorhus/iterm2-snazzy
  * windows: https://github.com/atomcorp/themes
  * linux: https://github.com/EliverLara/terminator-themes.git

# Command line tools
* Prezto: https://github.com/sorin-ionescu/prezto

* fzf (Ubuntu)
  * Install `sudo apt install fzf -y`
  * Add the following to `.zshrc`
    ```
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
    ```
* fzf (Mac)
  ```
  brew install fzf

  # To install useful key bindings and fuzzy completion:
  $(brew --prefix)/opt/fzf/install
  ```

# Linux
1. flameshot: https://flameshot.org/
2. CopyQ -->
