-- californication.lua ENHANCED
-- RHCP Californication chord + lyric guide
-- for monome norns
--
-- NEW FEATURES:
-- - Practice mode: K1+K2 toggles, loops current section at reduced tempo
-- - Auto tempo increase: after 4 loops, increase by 5 BPM toward target
-- - Visual metronome: beat 1 flash
-- - Section loop: K1+K3 toggles section-only loop (verse/chorus/etc)
-- - Screen redesign: beat_phase, popup system, brightness hierarchy
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

  -- NEW: Screen state vars
  beat_phase = 0,      -- 0-3 for beat tracking
  popup_param = nil,   -- popup category
  popup_val = nil,     -- popup value
  popup_time = 0,      -- popup display timer

  -- Metronome state
  beat_flash = 0,

  -- NEW: Playback mode (sync to BPM)
  playback_mode = false,
  playback_clock = nil,
  playback_bpm = nil,

  -- NEW: Key transposition
  transpose = 0,        -- -12 to 12 semitones

  -- NEW: Scale highlighting (12 semitone pitch classes)
  scale_notes = {},
}

-- NEW: MIDI output for chord tones
local midi_out = nil

-- NEW: Helper to get scale notes from a key
local SCALE_OFFSETS = {
  C = {0,2,4,5,7,9,11},
  D = {2,4,5,7,9,11,0},
  E = {4,5,7,9,11,0,2},
  F = {5,7,9,11,0,2,4},
  G = {7,9,11,0,2,4,5},
  A = {9,11,0,2,4,5,7},
  B = {11,0,2,4,5,7,9},
  Am = {9,0,2,4,5,7,9},  -- A minor
}

local function get_scale_from_key(key_str)
  return SCALE_OFFSETS[key_str] or {0,2,4,5,7,9,11}
end

-- NEW: Send full chord tones as MIDI (root, 3rd, 5th, 7th)
local function send_chord_midi(chord_str)
  if not midi_out then return end
  -- Parse chord like "Am", "F", "C", etc.
  -- For now, send root + common intervals as MIDI notes
  local root_pc = 0  -- would need chord parsing
  if chord_str:match("^[A-G]") then
    local note_map = {C=0, D=2, E=4, F=5, G=7, A=9, B=11}
    root_pc = note_map[chord_str:sub(1,1)] or 0
  end

  -- Send root, 3rd, 5th, 7th
  local octave = 4
  local intervals = {0, 4, 7, 11}  -- major 7th
  for _, interval in ipairs(intervals) do
    local note = (octave * 12) + root_pc + interval + state.transpose
    midi_out:note_on(note, 80)
  end
end

-- ============================================================
--  PRACTICE MODE LOGIC
-- ============================================================

local practice_clock = nil

-- NEW: Playback mode using clock.sync and BPM
local function start_playback_mode()
  state.playback_mode = true
  state.playback_bpm = SONGS[state.song_idx].bpm

  if state.playback_clock then
    pcall(function() clock.cancel(state.playback_clock) end)
  end

  state.playback_clock = clock.run(function()
    while state.playback_mode do
      -- Sync to beat and auto-advance sections
      clock.sync(1)  -- sync to one beat

      -- Advance section after section.bars beats
      local section = SONGS[state.song_idx].sections[state.section_idx]
      local bars_to_wait = section and section.bars or 8

      -- After bars complete, move to next section
      state.loop_bars_counter = state.loop_bars_counter + 1
      if state.loop_bars_counter >= bars_to_wait then
        state.loop_bars_counter = 0
        state.section_idx = state.section_idx + 1
        if state.section_idx > #SONGS[state.song_idx].sections then
          state.section_idx = 1  -- loop back
        end
      end

      redraw()
    end
  end)
end

local function stop_playback_mode()
  state.playback_mode = false
  if state.playback_clock then
    pcall(function() clock.cancel(state.playback_clock) end)
    state.playback_clock = nil
  end
end

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
  -- NEW: Initialize MIDI output
  midi_out = midi.connect(1)

  redraw()

  -- Screen update loop for beat_phase
  clock.run(function()
    while true do
      state.beat_phase = (state.beat_phase + 1) % 4
      redraw()
      clock.sleep(1/10)  -- ~10fps
    end
  end)
end

