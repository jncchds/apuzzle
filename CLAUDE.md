# APuzzle

A Flutter collection of grid logic puzzles, generated on the device. Package: `ua.pp.chds.apuzzle`.
Platforms: Android (the priority), Windows desktop (the main dev loop), web, iOS.

## Commands
Run them through the output condenser (see the global CLAUDE.md):
- `node ~/.claude/tools/run.mjs flutter analyze`
- `node ~/.claude/tools/run.mjs flutter test`
- `node ~/.claude/tools/run.mjs flutter build web --debug`, then preview with the `web` launch config (`tools/serve.mjs` serves `build/web` on :8080)
- `flutter run -d windows` (needs VS 2022 with the C++ workload, plus Developer Mode for plugin symlinks)
- Visual snapshots of every puzzle (phone size, dark and light) go to `build/snapshots/*.png`; view the PNGs afterwards:
  `node ~/.claude/tools/run.mjs flutter test test/snapshots --run-skipped --tags snapshot`
  (The in-app browser pane crops screenshots on high-DPI displays, so prefer these PNGs for layout checks.)
- Generator timings (all types, or `BENCH_TYPES=kings,lits`): `flutter test test/bench/generator_bench_test.dart --run-skipped --tags bench -r expanded`
- Per-type probes (time plus achieved tier/uniqueness): `PROBE=trail PROBE_SIZES=6,8,10 flutter test test/bench/probe_test.dart --run-skipped --tags bench -r expanded`

## Architecture
- `lib/core/puzzle_type.dart`: the `PuzzleType<P, S>` plug-in contract. P is the immutable puzzle (clues and solution), S is the immutable play state.
- `lib/core/value_grid.dart`:
  - `ValueGridType` is the base for "one value per cell" puzzles. It gives you:
    - the board, cycle/palette input, pencil marks and palette;
    - hints and state serialization.
  - Subclasses supply `values`, rules (`isSolved`, `conflicts`), `generate`, and optionally `buildOverlay`, `cellColor` and `buildValue`.
- `lib/core/game_controller.dart`: the generic session. It handles:
  - undo/redo (full-state snapshots), timer, submit/hint;
  - saving and resuming (shared_preferences), and win detection and stats.
- `lib/core/generator_runner.dart`: runs `type.generate(params)` via `compute`, which is an isolate on native platforms.
- `lib/ui/board/cell_grid_board.dart`: a fit-to-screen grid with no zoom, and the win ripple. `cell_tile.dart` is the standard animated cell.
- `lib/core/registry.dart`: register new types here.

## Adding a puzzle type
1. Create `lib/puzzles/<id>/`, containing:
   - `<id>_model.dart`: the puzzle plus a pure rule check;
   - `<id>_solver.dart`: tiered, sound deductions plus `countSolutions(limit: 2)`;
   - `<id>_generator.dart`: random solution → strip clues while still solvable at the difficulty's tier;
   - `<id>_type.dart`.
2. Generation must be deterministic for a given `GenParams.seed`, and pure, because it runs in an isolate. Types must be `const`.
3. Add it to `puzzleTypes` in `registry.dart`.
4. Add tests in `test/puzzles/<id>/`. Across seeds, sizes and difficulties, check that:
   - the solution is valid;
   - the puzzle has exactly one solution;
   - it is solvable at its tier;
   - generation is deterministic and fast.

## UX rules (from the user)
- No live error highlighting by default (a setting turns it on). Validation happens on Submit, and the game auto-wins when it's complete and correct.
- No zoom. Sizes are capped by `fittingSizes()` (a 36px minimum cell).
- Grid size is variable in every game. Input supports both tap-to-cycle and palette stamping, with pencil marks where useful.
- Use our own puzzle names and art, not LinkedIn's or the source app's (Tango, Queens, Zip, Mambo, Kings, …).

The full plan and puzzle rules are in `C:\Users\check\.claude\plans\hello-i-want-to-hazy-neumann.md`.

## Puzzle types (lib/puzzles/<id>)
| id | name | base | notes |
|----|------|------|-------|
| mambo | Sun & Moon | ValueGridType | tiers: propagation / probing |
| sudoku | Sudoku | ValueGridType | 4/6/9, pencil marks (auto-removal is a setting, off by default), peer + same-value highlight, tiers: singles / locked+pairs / unique-only |
| kings | Crowns | ValueGridType | balanced regions + counterexample repair for uniqueness, then `RegionSearch` (lib/core/region_search.dart) tunes borders to the target logic tier |
| hues | Hues | ValueGridType | 8-neighbour same-colour counts of blank cells; numbers count down as matching cells are painted |
| mosaic | Mosaic | PuzzleType | flood-it, limit = greedy plan + slack |
| blend | Blend | PuzzleType | free flood-it (repaint any patch), limit = best of 4 greedy runs + slack |
| pipes | Pipes | PuzzleType | spanning tree, rule-based win (any valid tree) |
| shikaku | Shikaku | PuzzleType | drag rectangles; local search moves numbers inside their rectangles to reach the tier |
| trail | Trail | PuzzleType | Hamiltonian path; sound edge logic (`trail_logic.dart`) adds waypoints where it stalls, so no path search; up to 10×10 |
| atoms | Atoms | PuzzleType | Hashi bridges; sound interval solver |
| lits | LITS | ValueGridType | regions grown cell by cell keeping the solution unique (monotone, so rejected pairs are never retried); capped at 7×7 (8×8 takes 1–5 s) |

## Known follow-ups
- A faster LITS uniqueness check (or logic-tier construction) to re-enable 8×8+ boards.
- Kings easy (tier 1) on 10×10 often lands on tier 2–3; tier-1 logic is very weak on big boards.
- LITS difficulty is only a region-shape knob (no logic-tier grading yet).
