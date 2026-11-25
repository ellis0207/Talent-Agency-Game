extends Control
## The main game screen for Phase 0: the agency building, an inbox of
## headlines, and an "Advance week" button. The layout is built in code so it
## is easy to read and change; later phases will move pieces into their own scenes.

const Palette = preload("res://scripts/ui/palette.gd")
const UiTheme = preload("res://scripts/ui/ui_theme.gd")
const Money = preload("res://scripts/core/money.gd")
const AgencyState = preload("res://scripts/sim/agency_state.gd")
const BuildingView = preload("res://scenes/building/agency_building.gd")
const BuildingScene = preload("res://scenes/building/agency_building.tscn")

## Run with `-- --smoke-test` to auto-play a few weeks and quit (used by the automatic checks).
const SMOKE_TEST_ARG := "--smoke-test"

var _agency_label: Label
var _week_label: Label
var _cash_label: Label
var _warning_label: Label
var _seed_label: Label
var _inbox_list: VBoxContainer
var _advance_button: Button
var _building: BuildingView
var _bankrupt_overlay: Control
var _bankrupt_text: Label
var _smoke_frames := -1


func _ready() -> void:
	theme = UiTheme.build()
	_build_layout()
	GameState.state_changed.connect(_refresh)
	GameState.week_advanced.connect(_on_week_advanced)
	GameState.went_bankrupt.connect(_on_went_bankrupt)
	_rebuild_inbox()
	_refresh()
	if SMOKE_TEST_ARG in OS.get_cmdline_user_args():
		_smoke_frames = 0


func _unhandled_input(event: InputEvent) -> void:
	# Space bar advances the week too.
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		if not GameState.state.is_bankrupt:
			GameState.advance_week()
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	if _smoke_frames >= 0:
		_run_smoke_test_step()


# --- Layout -----------------------------------------------------------------

func _build_layout() -> void:
	var background := ColorRect.new()
	background.color = Palette.BACKGROUND
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(side, 24)
	add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 18)
	margin.add_child(column)

	column.add_child(_build_top_bar())

	var middle := HBoxContainer.new()
	middle.size_flags_vertical = Control.SIZE_EXPAND_FILL
	middle.add_theme_constant_override("separation", 18)
	column.add_child(middle)

	var building_frame := PanelContainer.new()
	building_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	building_frame.size_flags_stretch_ratio = 1.8
	var frame_box := UiTheme.box(Palette.PAPER)
	frame_box.set_content_margin_all(6)
	building_frame.add_theme_stylebox_override("panel", frame_box)
	_building = BuildingScene.instantiate() as BuildingView
	building_frame.add_child(_building)
	middle.add_child(building_frame)

	middle.add_child(_build_inbox())
	column.add_child(_build_bottom_bar())

	_bankrupt_overlay = _build_bankrupt_overlay()
	add_child(_bankrupt_overlay)


func _build_top_bar() -> Control:
	var panel := PanelContainer.new()
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 32)
	panel.add_child(row)

	_agency_label = _label("", 36)
	row.add_child(_agency_label)

	_warning_label = _label("", 22, Palette.MONEY_RED)
	_warning_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_warning_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(_warning_label)

	_week_label = _label("", 30)
	row.add_child(_week_label)
	_cash_label = _label("", 36)
	row.add_child(_cash_label)
	return panel


func _build_inbox() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	panel.add_child(column)

	column.add_child(_label("Inbox", 32))

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)

	_inbox_list = VBoxContainer.new()
	_inbox_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_inbox_list.add_theme_constant_override("separation", 10)
	scroll.add_child(_inbox_list)
	return panel


func _build_bottom_bar() -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)

	_seed_label = _label("", 18, Palette.PAPER_DARK)
	_seed_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_seed_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(_seed_label)

	var new_button := _button("New agency", 26)
	new_button.pressed.connect(_on_new_agency_pressed)
	row.add_child(new_button)

	_advance_button = _button("Advance week  (Space)", 32)
	_advance_button.custom_minimum_size = Vector2(420, 84)
	_advance_button.pressed.connect(_on_advance_pressed)
	row.add_child(_advance_button)
	return row


func _build_bankrupt_overlay() -> Control:
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false

	var dim := ColorRect.new()
	dim.color = Color(Palette.OUTLINE, 0.75)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UiTheme.box(Palette.PAPER, 10))
	center.add_child(panel)

	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(760, 0)
	column.add_theme_constant_override("separation", 24)
	panel.add_child(column)

	var title := _label("Closed for good", 56, Palette.MONEY_RED)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(title)

	_bankrupt_text = _label("", 26)
	_bankrupt_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_bankrupt_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(_bankrupt_text)

	var again := _button("Open a new agency", 30)
	again.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	again.custom_minimum_size = Vector2(380, 76)
	again.pressed.connect(_on_new_agency_pressed)
	column.add_child(again)
	return overlay


