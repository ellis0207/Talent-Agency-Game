extends "res://tests/test_case.gd"

const AgencyState = preload("res://scripts/sim/agency_state.gd")
const WeekSimulator = preload("res://scripts/sim/week_simulator.gd")

var rng: RandomNumberGenerator
var state: AgencyState


func before_each() -> void:
	rng = RandomNumberGenerator.new()
	rng.seed = 1234
	state = AgencyState.new()
	state.agency_name = "Test Agency"
	state.cash = 1000


## A tiny, predictable world: rent 300 and one event worth `event_cash`.
func _content(event_cash: int, extra_event: Dictionary = {}) -> Dictionary:
	var events: Array = [{"id": "only", "division": "agency", "weight": 1.0, "cash": float(event_cash),
		"headline": "{client} paid {agency} {cash}."}]
	if not extra_event.is_empty():
		events.append(extra_event)
	return {
		"new_game": {"weekly_rent": 300.0, "low_cash_warning_weeks": 2.0},
		"events": events,
		"names": [{"country": "Testland", "first": ["Pat"], "last": ["Doe"]}],
	}


func test_week_advances_and_rent_is_paid() -> void:
	var report := WeekSimulator.advance_week(state, _content(100), rng)
	assert_eq(state.week, 2)
	assert_eq(state.cash, 800, "1000 + 100 event - 300 rent")
	assert_eq(report["rent"], 300)
	assert_eq(report["cash_before"], 1000)
	assert_eq(report["cash_after"], 800)


func test_headline_template_is_filled() -> void:
	var report := WeekSimulator.advance_week(state, _content(1500), rng)
	assert_eq(report["headline"], "Pat Doe paid Test Agency $1,500.")
	assert_eq(state.inbox[0]["headline"], report["headline"], "headline lands in the inbox")


func test_goes_bankrupt_below_zero() -> void:
	state.cash = 200
	var report := WeekSimulator.advance_week(state, _content(0), rng)
	assert_true(report["went_bankrupt"])
	assert_true(state.is_bankrupt)


func test_exactly_zero_cash_is_not_bankrupt() -> void:
	state.cash = 300
	WeekSimulator.advance_week(state, _content(0), rng)
	assert_eq(state.cash, 0)
	assert_false(state.is_bankrupt)


func test_nothing_happens_after_bankruptcy() -> void:
	state.is_bankrupt = true
	var report := WeekSimulator.advance_week(state, _content(500), rng)
	assert_true(report.is_empty())
	assert_eq(state.week, 1)
	assert_eq(state.cash, 1000)


func test_low_cash_warning() -> void:
	state.cash = 800  # after this week: 500, which is less than two weeks of rent
	var report := WeekSimulator.advance_week(state, _content(0), rng)
	assert_true(report["low_cash_warning"])


func test_min_week_events_wait_their_turn() -> void:
	var late := {"id": "late", "division": "agency", "weight": 1000.0, "cash": 0.0, "headline": "Late", "min_week": 5.0}
	var events: Array = _content(0, late)["events"]
	for week in range(1, 5):
		assert_eq(WeekSimulator.pick_event(events, week, rng)["id"], "only", "week %d" % week)
	assert_eq(WeekSimulator.pick_event(events, 5, rng)["id"], "late", "heavy event is allowed from week 5")


func test_weights_shape_how_often_events_happen() -> void:
	var events: Array = [
		{"id": "common", "weight": 9.0},
		{"id": "rare", "weight": 1.0},
	]
	var common := 0
	for i in 1000:
		if WeekSimulator.pick_event(events, 1, rng)["id"] == "common":
			common += 1
	assert_true(common > 850 and common < 950, "about 90%% common, got %d of 1000" % common)


func test_no_events_means_a_quiet_week() -> void:
	assert_eq(WeekSimulator.pick_event([], 1, rng)["id"], "quiet_week")


func test_inbox_is_capped() -> void:
	state.cash = 1000000
	for i in AgencyState.MAX_INBOX + 10:
		WeekSimulator.advance_week(state, _content(0), rng)
	assert_eq(state.inbox.size(), AgencyState.MAX_INBOX)
	assert_eq(state.inbox[0]["week"], AgencyState.MAX_INBOX + 10, "newest first")
