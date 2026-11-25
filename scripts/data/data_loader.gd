extends RefCounted
## Loads and checks the JSON content in data/.
##
## Every data file is a JSON object with a "format" (what kind of file it is)
## and a "version". See data/README.md for each format.
## Note: JSON has no integers, so every number arrives as a float. Use int() where needed.

const DATA_ROOT := "res://data"

## Required top-level fields for each format, and their JSON types.
const REQUIRED_FIELDS := {
	"new_game": {
		"starting_cash": TYPE_FLOAT,
		"weekly_rent": TYPE_FLOAT,
		"low_cash_warning_weeks": TYPE_FLOAT,
		"opening_message": TYPE_STRING,
		"agency_names": TYPE_ARRAY,
	},
	"events": {"events": TYPE_ARRAY},
	"names": {"country": TYPE_STRING, "region": TYPE_STRING, "first": TYPE_ARRAY, "last": TYPE_ARRAY},
	"league": {
		"id": TYPE_STRING,
		"name": TYPE_STRING,
		"sport": TYPE_STRING,
		"region": TYPE_STRING,
		"rules": TYPE_DICTIONARY,
		"season": TYPE_DICTIONARY,
		"teams": TYPE_ARRAY,
	},
}

const DIVISIONS := ["athletes", "musicians", "actors", "models", "agency"]


## Loads everything the game needs. Returns:
## {ok: bool, errors: PackedStringArray, new_game: Dictionary, events: Array,
##  names: Array, leagues: Array}
static func load_content(root: String = DATA_ROOT) -> Dictionary:
	var errors: Array[String] = []
	var content := {"new_game": {}, "events": [], "names": [], "leagues": []}

	var new_game = _load_file(root.path_join("config/new_game.json"), "new_game", errors)
	if new_game != null:
		content["new_game"] = new_game
	for data in _load_folder(root.path_join("events"), "events", errors):
		content["events"].append_array(data["events"])
	for data in _load_folder(root.path_join("names"), "names", errors):
		content["names"].append(data)
	for data in _load_folder(root.path_join("leagues"), "league", errors):
		content["leagues"].append(data)

	var seen_ids := {}
	for event: Dictionary in content["events"]:
		var id := String(event.get("id", ""))
		if seen_ids.has(id):
			errors.append("Duplicate event id '%s'" % id)
		seen_ids[id] = true

	content["ok"] = errors.is_empty()
	content["errors"] = PackedStringArray(errors)
	return content


## Parses JSON text without printing errors. Returns {data, error} where error is "" on success.
static func parse_json_text(text: String) -> Dictionary:
	var json := JSON.new()
	if json.parse(text) != OK:
		return {"data": null, "error": "line %d: %s" % [json.get_error_line(), json.get_error_message()]}
	return {"data": json.data, "error": ""}


## Checks a parsed data file. Returns a list of problems (empty means valid).
static func validate(data: Variant, expected_format: String) -> PackedStringArray:
	var errors := PackedStringArray()
	if typeof(data) != TYPE_DICTIONARY:
		errors.append("top level must be a JSON object")
		return errors
	var format := String(data.get("format", ""))
	if format != expected_format:
		errors.append("format is '%s', expected '%s'" % [format, expected_format])
		return errors
	if typeof(data.get("version")) != TYPE_FLOAT:
		errors.append("missing number field 'version'")
	var fields: Dictionary = REQUIRED_FIELDS.get(expected_format, {})
	for field: String in fields:
		if typeof(data.get(field)) != fields[field]:
			errors.append("missing or wrong type for field '%s'" % field)
	if not errors.is_empty():
		return errors

	match expected_format:
		"events":
			for i in data["events"].size():
				errors.append_array(_validate_event(data["events"][i], i))
		"names":
			if data["first"].is_empty() or data["last"].is_empty():
				errors.append("'first' and 'last' must not be empty")
		"league":
			if data["teams"].is_empty():
				errors.append("a league needs at least one team")
			for team in data["teams"]:
				if typeof(team) != TYPE_DICTIONARY or not (team.has("id") and team.has("city") and team.has("name")):
					errors.append("each team needs 'id', 'city' and 'name'")
					break
		"new_game":
			if data["agency_names"].is_empty():
				errors.append("'agency_names' must not be empty")
	return errors


static func _validate_event(event: Variant, index: int) -> PackedStringArray:
	var errors := PackedStringArray()
	if typeof(event) != TYPE_DICTIONARY:
		errors.append("event #%d is not an object" % index)
		return errors
	var label := "event '%s'" % String(event.get("id", "#%d" % index))
	if typeof(event.get("id")) != TYPE_STRING:
		errors.append("%s: needs a text 'id'" % label)
	if typeof(event.get("headline")) != TYPE_STRING:
		errors.append("%s: needs a text 'headline'" % label)
	if typeof(event.get("cash")) != TYPE_FLOAT:
		errors.append("%s: needs a number 'cash'" % label)
	if typeof(event.get("weight")) != TYPE_FLOAT or float(event.get("weight")) <= 0.0:
		errors.append("%s: needs a positive number 'weight'" % label)
	if not (String(event.get("division", "")) in DIVISIONS):
		errors.append("%s: 'division' must be one of %s" % [label, ", ".join(DIVISIONS)])
	return errors


## Reads, parses and validates one file. Returns the data, or null (and adds to errors).
static func _load_file(path: String, expected_format: String, errors: Array[String]) -> Variant:
	if not FileAccess.file_exists(path):
		errors.append("%s: file not found" % path)
		return null
	var parsed := parse_json_text(FileAccess.get_file_as_string(path))
	if parsed["error"] != "":
		errors.append("%s: %s" % [path, parsed["error"]])
		return null
	var problems := validate(parsed["data"], expected_format)
	for problem in problems:
		errors.append("%s: %s" % [path, problem])
	return null if not problems.is_empty() else parsed["data"]


## Loads every .json file in a folder (sorted by name, so order is stable).
static func _load_folder(folder: String, expected_format: String, errors: Array[String]) -> Array:
	var results := []
	if not DirAccess.dir_exists_absolute(folder):
		errors.append("%s: folder not found" % folder)
		return results
	var files := DirAccess.get_files_at(folder)
	files.sort()
	for file in files:
		if not file.ends_with(".json"):
			continue
		var data = _load_file(folder.path_join(file), expected_format, errors)
		if data != null:
			results.append(data)
	return results
