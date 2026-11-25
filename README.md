# Talent Agency Game

*(Working title.)* A 2D cartoon management game for desktop (Steam) where you run a talent agency, signing athletes, musicians, actors and models, guiding their careers, and building a talent empire.

- **Design:** [docs/GRAND_PLAN.md](docs/GRAND_PLAN.md)
- **Get it running:** [docs/SETUP.md](docs/SETUP.md) (Godot 4.7, about 15 minutes)
- **Current phase:** Phase 0, Foundations ([plan](docs/PHASE_0_PLAN.md))

## Quick start

1. Install [Godot 4.7](https://godotengine.org/download) (standard, not .NET).
2. In Godot's Project Manager, **Import** this folder's `project.godot`.
3. Press **F5** to play. Open `tests/test_runner.tscn` and press **F6** to run the tests.

## Project layout

| Folder | What's in it |
|---|---|
| `scenes/` | Screens and their scripts |
| `scripts/sim/` | Game rules as pure, tested logic |
| `scripts/core/`, `scripts/data/`, `scripts/ui/` | Global state, data loading, theme and palette |
| `data/` | Game content as JSON ([formats](data/README.md)) |
| `tests/` | Test runner and tests |
| `docs/` | Design, plans, setup, [art style](docs/ART_STYLE.md), [credits](docs/CREDITS.md) |
