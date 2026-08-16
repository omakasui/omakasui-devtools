# Shared helpers for theme-asset generation scripts: reading/validating a
# theme's accent + background colors from colors.toml, and compositing a
# logo centered on a solid-color canvas. Sourced, not executed directly.

# Reads and validates accent/background from colors.toml, setting
# THEME_ACCENT and THEME_BACKGROUND (hex, no leading '#') on success.
# On failure, prints a "Skipping <theme_name>: ..." message and returns 1 —
# callers should `continue` their per-theme loop rather than abort the batch.
theme_read_colors() {
  local colors_file="$1"
  local theme_name="$2"
  local accent background accent_hex bg_hex

  THEME_ACCENT=""
  THEME_BACKGROUND=""

  accent=$(grep -m1 '^accent' "$colors_file" | sed 's/.*=\s*"\(#[^"]*\)".*/\1/')
  background=$(grep -m1 '^background' "$colors_file" | sed 's/.*=\s*"\(#[^"]*\)".*/\1/')

  if [[ -z $accent || -z $background ]]; then
    echo "Skipping $theme_name: missing accent or background color"
    return 1
  fi

  accent_hex="${accent#\#}"
  bg_hex="${background#\#}"

  if ! [[ $bg_hex =~ ^[0-9a-fA-F]{6}$ ]]; then
    echo "Skipping $theme_name: invalid background color: $background (expected #RRGGBB)"
    return 1
  fi

  if ! [[ $accent_hex =~ ^[0-9a-fA-F]{6}$ ]]; then
    echo "Skipping $theme_name: invalid accent color: $accent (expected #RRGGBB)"
    return 1
  fi

  THEME_ACCENT="$accent_hex"
  THEME_BACKGROUND="$bg_hex"
}

# Composites logo_path centered onto a bg_hex-colored canvas_w x canvas_h
# canvas, written to output_path. Reads logo_path in place — no staging
# copy needed since convert never modifies its input.
theme_composite_centered() {
  local bg_hex="$1" logo_path="$2" canvas_w="$3" canvas_h="$4" output_path="$5"
  local logo_w logo_h logo_x logo_y

  logo_w=$(identify -format '%w' "$logo_path")
  logo_h=$(identify -format '%h' "$logo_path")
  logo_x=$(( (canvas_w - logo_w) / 2 ))
  logo_y=$(( (canvas_h - logo_h) / 2 ))

  convert -size "${canvas_w}x${canvas_h}" "xc:#$bg_hex" \
    "$logo_path" -geometry "+${logo_x}+${logo_y}" -composite \
    "$output_path"
}
