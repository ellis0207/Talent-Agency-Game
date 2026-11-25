extends RefCounted
## Builds random names from the name pools in data/names/.

const FALLBACK_NAME := "Somebody"


## pools: Array of name-pool Dictionaries ({country, first: [...], last: [...]})
static func full_name(pools: Array, rng: RandomNumberGenerator) -> String:
	if pools.is_empty():
		return FALLBACK_NAME
	var pool: Dictionary = pools[rng.randi_range(0, pools.size() - 1)]
	var first: Array = pool.get("first", [])
	var last: Array = pool.get("last", [])
	if first.is_empty() or last.is_empty():
		return FALLBACK_NAME
	return "%s %s" % [first[rng.randi_range(0, first.size() - 1)], last[rng.randi_range(0, last.size() - 1)]]
