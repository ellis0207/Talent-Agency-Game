# Notes for working on this repo

- Engine: **Godot 4.7**, GDScript only (no .NET). Design doc: `docs/GRAND_PLAN.md`; phase plans in `docs/PHASE_*_PLAN.md`.
- Every phase must end with something Ellis can open in Godot and test. Update `docs/SETUP.md` when the way to test changes.
- Everything in the game is fictional (leagues, teams, brands, people). Third-party assets must allow commercial use and be listed in `docs/CREDITS.md`.

## Code conventions

- `scripts/sim/` is pure logic: no nodes, no UI, randomness only through a passed-in `RandomNumberGenerator`. All rules go here and get tests.
- Scripts reference each other with `const X = preload("res://...")`, not `class_name`, so tests run headless without an editor import step.
- Content is JSON in `data/`, loaded and validated by `scripts/data/data_loader.gd`. New formats get a schema entry there, a section in `data/README.md` and a test.
- UI follows `docs/ART_STYLE.md`; colors come from `scripts/ui/palette.gd`.

## Tests

- Tests live in `tests/unit/test_*.gd`, extend `res://tests/test_case.gd`, and every `test_*` method runs.
- Command line: `godot --headless --path . -s res://tests/run_tests.gd`
- Smoke test of the main screen: `godot --headless --path . -- --smoke-test` (prints `SMOKE OK`)
- GitHub Actions (`.github/workflows/tests.yml`) runs both on every pull request.
