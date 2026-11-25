extends "res://tests/test_case.gd"

const NameGenerator = preload("res://scripts/sim/name_generator.gd")


func test_builds_first_and_last_name_from_a_pool() -> void:
	var rng := RandomNumberGenerator.new()
	var pools := [{"country": "Testland", "first": ["Ana"], "last": ["Lima"]}]
	assert_eq(NameGenerator.full_name(pools, rng), "Ana Lima")


func test_empty_pools_fall_back_safely() -> void:
	var rng := RandomNumberGenerator.new()
	assert_eq(NameGenerator.full_name([], rng), NameGenerator.FALLBACK_NAME)
	assert_eq(NameGenerator.full_name([{"first": [], "last": ["X"]}], rng), NameGenerator.FALLBACK_NAME)
