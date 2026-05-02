#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Amazon Linux 2023 Development Environment Setup ===${NC}"

# Update package manager
echo -e "${YELLOW}Updating package manager and installing core tools...${NC}"
sudo dnf update -y

# 1. Install core system packages
# Note: AL2023 might not have all desktop packages (like flameshot) in default repos
sudo dnf install -y zsh tar gzip git util-linux

# Install zoxide (via official script, as it might not be in AL2023 dnf repos)
echo -e "${YELLOW}Installing zoxide...${NC}"
curl -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install bat (via official binary if dnf fails, but we'll try dnf first or just download standard)
echo -e "${YELLOW}Attempting to install bat...${NC}"
sudo dnf install -y bat || echo -e "${RED}bat not found in default dnf repos.${NC}"

# Install yazi (via official script/binary, as AL2023 dnf repos might lack it)
# We will use the cargo/binary approach or just warn.
echo -e "${YELLOW}Attempting to install yazi...${NC}"
if ! command -v yazi &> /dev/null; then
  echo -e "${RED}yazi might need manual installation via cargo on AL2023.${NC}"
fi

# 2. Install External Tools
echo -e "${YELLOW}Installing VSCode Server/Desktop...${NC}"
if ! command -v code &> /dev/null; then
  cd /tmp
  wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64" -O code_stable_x64.rpm
  sudo dnf install -y ./code_stable_x64.rpm
  rm ./code_stable_x64.rpm
  echo -e "${GREEN}VSCode installed${NC}"
else
  echo -e "${GREEN}VSCode already installed${NC}"
fi

echo -e "${YELLOW}Installing uv...${NC}"
if ! command -v uv &> /dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  echo -e "${GREEN}uv installed${NC}"
else
  echo -e "${GREEN}uv already installed${NC}"
fi

echo -e "${YELLOW}Skipping Ghostty (Ubuntu-specific script)...${NC}"
# Ghostty bash script is marked for Ubuntu, so we skip it here.

# 3. Clone Dotfiles & Setup Prezto
DOTFILES_REPO="https://github.com/baichuan05/dotfiles"
DOTFILES_DIR="${HOME}/dotfiles"

echo -e "${YELLOW}Setting up dotfiles...${NC}"
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  cd "$DOTFILES_DIR" && git pull origin master
fi

echo -e "${YELLOW}Installing Prezto...${NC}"
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  
  echo -e "${YELLOW}Setting up Prezto runcoms...${NC}"
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*; do
    [ "$(basename "$rcfile")" = "README.md" ] && continue
    ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.$(basename "$rcfile")"
  done
else
  echo -e "${GREEN}Prezto already installed${NC}"
fi

echo -e "${YELLOW}Copying custom configuration files...${NC}"
cp "$DOTFILES_DIR/.zpreztorc" "${ZDOTDIR:-$HOME}/.zpreztorc"

# 4. Configure .zshrc helpers
echo -e "${YELLOW}Updating .zshrc with helpers...${NC}"
if ! grep -q "zoxide init zsh" "${ZDOTDIR:-$HOME}/.zshrc"; then
  echo "" >> "${ZDOTDIR:-$HOME}/.zshrc"
  echo "eval \"\$($HOME/.local/bin/zoxide init zsh)\"" >> "${ZDOTDIR:-$HOME}/.zshrc"
fi

if ! grep -q "alias cat='bat'" "${ZDOTDIR:-$HOME}/.zshrc"; then
  echo "alias cat='bat'" >> "${ZDOTDIR:-$HOME}/.zshrc"
fi

if ! grep -q "function y()" "${ZDOTDIR:-$HOME}/.zshrc"; then
  cat >> "${ZDOTDIR:-$HOME}/.zshrc" << 'EOF'

# Yazi function
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
EOF
fi

# 5. Set Default Shell
echo -e "${YELLOW}Setting zsh as default shell...${NC}"
if [ "$SHELL" != "$(which zsh)" ]; then
  sudo chsh -s "$(which zsh)" "$(whoami)"
  echo -e "${GREEN}Default shell changed to zsh${NC}"
else
  echo -e "${GREEN}zsh is already the default shell${NC}"
fi

echo -e "${GREEN}=== Setup Complete ===${NC}"
echo -e "${YELLOW}Please restart your terminal or run: exec zsh${NC}"
