# droid-fan

Spin any image as rotating ASCII art in your terminal.
Uses the same character set (`* # ▐`) as the Factory Droid startup animation.

![demo](https://raw.githubusercontent.com/infatoshi/droid-fan/main/demo.gif)

## Install

One line:

```bash
curl -fsSL https://raw.githubusercontent.com/infatoshi/droid-fan/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/infatoshi/droid-fan.git ~/.local/share/droid-fan
cd ~/.local/share/droid-fan
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
ln -s "$(pwd)/droid-fan" ~/.local/bin/droid-fan
```

Requires: git, python3 (3.10+). The install script creates an isolated venv at `~/.local/share/droid-fan/.venv` so it won't touch your system Python.

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
