# APuzzle

> ### ▶ [Play in your browser: jncchds.github.io/apuzzle](https://jncchds.github.io/apuzzle/)
> No install needed: the web version has every game, the daily challenges, the tutorials and explain mode, and it saves your progress in the browser.
>
> **Prefer an app?** Download it from the [latest release](https://github.com/jncchds/apuzzle/releases/latest): an `.apk` for Android and a `.zip` for Windows.

A collection of grid logic puzzles for Android, Windows, iOS and the web, built with Flutter.
Every puzzle is **generated on the device**, and a solver checks that it has **exactly one solution**.
Mines is solved by logic without guessing. The casual games (the color floods, Pop, 2048, Snake, Junction and the memory games), Formula, Homeward and Blockade are played for a move limit, a target or a best score instead; their limits and targets come from solver playthroughs or the board size, so they are always reachable (Homeward's fuel and Blockade's turns come from the exact shortest plan).
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
| <img src="docs/screenshots/solo_dark.png" width="90" alt="Solo, dark theme"> | <img src="docs/screenshots/solo_light.png" width="90" alt="Solo, light theme"> | **Solo** | Every cell holds a number. Shade some so that no number shows twice in a row or column. Shaded cells never touch side by side, the cells left stay in one piece, and a shaded number must still show in its row or column. |
| <img src="docs/screenshots/domino_dark.png" width="90" alt="Dominoes, dark theme"> | <img src="docs/screenshots/domino_light.png" width="90" alt="Dominoes, light theme"> | **Dominoes** | A full set of dominoes lies on the grid with the outlines rubbed off. Split the numbers into dominoes of two neighbouring cells so that every pair, from 0–0 up to the highest double, shows up exactly once. |
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
| <img src="docs/screenshots/fleet_dark.png" width="90" alt="Fleet, dark theme"> | <img src="docs/screenshots/fleet_light.png" width="90" alt="Fleet, light theme"> | **Fleet** | A fleet of straight ships hides in the grid, listed below it. Ships never touch, not even diagonally, the counts outside give the ship cells per row and column, and a few cells start shown: water or a ship piece whose shape tells where its ship goes on. |
| <img src="docs/screenshots/basins_dark.png" width="90" alt="Basins, dark theme"> | <img src="docs/screenshots/basins_light.png" width="90" alt="Basins, light theme"> | **Basins** | The grid is cut into basins. Fill them with water that settles from the bottom up to one level across each basin, so that every row and column holds the water count beside it. |
| <img src="docs/screenshots/islands_dark.png" width="90" alt="Islands, dark theme"> | <img src="docs/screenshots/islands_light.png" width="90" alt="Islands, light theme"> | **Islands** | Shade the sea. Every island holds one number equal to its size, islands never touch, and the sea is connected with no 2×2 pools. |
| <img src="docs/screenshots/lamps_dark.png" width="90" alt="Lamps, dark theme"> | <img src="docs/screenshots/lamps_light.png" width="90" alt="Lamps, light theme"> | **Lamps** | Place lamps that light their row and column up to the walls. Light every cell, never shine a lamp on another, and match the numbers on the walls. |
| <img src="docs/screenshots/orbits_dark.png" width="90" alt="Orbits, dark theme"> | <img src="docs/screenshots/orbits_light.png" width="90" alt="Orbits, light theme"> | **Orbits** | Give every star its own region. A region is one connected piece with its star in the exact middle, and it looks the same after half a turn around the star. |
| <img src="docs/screenshots/inlay_dark.png" width="90" alt="Inlay, dark theme"> | <img src="docs/screenshots/inlay_light.png" width="90" alt="Inlay, light theme"> | **Inlay** | Fit all the pieces from the tray into the shape, covering every cell with no overlaps. Pieces can be turned, and on hard boards flipped over too. Any way that fits them all wins. |
| <img src="docs/screenshots/mines_dark.png" width="90" alt="Mines, dark theme"> | <img src="docs/screenshots/mines_light.png" width="90" alt="Mines, light theme"> | **Mines** | Clear every cell without a mine. Numbers count the mines around them, and the start is chosen so that logic alone clears the board. |

### Paths & loops

Pipes and Channel are one family on the home screen, Plumbing.

| Dark | Light | Puzzle | Goal |
|---|---|---|---|
| <img src="docs/screenshots/trail_dark.png" width="90" alt="Trail, dark theme"> | <img src="docs/screenshots/trail_light.png" width="90" alt="Trail, light theme"> | **Trail** | Draw one path through every cell that passes the numbers in order. |
| <img src="docs/screenshots/links_dark.png" width="90" alt="Links, dark theme"> | <img src="docs/screenshots/links_light.png" width="90" alt="Links, light theme"> | **Links** | Join each pair of equal dots with a path. Paths never cross, and together they fill the whole grid. |
| <img src="docs/screenshots/labyrinth_dark.png" width="90" alt="Labyrinth, dark theme"> | <img src="docs/screenshots/labyrinth_light.png" width="90" alt="Labyrinth, light theme"> | **Labyrinth** | Walk through the maze from the top-left corner to the exit in the bottom-right corner. |
| <img src="docs/screenshots/homeward_dark.png" width="90" alt="Homeward, dark theme"> | <img src="docs/screenshots/homeward_light.png" width="90" alt="Homeward, light theme"> | **Homeward** | Drive the car along the roads to pick up every pet and bring it to the home with the same symbol. The car has only a few seats, every road costs fuel, and the fuel is just enough for a well-planned drive. |
| <img src="docs/screenshots/blockade_dark.png" width="90" alt="Blockade, dark theme"> | <img src="docs/screenshots/blockade_light.png" width="90" alt="Blockade, light theme"> | **Blockade** | Sail the boat to the harbour, one cell or one wait per turn. Patrol ships sail their drawn beats one cell after each of your turns: never end a turn on a ship's cell or swap places with one, and arrive within the turns you have. |
| <img src="docs/screenshots/pipes_dark.png" width="90" alt="Pipes, dark theme"> | <img src="docs/screenshots/pipes_light.png" width="90" alt="Pipes, light theme"> | **Pipes** | Rotate tiles until every pipe connects to the source, with no open ends and no loops. |
| <img src="docs/screenshots/channel_dark.png" width="90" alt="Channel, dark theme"> | <img src="docs/screenshots/channel_light.png" width="90" alt="Channel, light theme"> | **Channel** | Turn the tiles so that one pipe leads the water from the source to the drain. The other tiles don't matter and ends may stay open; water goes straight across a bridge, so the pipe can pass one twice. |
| <img src="docs/screenshots/atoms_dark.png" width="90" alt="Atoms, dark theme"> | <img src="docs/screenshots/atoms_light.png" width="90" alt="Atoms, light theme"> | **Atoms** | Connect atoms with single or double bonds that match their numbers. Bonds can't cross, and all atoms must end up connected. |
| <img src="docs/screenshots/fence_dark.png" width="90" alt="Fence, dark theme"> | <img src="docs/screenshots/fence_light.png" width="90" alt="Fence, light theme"> | **Fence** | Draw one loop along the grid lines. A number tells how many sides of its cell the loop uses. |
| <img src="docs/screenshots/pearls_dark.png" width="90" alt="Pearls, dark theme"> | <img src="docs/screenshots/pearls_light.png" width="90" alt="Pearls, light theme"> | **Pearls** | Draw one loop through the cell centres and every pearl: straight through white pearls (turning next to them), turning on black pearls (going straight next to them). |
| <img src="docs/screenshots/rails_dark.png" width="90" alt="Rails, dark theme"> | <img src="docs/screenshots/rails_light.png" width="90" alt="Rails, light theme"> | **Rails** | Lay one track from the entry on the left to the exit at the bottom. The counts outside the grid give the track cells per row and column, and given pieces are fixed. |
| <img src="docs/screenshots/arrows_dark.png" width="90" alt="Arrows, dark theme"> | <img src="docs/screenshots/arrows_light.png" width="90" alt="Arrows, light theme"> | **Arrows** | Shade some cells and draw one loop through all the others. Shaded cells never touch, and each arrow clue counts the shaded cells in its direction. |

### Casual

Mosaic and Blend are one family on the home screen, Flood; the memory games (Glimpse, Vanish, Hopper, Rebound) are another, Memory.

| Dark | Light | Puzzle | Goal |
|---|---|---|---|
| <img src="docs/screenshots/mosaic_dark.png" width="90" alt="Mosaic, dark theme"> | <img src="docs/screenshots/mosaic_light.png" width="90" alt="Mosaic, light theme"> | **Mosaic** | Flood the board with one color from the top-left corner, within the move limit. |
| <img src="docs/screenshots/blend_dark.png" width="90" alt="Blend, dark theme"> | <img src="docs/screenshots/blend_light.png" width="90" alt="Blend, light theme"> | **Blend** | Pick a color and repaint any patch; it merges with touching patches of that color. Make the board one color within the move limit. |
| <img src="docs/screenshots/pop_dark.png" width="90" alt="Pop, dark theme"> | <img src="docs/screenshots/pop_light.png" width="90" alt="Pop, light theme"> | **Pop** | Tap a group of touching same-colored bubbles to select it, tap again to pop it: n bubbles score n×(n−1). Modes: Standard, Shifter (rows slide right), Continuous (new columns roll in) and Mega (both). Goals: clear the board (Standard only, always possible), reach a target score, or free play for a best score. |
| <img src="docs/screenshots/merge_dark.png" width="90" alt="2048, dark theme"> | <img src="docs/screenshots/merge_light.png" width="90" alt="2048, light theme"> | **2048** | Slide the tiles and merge equal ones. Build the target tile (2048 on a hard 4×4), or play freely for a best score. New tiles come from the seed, so a share code replays the same game. |
| <img src="docs/screenshots/snake_dark.png" width="90" alt="Snake, dark theme"> | <img src="docs/screenshots/snake_light.png" width="90" alt="Snake, light theme"> | **Snake** | Steer the snake to the apples, grow longer and don't crash. Play for a best score or an apple target; the difficulty sets the speed. |
| <img src="docs/screenshots/junction_dark.png" width="90" alt="Junction, dark theme"> | <img src="docs/screenshots/junction_light.png" width="90" alt="Junction, light theme"> | **Junction** | Trains leave a tunnel one by one and run along a branching track. Tap the switches so each train reaches the station with its symbol. Route 20 trains, or as many as you can in two minutes; the difficulty sets the speed, how often trains leave and how many stations there are. |
| <img src="docs/screenshots/glimpse_dark.png" width="90" alt="Glimpse, dark theme"> | <img src="docs/screenshots/glimpse_light.png" width="90" alt="Glimpse, light theme"> | **Glimpse** | Some cells light up for a moment: tap them all from memory. A round you get right lights one more cell next time, a miss one fewer. Play 10 rounds for a best score, or until your third miss. |
| <img src="docs/screenshots/vanish_dark.png" width="90" alt="Vanish, dark theme"> | <img src="docs/screenshots/vanish_light.png" width="90" alt="Vanish, light theme"> | **Vanish** | Numbers from 1 up appear on the grid. Tap 1 and the others hide: tap their cells in order from memory. A round you get right shows one number more next time, a miss one fewer. |
| <img src="docs/screenshots/hopper_dark.png" width="90" alt="Hopper, dark theme"> | <img src="docs/screenshots/hopper_light.png" width="90" alt="Hopper, light theme"> | **Hopper** | A frog hops from pad to pad, one jump at a time; then tap the pads it landed on, in the same order or backwards (a game option). Each round you get right adds a jump, a miss takes one away. |
| <img src="docs/screenshots/rebound_dark.png" width="90" alt="Rebound, dark theme"> | <img src="docs/screenshots/rebound_light.png" width="90" alt="Rebound, light theme"> | **Rebound** | Remember the bumpers on the grid; once they hide, a ball rolls in at the arrow, and every bumper it meets turns it. Tap the edge where it leaves. Each round you get right adds a bumper, a miss takes one away. |

## Features

- **Endless puzzles.** Generation is seeded and deterministic, and runs in a background isolate.
- **Daily challenges.** Every day picks three games, each at every difficulty, the same for everyone. Results are kept in a calendar, and you can choose which games the days draw from.
- **Interactive tutorials.** Every game teaches its rules on a few tiny boards you play, ending with a small real one. Optional strategy lessons then show the techniques strong players use, each on a board that needs it.
- **Explain mode.** For every logic puzzle, the button next to Hint explains the next step in words ("E4 must be a crown, because…"), highlights the cells it talks about, and can play the step for you.
- **Memory games.** Glimpse, Vanish, Hopper and Rebound show something for a moment (or until you tap Ready), hides it, and asks for it back. Rounds get harder as you get them right and easier after a miss; play a set number of rounds or until your third miss, for a best score. Rounds come from the seed, so a share code replays the same game.
- **Real-time games.** Snake and Junction run on their own clock: they wait for your first move, pause with a tap (or when you leave the app), and draw everything that happens from the seed, so a share code replays the same game.
- **Share codes.** Every puzzle has a code (and a link on the web) that recreates it exactly.
- **Exactly one solution.** Most types are also graded by how deep the solver's logic has to go (easy, medium, hard, and expert for Sudoku).
- **Game options.** A puzzle can offer extra choices when you start a game, like Pop's mode and goal. They are part of the share code, and stats are kept per choice.
- **Variable grid sizes.** A size is only offered if it fits the screen, so there's no zooming.
- **Two input styles.** Tap a cell to cycle its values, or pick a value from a palette and stamp it. Slide across cells to mark them all in one go. Pencil marks are available where useful.
- **Notes done for you.** In Crowns, Campsite, Pairs and Fleet, a long press dots every cell that the pieces you have placed already rule out. In Basins it lets the water settle: it fills the cells below your water and marks the cells it can't reach dry.
- **Checked on submit.** Mistakes aren't highlighted while you play; live highlighting is an option in Settings.
- **Undo, redo, restart and hints.** There's a timer, and stats (best time, or best score for the score games) are kept per puzzle and difficulty.
- **Auto-save.** Leave at any time and continue where you stopped.
- **Move your progress.** Export wins, best times, daily results and saved games as a file or as text, and import them on another device; importing merges and never replaces.
- **Portrait and landscape.** Turn the phone or widen the window, and the board fills the height with the controls in a side panel.
- **A tidy home screen.** Search at the top, then your games (the ones you pinned and played last), the daily challenge and one tile per category (Numbers, Logic grids, Paths & loops, Casual). A category lists its games; games that are variants of one idea share a family page. Search finds games by name, by what you do in them ("draw a loop", "shade cells") in any of the four languages, and by other names the puzzles are known by; it forgives typos, and when nothing matches it shows the closest games, also by part of a word. Long-press a game, or use the pin on its new-game sheet, to pin it.
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
    recall.dart           shared rounds, levels, score and goals of the memory games (board in ui/board/recall_board.dart)
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
