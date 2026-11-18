# Testing Rocky Chunk Indicator

For people and agents who test the mod in the game. Read it before you use anything the mod adds.
Assume nothing about the mod when it is not installed: check `logs\rqmod.log` for
`Loading rocky-chunk-indicator` and the line `rocky-chunk-indicator: marks <cg> (full) and <cg> (faded)`.

## What it adds

- **A mark on the status page** (`rq.gamebutton` group `"status"`, `spot = "left"`): the control
  `rocky-chunk-indicator.mark` of the `status` screen, the button 100103 (or 100104 when another
  mod's left entry comes first), at x 20, y 90, 32 × 26. It is not a button: a click does nothing
  and plays no sound, the keys never land on it. Under the mouse it lights up as the buttons by
  the X do, and the game's comment window shows the title "Rocky Chunk" and:
  - character without the flag: "'<name>' has not consumed / the power of Rocky Chunk yet. / Equip
    one and learn Rock On: +10 skill points, once."
  - character with it: "'<name>' has already consumed / the power of Rocky Chunk. / Another Rocky
    Chunk gives no more skill points."
- **The flag:** `rq.ain.call("ＣＦＡ", iic, 36, -1) == 7`. The game sets it when the stats are
  worked out for a character who has Rock On (skill 312), and never clears it.
- **The question** (`rq.item.on_try_equip`): a Rocky Chunk (item 310) put on a character with the
  flag, from the vault's or the storage screen's equip list, the shop's rack or the status page's
  item list, shows the game's Yes/No dialog: "'<name>' already consumed Rocky Chunk's power.
  Another one gives no skill points. Equip it anyway?" (one run of text the dialog wraps, 3 lines
  even for Captain Vanilla Familiar), the cursor on No, with the "don't ask again" row (the mod's
  key `spent`). No (or a
  dialog that could not show) equips nothing and logs `rocky-chunk-indicator: a Rocky Chunk kept
  off <name>`; Yes goes on to the game's own questions. A character without the flag gets no
  question.

No keys or settings. Do not invent other controls.

## How to check it

1. Open a character's status page whose Rock On points were never given: the mark is faded.
   Hover it: the "not consumed" text.
2. Set the flag (`rq.ain.call("ＣＦＡ", iic, 36, 7)`, then `rq.statuspage.refresh()`), or learn
   Rock On with a chunk worn: the mark is full, the tip says "already consumed".
3. With the flag set, drag a Rocky Chunk (`rq.item.give(310)`) from the vault onto that character:
   the question shows. No: the chunk stays in the vault. Yes: it is equipped.
4. The same from the status page's item list (the Special slot).
5. On a character without the flag: no question, the chunk goes on.

## Forcing it for a test

`rq.mod.get("rocky-chunk-indicator")` returns `ROCKY_CHUNK`, `FULL` and `FADED` (the mark's CGs),
`consumed(iic)`, `tip(iic)` and `question(iic)` (the texts), and `mark` (the `rq.gamebutton`
handle).

## Tested in the game

The Test Lab's scenario `rocky-chunk` (with this mod installed): the loader's left spot and `icon` function, the
`rq.item.on_try_equip` places and what stops the attempt first, then the mod: both looks of the
mark and its tips, the question on the vault's drag and the status page's pick with No and Yes, no
question without the flag.
