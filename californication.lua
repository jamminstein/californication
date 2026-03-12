-- californication.lua
-- RHCP Californication chord + lyric guide
-- for monome norns
--
-- ENC1: scroll songs
-- ENC2: scroll sections
-- KEY2: prev song
-- KEY3: next song

local SONGS = {
  {
    title = "Around The World",
    key = "Am",
    sections = {
      { name = "VERSE", chords = "Am - F - C - G", hint = "Around the world..." },
      { name = "CHORUS", chords = "Am - F - C - G", hint = "Around the world..." },
      { name = "BRIDGE", chords = "F - G - Am", hint = "(instrumental funk)" },
    }
  },
  {
    title = "Parallel Universe",
    key = "E",
    sections = {
      { name = "INTRO", chords = "E5 - A5 - D5", hint = "(heavy riff)" },
      { name = "VERSE", chords = "E - A - D - A", hint = "Deep inside a parallel..." },
      { name = "CHORUS", chords = "B - A - E", hint = "Psychic changes are..." },
      { name = "BRIDGE", chords = "C#m - A - E - B", hint = "Cosmic consciousness..." },
    }
  },
  {
    title = "Scar Tissue",
    key = "C",
    sections = {
      { name = "INTRO", chords = "F - C - Am - G", hint = "(finger-picked)" },
      { name = "VERSE", chords = "F - C - Am - G", hint = "Scar tissue that I..." },
      { name = "CHORUS", chords = "F - C - G - Am", hint = "With the birds I'll share..." },
      { name = "BRIDGE", chords = "Am - F - C - G", hint = "Soft spoken with a..." },
    }
  },
  {
    title = "Otherside",
    key = "Am",
    sections = {
      { name = "INTRO", chords = "Am - F - C - G", hint = "(arpeggiated)" },
      { name = "VERSE", chords = "Am - F - C - G", hint = "How long how long..." },
      { name = "CHORUS", chords = "F - C - G - Am", hint = "I heard your voice..." },
      { name = "BRIDGE", chords = "Dm - Am - F - C", hint = "Centuries are what it..." },
    }
  },
  {
    title = "Get On Top",
    key = "E",
    sections = {
      { name = "VERSE", chords = "E7 - A7", hint = "(funky 16ths)" },
      { name = "CHORUS", chords = "E7 - B7 - A7", hint = "Get on top..." },
      { name = "BRIDGE", chords = "E - A - D - A", hint = "(wah riff)" },
    }
  },
  {
    title = "Californication",
    key = "Am",
    sections = {
      { name = "INTRO", chords = "Am - F", hint = "(iconic arp riff)" },
      { name = "VERSE", chords = "Am - F - C - G - F - Dm", hint = "Psychic spies from China..." },
      { name = "PRE-CH", chords = "Am - Fmaj7", hint = "Pay your surgeon very well..." },
      { name = "CHORUS", chords = "C - G - Dm - Am", hint = "Dream of californication..." },
      { name = "SOLO", chords = "F#m - D - Bm - D - A - E", hint = "(key change A major)" },
    }
  },
  {
    title = "Easily",
    key = "G",
    sections = {
      { name = "VERSE", chords = "G - D - Am - C", hint = "Easily let your love..." },
      { name = "CHORUS", chords = "C - G - D - Am", hint = "Release your love..." },
      { name = "BRIDGE", chords = "Em - C - G - D", hint = "Red hot..." },
    }
  },
  {
    title = "Porcelain",
    key = "D",
    sections = {
      { name = "INTRO", chords = "Dmaj7 - Bm - G - A", hint = "(delicate, clean)" },
      { name = "VERSE", chords = "Dmaj7 - Bm - G - A", hint = "In you a little girl..." },
      { name = "CHORUS", chords = "G - A - Bm - D", hint = "Are you wasting away..." },
    }
  },
  {
    title = "Emit Remmus",
    key = "E",
    sections = {
      { name = "VERSE", chords = "E - A - B", hint = "(driving 8ths)" },
      { name = "CHORUS", chords = "A - E - B - C#m", hint = "Summer time..." },
      { name = "BRIDGE", chords = "C#m - A - E - B", hint = "Summer time..." },
    }
  },
  {
    title = "I Like Dirt",
    key = "A",
    sections = {
      { name = "RIFF", chords = "A5 - G5 - D5", hint = "(funky rock riff)" },
      { name = "VERSE", chords = "A - G - D - A", hint = "I like dirt..." },
      { name = "CHORUS", chords = "D - A - G - A", hint = "I like dirt and I..." },
    }
  },
  {
    title = "This Velvet Glove",
    key = "Am",
    sections = {
      { name = "INTRO", chords = "Am - E - Am - E", hint = "(clean tones)" },
      { name = "VERSE", chords = "Am - E - F - G", hint = "Locked in a cage..." },
      { name = "CHORUS", chords = "F - C - G - Am", hint = "This velvet glove..." },
      { name = "BRIDGE", chords = "Dm - Am - E - Am", hint = "Cover me in..." },
    }
  },
  {
    title = "Savior",
    key = "E",
    sections = {
      { name = "VERSE", chords = "E - C#m - A - B", hint = "She's a brick..." },
      { name = "CHORUS", chords = "A - E - B - C#m", hint = "Savior..." },
      { name = "BRIDGE", chords = "F#m - D - A - E", hint = "Let me be your..." },
    }
  },
  {
    title = "Purple Stain",
    key = "A",
    sections = {
      { name = "INTRO", chords = "A5 - D5 - E5", hint = "(aggressive riff)" },
      { name = "VERSE", chords = "A - D - E", hint = "How would I know..." },
      { name = "CHORUS", chords = "D - A - E - A", hint = "Purple stain..." },
    }
  },
  {
    title = "Right On Time",
    key = "E",
    sections = {
      { name = "VERSE", chords = "E - A7 - E - B7", hint = "(tight funk)" },
      { name = "CHORUS", chords = "A - E - B", hint = "Right on time..." },
      { name = "BREAK", chords = "E7", hint = "(funk breakdown)" },
    }
  },
  {
    title = "Road Trippin'",
    key = "Am",
    sections = {
      { name = "INTRO", chords = "Am - Dm - Am - E", hint = "(nylon string, gentle)" },
      { name = "VERSE", chords = "Am - Dm - G - C", hint = "Road trippin' with my..." },
      { name = "CHORUS", chords = "F - C - G - Am", hint = "And I can't wait..." },
      { name = "BRIDGE", chords = "Am - E - Dm - Am", hint = "Lets go adventurin'..." },
    }
  },
}

