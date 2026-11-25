extends Node
## Global game state, available everywhere as the autoload "GameState".
## Owns the current run and the loaded content. Screens call its methods and
## listen to its signals; the actual rules live in scripts/sim/.

signal state_changed
signal week_advanced(report: Dictionary)
signal went_bankrupt

const AgencyState = preload("res://scripts/sim/agency_state.gd")
const WeekSimulator = preload("res://scripts/sim/week_simulator.gd")
const DataLoader = preload("res://scripts/data/data_loader.gd")

var content: Dictionary = {}
var state: AgencyState
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	load_content()
	new_game()


func load_content() -> void:
	content = DataLoader.load_content()
	for problem: String in content["errors"]:
		push_error("Data problem: " + problem)


## Starts a fresh agency. Pass a seed to replay a run exactly; -1 picks a random one.
func new_game(world_seed: int = -1) -> void:
	if world_seed < 0:
		world_seed = randi()
	rng.seed = world_seed
	state = AgencyState.new()
	state.world_seed = world_seed
	var setup: Dictionary = content.get("new_game", {})
	state.cash = int(setup.get("starting_cash", 1000))
	var names: Array = setup.get("agency_names", ["Your Agency"])
	state.agency_name = String(names[rng.randi_range(0, names.size() - 1)])
	state.add_to_inbox({
		"week": 0,
		"division": "agency",
		"headline": String(setup.get("opening_message", "Your agency is open for business.")),
		"cash": 0,
	})
	state_changed.emit()


## Plays out one week. Returns the simulator's report (empty if bankrupt).
func advance_week() -> Dictionary:
	var report := WeekSimulator.advance_week(state, content, rng)
	if report.is_empty():
		return report
	week_advanced.emit(report)
	state_changed.emit()
	if report["went_bankrupt"]:
		went_bankrupt.emit()
	return report
