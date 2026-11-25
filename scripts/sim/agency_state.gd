extends RefCounted
## Everything about one agency run. Plain data only: no nodes, no UI.
## The simulator changes it, the UI reads it.

## Newest inbox entries are kept up to this many.
const MAX_INBOX := 30

var agency_name: String = ""
## The week about to be played. Starts at 1.
var week: int = 1
var cash: int = 0
## The seed this run was started from, so it can be replayed exactly.
var world_seed: int = 0
var is_bankrupt: bool = false
## Newest first. Each entry: {week: int, division: String, headline: String, cash: int}
var inbox: Array[Dictionary] = []


func add_to_inbox(entry: Dictionary) -> void:
	inbox.push_front(entry)
	if inbox.size() > MAX_INBOX:
		inbox.resize(MAX_INBOX)
