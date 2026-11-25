extends SceneTree
## Command-line test entry point:
##   godot --headless --path . -s res://tests/run_tests.gd
## Exits with code 0 if every test passed, 1 otherwise.

const TestRunner = preload("res://tests/test_runner.gd")


func _initialize() -> void:
	var results := TestRunner.run_all()
	for line: String in results["lines"]:
		print(line)
	print("")
	print("%d passed, %d failed" % [results["passed"], results["failed"]])
	quit(1 if results["failed"] > 0 else 0)
