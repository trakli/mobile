#!/bin/bash

# Set up PATH to include global pub cache
export PATH="${PATH}:$FLUTTER_ROOT/bin:${PUB_CACHE}/bin:$HOME/.pub-cache/bin"

# Determine the Crashlytics upload script path
if [ -z "$PODS_ROOT" ] || [ ! -d "$PODS_ROOT/FirebaseCrashlytics" ]; then
  # Cannot use "BUILD_DIR%/Build/*" as per Firebase documentation, it points to "flutter-project/build/ios/*" path which doesn't have run script
  DERIVED_DATA_PATH=$(echo "$BUILD_ROOT" | sed -E 's|(.*DerivedData/[^/]+).*|\1|')
  PATH_TO_CRASHLYTICS_UPLOAD_SCRIPT="${DERIVED_DATA_PATH}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
else
  PATH_TO_CRASHLYTICS_UPLOAD_SCRIPT="$PODS_ROOT/FirebaseCrashlytics/run"
fi

# Try to upload symbols using FlutterFire first
if command -v flutterfire &> /dev/null; then
  echo "Using FlutterFire CLI to upload Crashlytics symbols..."
  flutterfire upload-crashlytics-symbols \
    --upload-symbols-script-path="$PATH_TO_CRASHLYTICS_UPLOAD_SCRIPT" \
    --platform=ios \
    --apple-project-path="${SRCROOT}" \
    --env-platform-name="${PLATFORM_NAME}" \
    --env-configuration="${CONFIGURATION}" \
    --env-project-dir="${PROJECT_DIR}" \
    --env-built-products-dir="${BUILT_PRODUCTS_DIR}" \
    --env-dwarf-dsym-folder-path="${DWARF_DSYM_FOLDER_PATH}" \
    --env-dwarf-dsym-file-name="${DWARF_DSYM_FILE_NAME}" \
    --env-infoplist-path="${INFOPLIST_PATH}" \
    --default-config=default
elif command -v firebase &> /dev/null; then
  echo "Using Firebase CLI to upload Crashlytics symbols..."
  firebase crashlytics:symbols:upload --app="$GOOGLE_APP_ID" "$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME"
else
  echo "Warning: Neither flutterfire nor firebase CLI found. Skipping Crashlytics symbol upload."
  exit 0
fi
