# Placeholder Art Style

Phase 0 sets a **placeholder** look so every screen already feels like the game: warm, chunky, cartoon, readable. Real art will replace it, but it should keep these rules.

Inspiration is the *feel* of News Tower (a lively building you look into from the side). We don't copy its art, layout or UI.

## Rules

1. **Chunky dark outlines.** Shapes have a 4 px outline in ink (`#2b2d42`). Small details use 2 px.
2. **Rounded, friendly shapes.** Panels and buttons have rounded corners (14 px).
3. **Warm paper UI.** Panels look like paper cards (`#fff6e5`) sitting on a dark navy desk (`#253046`). Buttons are warm orange with a small cartoon drop shadow that disappears when pressed.
4. **Flat color, no gradients.** Depth comes from bands of color and outlines, not shading.
5. **The building is the hero.** The side-view building takes most of the screen. Rooms you own are warm and lit; floors you don't own are dim purple with "For Lease" signs.
6. **Faces, not figures.** Show a reaction, an object or a headline before a number. Numbers are small and colored: green for money in, red for money out.
7. **One color per division** so the player can tell news apart at a glance.

## Palette

The source of truth is `scripts/ui/palette.gd`.

| Use | Color |
|---|---|
| Background (desk) | `#253046` |
| Paper panels / cards | `#fff6e5` / `#f2e2c4` |
| Ink (text, outlines) | `#2b2d42` |
| Buttons | `#f4a261` (hover `#f7b883`, pressed `#e07a2f`) |
| Money in / out | `#2a9d8f` / `#e63946` |
| Sky / sun | `#8fd3ff` / `#ffd166` |
| Roof / street | `#3d405b` / `#4a4e69` |
| Your office wall / floor | `#ffe8c2` / `#b5835a` |
| Vacant floor | `#6d597a` |
| Athletes | `#e76f51` |
| Musicians | `#9b5de5` |
| Actors | `#d62839` |
| Models | `#00a6a6` |
| Agency news | `#457b9d` |

## Fonts

For now we use Godot's built-in default font. A characterful display font (with a license that allows commercial use) is a later art decision; record it in `docs/CREDITS.md` when chosen.
