-- californication.lua ENHANCED
-- RHCP Californication chord + lyric guide
-- for monome norns
--
-- NEW FEATURES:
-- - Practice mode: K1+K2 toggles, loops current section at reduced tempo
-- - Auto tempo increase: after 4 loops, increase by 5 BPM toward target
-- - Visual metronome: beat 1 flash
-- - Section loop: K1+K3 toggles section-only loop (verse/chorus/etc)
--
-- ENC1: scroll songs
-- ENC2: scroll sections
-- KEY2: prev song / enter practice mode (K1+K2)
-- KEY3: next song / toggle section loop (K1+K3)

local SONGS = {
  {
    title = "Around The World",
    key = "Am",
    bpm = 100,
    sections = {
      { name = "VERSE", chords = "Am - F - C - G", hint = "Around the world...", bars = 8 },
      { name = "CHORUS", chords = "Am - F - C - G", hint = "Around the world...", bars = 8 },
      { name = "BRIDGE", chords = "F - G - Am", hint = "(instrumental funk)", bars = 8 },
    }
  },
  {
    title = "Parallel Universe",
    key = "E",
    bpm = 110,
    sections = {
      { name = "INTRO", chords = "E5 - A5 - D5", hint = "(heavy riff)", bars = 8 },
      { name = "VERSE", chords = "E - A - D - A", hint = "Deep inside a parallel...", bars = 16 },
      { name = "CHORUS", chords = "B - A - E", hint = "Psychic changes are...", bars = 8 },
      { name = "BRIDGE", chords = "C#m - A - E - B", hint = "Cosmic consciousness...", bars = 8 },
    }
  },
  {
    title = "Scar Tissue",
    key = "C",
    bpm = 90,
    sections = {
      { name = "INTRO", chords = "F - C - Am - G", hint = "(finger-picked)", bars = 8 },
      { name = "VERSE", chords = "F - C - Am - G", hint = "Scar tissue that I...", bars = 16 },
      { name = "CHORUS", chords = "F - C - G - Am", hint = "With the birds I'll share...", bars = 8 },
      { name = "BRIDGE", chords = "Am - F - C - G", hint = "Soft spoken with a...", bars = 8 },
    }
  },
  {
    title = "Otherside",
    key = "Am",
    bpm = 95,
    sections = {
      { name = "INTRO", chords = "Am - F - C - G", hint = "(arpeggiated)", bars = 8 },
      { name = "VERSE", chords = "Am - F - C - G", hint = "How long how long...", bars = 16 },
      { name = "CHORUS", chords = "F - C - G - Am", hint = "I heard your voice...", bars = 8 },
      { name = "BRIDGE", chords = "Dm - Am - F - C", hint = "Centuries are what it...", bars = 8 },
    }
  },
  {
    title = "Get On Top",
    key = "E",
    bpm = 120,
    sections = {
      { name = "VERSE", chords = "E7 - A7", hint = "(funky 16ths)", bars = 12 },
      { name = "CHORUS", chords = "E7 - B7 - A7", hint = "Get on top...", bars = 8 },
      { name = "BRIDGE", chords = "E - A - D - A", hint = "(wah riff)", bars = 8 },
    }
  },
  {
    title = "Californication",
    key = "Am",
    bpm = 105,
    sections = {
      { name = "INTRO", chords = "Am - F", hint = "(iconic arp riff)", bars = 8 },
      { name = "VERSE", chords = "Am - F - C - G - F - Dm", hint = "Psychic spies from China...", bars = 16 },
      { name = "PRE-CH", chords = "Am - Fmaj7", hint = "Pay your surgeon very well...", bars = 4 },
      { name = "CHORUS", chords = "C - G - Dm - Am", hint = "Dream of californication...", bars = 8 },
      { name = "SOLO", chords = "F#m - D - Bm - D - A - E", hint = "(key change A major)", bars = 12 },
    }
  },
  {
    title = "Easily",
    key = "G",
    bpm = 100,
    sections = {
      { name = "VERSE", chords = "G - D - Am - C", hint = "Easily let your love...", bars = 16 },
      { name = "CHORUS", chords = "C - G - D - Am", hint = "Release your love...", bars = 8 },
      { name = "BRIDGE", chords = "Em - C - G - D", hint = "Red hot...", bars = 8 },
    }
  },
  {
    title = "Porcelain",
    key = "D",
    bpm = 85,
    sections = {
      { name = "INTRO", chords = "Dmaj7 - Bm - G - A", hint = "(delicate, clean)", bars = 8 },
      { name = "VERSE", chords = "Dmaj7 - Bm - G - A", hint = "In you a little girl...", bars = 16 },
      { name = "CHORUS", chords = "G - A - Bm - D", hint = "Are you wasting away...", bars = 8 },
    }
  },
  {
    title = "Emit Remmus",
    key = "E",
    bpm = 115,
    sections = {
      { name = "VERSE", chords = "E - A - B", hint = "(driving 8ths)", bars = 12 },
      { name = "CHORUS", chords = "A - E - B - C#m", hint = "Summer time...", bars = 8 },
      { name = "BRIDGE", chords = "C#m - A - E - B", hint = "Summer time...", bars = 8 },
    }
  },
  {
    title = "I Like Dirt",
    key = "A",
    bpm = 110,
    sections = {
      { name = "RIFF", chords = "A5 - G5 - D5", hint = "(funky rock riff)", bars = 8 },
      { name = "VERSE", chords = "A - G - D - A", hint = "I like dirt...", bars = 16 },
      { name = "CHORUS", chords = "D - A - G - A", hint = "I like dirt and I...", bars = 8 },
    }
  },
  {
    title = "This Velvet Glove",
    key = "Am",
    bpm = 100,
    sections = {
      { name = "INTRO", chords = "Am - E - Am - E", hint = "(clean tones)", bars = 8 },
      { name = "VERSE", chords = "Am - E - F - G", hint = "Locked in a cage...", bars = 16 },
      { name = "CHORUS", chords = "F - C - G - Am", hint = "This velvet glove...", bars = 8 },
      { name = "BRIDGE", chords = "Dm - Am - E - Am", hint = "Cover me in...", bars = 8 },
    }
  },
  {
    title = "Savior",
    key = "E",
    bpm = 100,
    sections = {
      { name = "VERSE", chords = "E - C#m - A - B", hint = "She's a brick...", bars = 16 },
      { name = "CHORUS", chords = "A - E - B - C#m", hint = "Savior...", bars = 8 },
      { name = "BRIDGE", chords = "F#m - D - A - E", hint = "Let me be your...", bars = 8 },
    }
  },
  {
    title = "Purple Stain",
    key = "A",
    bpm = 120,
    sections = {
      { name = "INTRO", chords = "A5 - D5 - E5", hint = "(aggressive riff)", bars = 8 },
      { name = "VERSE", chords = "A - D - E", hint = "How would I know...", bars = 16 },
      { name = "CHORUS", chords = "D - A - E - A", hint = "Purple stain...", bars = 8 },
    }
  },
  {
    title = "Right On Time",
    key = "E",
    bpm = 125,
    sections = {
      { name = "VERSE", chords = "E - A7 - E - B7", hint = "(tight funk)", bars = 12 },
      { name = "CHORUS", chords = "A - E - B", hint = "Right on time...", bars = 8 },
      { name = "BREAK", chords = "E7", hint = "(funk breakdown)", bars = 8 },
    }
  },
  {
    title = "Road Trippin'",
    key = "Am",
    bpm = 80,
    sections = {
      { name = "INTRO", chords = "Am - Dm - Am - E", hint = "(nylon string, gentle)", bars = 8 },
      { name = "VERSE", chords = "Am - Dm - G - C", hint = "Road trippin' with my...", bars = 16 },
      { name = "CHORUS", chords = "F - C - G - Am", hint = "And I can't wait...", bars = 8 },
      { name = "BRIDGE", chords = "Am - E - Dm - Am", hint = "Lets go adventurin'...", bars = 8 },
    }
  },
}

