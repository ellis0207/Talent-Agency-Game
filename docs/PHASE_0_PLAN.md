# Phase 0: Foundations — Plan

> Goal from the roadmap: *a window that opens, a test suite that runs, a fake week that advances.*

## What Phase 0 delivers

1. **A Godot 4 project** (Godot 4.7, standard edition, GDScript) at the root of this repo, which opens straight into the game.
2. **A fake week loop.** The main screen shows the agency (a placeholder cartoon building), a top bar with week and cash, and an inbox of headlines. Pressing **Advance week** moves time forward, pays rent, rolls a random event from data, and updates everything on screen. Running out of cash shows a "closed for good" screen, as a first taste of bankruptcy.
3. **Repo structure** that later phases grow into (see below).
4. **Data formats.** Game content lives in JSON under `data/`, loaded and checked by one loader. Phase 0 ships a sample of each format we will need next: weekly events, a fictional placeholder league, and name pools.
5. **A test suite.** Simulation code is pure logic with no UI, so it can be tested. Tests run three ways: inside the editor (open one scene, press a key), from the command line, and automatically on GitHub for every push.
6. **A placeholder art style.** A small palette and UI theme in code, plus a hand-drawn (in code) side-view building, so every screen already has the warm, chunky cartoon feel. Documented in `docs/ART_STYLE.md`. Real art replaces it later.
7. **Setup instructions** for Windows and Mac in `docs/SETUP.md`, written for someone new to Godot.

## Repo structure

```
project.godot            Godot project file (open this in Godot)
scenes/                  Scenes (.tscn) and the scripts attached to them
  main/                  The main game screen
  building/              The agency building view
scripts/
  core/                  Game state and autoloads (global singletons)
  sim/                   Pure simulation logic (no UI); fully tested
  data/                  Loading and validating JSON content
  ui/                    Theme, palette and UI helpers
data/                    Game content as JSON (events, leagues, names)
tests/                   Test runner and test files
docs/                    Design doc, plans, setup, art style
.github/workflows/       Automatic test runs on GitHub
```

## Key technical decisions

- **Godot 4.7 standard (not .NET).** GDScript only, so there is nothing else to install.
- **Our own tiny test runner instead of GUT, for now.** The grand plan named GUT. A ~100-line runner in `tests/` has no add-on to install or keep updated, and works the same in the editor, the command line and GitHub. We can switch to GUT later if tests outgrow it; test files are written in a GUT-like style to make that easy.
- **Simulation separate from presentation.** `scripts/sim/` never touches nodes or the screen. The UI calls into it and displays the results. This keeps rules testable and lets later phases swap the UI freely.
- **Seeded randomness.** Every run has a seed, so a week can be replayed exactly (useful for bugs and, later, shared worlds).
- **Resolution.** Designed at 1920×1080 and scales to any window size.

## Out of scope (comes in later phases)

Real clients, negotiation, saving and loading, the buildable building, Steam export. The event text in Phase 0 is placeholder flavor.

## How to test Phase 0

1. Follow `docs/SETUP.md` to install Godot and open the project.
2. Press **F5**. A window opens with the agency and the inbox.
3. Press **Advance week** a few times: the week counter goes up, cash changes, new headlines appear.
4. Keep pressing until cash runs out to see the bankruptcy screen, then start a new agency.
5. Open `tests/test_runner.tscn` and press **F6**: all tests should report as passed in the Output panel.
