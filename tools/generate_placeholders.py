"""
Generate placeholder PNG images for the project.

Run from project root:
  python tools/generate_placeholders.py

This creates:
  assets/images/logo.png
  assets/images/{SandwichType.name}_footlong.png
  assets/images/{SandwichType.name}_six_inch.png

Requires Pillow:
  pip install pillow
"""
import os
import sys

try:
    from PIL import Image, ImageDraw, ImageFont
except Exception as e:
    print("ERROR: Pillow (PIL) is not available. Install it with: pip install pillow")
    print("Import error:", e)
    sys.exit(1)

# Project paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, '..'))
OUT_DIR = os.path.join(PROJECT_ROOT, 'assets', 'images')
os.makedirs(OUT_DIR, exist_ok=True)

# SandwichType names must match your Dart enum names
SANDWICH_TYPES = [
    "veggieDelight",
    "chickenTeriyaki",
    "tunaMelt",
    "meatballMarinara",
]

SIZES = {
    "footlong": (70, 160, 70),    # green-ish
    "six_inch": (160, 70, 70),    # reddish
}

def save_colored(path, color, text):
    size = (400, 200)  # wide rectangle for sandwiches
    img = Image.new('RGBA', size, color)
    draw = ImageDraw.Draw(img)
    try:
        # Use a default font; system fallback if not available
        font = ImageFont.load_default()
        # center text
        try:
            bbox = draw.textbbox((0, 0), text, font=font)
            w = bbox[2] - bbox[0]
            h = bbox[3] - bbox[1]
        except AttributeError:
            w, h = draw.textsize(text, font=font)
        draw.text(((size[0]-w)/2, (size[1]-h)/2), text, fill='white', font=font)
    except Exception:
        pass
    img.save(path, format='PNG')
    print('Wrote', path)

def save_logo(path):
    size = (300, 300)
    img = Image.new('RGBA', size, (30, 120, 200, 255))
    draw = ImageDraw.Draw(img)
    try:
        font = ImageFont.load_default()
        text = "LOGO"
        try:
            bbox = draw.textbbox((0, 0), text, font=font)
            w = bbox[2] - bbox[0]
            h = bbox[3] - bbox[1]
        except AttributeError:
            w, h = draw.textsize(text, font=font)
        draw.text(((size[0]-w)/2, (size[1]-h)/2), text, fill='white', font=font)
    except Exception:
        pass
    img.save(path, format='PNG')
    print('Wrote', path)

def main():
    print("Project root:", PROJECT_ROOT)
    print("Output directory:", OUT_DIR)
    # logo
    save_logo(os.path.join(OUT_DIR, 'logo.png'))

    # sandwich images
    for t in SANDWICH_TYPES:
        for size_name, color in SIZES.items():
            filename = f"{t}_{size_name}.png"
            path = os.path.join(OUT_DIR, filename)
            label = f"{t} {size_name.replace('_', ' ')}"
            save_colored(path, color + (255,), label)

    print('Placeholders generated. Run: flutter pub get')

if __name__ == '__main__':
    main()
