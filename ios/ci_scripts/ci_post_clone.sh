#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Extract version from git tag and set as environment variables for Flutter build
echo "Xcode Cloud Environment variables:"
echo "CI_TAG: $CI_TAG"
echo "CI_GIT_REF: $CI_GIT_REF"

# Use Xcode Cloud environment variables if available, otherwise try git
if [ -n "$CI_TAG" ]; then
    VERSION="$CI_TAG"
    echo "Using CI_TAG: $VERSION"
elif [ -n "$CI_GIT_REF" ]; then
    # CI_GIT_REF might include refs/tags/ prefix, so we need to extract the tag name
    VERSION=$(echo "$CI_GIT_REF" | sed 's|refs/tags/||')
    echo "Using CI_GIT_REF: $VERSION"
else
    echo "Trying git describe..."
    VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    if [ -n "$VERSION" ]; then
        echo "Using git describe: $VERSION"
    fi
fi

if [ -n "$VERSION" ]; then
    # Remove 'v' prefix if present (e.g., v0.1.32-rc.1 -> 0.1.32-rc.1)
    VERSION_NUMBER="${VERSION#v}"
    
    # Set environment variables for Flutter build
    export FLUTTER_BUILD_NAME="$VERSION_NUMBER"
    export FLUTTER_BUILD_NUMBER="$VERSION_NUMBER"
    
    echo "Set FLUTTER_BUILD_NAME=$FLUTTER_BUILD_NAME"
    echo "Set FLUTTER_BUILD_NUMBER=$FLUTTER_BUILD_NUMBER"
    
    # Also set for Fastlane to use
    export VERSION_NUMBER
else
    echo "No version found, using default version from project"
fi

# Download and extract Flutter SDK from the provided URL.
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.32.8-stable.zip"
FLUTTER_DIR="$HOME/flutter"

curl -A "Mozilla/5.0" -o flutter.zip $FLUTTER_URL
unzip -q flutter.zip -d $HOME
rm flutter.zip
export PATH="$PATH:$FLUTTER_DIR/bin"

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

# configure flutter fire
# dart pub global activate flutterfire_cli

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

exit 0


