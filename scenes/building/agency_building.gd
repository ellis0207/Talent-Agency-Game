extends Control
## Placeholder side view of the agency building, drawn entirely in code.
## You rent the ground floor; the floors above are empty for now.
## Phase 4 replaces this with real art and rooms you can build.

const Palette = preload("res://scripts/ui/palette.gd")

const FLOORS := 3
const LINE := 4.0

var week: int = 1
var floor_label: String = "YOUR AGENCY"
var _ring := 0.0  # 1.0 while the phone has just started ringing, fading to 0
var _font: Font


func _ready() -> void:
	_font = get_theme_default_font()
	resized.connect(queue_redraw)


func set_week(value: int) -> void:
	week = value
	queue_redraw()


## Makes the desk phone shake for a moment.
func ring_phone() -> void:
	var tween := create_tween()
	tween.tween_method(_set_ring, 1.0, 0.0, 0.9)


func _set_ring(value: float) -> void:
	_ring = value
	queue_redraw()


func _draw() -> void:
	var w := size.x
	var h := size.y
	if w < 10.0 or h < 10.0:
		return
	var ground_y := h * 0.86
	_draw_sky(w, ground_y)

	# The building
	var building_w := minf(w * 0.62, h * 0.95)
	var floor_h := (ground_y - h * 0.16) / FLOORS
	var left := (w - building_w) * 0.5
	for i in FLOORS:
		var rect := Rect2(left, ground_y - floor_h * (i + 1), building_w, floor_h)
		if i == 0:
			_draw_office(rect)
		else:
			_draw_vacant(rect, i + 1)
	var top := ground_y - floor_h * FLOORS
	_box(Rect2(left - 16, top - 28, building_w + 32, 28), Palette.ROOF)
	_box(Rect2(left, top, building_w, floor_h * FLOORS), Color(0, 0, 0, 0))

	# Street
	_box(Rect2(-LINE, ground_y, w + LINE * 2, 16), Palette.SIDEWALK)
	draw_rect(Rect2(0, ground_y + 16, w, h - ground_y - 16), Palette.STREET)
	for x in range(0, int(w), 120):
		draw_rect(Rect2(x + 20, ground_y + (h - ground_y) * 0.55, 60, 8), Palette.PAPER_DARK)


func _draw_sky(w: float, ground_y: float) -> void:
	draw_rect(Rect2(0, 0, w, ground_y), Palette.SKY)
	draw_rect(Rect2(0, ground_y * 0.6, w, ground_y * 0.4), Palette.SKY_LOW)
	draw_circle(Vector2(w * 0.86, ground_y * 0.16), ground_y * 0.07, Palette.SUN)
	_cloud(Vector2(w * 0.14, ground_y * 0.14), ground_y * 0.045)
	_cloud(Vector2(w * 0.62, ground_y * 0.09), ground_y * 0.035)
	# Distant skyline
	var heights := [0.35, 0.5, 0.28, 0.6, 0.42, 0.3, 0.55, 0.38]
	var block_w := w / heights.size()
	for i in heights.size():
		var bh: float = ground_y * heights[i]
		draw_rect(Rect2(i * block_w, ground_y - bh, block_w * 0.8, bh), Palette.SKYLINE)


func _cloud(center: Vector2, r: float) -> void:
	for offset in [Vector2(-1.2, 0.2), Vector2(0, -0.3), Vector2(1.1, 0.15), Vector2(0.2, 0.4)]:
		draw_circle(center + offset * r, r, Palette.CLOUD)


