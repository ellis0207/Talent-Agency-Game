extends "res://tests/test_case.gd"

const GameStateScript = preload("res://scripts/core/game_state.gd")

var game


func before_each() -> void:
	game = GameStateScript.new()
	game.load_content()


func after_each() -> void:
	game.free()


func _play(world_seed: int, weeks: int) -> Array:
	game.new_game(world_seed)
	for i in weeks:
		game.advance_week()
	var headlines := []
	for entry: Dictionary in game.state.inbox:
		headlines.append(entry["headline"])
	return [game.state.agency_name, game.state.cash, headlines]


func test_new_game_uses_starting_cash_and_welcomes_you() -> void:
	game.new_game(7)
	assert_eq(game.state.week, 1)
	assert_eq(game.state.cash, int(game.content["new_game"]["starting_cash"]))
	assert_eq(game.state.inbox.size(), 1, "opening message")
	assert_ne(game.state.agency_name, "")


func test_same_seed_replays_exactly() -> void:
	var first := _play(99, 5)
	var second := _play(99, 5)
	assert_eq(first, second)


func test_different_seeds_differ() -> void:
	var first := _play(1, 8)
	var second := _play(2, 8)
	assert_ne(first, second)


func test_shipped_economy_eventually_bankrupts_an_idle_agency() -> void:
	game.new_game(5)
	var weeks := 0
	while not game.state.is_bankrupt and weeks < 200:
		game.advance_week()
		weeks += 1
	assert_true(game.state.is_bankrupt, "Phase 0 fake week should run out of money")
	assert_gt(weeks, 2, "but not instantly")
