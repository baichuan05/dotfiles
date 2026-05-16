# Quick Setup on New PC

Run the automated setup script to install and configure your dev environment.

**For Ubuntu / Debian:**
```bash
curl -fsSL https://raw.githubusercontent.com/baichuan05/dotfiles/master/setup-ubuntu.sh | bash
```

**For Amazon Linux 2023:**
```bash
curl -fsSL https://raw.githubusercontent.com/baichuan05/dotfiles/master/setup-amazon-linux.sh | bash
```

This script will:
1. Install core apt packages: zsh, curl, zoxide, bat, flameshot, yazi
2. Install external tools: VSCode, uv, Ghostty
3. Apply app configurations (e.g. Ghostty theme)
4. Clone your dotfiles and set up Prezto
5. Update `.zshrc` with helper functions (zoxide, bat alias, `y()` for yazi)
6. Set zsh as your default shell

After setup, restart your terminal or run `exec zsh` to reload the shell.



# Linux
1. flameshot: https://flameshot.org/
2. CopyQ -->