-- state
local song_idx = 1
local section_idx = 1
local scroll_offset = 0

function init()
  -- nothing needed
end

function enc(n, d)
  if n == 1 then
    song_idx = util.clamp(song_idx + d, 1, #SONGS)
    section_idx = 1
    scroll_offset = 0
  elseif n == 2 then
    local s = SONGS[song_idx]
    section_idx = util.clamp(section_idx + d, 1, #s.sections)
  end
  redraw()
end

function key(n, z)
  if z == 1 then
    if n == 2 then
      song_idx = util.clamp(song_idx - 1, 1, #SONGS)
      section_idx = 1
    elseif n == 3 then
      song_idx = util.clamp(song_idx + 1, 1, #SONGS)
      section_idx = 1
    end
    redraw()
  end
end

function redraw()
  screen.clear()
  local s = SONGS[song_idx]
  local sec = s.sections[section_idx]

  -- top bar: song number + title
  screen.level(15)
  screen.move(0, 8)
  local title_str = song_idx .. "/" .. #SONGS .. " " .. s.title
  -- truncate if too long
  if string.len(title_str) > 21 then
    title_str = string.sub(title_str, 1, 20) .. "~"
  end
  screen.text(title_str)

  -- key indicator
  screen.level(5)
  screen.move(110, 8)
  screen.text("k:" .. s.key)

  -- divider
  screen.level(3)
  screen.move(0, 11)
  screen.line(128, 11)
  screen.stroke()

  -- section tabs row
  local tab_x = 0
  for i, sec_item in ipairs(s.sections) do
    if i == section_idx then
      screen.level(15)
      -- highlight box
      local w = string.len(sec_item.name) * 4 + 4
      screen.rect(tab_x, 13, w, 8)
      screen.fill()
      screen.level(0)
    else
      screen.level(6)
    end
    screen.move(tab_x + 2, 20)
    screen.text(sec_item.name)
    local w = string.len(sec_item.name) * 4 + 4
    tab_x = tab_x + w + 2
    if tab_x > 100 then break end -- overflow guard
  end

  -- divider
  screen.level(3)
  screen.move(0, 24)
  screen.line(128, 24)
  screen.stroke()

  -- chord progression (big, bright)
  screen.level(15)
  screen.font_size(8)
  -- wrap chords if long
  local chords = sec.chords
  screen.move(0, 35)
  if string.len(chords) <= 21 then
    screen.text(chords)
  else
    -- split at " - " midpoint
    local mid = math.floor(#chords / 2)
    local split = chords:find(" - ", mid) or mid
    screen.text(string.sub(chords, 1, split - 1))
    screen.move(0, 44)
    screen.level(13)
    screen.text(string.sub(chords, split + 1))
  end

  -- hint / lyric cue
  screen.level(5)
  screen.font_size(8)
  screen.move(0, 55)
  local hint = sec.hint
  if string.len(hint) > 23 then
    hint = string.sub(hint, 1, 22) .. "~"
  end
  screen.text(hint)

  -- bottom nav hint
  screen.level(2)
  screen.move(0, 63)
  screen.text("e1:song  e2:section  k2/k3")

  screen.update()
end

function cleanup()
  clock.cancel_all()
  if g then g:all(0); g:refresh() end
  if m then
    for ch = 1, 16 do
      m:cc(123, 0, ch)
      m:cc(120, 0, ch)
    end
  end
end
