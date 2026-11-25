# Game Data

Game content lives here as JSON, so adding events, names or leagues means adding data, not code. `scripts/data/data_loader.gd` loads and checks every file when the game starts; any problem is printed in red in Godot's Output panel, and the tests fail.

Every file is a JSON object with:

- `"format"`: what kind of file it is (below).
- `"version"`: the format version (currently `1`).
- `"notes"` (optional): free text for humans; ignored by the game.

Note: JSON numbers have no integer type, so the game reads them as decimals and rounds where needed.

All names here must be **fictional** (people, teams, leagues, brands). Real countries, regions and cities are fine.

## `new_game` — `config/new_game.json`

Settings for starting an agency.

| Field | Meaning |
|---|---|
| `starting_cash` | Money at the start |
| `weekly_rent` | Paid every week |
| `low_cash_warning_weeks` | Warn when cash drops below this many weeks of rent |
| `opening_message` | First inbox message |
| `agency_names` | A random one is picked for each new agency |

## `events` — any file in `events/`

Random weekly events. All files in the folder are combined; every `id` must be unique.

| Field | Meaning |
|---|---|
| `id` | Unique name, e.g. `"pizza_ad"` |
| `division` | `athletes`, `musicians`, `actors`, `models` or `agency` |
| `weight` | How likely compared with other events (positive number) |
| `cash` | Money gained (positive) or lost (negative) |
| `headline` | Inbox text. `{client}` = a random name, `{agency}` = your agency, `{cash}` = the amount |
| `min_week` | Optional: can't happen before this week |

## `names` — any file in `names/`

One file per country: name pools for generated people.

| Field | Meaning |
|---|---|
| `country`, `region` | Where these names come from |
| `first`, `last` | Lists of first and last names |

## `league` — any file in `leagues/`

A fictional league. Phase 0 only loads and checks these; Phase 3 brings the rules to life.

| Field | Meaning |
|---|---|
| `id`, `name`, `short_name` | Fictional identity |
| `sport`, `mirrors`, `region`, `tier` | What it is and which real-world rule set it mirrors |
| `rules` | Contract rules (cap, minimums, maximums, ...) |
| `season` | Calendar weeks for key moments (draft, free agency, ...) |
| `teams` | List of `{id, city, name}` |