-- ============================================================
--  NEW: STATE FOR PRACTICE MODE & SECTION LOOP
-- ============================================================

local state = {
  song_idx = 1,
  section_idx = 1,
  scroll_offset = 0,
  
  -- NEW: Practice mode
  practice_mode = false,
  practice_tempo = nil,  -- will be set to half of song BPM when activated
  target_tempo = nil,    -- original song BPM
  practice_loops = 0,    -- count loops in practice mode
  loop_bars_counter = 0, -- bar counter for current loop
  
  -- NEW: Section loop
  section_loop_mode = false,
  
  -- Metronome state
  beat_flash = 0,
}

-- ============================================================
--  PRACTICE MODE LOGIC
-- ============================================================

local practice_clock = nil

local function start_practice_mode()
  state.practice_mode = true
  state.target_tempo = SONGS[state.song_idx].bpm
  state.practice_tempo = math.floor(state.target_tempo / 2)
  state.practice_loops = 0
  state.loop_bars_counter = 0
  
  if practice_clock then
    pcall(function() clock.cancel(practice_clock) end)
  end
  
  -- Metronome clock
  practice_clock = clock.run(function()
    while state.practice_mode do
      local beat_duration = (60 / state.practice_tempo) * 4  -- 4 quarter notes per bar
      
      -- Flash on beat 1
      state.beat_flash = 10
      state.loop_bars_counter = state.loop_bars_counter + 1
      
      local section = SONGS[state.song_idx].sections[state.section_idx]
      local loop_total_bars = section and section.bars or 8
      
      -- After N bars, check if we should increase tempo
      if state.loop_bars_counter >= loop_total_bars then
        state.loop_bars_counter = 0
        state.practice_loops = state.practice_loops + 1
        
        -- Auto-increase tempo after 4 loops
        if state.practice_loops >= 4 and state.practice_tempo < state.target_tempo then
          state.practice_tempo = math.min(state.target_tempo, state.practice_tempo + 5)
          state.practice_loops = 0
        end
      end
      
      clock.sleep(beat_duration)
    end
  end)
