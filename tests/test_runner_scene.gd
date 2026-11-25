extends Control
## Open tests/test_runner.tscn in the editor and press F6 (Mac: Cmd+R) to run
## every test. Results show in this window and in the Output panel.

const TestRunner = preload("res://tests/test_runner.gd")
const Palette = preload("res://scripts/ui/palette.gd")


func _ready() -> void:
	var results := TestRunner.run_all()
	var all_passed: bool = results["failed"] == 0

	var background := ColorRect.new()
	background.color = Palette.PAPER
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var text := RichTextLabel.new()
	text.set_anchors_preset(Control.PRESET_FULL_RECT)
	text.offset_left = 32
	text.offset_top = 32
	text.offset_right = -32
	text.offset_bottom = -32
	text.add_theme_font_size_override("normal_font_size", 22)
	text.add_theme_color_override("default_color", Palette.INK)
	add_child(text)

	var summary := "%d passed, %d failed" % [results["passed"], results["failed"]]
	var color := Palette.MONEY_GREEN if all_passed else Palette.MONEY_RED
	text.push_font_size(44)
	text.push_color(color)
	text.add_text(("ALL TESTS PASSED  " if all_passed else "SOME TESTS FAILED  ") + "(" + summary + ")\n\n")
	text.pop()
	text.pop()
	for line: String in results["lines"]:
		if line.strip_edges().begins_with("FAIL") or line.strip_edges().begins_with("-"):
			text.push_color(Palette.MONEY_RED)
			text.add_text(line + "\n")
			text.pop()
		else:
			text.add_text(line + "\n")
		print(line)
	print(summary)
