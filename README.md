# Rocky Chunk Indicator

Shows on each character's status page whether they already had a Rocky Chunk's effect, and asks
before another chunk goes on a character who did.

## What it changes

A Rocky Chunk lets its wearer learn Rock On, which gives 10 skill points, once per character: a
second chunk on the same character gives nothing, and a chunk vanishes when taken off.

- **On the status page**, a small Rocky Chunk sits at the top left, under the class icon and left
  of "LV.":
  - **faded** while the character has not consumed the chunk's power yet;
  - **full** once they have (Rock On learned, even if it was erased later).
  - Under the mouse it says which: "'Alkanese Rize' has already consumed the power of Rocky Chunk."
- **Putting a Rocky Chunk on such a character** (a drag in the vault or the storage screen, the
  shop's rack, or the status page's item list) asks first: "'Alkanese Rize' already consumed Rocky
  Chunk's power. Another one gives no skill points. Equip it anyway?" No is the default; No keeps
  the chunk where it was. (Like any Rocky Chunk, one put on anyway disappears when taken off.)
- The question has the game's "don't ask again" row. Turned off, it can be turned back on in
  Config → Mods → Confirmations, or by Resetting Config's Confirmations tab.

## With other mods

- **Morurun Items, Loadouts:** their buttons stay by the X in the status page's title row; this
  mod's mark is in the other corner and takes none of their room.
- **Morurun's reset and Skill Again:** the game gives Rock On back to a character who had it, and
  the mark stays full.

## Keys and settings

None. The mark is not a button: clicking it does nothing, and the keys pass it by.

## Saves

Nothing is saved by the mod. It reads the game's own record of Rock On's points, so it is right for
saves made before it was installed.

## Install

Needs [RQ MOD](https://github.com/RQ-Modding/RQ-Mod) with loader **2.58.0** or newer. Extract the
release zip into the game's `mods` folder, so that you have `mods/rocky-chunk-indicator/mod.json`.

## How it works

The game marks a character whose Rock On points were given (`ＣＦＡ(iic, 36)` is 7, set in the
stats' update and kept after an ERASE). `rq.gamebutton`'s `"status"` group with `spot = "left"`
draws the mark, its `icon` and `tip` asked for the character shown; `rq.item.on_try_equip` asks
with `rq.ui.confirm` before a chunk goes on.

## License

MIT, see [LICENSE](LICENSE).
