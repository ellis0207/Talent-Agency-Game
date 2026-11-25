extends RefCounted
## Finds every tests/unit/test_*.gd file and runs each of its "test_" methods.
## Used by tests/run_tests.gd (command line) and tests/test_runner.tscn (editor).

const TEST_DIR := "res://tests/unit"


## Returns {passed: int, failed: int, lines: Array[String]}
static func run_all(dir: String = TEST_DIR) -> Dictionary:
	var passed := 0
	var failed := 0
	var lines: Array[String] = []
	var files := DirAccess.get_files_at(dir)
	files.sort()
	for file in files:
		if not (file.begins_with("test_") and file.ends_with(".gd")):
			continue
		lines.append(file)
		var script := load(dir.path_join(file)) as GDScript
		if script == null or not script.can_instantiate():
			failed += 1
			lines.append("  FAIL  could not load this file (look for a script error above)")
			continue
		for method in script.get_script_method_list():
			var method_name: String = method["name"]
			if not method_name.begins_with("test_"):
				continue
			var test = script.new()
			test.test_name = method_name
			if test.has_method("before_each"):
				test.before_each()
			test.call(method_name)
			if test.has_method("after_each"):
				test.after_each()
			if test.failures.is_empty():
				passed += 1
				lines.append("  ok    " + method_name)
			else:
				failed += 1
				lines.append("  FAIL  " + method_name)
				for failure: String in test.failures:
					lines.append("        - " + failure)
	return {"passed": passed, "failed": failed, "lines": lines}
