#!/usr/bin/env bash

set -e

APP_NAME="todolist"
BINARY_NAME="rust_todo"
INSTALL_PATH="/usr/local/bin"
DESKTOP_PATH="$HOME/.local/share/applications"
ICON_PATH="$HOME/.local/share/icons/hicolor/256x256/apps"

echo "========================================"
echo "Modern TODO Installer"
echo "========================================"

# ----------------------------------------
# 1️⃣ Check Rust Installation
# ----------------------------------------

if ! command -v cargo >/dev/null 2>&1; then
    echo "Rust not found. Installing Rust using rustup..."

    if ! command -v curl >/dev/null 2>&1; then
        echo "Error: curl is required to install Rust."
        echo "Please install curl using your package manager."
        exit 1
    fi

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Load cargo into current shell
    source "$HOME/.cargo/env"

    echo "Rust installed successfully."
else
    echo "Rust already installed."
fi

# ----------------------------------------
# 2️⃣ Update Toolchain
# ----------------------------------------

rustup update stable || true

# ----------------------------------------
# 3️⃣ Build Release Binary
# ----------------------------------------

echo "Building release binary..."
cargo build --release

# ----------------------------------------
# 4️⃣ Install Binary
# ----------------------------------------

echo "Installing binary to $INSTALL_PATH..."
sudo cp target/release/$BINARY_NAME $INSTALL_PATH/$APP_NAME
sudo chmod +x $INSTALL_PATH/$APP_NAME

# ----------------------------------------
# 5️⃣ Create Desktop Entry
# ----------------------------------------

echo "Creating desktop entry..."
mkdir -p "$DESKTOP_PATH"

cat > "$DESKTOP_PATH/$APP_NAME.desktop" <<EOF
[Desktop Entry]
Name=Modern TODO
Comment=Simple Minimal Task Manager
Exec=$INSTALL_PATH/$APP_NAME
Icon=$APP_NAME
Terminal=false
Type=Application
Categories=Utility;Productivity;
StartupWMClass=com.todo.gtk
EOF

# ----------------------------------------
# 6️⃣ Install Icon
# ----------------------------------------

echo "Installing icon (if exists)..."

if [ -f "assets/todolist.png" ]; then
    mkdir -p "$ICON_PATH"
    cp assets/todolist.png "$ICON_PATH/$APP_NAME.png"
    gtk-update-icon-cache "$HOME/.local/share/icons/hicolor" || true
fi

# ----------------------------------------
# 7️⃣ Update Desktop Database
# ----------------------------------------

update-desktop-database "$DESKTOP_PATH" || true

echo "========================================"
echo "Installation complete."
echo "Run the app with: $APP_NAME"
echo "Or launch it from Rofi / application launcher."
echo "========================================"
