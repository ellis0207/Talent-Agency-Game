extends "res://tests/test_case.gd"

const DataLoader = preload("res://scripts/data/data_loader.gd")

var content: Dictionary


func before_each() -> void:
	content = DataLoader.load_content()


func test_shipped_content_has_no_errors() -> void:
	assert_true(content["ok"], "data files should be valid: %s" % ", ".join(content["errors"]))


func test_shipped_content_has_events_names_and_a_league() -> void:
	assert_gt(content["events"].size(), 5, "events")
	assert_gt(content["names"].size(), 1, "name pools from more than one country")
	assert_gt(content["leagues"].size(), 0, "leagues")
	assert_gt(int(content["new_game"].get("starting_cash", 0)), 0, "starting cash")


func test_events_cover_all_launch_divisions() -> void:
	var divisions := {}
	for event: Dictionary in content["events"]:
		divisions[event["division"]] = true
	for division in ["athletes", "musicians", "actors", "models"]:
		assert_has(divisions, division)


func test_parse_error_is_reported_not_crashed() -> void:
	var parsed := DataLoader.parse_json_text("{ \"format\": \"events\", ")
	assert_eq(parsed["data"], null)
	assert_ne(parsed["error"], "")


func test_rejects_wrong_format() -> void:
	var errors := DataLoader.validate({"format": "names", "version": 1.0}, "events")
	assert_eq(errors.size(), 1)


func test_rejects_event_without_headline() -> void:
	var data := {"format": "events", "version": 1.0, "events": [
		{"id": "broken", "division": "agency", "weight": 1.0, "cash": 0.0},
	]}
	var errors := DataLoader.validate(data, "events")
	assert_eq(errors.size(), 1)
	assert_true(errors.size() > 0 and errors[0].contains("headline"), "error mentions the headline")


func test_rejects_unknown_division_and_bad_weight() -> void:
	var data := {"format": "events", "version": 1.0, "events": [
		{"id": "odd", "division": "wizards", "weight": 0.0, "cash": 0.0, "headline": "Hi"},
	]}
	assert_eq(DataLoader.validate(data, "events").size(), 2)


func test_accepts_valid_names_file() -> void:
	var data := {"format": "names", "version": 1.0, "country": "Kenya", "region": "Africa",
		"first": ["Wanjiru"], "last": ["Kamau"]}
	assert_eq(DataLoader.validate(data, "names").size(), 0)
