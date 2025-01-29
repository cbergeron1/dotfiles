#!/usr/bin/env bash

BREW_FORMULA=(
	git
	gh
	tfenv
	coreutils
	moreutils
	wget
	awscli
	automake
	cmake
	jq
	docker
	pidof
	watch
	httpie
	xz
	ripgrep
	mitmproxy
	gnu-sed
	kafka
	tmux
	jesseduffield/lazygit/lazygit
	gdu
	bottom
	neovim
	curl
	m-cli	
)

FAILED_FORMULA=()

# Check if homebrew is installed already
if command -v brew &>/dev/null; then
	echo "Homebrew is installed already, time to update."
else
	echo "Installing Homebrew!"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

for formula in "${BREW_FORMULA[@]}"; do
	if brew list "$formula" &>/dev/null; then
		echo "$formula is already installed."
	else
		echo "$formula is not installed. Installing now..."
		brew install "$formula"
		
		# Check install was successful
		if brew list "$formula" &>/dev/null; then
			echo "$formula installed successfully."
		else
			echo "Failed to install $formula."
			FAILED_FORMULA+=("$formula")
		fi
	fi
done

PATH=$PATH:$(brew --prefix coreutils)/libexec/gnubin
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Remove outdated versions from the cellar.
brew cleanup

if [ ${#FAILED_FORMULA[@]} -eq 0 ]; then
	echo "All specified formula are now installed."
else
	echo "The following formula failed to install:"
	for failed_formula in "${FAILED_FORMULA[@]}"; do
		echo "- $failed_formula"
	done
fi
