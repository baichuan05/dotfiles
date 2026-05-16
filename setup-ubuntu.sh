#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Ubuntu Development Environment Setup ===${NC}"

# Update package manager
echo -e "${YELLOW}Updating package manager and installing core tools...${NC}"
sudo apt update

# 1. Install core system packages
sudo apt install -y zsh curl zoxide bat flameshot fzf

# 2. Install External Tools
echo -e "${YELLOW}Installing VSCode...${NC}"
if ! command -v code &> /dev/null; then
  cd /tmp
  wget https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -O code_stable_x64.deb
  sudo apt install -y ./code_stable_x64.deb
  rm ./code_stable_x64.deb
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

echo -e "${YELLOW}Installing yazi...${NC}"
if ! command -v yazi &> /dev/null; then
  sudo snap install yazi --classic
  echo -e "${GREEN}yazi installed${NC}"
else
  echo -e "${GREEN}yazi already installed${NC}"
fi

echo -e "${YELLOW}Installing Ghostty...${NC}"
if ! command -v ghostty &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
  echo -e "${GREEN}Ghostty installed${NC}"
else
  echo -e "${GREEN}Ghostty already installed${NC}"
fi

# 3. Configure App Settings (Ghostty)
echo -e "${YELLOW}Configuring Ghostty...${NC}"
mkdir -p "${HOME}/.config/ghostty"
cat > "${HOME}/.config/ghostty/config" << 'EOF'
theme = Snazzy Soft
scrollback-limit = 100000
command = zsh
EOF
echo -e "${GREEN}Ghostty configured${NC}"

# 4. Clone Dotfiles & Setup Prezto
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

# 5. Configure .zshrc helpers
echo -e "${YELLOW}Updating .zshrc with helpers...${NC}"
if ! grep -q "zoxide init zsh" "${ZDOTDIR:-$HOME}/.zshrc"; then
  echo "" >> "${ZDOTDIR:-$HOME}/.zshrc"
  echo "eval \"\$(zoxide init zsh)\"" >> "${ZDOTDIR:-$HOME}/.zshrc"
fi

if ! grep -q "alias bat='batcat'" "${ZDOTDIR:-$HOME}/.zshrc"; then
  echo "alias bat='batcat'" >> "${ZDOTDIR:-$HOME}/.zshrc"
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

if ! grep -q "fzf/examples/key-bindings.zsh" "${ZDOTDIR:-$HOME}/.zshrc"; then
  echo -e "${YELLOW}Adding fzf bindings to .zshrc...${NC}"
  cat >> "${ZDOTDIR:-$HOME}/.zshrc" << 'EOF'

# fzf bindings
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
    source /usr/share/doc/fzf/examples/completion.zsh
fi
EOF
fi

echo -e "${GREEN}=== Setup Complete ===${NC}"
echo -e "${YELLOW}Please restart your terminal or run: exec zsh${NC}"
