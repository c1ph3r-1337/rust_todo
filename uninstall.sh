#!/usr/bin/env bash

APP_NAME="todolist"

echo "Removing binary..."
sudo rm -f /usr/local/bin/$APP_NAME

echo "Removing desktop entry..."
rm -f ~/.local/share/applications/$APP_NAME.desktop

echo "Removing icon..."
rm -f ~/.local/share/icons/hicolor/256x256/apps/$APP_NAME.png

echo "Uninstall complete."