func _draw_office(r: Rect2) -> void:
	_box(r, Palette.OFFICE_WALL)
	var floor_top := r.end.y - r.size.y * 0.14
	draw_rect(Rect2(r.position.x, floor_top, r.size.x, r.end.y - floor_top), Palette.OFFICE_FLOOR)
	draw_line(Vector2(r.position.x, floor_top), Vector2(r.end.x, floor_top), Palette.OUTLINE, LINE)

	var u := r.size.y / 10.0  # one "unit" so everything scales with the room
	# Window with a view of the street
	var window := Rect2(r.position.x + u * 1.2, r.position.y + u * 1.6, u * 3.4, u * 3.6)
	_box(window, Palette.WINDOW_GLASS)
	draw_line(Vector2(window.get_center().x, window.position.y), Vector2(window.get_center().x, window.end.y), Palette.OUTLINE, LINE)

	# Wall calendar showing the current week
	var cal := Rect2(r.position.x + r.size.x * 0.44, r.position.y + u * 1.4, u * 2.4, u * 2.6)
	_box(cal, Palette.PAPER)
	draw_rect(Rect2(cal.position, Vector2(cal.size.x, u * 0.8)), Palette.MONEY_RED)
	draw_rect(Rect2(cal.position, Vector2(cal.size.x, u * 0.8)), Palette.OUTLINE, false, LINE)
	_text_centered("WEEK", Vector2(cal.get_center().x, cal.position.y + u * 1.45), int(u * 0.5))
	_text_centered(str(week), Vector2(cal.get_center().x, cal.position.y + u * 2.3), int(u * 0.9))

	# Desk, lamp and phone
	var desk := Rect2(r.position.x + r.size.x * 0.36, floor_top - u * 2.6, r.size.x * 0.32, u * 0.7)
	_box(Rect2(desk.position.x + u * 0.3, desk.end.y, u * 0.5, floor_top - desk.end.y), Palette.WOOD)
	_box(Rect2(desk.end.x - u * 0.8, desk.end.y, u * 0.5, floor_top - desk.end.y), Palette.WOOD)
	_box(desk, Palette.WOOD)
	var lamp_base := Vector2(desk.position.x + u * 0.9, desk.position.y)
	draw_line(lamp_base, lamp_base + Vector2(u * 0.5, -u * 1.5), Palette.OUTLINE, LINE)
	var shade := PackedVector2Array([
		lamp_base + Vector2(u * 0.1, -u * 1.4), lamp_base + Vector2(u * 1.1, -u * 1.4),
		lamp_base + Vector2(u * 0.8, -u * 2.1), lamp_base + Vector2(u * 0.4, -u * 2.1)])
	draw_colored_polygon(shade, Palette.SUN)
	draw_polyline(shade + PackedVector2Array([shade[0]]), Palette.OUTLINE, LINE)

	var shake := Vector2(sin(_ring * 60.0) * u * 0.15 * _ring, 0)
	var phone := Rect2(desk.end.x - u * 2.2, desk.position.y - u * 0.7, u * 1.3, u * 0.7)
	phone.position += shake
	_box(phone, Palette.MONEY_RED)
	_box(Rect2(phone.position + Vector2(-u * 0.15, -u * 0.3), Vector2(u * 1.6, u * 0.35)), Palette.MONEY_RED)
	if _ring > 0.05:
		_text_centered("RING!", phone.get_center() + Vector2(0, -u * 0.9), int(u * 0.6), Palette.MONEY_RED)

	# Chair
	var chair_x := desk.get_center().x - u * 0.6
	_box(Rect2(chair_x, floor_top - u * 2.0, u * 1.2, u * 0.4), Palette.AGENCY)
	_box(Rect2(chair_x + u * 0.9, floor_top - u * 3.4, u * 0.4, u * 1.8), Palette.AGENCY)
	draw_line(Vector2(chair_x + u * 0.6, floor_top - u * 1.6), Vector2(chair_x + u * 0.6, floor_top), Palette.OUTLINE, LINE)

	# Plant and door
	var pot := Rect2(r.end.x - r.size.x * 0.27, floor_top - u * 1.2, u * 1.0, u * 1.2)
	draw_circle(pot.position + Vector2(u * 0.5, -u * 0.6), u * 0.75, Palette.PLANT)
	_box(pot, Palette.BRICK)
	var door := Rect2(r.end.x - u * 3.0, floor_top - u * 5.4, u * 2.2, u * 5.4)
	_box(door, Palette.WOOD)
	draw_circle(door.position + Vector2(u * 1.8, u * 2.9), u * 0.15, Palette.SUN)

	_label_tag(r, floor_label, Palette.ACCENT)


func _draw_vacant(r: Rect2, floor_number: int) -> void:
	_box(r, Palette.VACANT_WALL)
	var u := r.size.y / 10.0
	for i in 3:
		var win := Rect2(r.position.x + r.size.x * (0.1 + 0.3 * i), r.position.y + u * 2.0, r.size.x * 0.2, u * 5.0)
		_box(win, Palette.WINDOW_GLASS.darkened(0.35))
		for slat in range(1, 5):
			var y := win.position.y + win.size.y * slat / 5.0
			draw_line(Vector2(win.position.x, y), Vector2(win.end.x, y), Palette.OUTLINE, 2.0)
	var sign_rect := Rect2(r.get_center().x - u * 2.2, r.end.y - u * 2.4, u * 4.4, u * 1.6)
	_box(sign_rect, Palette.PAPER)
	_text_centered("FOR LEASE", sign_rect.get_center() + Vector2(0, u * 0.25), int(u * 0.7), Palette.MONEY_RED)
	_label_tag(r, "FLOOR %d" % floor_number, Palette.PAPER_DARK)


## A small name tag in the top-left corner of a floor.
func _label_tag(r: Rect2, text: String, color: Color) -> void:
	var font_size := int(r.size.y * 0.075)
	var text_w := _font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var tag := Rect2(r.position + Vector2(12, 12), Vector2(text_w + 24, font_size * 1.6))
	_box(tag, color)
	draw_string(_font, tag.position + Vector2(12, font_size * 1.15), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Palette.INK)


## Filled rectangle with the chunky cartoon outline.
func _box(r: Rect2, fill: Color) -> void:
	if fill.a > 0.0:
		draw_rect(r, fill)
	draw_rect(r, Palette.OUTLINE, false, LINE)


func _text_centered(text: String, center: Vector2, font_size: int, color: Color = Palette.INK) -> void:
	var text_w := _font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	draw_string(_font, Vector2(center.x - text_w * 0.5, center.y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
