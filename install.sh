#!/bin/bash
set -e

PREFIX="${PREFIX:-$HOME/.local}"
INSTALL_DIR="$PREFIX/share/droid-fan"
BIN_DIR="$PREFIX/bin"

echo "Installing droid-fan..."

# Check deps
command -v git >/dev/null 2>&1 || { echo "git is required"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "python3 is required"; exit 1; }

# Clone or update
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull --ff-only
else
    rm -rf "$INSTALL_DIR"
    git clone https://github.com/infatoshi/droid-fan.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Create venv and install deps
python3 -m venv .venv
.venv/bin/pip install -q --upgrade pip
.venv/bin/pip install -q -r requirements.txt

# Create wrapper script that uses the venv python
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/droid-fan" << WRAPPER
#!/bin/bash
exec $INSTALL_DIR/.venv/bin/python3 $INSTALL_DIR/droid-fan "\$@"
WRAPPER
chmod +x "$BIN_DIR/droid-fan"

echo ""
echo "Installed to $BIN_DIR/droid-fan"
echo ""
echo "Make sure $BIN_DIR is in your PATH."
echo "  export PATH=\"$BIN_DIR:\$PATH\"" >> ~/.zshrc 2>/dev/null || true
echo ""
echo "Run: droid-fan"
