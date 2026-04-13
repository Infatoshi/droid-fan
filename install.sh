#!/bin/bash
set -e

PREFIX="${PREFIX:-$HOME/.local}"
INSTALL_DIR="$PREFIX/share/droid-fan"
BIN_DIR="$PREFIX/bin"

echo "Installing droid-fan..."

command -v git >/dev/null 2>&1 || { echo "Error: git is required"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "Error: python3 is required"; exit 1; }

# Clone or update
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR"
    git checkout -- .
    git pull --ff-only
else
    rm -rf "$INSTALL_DIR"
    git clone https://github.com/infatoshi/droid-fan.git "$INSTALL_DIR"
fi

# Create venv and install deps
echo "Installing dependencies..."
python3 -m venv "$INSTALL_DIR/.venv"
"$INSTALL_DIR/.venv/bin/pip" install -q --upgrade pip
"$INSTALL_DIR/.venv/bin/pip" install -q -r "$INSTALL_DIR/requirements.txt"

# Create wrapper script that calls venv python
mkdir -p "$INSTALL_DIR/bin"
cat > "$INSTALL_DIR/bin/droid-fan" << WRAPPER
#!/bin/bash
exec $INSTALL_DIR/.venv/bin/python3 $INSTALL_DIR/droid-fan "\$@"
WRAPPER
chmod +x "$INSTALL_DIR/bin/droid-fan"

# Symlink into PATH
mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/bin/droid-fan" "$BIN_DIR/droid-fan"

# Add to PATH if not already there
if [ -n "$ZSH_VERSION" ]; then
    rc_file="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    rc_file="$HOME/.bashrc"
else
    rc_file=""
fi
if [ -n "$rc_file" ] && ! grep -q "$BIN_DIR" "$rc_file" 2>/dev/null; then
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$rc_file"
fi

echo ""
echo "Installed. Run: droid-fan"
