extends RefCounted
## Base class for tests. A test file extends this, and every method whose name
## starts with "test_" is run by tests/test_runner.gd. Optional before_each()
## and after_each() run before and after every test. Assertions are named
## like GUT's, so switching to GUT later is easy.

var test_name := ""
var failures: Array[String] = []


func fail(message: String) -> void:
	failures.append(message)


func assert_true(condition: bool, note: String = "") -> void:
	if not condition:
		fail(_with_note("expected true, got false", note))


func assert_false(condition: bool, note: String = "") -> void:
	if condition:
		fail(_with_note("expected false, got true", note))


func assert_eq(actual: Variant, expected: Variant, note: String = "") -> void:
	if not _same(actual, expected):
		fail(_with_note("expected %s, got %s" % [_show(expected), _show(actual)], note))


func assert_ne(actual: Variant, not_expected: Variant, note: String = "") -> void:
	if _same(actual, not_expected):
		fail(_with_note("expected anything but %s" % _show(not_expected), note))


func assert_gt(actual: Variant, limit: Variant, note: String = "") -> void:
	if not (actual > limit):
		fail(_with_note("expected more than %s, got %s" % [_show(limit), _show(actual)], note))


func assert_has(container: Variant, item: Variant, note: String = "") -> void:
	if not container.has(item):
		fail(_with_note("expected %s to contain %s" % [_show(container), _show(item)], note))


func _same(a: Variant, b: Variant) -> bool:
	var numbers := [TYPE_INT, TYPE_FLOAT]
	var ta := typeof(a)
	var tb := typeof(b)
	if ta != tb and not (ta in numbers and tb in numbers):
		return false
	return a == b


func _show(value: Variant) -> String:
	return "\"%s\"" % value if typeof(value) == TYPE_STRING else str(value)


func _with_note(message: String, note: String) -> String:
	return message if note == "" else "%s (%s)" % [note, message]
