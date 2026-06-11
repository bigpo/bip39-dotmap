#!/usr/bin/env bash
set -euo pipefail

APP_NAME="BIP39 Dotmap"
BUILD_DIR="dist"
APP_DIR="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

cp macos/Info.plist "$CONTENTS_DIR/Info.plist"
cp index.html styles.css app.js wordlist.js "$RESOURCES_DIR/"

xcrun swiftc \
  macos/AppDelegate.swift \
  -o "$MACOS_DIR/$APP_NAME" \
  -framework Cocoa \
  -framework WebKit \
  -parse-as-library

chmod +x "$MACOS_DIR/$APP_NAME"

echo "Built $APP_DIR"
