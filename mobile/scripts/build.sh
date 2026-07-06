#!/usr/bin/env bash
# build.sh - Build and test script for the Flutter mobile client.
set -e

# Change directory to the root of the mobile folder (which is the parent of scripts/)
cd "$(dirname "$0")/.."

echo "📦 Fetching dependencies..."
flutter pub get

echo "🔍 Running code analysis (linter)..."
flutter analyze

echo "🧪 Running unit and integration tests..."
flutter test lib/

# Check if CONFIG_FILE or BASE_URL are defined, and build appropriately.
if [ -n "$CONFIG_FILE" ]; then
  echo "🚀 Building Android Release APK using config file: $CONFIG_FILE"
  flutter build apk --release --dart-define-from-file="$CONFIG_FILE"
elif [ -n "$BASE_URL" ]; then
  echo "🚀 Building Android Release APK using base URL: $BASE_URL"
  flutter build apk --release --dart-define=BASE_URL="$BASE_URL"
else
  echo "🚀 Building Android Release APK with default environment settings..."
  if [ -f "config/dev.json" ]; then
    flutter build apk --release --dart-define-from-file="config/dev.json"
  else
    flutter build apk --release
  fi
fi

echo "✅ Build completed successfully!"
