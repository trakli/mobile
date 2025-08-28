#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Download and extract Flutter SDK from the provided URL.
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.32.8-stable.zip"
FLUTTER_DIR="$HOME/flutter"

curl -A "Mozilla/5.0" -o flutter.zip $FLUTTER_URL
unzip -q flutter.zip -d $HOME
rm flutter.zip
export PATH="$PATH:$FLUTTER_DIR/bin"


# Install and configure FlutterFire CLI
dart pub global activate flutterfire_cli

# Set up PATH to include global pub cache where FlutterFire is installed
export PATH="$PATH:$HOME/.pub-cache/bin"

# Install Node.js and Firebase Tools as an alternative (more reliable in CI)
if ! command -v node &> /dev/null; then
  echo "Installing Node.js..."
  brew install node
fi
npm install -g firebase-tools

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# copy environment varaible depending on the branch
# if [ "$CI_BRANCH" = "main" ]; then
#   cp .env.prod .env
# else
#   cp .env.stag .env
# fi

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

exit 0




