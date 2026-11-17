-- Rocky Chunk Indicator. On a character's status page, a Rocky Chunk at the top left: faded while
-- the character has not had the chunk's effect yet (Rock On's 10 skill points), full once it has,
-- and its tip says which. Putting a Rocky Chunk on a character who already had it asks first: a
-- second chunk gives no points.
--
-- The game's record: Rocky Chunk (item 310) lets its wearer learn Rock On (skill 312). Ｃ再計算 sets
-- ＣＦＡ(iic, 36) to 7 for a character who has Rock On and adds the 10 points once; the flag stays
-- after an ERASE, so it is the one sign that the chunk's power is spent.
-- Loader 2.58.0: rq.gamebutton's "status" spot "left" with icon as a function, rq.item.on_try_equip.

if not (rq.item.on_try_equip and rq.gamebutton) then
  error("rocky-chunk-indicator: loader 2.58.0 or newer needed")
end

local ROCKY_CHUNK = 310     -- the item
local FLAG, SPENT = 36, 7   -- ＣＦＡ(iic, 36) == 7: Rock On's points given
local ICON_CG = 6247        -- Rocky Chunk's own icon
local SIZE = 26             -- the left spot's cells are 32 × 26
local FADED_ALPHA = 90

local FULL = rq.image.compose("rocky-chunk-indicator:full",
  { { cg = ICON_CG, w = SIZE, h = SIZE } }, { w = SIZE, h = SIZE })
local FADED = rq.image.compose("rocky-chunk-indicator:faded",
  { { cg = ICON_CG, w = SIZE, h = SIZE, alpha = FADED_ALPHA } }, { w = SIZE, h = SIZE })

-- The chunk's power is spent on this character (roster slot).
local function consumed(iic)
  if math.type(iic) ~= "integer" or iic <= 0 then return false end
  local ok, v = pcall(rq.ain.call, "ＣＦＡ", iic, FLAG, -1)
  return ok and v == SPENT
end

local function name_of(iic)
  local ok, c = pcall(rq.chara.get, iic)
  return ok and type(c) == "table" and c.name or "This character"
end

local function tip(iic)
  local who = "'" .. name_of(iic) .. "'"
  if consumed(iic) then
    return who .. " has already consumed\nthe power of Rocky Chunk.\n"
      .. "Another Rocky Chunk gives no more skill points."
  end
  return who .. " has not consumed\nthe power of Rocky Chunk yet.\n"
    .. "Equip one and learn Rock On: +10 skill points, once."
end

-- One run of text: the dialog wraps it, and it stays within the 3 lines of one row even for the
-- game's longest name (Captain Vanilla Familiar); a 4th line would start a second row.
local function question(iic)
  return "'" .. name_of(iic) .. "' already consumed Rocky Chunk's power. "
    .. "Another one gives no skill points. Equip it anyway?"
end

-- The status page: the mark at the top left -------------------------------------------------------

local mark = rq.gamebutton.add({
  group = "status",
  spot = "left",
  id = "mark",
  label = "Rocky Chunk",
  icon = function(iic) return consumed(iic) and FULL or FADED end,
  tip = tip,
})

-- Equipping a chunk on a character whose power is spent ---------------------------------------------

rq.item.on_try_equip(function(ctx)
  if ctx.no ~= ROCKY_CHUNK or not consumed(ctx.iic) then return end
  local yes = rq.ui.confirm(question(ctx.iic), {
    cursor = "no",
    remember = "spent",
    remember_label = "Rocky Chunk on a character who already had its effect",
  })
  -- Not shown (another dialog was up): nothing is equipped, the player can try again.
  if yes ~= true then
    rq.log(("rocky-chunk-indicator: a Rocky Chunk kept off %s"):format(name_of(ctx.iic)))
    return false
  end
end)

rq.log(("rocky-chunk-indicator: marks %d (full) and %d (faded)"):format(FULL, FADED))

-- For the Lab.
return {
  ROCKY_CHUNK = ROCKY_CHUNK,
  FULL = FULL,
  FADED = FADED,
  consumed = consumed,
  tip = tip,
  question = question,
  mark = mark,
}
