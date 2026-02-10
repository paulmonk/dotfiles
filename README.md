# Dotfiles

User preference and configuration files that I use. Beware :wink:

This repository includes [git](http://git-scm.com/) submodules.
The submodules need to be initialised:

```sh
git submodule update --init --recursive --remote --rebase
```

To install [homebrew](https://brew.sh) you will need the Xcode
command-line tools installed and the licence accepted.

```sh
xcode-select --install
sudo xcodebuild -license accept
```

Then from macOS Mojave onwards we need to install headers into the
correct place.

```sh
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
```
