# Nonogram picture catalog

Nonogram puzzles are real pictures from four open icon libraries, not generated
boards. This tool turns the icons into a fixed catalog: each picture appears
once, at the smallest size that still reads, with a difficulty graded by the
game's own solver. It runs locally and offline, and its output is committed and
shipped with the game.

| Library | Mode | Licence |
|---|---|---|
| game-icons.net | mono | CC BY 3.0 |
| Material Symbols (filled) | mono | Apache 2.0 |
| Twemoji | colour | CC BY 4.0 |
| OpenMoji | colour | CC BY-SA 4.0 |

## Run

```bash
cd tools/nonogram && npm install && cd ../..
node tools/nonogram/render.mjs                    # ~20 min: candidates.jsonl
node tools/nonogram/judge.mjs --api=http://<host>:1234/v1 --model=qwen/qwen3.8-27b   # hours: judge.jsonl
dart run tools/nonogram/build.dart --since=2026-10-01 --dry-run   # report + review sheets only
node tools/nonogram/sheet.mjs                     # cache/sheet-<mode>-<difficulty>.png
dart run tools/nonogram/build.dart --since=2026-10-01             # writes catalog + assets
```

Add `--sample=100` (render) or `--limit=N` (judge) for quick looks.

## Stages

1. **render.mjs** renders each icon with resvg. It quantizes colour icons to at most
   4 colours and writes candidate grids to `cache/candidates.jsonl`: widths 5–15 (the judge only uses 7+)
   (heights up to 20), several scales, offsets and thresholds, each with a
   fidelity score (soft IoU against the render).
2. **judge.mjs** asks a vision model on an OpenAI-compatible server (LM Studio)
   whether the picture is recognisable:
   - **Multiple choice:** the real name plus 7 decoys. The probability of the
     right letter (from logprobs) is scored at 15 wide. The picture is dropped
     below 0.4. Otherwise a binary search finds the smallest width that reaches
     80% of that score.
   - **Blind naming** at that width: the model names the picture, then a
     text-only question checks that the name fits (e.g. "cow" for bison). If it
     doesn't fit, bigger widths are tried.

   Answers are cached in `cache/judge-answers.jsonl`, so reruns are cheap.
3. **build.dart** starts at the judged width. It keeps the first candidate that:
   - is still at least 7 wide after trimming empty border lines;
   - has a fill between 20% and 85%;
   - is solved by `NonogramSolver` (tier 1: line logic, tier 2: probing), which
     means it has exactly one solution.

   It then scores the difficulty (cells × deduction depth × probing) and sorts
   the picture into easy/medium/hard/expert by quantiles.

## Files

- `catalog.tsv` (committed): the source of truth. It is **append-only**: a
  picture's pool index is its share-code seed, and `since` gates which pictures
  dailies may use. Never reorder or delete rows. To retire a picture, keep its
  row and exclude it in the game.
- `params.json` (committed): the frozen difficulty cut-offs. `--rebucket`
  recomputes them and breaks old share codes, so only use it before release.
- `exclude.txt` (committed): ids (`twemoji:eyes`), whole sources, or prefixes
  (`material-symbols:format-*`) to leave out.
- `assets/nonogram/{mono,color}.bin` (shipped): the binary pools. The layout is
  in `encodeAsset`.
- `cache/` (ignored): renders, model answers, review pages and sheets.

## Status (paused, 2026-09-27)

The full judge run (Qwen 3.8 27B, ~5 GPU hours) is committed as
`cache/judge.jsonl`, so `build.dart` works after just re-running `render.mjs`
(deterministic). The last dry run kept 2,089 pictures (mono 1,114, colour 975,
about 250 per pool). Before writing the catalog:
- drop Material UI glyphs by name (add, list, box, chart, folder, docs, currency…);
- dedupe near-duplicates: same name across sources (prefer Twemoji), and similar
  pixels within a mode (face and wheelchair variants);
- drop colour pictures that are mostly thin one-cell lines (OpenMoji outlines);
- give the board a tinted empty colour, since very light palette colours vanish on white;
- pick the `--since` date, then run the build without `--dry-run`.
The game type itself (`lib/puzzles/nonogram/*_type.dart`, board, tutorial, ARB
texts, credits screen) isn't started; only the solver exists.
