#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! "$(command -v omz)"; then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! "$(command -v brew)"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew bundle

# Install PHP extensions with PECL
pecl install imagick

# Create the Herd directory for PHP/Laravel projects
mkdir -p "$HOME/Herd"

# Symlink dotfiles into $HOME (idempotent — safe to re-run)
for file in .zshrc .gitconfig .gitignore_global aliases.zsh path.zsh; do
  ln -sf "$HOME/.dotfiles/$file" "$HOME/$file"
done

# Symlink app configs that live outside $HOME
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -sf "$HOME/.dotfiles/ghostty.config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

mkdir -p "$HOME/Library/Application Support/Code/User"
ln -sf "$HOME/.dotfiles/vscode-settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

mkdir -p "$HOME/.ssh"
ln -sf "$HOME/.dotfiles/ssh.config" "$HOME/.ssh/config"

# Set macOS preferences (will reload the shell at the end)
source .macos

# Set custom keyboard shortcuts
source .keyboard

cat <<'EOF'

Bootstrap complete. Next steps:
  1. Launch Herd.app and run its install process
  2. Install latest Node LTS:    fnm install --lts && fnm default lts-latest
  3. Sign into 1Password, Raycast, GitHub, Slack
  4. Restore app preferences manually (no more Mackup)

EOF