func _inbox_card(entry: Dictionary) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UiTheme.box(Palette.PAPER_DARK, 4))
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 6)
	card.add_child(column)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	column.add_child(header)

	var division := String(entry.get("division", "agency"))
	var tag := PanelContainer.new()
	var tag_box := UiTheme.box(Palette.division_color(division))
	tag_box.set_border_width_all(2)
	tag_box.set_corner_radius_all(8)
	tag_box.content_margin_left = 10
	tag_box.content_margin_right = 10
	tag_box.content_margin_top = 2
	tag_box.content_margin_bottom = 2
	tag.add_theme_stylebox_override("panel", tag_box)
	tag.add_child(_label(division.to_upper(), 16, Palette.PAPER))
	header.add_child(tag)

	var week := int(entry.get("week", 0))
	var when := _label("Opening day" if week == 0 else "Week %d" % week, 18, Palette.INK_SOFT)
	when.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(when)

	var cash := int(entry.get("cash", 0))
	if cash != 0:
		header.add_child(_label(Money.format_signed(cash), 22, Palette.MONEY_GREEN if cash > 0 else Palette.MONEY_RED))

	var headline := _label(String(entry.get("headline", "")), 22)
	headline.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(headline)
	return card


# --- Updating ---------------------------------------------------------------

func _refresh() -> void:
	var state: AgencyState = GameState.state
	_agency_label.text = state.agency_name
	@warning_ignore("integer_division")
	var year: int = (state.week - 1) / 52 + 1
	var week_of_year: int = (state.week - 1) % 52 + 1
	_week_label.text = "Year %d  ·  Week %d" % [year, week_of_year]
	_cash_label.text = Money.format(state.cash)
	_cash_label.add_theme_color_override("font_color", Palette.MONEY_RED if state.cash < 0 else Palette.MONEY_GREEN)
	_seed_label.text = "World seed %d" % state.world_seed
	_building.set_week(week_of_year)
	_advance_button.disabled = state.is_bankrupt
	_bankrupt_overlay.visible = state.is_bankrupt
	if state.is_bankrupt:
		_bankrupt_text.text = "After %d weeks, %s couldn't make rent. The landlord changed the locks and kept the plant." % [state.week - 1, state.agency_name]


func _rebuild_inbox() -> void:
	for child in _inbox_list.get_children():
		child.queue_free()
	for entry: Dictionary in GameState.state.inbox:
		_inbox_list.add_child(_inbox_card(entry))


func _on_week_advanced(report: Dictionary) -> void:
	var card := _inbox_card(GameState.state.inbox[0])
	_inbox_list.add_child(card)
	_inbox_list.move_child(card, 0)
	while _inbox_list.get_child_count() > GameState.state.inbox.size():
		var oldest := _inbox_list.get_child(_inbox_list.get_child_count() - 1)
		_inbox_list.remove_child(oldest)
		oldest.queue_free()
	card.modulate.a = 0.0
	create_tween().tween_property(card, "modulate:a", 1.0, 0.35)
	_building.ring_phone()
	if report["low_cash_warning"]:
		_warning_label.text = "Rent is due every week. Cash is running low!"
	else:
		_warning_label.text = ""


func _on_went_bankrupt() -> void:
	_warning_label.text = ""


func _on_advance_pressed() -> void:
	GameState.advance_week()


func _on_new_agency_pressed() -> void:
	GameState.new_game()
	_warning_label.text = ""
	_rebuild_inbox()


# --- Helpers ----------------------------------------------------------------

func _label(text: String, font_size: int, color: Color = Palette.INK) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


func _button(text: String, font_size: int) -> Button:
	var button := Button.new()
	button.text = text
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", font_size)
	return button


## Auto-plays until bankrupt (or 60 weeks), starts a new agency, then quits.
## Lets the automatic checks exercise the real screen without a person.
func _run_smoke_test_step() -> void:
	_smoke_frames += 1
	var state: AgencyState = GameState.state
	if not state.is_bankrupt and state.week <= 60:
		_on_advance_pressed()
		return
	var weeks_played: int = state.week - 1
	_on_new_agency_pressed()
	var ok: bool = GameState.state.week == 1 and not GameState.state.is_bankrupt and _inbox_list.get_child_count() > 0
	print("SMOKE %s: played %d weeks, then started a new agency" % ["OK" if ok else "FAILED", weeks_played])
	get_tree().quit(0 if ok else 1)
