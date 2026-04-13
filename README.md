# droid-fan

Spin any image as rotating ASCII art in your terminal.
Uses the same character set (`* # ▐`) as the Factory Droid startup animation.

![demo](https://raw.githubusercontent.com/infatoshi/droid-fan/main/demo.gif)

## Install

```bash
git clone https://github.com/infatoshi/droid-fan.git
cd droid-fan

# Create venv and install deps
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt

# Make executable
chmod +x droid-fan

# Symlink into your PATH
ln -s "$(pwd)/droid-fan" ~/.local/bin/droid-fan
```

Requires Python 3.10+ with Pillow.

## Usage

```
droid-fan                           # Droid logo, full terminal, 30 RPM
droid-fan logo.png                  # Spin a custom image
droid-fan logo.png 60               # Fast spin (60 RPM)
droid-fan logo.png 15 -s 0.5        # Half-size, slow
droid-fan --invert dark-on-light.png  # Invert brightness
```

Press any key to exit.

### Options

| Flag | Default | Description |
|------|---------|-------------|
| `image` | Droid logo | Path to image file |
| `rpm` | 30 | Rotation speed in revolutions per minute |
| `-s, --scale` | 1.0 | Fraction of terminal to fill (0.01-1.0) |
| `--invert` | auto | Invert brightness mapping |

## How it works

1. Loads the image, handles transparency, normalizes contrast
2. Pre-renders 36 rotated frames as ASCII art using Droid's character ramp
3. Plays frames in a loop at the requested RPM, centered in your terminal

Works with PNG, JPG, GIF, BMP, WebP, TIFF. Palette and RGBA images with
transparency are handled automatically.
