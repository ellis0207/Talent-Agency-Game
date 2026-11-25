extends RefCounted
## Plays out one week for an agency. Pure logic: give it the state, the content
## and a random number generator, and it returns a report of what happened.
## Phase 0 version: pay rent, roll one random event, check for bankruptcy.

const AgencyState = preload("res://scripts/sim/agency_state.gd")
const NameGenerator = preload("res://scripts/sim/name_generator.gd")
const Money = preload("res://scripts/core/money.gd")

const QUIET_WEEK := {"id": "quiet_week", "division": "agency", "cash": 0, "headline": "A quiet week. The phone didn't ring once."}


## Advances `state` by one week and returns a report:
## {week, event_id, headline, division, event_cash, rent, cash_before, cash_after,
##  went_bankrupt, low_cash_warning}
## Returns an empty Dictionary if the agency is already bankrupt.
static func advance_week(state: AgencyState, content: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	if state.is_bankrupt:
		return {}
	var setup: Dictionary = content.get("new_game", {})
	var rent := int(setup.get("weekly_rent", 0))
	var event := pick_event(content.get("events", []), state.week, rng)
	var client := NameGenerator.full_name(content.get("names", []), rng)
	var event_cash := int(event.get("cash", 0))
	var headline := fill_template(String(event.get("headline", "")), state.agency_name, client, event_cash)

	var report := {
		"week": state.week,
		"event_id": String(event.get("id", "")),
		"headline": headline,
		"division": String(event.get("division", "agency")),
		"event_cash": event_cash,
		"rent": rent,
		"cash_before": state.cash,
	}
	state.cash += event_cash - rent
	state.add_to_inbox({"week": state.week, "division": report["division"], "headline": headline, "cash": event_cash})
	state.week += 1
	if state.cash < 0:
		state.is_bankrupt = true

	var warning_weeks := int(setup.get("low_cash_warning_weeks", 0))
	report["cash_after"] = state.cash
	report["went_bankrupt"] = state.is_bankrupt
	report["low_cash_warning"] = not state.is_bankrupt and state.cash < rent * warning_weeks
	return report


## Picks one event, weighted by its "weight", from those allowed this week
## (an event with "min_week" can't happen before that week).
static func pick_event(events: Array, week: int, rng: RandomNumberGenerator) -> Dictionary:
	var eligible: Array[Dictionary] = []
	var total_weight := 0.0
	for event: Dictionary in events:
		if int(event.get("min_week", 1)) > week:
			continue
		var weight := float(event.get("weight", 1.0))
		if weight <= 0.0:
			continue
		eligible.append(event)
		total_weight += weight
	if eligible.is_empty():
		return QUIET_WEEK
	var roll := rng.randf() * total_weight
	for event in eligible:
		roll -= float(event.get("weight", 1.0))
		if roll < 0.0:
			return event
	return eligible[eligible.size() - 1]


## Replaces {agency}, {client} and {cash} in an event's text.
static func fill_template(text: String, agency_name: String, client: String, cash: int) -> String:
	return text.replace("{agency}", agency_name).replace("{client}", client).replace("{cash}", Money.format(absi(cash)))
