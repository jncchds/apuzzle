# APuzzle

> ### ▶ [Play in your browser: jncchds.github.io/apuzzle](https://jncchds.github.io/apuzzle/)
> No install needed: the web version has every game, the daily challenges, the tutorials and explain mode, and it saves your progress in the browser.
>
> **Prefer an app?** Download it from the [latest release](https://github.com/jncchds/apuzzle/releases/latest): an `.apk` for Android and a `.zip` for Windows.

A collection of grid logic puzzles for Android, Windows, iOS and the web, built with Flutter.
Every puzzle is **generated on the device**, and a solver checks that it has **exactly one solution**.
Mines is solved by logic without guessing. The casual games (the color floods, Pop, 2048 and Snake) and Formula are played for a move limit, a target or a best score instead; their limits and targets come from solver playthroughs or the board size, so they are always reachable.
You choose the grid size and the difficulty.

<p align="center">
  <img src="docs/screenshots/home.png" width="220" alt="Home screen">
  <img src="docs/screenshots/kings_dark.png" width="220" alt="Crowns">
  <img src="docs/screenshots/sudoku_dark.png" width="220" alt="Sudoku">
</p>

## Puzzles

The games are grouped by the home screen's categories. Each one is shown in the dark and the light theme.

### Numbers

Skyline, Cages and Signs are one family on the home screen, Latin squares.

| Dark | Light | Puzzle | Goal |
|---|---|---|---|
| <img src="docs/screenshots/sudoku_dark.png" width="90" alt="Sudoku, dark theme"> | <img src="docs/screenshots/sudoku_light.png" width="90" alt="Sudoku, light theme"> | **Sudoku** | 4×4, 6×6 or 9×9 grids. Every number appears once per row, column and box. Supports pencil marks. |
| <img src="docs/screenshots/skyline_dark.png" width="90" alt="Skyline, dark theme"> | <img src="docs/screenshots/skyline_light.png" width="90" alt="Skyline, light theme"> | **Skyline** | Put a tower in every cell, each height once per row and column. The clues around the grid say how many towers can be seen from there; taller towers hide shorter ones behind them. Supports pencil marks. |
| <img src="docs/screenshots/cages_dark.png" width="90" alt="Cages, dark theme"> | <img src="docs/screenshots/cages_light.png" width="90" alt="Cages, light theme"> | **Cages** | Fill the grid so every number appears once per row and column. The numbers in each outlined cage make the clue in its corner: added, multiplied, or, in a cage of two cells, subtracted or divided. Supports pencil marks. |
| <img src="docs/screenshots/signs_dark.png" width="90" alt="Signs, dark theme"> | <img src="docs/screenshots/signs_light.png" width="90" alt="Signs, light theme"> | **Signs** | Fill the grid so every number appears once per row and column. A sign between two cells points at the smaller number. Supports pencil marks. |
| <img src="docs/screenshots/blocks_dark.png" width="90" alt="Blocks, dark theme"> | <img src="docs/screenshots/blocks_light.png" width="90" alt="Blocks, light theme"> | **Blocks** | Fill every region of k cells with the numbers 1 to k. Equal numbers never touch, not even diagonally. Supports pencil marks. |
| <img src="docs/screenshots/tally_dark.png" width="90" alt="Tally, dark theme"> | <img src="docs/screenshots/tally_light.png" width="90" alt="Tally, light theme"> | **Tally** | Every cell holds a number. Cross some out so that the numbers left in each row and column add up to the sums outside the grid. |
| <img src="docs/screenshots/formula_dark.png" width="90" alt="Formula, dark theme"> | <img src="docs/screenshots/formula_light.png" width="90" alt="Formula, light theme"> | **Formula** | Guess the hidden equation in six tries. Every guess is a true equation, and each tile is marked as in place, elsewhere or not there. Six, eight or ten tiles wide; harder levels add × ÷, then brackets, squares and cubes. |
| <img src="docs/screenshots/plots_dark.png" width="90" alt="Plots, dark theme"> | <img src="docs/screenshots/plots_light.png" width="90" alt="Plots, light theme"> | **Plots** | Fill every cell with a number. Equal numbers that touch form a plot with exactly that many cells, and plots of the same size never touch. |
| <img src="docs/screenshots/shikaku_dark.png" width="90" alt="Shikaku, dark theme"> | <img src="docs/screenshots/shikaku_light.png" width="90" alt="Shikaku, light theme"> | **Shikaku** | Split the grid into rectangles. Each holds one number equal to its area. |

### Logic grids

| Dark | Light | Puzzle | Goal |
|---|---|---|---|
| <img src="docs/screenshots/mambo_dark.png" width="90" alt="Sun & Moon, dark theme"> | <img src="docs/screenshots/mambo_light.png" width="90" alt="Sun & Moon, light theme"> | **Sun & Moon** | Fill every cell with a sun or a moon. No three of the same in a row, equal counts in every row and column, and `=` / `×` clues between cells. |
| <img src="docs/screenshots/kings_dark.png" width="90" alt="Crowns, dark theme"> | <img src="docs/screenshots/kings_light.png" width="90" alt="Crowns, light theme"> | **Crowns** | Place one crown in every row, column and colored region. Crowns can't touch, not even diagonally. |
| <img src="docs/screenshots/pairs_dark.png" width="90" alt="Pairs, dark theme"> | <img src="docs/screenshots/pairs_light.png" width="90" alt="Pairs, light theme"> | **Pairs** | Shade exactly two cells in every region. Shaded cells come in side-by-side pairs, and pairs never touch each other. |
| <img src="docs/screenshots/hues_dark.png" width="90" alt="Hues, dark theme"> | <img src="docs/screenshots/hues_light.png" width="90" alt="Hues, light theme"> | **Hues** | Color the blank cells. Each number counts the blank cells around it (all 8 neighbors) that end up in its color. Supports pencil marks. |
| <img src="docs/screenshots/lits_dark.png" width="90" alt="Tetra, dark theme"> | <img src="docs/screenshots/lits_light.png" width="90" alt="Tetra, light theme"> | **Tetra** | Shade one L, I, T or S tetromino in every region. The shaded area is connected, with no 2×2 blocks, and identical shapes never touch across region borders. |
| <img src="docs/screenshots/camp_dark.png" width="90" alt="Campsite, dark theme"> | <img src="docs/screenshots/camp_light.png" width="90" alt="Campsite, light theme"> | **Campsite** | Pitch a tent next to every tree, one tent per tree. Tents never touch, not even diagonally, and the counts outside the grid give the tents per row and column. |
| <img src="docs/screenshots/islands_dark.png" width="90" alt="Islands, dark theme"> | <img src="docs/screenshots/islands_light.png" width="90" alt="Islands, light theme"> | **Islands** | Shade the sea. Every island holds one number equal to its size, islands never touch, and the sea is connected with no 2×2 pools. |
| <img src="docs/screenshots/lamps_dark.png" width="90" alt="Lamps, dark theme"> | <img src="docs/screenshots/lamps_light.png" width="90" alt="Lamps, light theme"> | **Lamps** | Place lamps that light their row and column up to the walls. Light every cell, never shine a lamp on another, and match the numbers on the walls. |
| <img src="docs/screenshots/orbits_dark.png" width="90" alt="Orbits, dark theme"> | <img src="docs/screenshots/orbits_light.png" width="90" alt="Orbits, light theme"> | **Orbits** | Give every star its own region. A region is one connected piece with its star in the exact middle, and it looks the same after half a turn around the star. |
| <img src="docs/screenshots/mines_dark.png" width="90" alt="Mines, dark theme"> | <img src="docs/screenshots/mines_light.png" width="90" alt="Mines, light theme"> | **Mines** | Clear every cell without a mine. Numbers count the mines around them, and the start is chosen so that logic alone clears the board. |

### Paths & loops

| Dark | Light | Puzzle | Goal |
|---|---|---|---|
| <img src="docs/screenshots/trail_dark.png" width="90" alt="Trail, dark theme"> | <img src="docs/screenshots/trail_light.png" width="90" alt="Trail, light theme"> | **Trail** | Draw one path through every cell that passes the numbers in order. |
| <img src="docs/screenshots/links_dark.png" width="90" alt="Links, dark theme"> | <img src="docs/screenshots/links_light.png" width="90" alt="Links, light theme"> | **Links** | Join each pair of equal dots with a path. Paths never cross, and together they fill the whole grid. |
| <img src="docs/screenshots/labyrinth_dark.png" width="90" alt="Labyrinth, dark theme"> | <img src="docs/screenshots/labyrinth_light.png" width="90" alt="Labyrinth, light theme"> | **Labyrinth** | Walk through the maze from the top-left corner to the exit in the bottom-right corner. |
| <img src="docs/screenshots/pipes_dark.png" width="90" alt="Pipes, dark theme"> | <img src="docs/screenshots/pipes_light.png" width="90" alt="Pipes, light theme"> | **Pipes** | Rotate tiles until every pipe connects to the source, with no open ends and no loops. |
| <img src="docs/screenshots/atoms_dark.png" width="90" alt="Atoms, dark theme"> | <img src="docs/screenshots/atoms_light.png" width="90" alt="Atoms, light theme"> | **Atoms** | Connect atoms with single or double bonds that match their numbers. Bonds can't cross, and all atoms must end up connected. |
| <img src="docs/screenshots/fence_dark.png" width="90" alt="Fence, dark theme"> | <img src="docs/screenshots/fence_light.png" width="90" alt="Fence, light theme"> | **Fence** | Draw one loop along the grid lines. A number tells how many sides of its cell the loop uses. |
| <img src="docs/screenshots/pearls_dark.png" width="90" alt="Pearls, dark theme"> | <img src="docs/screenshots/pearls_light.png" width="90" alt="Pearls, light theme"> | **Pearls** | Draw one loop through the cell centres and every pearl: straight through white pearls (turning next to them), turning on black pearls (going straight next to them). |
| <img src="docs/screenshots/rails_dark.png" width="90" alt="Rails, dark theme"> | <img src="docs/screenshots/rails_light.png" width="90" alt="Rails, light theme"> | **Rails** | Lay one track from the entry on the left to the exit at the bottom. The counts outside the grid give the track cells per row and column, and given pieces are fixed. |
| <img src="docs/screenshots/arrows_dark.png" width="90" alt="Arrows, dark theme"> | <img src="docs/screenshots/arrows_light.png" width="90" alt="Arrows, light theme"> | **Arrows** | Shade some cells and draw one loop through all the others. Shaded cells never touch, and each arrow clue counts the shaded cells in its direction. |

### Casual

Mosaic and Blend are one family on the home screen, Flood.

| Dark | Light | Puzzle | Goal |
|---|---|---|---|
| <img src="docs/screenshots/mosaic_dark.png" width="90" alt="Mosaic, dark theme"> | <img src="docs/screenshots/mosaic_light.png" width="90" alt="Mosaic, light theme"> | **Mosaic** | Flood the board with one color from the top-left corner, within the move limit. |
| <img src="docs/screenshots/blend_dark.png" width="90" alt="Blend, dark theme"> | <img src="docs/screenshots/blend_light.png" width="90" alt="Blend, light theme"> | **Blend** | Pick a color and repaint any patch; it merges with touching patches of that color. Make the board one color within the move limit. |
| <img src="docs/screenshots/pop_dark.png" width="90" alt="Pop, dark theme"> | <img src="docs/screenshots/pop_light.png" width="90" alt="Pop, light theme"> | **Pop** | Tap a group of touching same-colored bubbles to select it, tap again to pop it: n bubbles score n×(n−1). Modes: Standard, Shifter (rows slide right), Continuous (new columns roll in) and Mega (both). Goals: clear the board (Standard only, always possible), reach a target score, or free play for a best score. |
| <img src="docs/screenshots/merge_dark.png" width="90" alt="2048, dark theme"> | <img src="docs/screenshots/merge_light.png" width="90" alt="2048, light theme"> | **2048** | Slide the tiles and merge equal ones. Build the target tile (2048 on a hard 4×4), or play freely for a best score. New tiles come from the seed, so a share code replays the same game. |
| <img src="docs/screenshots/snake_dark.png" width="90" alt="Snake, dark theme"> | <img src="docs/screenshots/snake_light.png" width="90" alt="Snake, light theme"> | **Snake** | Steer the snake to the apples, grow longer and don't crash. Play for a best score or an apple target; the difficulty sets the speed. |

## Features

- **Endless puzzles.** Generation is seeded and deterministic, and runs in a background isolate.
- **Daily challenges.** Every day picks three games, each at every difficulty, the same for everyone. Results are kept in a calendar, and you can choose which games the days draw from.
- **Interactive tutorials.** Every game teaches its rules on a few tiny boards you play, ending with a small real one. Optional strategy lessons then show the techniques strong players use, each on a board that needs it.
- **Explain mode.** For every logic puzzle, the button next to Hint explains the next step in words ("E4 must be a crown, because…"), highlights the cells it talks about, and can play the step for you.
- **Share codes.** Every puzzle has a code (and a link on the web) that recreates it exactly.
- **Exactly one solution.** Most types are also graded by how deep the solver's logic has to go (easy, medium, hard, and expert for Sudoku).
- **Game options.** A puzzle can offer extra choices when you start a game, like Pop's mode and goal. They are part of the share code, and stats are kept per choice.
- **Variable grid sizes.** A size is only offered if it fits the screen, so there's no zooming.
- **Two input styles.** Tap a cell to cycle its values, or pick a value from a palette and stamp it. Slide across cells to mark them all in one go. Pencil marks are available where useful.
- **Notes done for you.** In Crowns, Campsite and Pairs, a long press dots every cell that the pieces you have placed already rule out.
- **Checked on submit.** Mistakes aren't highlighted while you play; live highlighting is an option in Settings.
- **Undo, redo, restart and hints.** There's a timer, and stats (best time, or best score for the score games) are kept per puzzle and difficulty.
- **Auto-save.** Leave at any time and continue where you stopped.
- **Move your progress.** Export wins, best times, daily results and saved games as a file or as text, and import them on another device; importing merges and never replaces.
- **Portrait and landscape.** Turn the phone or widen the window, and the board fills the height with the controls in a side panel.
- **A tidy home screen.** Search at the top, then your games (the ones you pinned and played last), the daily challenge and one tile per category (Numbers, Logic grids, Paths & loops, Casual). A category lists its games; games that are variants of one idea share a family page. Search finds games by name, by what you do in them ("draw a loop", "shade cells") in any of the four languages, and by other names the puzzles are known by; it forgives typos. Long-press a game, or use the pin on its new-game sheet, to pin it.
- **Animations.** Cells pop and fade, pipes rotate, colors flood, bubbles fall and slide, and solving plays a ripple with confetti.
- **Light and dark themes** (Material 3).
- **Four languages:** English, Ukrainian, Polish and German.
- **Release notes** in Settings, also in [RELEASE_NOTES.md](RELEASE_NOTES.md).

## Getting started

Requirements:
- **Flutter** stable 3.47 or newer, with Dart 3.13 or newer.
- **Android:** the Android SDK, with licenses accepted via `flutter doctor --android-licenses`.
- **Windows desktop:** Visual Studio 2022 with the *Desktop development with C++* workload, and Windows *Developer Mode* turned on (plugins need symlinks).

```bash
flutter pub get
```

```bash
flutter run -d windows
```

```bash
flutter run -d chrome
```

```bash
flutter build apk --release
```

## Tests

```bash
flutter analyze
```

```bash
flutter test
```

For every puzzle type, the generator tests check the following across sizes, difficulties and seeds:
- the solution is valid;
- the puzzle has exactly one solution;
- it can be solved at its target logic tier;
- generation is deterministic;
- generation is fast.

The screenshots above come from a snapshot harness, which renders every game screen at phone size (dark and light) to `build/snapshots/`:

```bash
flutter test test/snapshots --run-skipped --tags snapshot
```

## Architecture

```
lib/
  core/
    puzzle_type.dart      plug-in contract every puzzle implements
    value_grid.dart       base for "one value per cell" puzzles (input, palette, pencil marks, hints)
    lattice_loop.dart     shared loop solver for Fence, Pearls, Rails and Arrows
    latin_square.dart     shared Latin-square candidates, rules, generator and explainer (Skyline, Cages, Signs)
    game_controller.dart  session: state history (undo/redo), timer, submit, hints, save/resume, stats
    generator_runner.dart runs generation off the UI thread
    daily.dart            daily challenges
    tutorial.dart         tutorial and strategy steps
    explain.dart          explain mode: traced solver deductions turned into steps and texts
    backup.dart           progress export and import
    registry.dart         puzzle types, grouped into families and home-screen categories
    search.dart           game search: tags, other names, accent-insensitive word-prefix matching
  ui/                     home, category and family pages (browse_screens.dart), new-game sheet, game, daily, learn and settings screens, board widgets
  puzzles/<id>/           model, solver, generator, type, tutorial and explainer for each puzzle
  l10n/                   texts in four languages (ARB files)
test/                     generator and solver tests per puzzle, tutorial, explain and controller tests, snapshots
```

To add a puzzle:
1. Create `lib/puzzles/<id>/`.
2. Implement `PuzzleType` (or `ValueGridType` for tap-to-fill grids). This needs:
   - an immutable puzzle and state;
   - a sound solver that can count solutions;
   - a seeded generator;
   - a tutorial, and an explainer if the puzzle is solved by deduction.
3. Register the type in `lib/core/registry.dart` (in a family of a category), and give it search tags and any other names it is known by in `lib/core/search.dart`.
4. Add tests.
5. Add it to its group's table above, with a dark and a light screenshot in `docs/screenshots/`.

## Status

The Tetra and Skyline generators are currently limited to 7×7. At larger sizes, proving the solution is unique (Tetra) or grading a hard board (Skyline) is still too slow to do on the device.

## Credits

APuzzle was written with [Claude Code](https://claude.com/claude-code), using Anthropic's Claude Opus 5.5 model.

## License

[MIT](LICENSE) © 2026 Kirill Chekanov.