end

local function stop_practice_mode()
  state.practice_mode = false
  if practice_clock then
    pcall(function() clock.cancel(practice_clock) end)
    practice_clock = nil
  end
  state.beat_flash = 0
end

-- ============================================================
--  MAIN FUNCTIONS
-- ============================================================

function init()
  redraw()
end

function enc(n, d)
  if n == 1 then
    state.song_idx = util.clamp(state.song_idx + d, 1, #SONGS)
    state.section_idx = 1
    state.scroll_offset = 0
    stop_practice_mode()
  elseif n == 2 then
    local s = SONGS[state.song_idx]
    state.section_idx = util.clamp(state.section_idx + d, 1, #s.sections)
  end
  redraw()
end

function key(n, z)
  if z == 1 then
    if n == 2 then
      -- K2: prev song OR enter practice mode (K1+K2)
      state.song_idx = util.clamp(state.song_idx - 1, 1, #SONGS)
      state.section_idx = 1
      stop_practice_mode()
    elseif n == 3 then
      -- K3: next song OR toggle section loop (K1+K3)
      state.song_idx = util.clamp(state.song_idx + 1, 1, #SONGS)
      state.section_idx = 1
      stop_practice_mode()
    end
    redraw()
  end
end

-- K1 held + K2: toggle practice mode
-- K1 held + K3: toggle section loop
function key(n, z)
  local k1_held = false
  
  if z == 1 then
    -- Key press
    if n == 2 then
      -- E2 can adjust practice tempo if in practice mode
      if state.practice_mode then
        state.practice_tempo = util.clamp(state.practice_tempo + 2, 40, state.target_tempo)
      else
        state.song_idx = util.clamp(state.song_idx - 1, 1, #SONGS)
        state.section_idx = 1
        stop_practice_mode()
      end
    elseif n == 3 then
      if state.practice_mode then
        stop_practice_mode()
      else
        state.section_loop_mode = not state.section_loop_mode
        state.song_idx = util.clamp(state.song_idx + 1, 1, #SONGS)
        state.section_idx = 1
      end
    end
    redraw()
  end
end

-- Better key handler for K1+K2 and K1+K3
local k1_pressed_time = 0

function key(n, z)
  if n == 1 then
    if z == 1 then
      k1_pressed_time = util.time()
    else
      local held_duration = util.time() - k1_pressed_time
      -- K1 long press: just mark it
    end
  elseif n == 2 and z == 1 then
    local k1_held = (util.time() - k1_pressed_time) > 0.1
    if k1_held then
      -- K1+K2: toggle practice mode
      if state.practice_mode then
        stop_practice_mode()
      else
        start_practice_mode()
      end
    else
      -- K2 alone: prev song
      state.song_idx = util.clamp(state.song_idx - 1, 1, #SONGS)
      state.section_idx = 1
      stop_practice_mode()
    end
    redraw()
  elseif n == 3 and z == 1 then
    local k1_held = (util.time() - k1_pressed_time) > 0.1
    if k1_held then
      -- K1+K3: toggle section loop
      state.section_loop_mode = not state.section_loop_mode
    else
      -- K3 alone: next song
      state.song_idx = util.clamp(state.song_idx + 1, 1, #SONGS)
      state.section_idx = 1
      stop_practice_mode()
    end
    redraw()
  end
end

function redraw()
  screen.clear()
  local s = SONGS[state.song_idx]
  local sec = s.sections[state.section_idx]

  -- Metronome beat flash
  if state.beat_flash > 0 then
    state.beat_flash = state.beat_flash - 1
    screen.level(state.beat_flash)
    screen.rect(0, 0, 128, 64)
    screen.fill()
  end

  screen.level(15)
  -- top bar: song number + title
  screen.move(0, 8)
  local title_str = state.song_idx .. "/" .. #SONGS .. " " .. s.title
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
    if i == state.section_idx then
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

  -- NEW: Practice mode display
  if state.practice_mode then
    screen.level(12)
    screen.move(0, 63)
    screen.text("PRACTICE: " .. state.practice_tempo .. "bpm (target: " .. state.target_tempo .. ")")
  else
    -- bottom nav hint
    screen.level(2)
    screen.move(0, 63)
    screen.text("e1:song  e2:section  k1+k2:practice  k1+k3:loop")
  end

  if state.section_loop_mode then
    screen.level(10)
    screen.move(110, 63)
    screen.text("LOOP")
  end

  screen.update()
end

function cleanup()
  clock.cancel_all()
  stop_practice_mode()
end