function enc(n, d)
  if n == 1 then
    state.song_idx = util.clamp(state.song_idx + d, 1, #SONGS)
    state.section_idx = 1
    state.scroll_offset = 0
    stop_practice_mode()
    stop_playback_mode()
    state.popup_param = "SONG"
    state.popup_val = state.song_idx
    state.popup_time = 20
  elseif n == 2 then
    local s = SONGS[state.song_idx]
    state.section_idx = util.clamp(state.section_idx + d, 1, #s.sections)
    state.popup_param = "SECTION"
    state.popup_val = state.section_idx
    state.popup_time = 20
  elseif n == 3 then
    -- NEW: E3 controls transpose
    state.transpose = util.clamp(state.transpose + d, -12, 12)
    state.popup_param = "TRANSPOSE"
    state.popup_val = state.transpose
    state.popup_time = 20
  end
  redraw()
end

local k1_pressed_time = 0

function key(n, z)
  if n == 1 then
    if z == 1 then
      k1_pressed_time = util.time()
    else
      local held_duration = util.time() - k1_pressed_time
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
      -- K2 alone: prev song (or toggle playback mode)
      state.song_idx = util.clamp(state.song_idx - 1, 1, #SONGS)
      state.section_idx = 1
      stop_practice_mode()
      stop_playback_mode()
      state.popup_param = "SONG"
      state.popup_val = state.song_idx
      state.popup_time = 20
    end
    redraw()
  elseif n == 3 and z == 1 then
    local k1_held = (util.time() - k1_pressed_time) > 0.1
    if k1_held then
      -- K1+K3: toggle playback mode (auto sync to BPM)
      if state.playback_mode then
        stop_playback_mode()
      else
        start_playback_mode()
      end
      state.popup_param = "PLAYBACK"
      state.popup_val = state.playback_mode and "ON" or "OFF"
      state.popup_time = 20
    else
      -- K3 alone: next song
      state.song_idx = util.clamp(state.song_idx + 1, 1, #SONGS)
      state.section_idx = 1
      stop_practice_mode()
      stop_playback_mode()
      state.popup_param = "SONG"
      state.popup_val = state.song_idx
      state.popup_time = 20
    end
    redraw()
  end
end

-- ============================================================
--  SCREEN
-- ============================================================

function redraw()
  screen.clear()
  screen.aa(1)

  local s = SONGS[state.song_idx]
  local sec = s.sections[state.section_idx]

  -- ── STATUS STRIP ──────────────────────────────────────
  screen.level(4)
  screen.rect(0, 0, 128, 11)
  screen.fill()

  screen.level(15)
  screen.font_face(7)
  screen.font_size(8)
  screen.move(2, 8)
  screen.text("CALIFORNICATION")

  -- track number at level 6
  screen.level(6)
  screen.font_face(1)
  screen.font_size(5)
  screen.move(100, 8)
  screen.text(state.song_idx.."/"..#SONGS)

  -- beat pulse dot
  local beat_flash = (state.beat_phase % 4) < 2 and 12 or 4
  screen.level(beat_flash)
  screen.circle(120, 5, 2)
  screen.fill()

  -- NEW: Show playback mode indicator
  if state.playback_mode then
    screen.level(10)
    screen.font_size(5)
    screen.move(85, 8)
    screen.text("AUTO")
  end

  -- ── LIVE ZONE ─────────────────────────────────────────
  -- Track name at level 12 center
  screen.level(12)
  screen.font_face(7)
  screen.font_size(8)
  screen.move(0, 25)
  screen.text(s.title)

  -- Current section (VERSE/CHORUS/BRIDGE) at level 15
  screen.level(15)
  screen.font_face(7)
  screen.font_size(8)
  screen.move(0, 36)
  screen.text(sec.name)

  -- Chord progression for current section as blocks
  screen.level(10)
  screen.font_face(1)
  screen.font_size(5)
  screen.move(0, 46)
  local chords = sec.chords
  if #chords <= 35 then
    screen.text(chords)
  else
    screen.text(chords:sub(1, 35).."...")
  end

  -- Section loop indicator: progress bar at level 6
  if state.section_loop_mode then
    screen.level(6)
    screen.rect(0, 54, 128, 3)
    screen.stroke()
    
    local loop_progress = (state.loop_bars_counter / (sec.bars or 8)) * 128
    screen.level(12)
    screen.rect(0, 54, loop_progress, 3)
    screen.fill()
  end

  -- Practice mode: BPM ramp progress at level 8
  if state.practice_mode then
    screen.level(8)
    screen.font_face(1)
    screen.font_size(5)
    screen.move(0, 62)
    screen.text(string.format("%d -> %d BPM", state.practice_tempo, state.target_tempo))
  elseif state.playback_mode then
    -- Playback mode info
    screen.level(8)
    screen.font_face(1)
    screen.font_size(5)
    screen.move(0, 62)
    screen.text(string.format("PLAYING: %d BPM + Tr %d", s.bpm, state.transpose))
  else
    -- Context bar at level 6
    screen.level(6)
    screen.font_face(1)
    screen.font_size(5)
    screen.move(0, 62)
    screen.text(sec.name.." @ "..s.bpm.." BPM")
  end

  -- NEW: Scale highlighting - draw 12 chromatic notes
  if state.section_idx <= #s.sections then
    local scale = get_scale_from_key(s.key)
    state.scale_notes = scale
    screen.level(3)
    local note_spacing = 128 / 12
    for i = 0, 11 do
      local x = i * note_spacing + 2
      local in_scale = false
      for _, note_pc in ipairs(scale) do
        if note_pc == i then in_scale = true; break end
      end
      screen.level(in_scale and 10 or 3)
      screen.circle(x, 50, 1)
      screen.fill()
    end
  end

  -- Popup system
  if state.popup_param and state.popup_time > 0 then
    screen.level(15)
    screen.rect(20, 30, 90, 28)
    screen.fill()
    
    screen.level(0)
    screen.font_face(7)
    screen.font_size(8)
    screen.move(25, 40)
    screen.text(state.popup_param)
    
    screen.font_face(1)
    screen.font_size(7)
    screen.move(25, 52)
    screen.text(tostring(state.popup_val))
    
    state.popup_time = state.popup_time - 1
  end

  screen.update()
end

function cleanup()
  clock.cancel_all()
  stop_practice_mode()
  stop_playback_mode()
end