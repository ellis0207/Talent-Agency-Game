extends RefCounted
## Builds the placeholder UI theme in code: warm paper panels, chunky dark
## outlines and rounded corners. See docs/ART_STYLE.md.

const Palette = preload("res://scripts/ui/palette.gd")

const OUTLINE_WIDTH := 4
const CORNER_RADIUS := 14


static func build() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 24

	theme.set_stylebox("panel", "PanelContainer", box(Palette.PAPER))
	theme.set_stylebox("panel", "Panel", box(Palette.PAPER))
	theme.set_color("font_color", "Label", Palette.INK)
	theme.set_color("default_color", "RichTextLabel", Palette.INK)

	theme.set_stylebox("normal", "Button", box(Palette.ACCENT, 6))
	theme.set_stylebox("hover", "Button", box(Palette.ACCENT_HOVER, 6))
	theme.set_stylebox("pressed", "Button", box(Palette.ACCENT_PRESSED, 6, 2))
	theme.set_stylebox("disabled", "Button", box(Palette.PAPER_DARK, 6))
	theme.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_hover_pressed_color"]:
		theme.set_color(state, "Button", Palette.INK)
	theme.set_color("font_disabled_color", "Button", Palette.INK_SOFT)
	return theme


## A rounded, outlined box. `drop` is the height of the cartoon shadow under it;
## `margin_extra` pushes the content down (used to make pressed buttons look pushed in).
static func box(fill: Color, drop: int = 0, margin_extra: int = 0) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = fill
	sb.border_color = Palette.OUTLINE
	sb.set_border_width_all(OUTLINE_WIDTH)
	sb.set_corner_radius_all(CORNER_RADIUS)
	sb.content_margin_left = 18
	sb.content_margin_right = 18
	sb.content_margin_top = 12 + margin_extra
	sb.content_margin_bottom = 12
	if drop > 0:
		sb.shadow_color = Palette.OUTLINE
		sb.shadow_size = 1
		sb.shadow_offset = Vector2(0, drop)
	return sb
