-- californication.lua with OP-XY MIDI support
-- RHCP Californication album chord and lyric guide for norns
-- Internal synth with MollyThePoly

engine.name = "MollyThePoly"
local MollyThePoly = require "molly_the_poly/lib/molly_the_poly_engine"

local midi_out = midi.connect(1)

-- OP-XY MIDI helpers
local opxy_out = nil
local function opxy_note_on(note, vel)
  if opxy_out and params:get("opxy_enabled") == 2 then
    opxy_out:note_on(note, vel, params:get("opxy_channel"))
  end
end
local function opxy_note_off(note)
  if opxy_out and params:get("opxy_enabled") == 2 then
    opxy_out:note_off(note, 0, params:get("opxy_channel"))
  end
end
local function opxy_cc(cc, val)
  if opxy_out and params:get("opxy_enabled") == 2 then
    opxy_out:cc(cc, math.floor(util.clamp(val, 0, 127)), params:get("opxy_channel"))
  end
end

local function midi_to_hz(note)
  return 440 * 2^((note - 69) / 12)
end

local function clamp(x, lo, hi)
  if x < lo then return lo end
  if x > hi then return hi end
  return x
end

-- Song data: name, key, chords, sections with lyrics/chords
local SONGS = {
  {
    name = "By the Way",
    root = 0,
    sections = {
      {chord = "Am", intervals = {0, 3, 7}, lyrics = "City of Angels"},
      {chord = "Dm", intervals = {2, 5, 9}, lyrics = "take some time to dance"},
      {chord = "G", intervals = {7, 11, 14}, lyrics = "by the way"},
    }
  },
  {
    name = "Californication",
    root = 0,
    sections = {
      {chord = "Em", intervals = {0, 3, 7}, lyrics = "Psychic spies from China"},
      {chord = "Am", intervals = {0, 3, 7}, lyrics = "Try to steal your mind's elation"},
      {chord = "Em", intervals = {0, 3, 7}, lyrics = "Little girl from Sweden"},
    }
  },
  {
    name = "All Around the World",
    root = 5,
    sections = {
      {chord = "F", intervals = {5, 9, 12}, lyrics = "All around the world"},
      {chord = "Bbm", intervals = {10, 13, 17}, lyrics = "gotta settle down"},
      {chord = "C", intervals = {0, 4, 7}, lyrics = "with a love that's pure"},
    }
  },
  {
    name = "Scar Tissue",
    root = 0,
    sections = {
      {chord = "F#m", intervals = {9, 12, 16}, lyrics = "Scar tissue that I wish you saw"},
      {chord = "Bm", intervals = {2, 5, 9}, lyrics = "sarcastic mister know-it-all"},
      {chord = "Dmaj", intervals = {2, 6, 9}, lyrics = "close your eyes and I'll kiss you"},
    }
  },
  {
    name = "Otherside",
    root = 2,
    sections = {
      {chord = "D", intervals = {2, 6, 9}, lyrics = "How long, how long will I slide?"},
      {chord = "Gm", intervals = {7, 10, 14}, lyrics = "separate my side"},
      {chord = "A", intervals = {9, 13, 16}, lyrics = "I got you"},
    }
  },
  {
    name = "Get on Top",
    root = 0,
    sections = {
      {chord = "Gm", intervals = {7, 10, 14}, lyrics = "Every single one of us"},
      {chord = "Ebmaj", intervals = {3, 7, 10}, lyrics = "got a little light inside"},
      {chord = "Bb", intervals = {10, 14, 17}, lyrics = "Let it shine"},
    }
  },
}

local state = {
  song_idx = 1,
  section_idx = 1,
  playing_chord = nil,
  octave = 4,
}

local function engine_note_on(note, vel)
  local freq = midi_to_hz(note)
  engine.noteOn(note, freq, vel / 127)
end

local function engine_note_off(note)
  engine.noteOff(note)
end

local function note_on(note, vel)
  if midi_out then midi_out:note_on(note, vel, 1) end
  opxy_note_on(note, vel)
  engine_note_on(note, vel)
end

local function note_off(note)
  if midi_out then midi_out:note_off(note, 0, 1) end
  opxy_note_off(note)
  engine_note_off(note)
end

local function stop_chord()
  if state.playing_chord then
    for _, note in ipairs(state.playing_chord) do
      note_off(note)
    end
    state.playing_chord = nil
  end
end

local function play_chord(root, intervals)
  stop_chord()
  local notes = {}
  for _, interval in ipairs(intervals) do
    local note = root + interval + state.octave * 12
    note_on(note, 80)
    table.insert(notes, note)
  end
  state.playing_chord = notes
end

function redraw()
  screen.clear()
  screen.aa(0)

  local song = SONGS[state.song_idx]
  local section = song.sections[state.section_idx]

  -- ── Song title bar (top) ──
  screen.level(3)
  screen.rect(0, 0, 128, 11)
  screen.fill()
  screen.level(15)
  screen.font_face(1)
  screen.font_size(8)
  screen.move(2, 8)
  screen.text(song.name:upper())

  -- Song index dots (top right)
  for i = 1, #SONGS do
    screen.level(i == state.song_idx and 15 or 3)
    screen.circle(100 + (i - 1) * 5, 5, 1)
    screen.fill()
  end

  -- ── Large chord name, centered ──
  screen.level(15)
  screen.font_face(1)
  screen.font_size(22)
  screen.move(64, 35)
  screen.text_center(section.chord)

  -- ── Playing indicator (pulsing dot next to chord if sounding) ──
  if state.playing_chord then
    screen.level(12)
    screen.circle(10, 28, 3)
    screen.fill()
  end

  -- ── Section navigation: dots for each section ──
  local sec_count = #song.sections
  local sec_w = 80 / sec_count
  for i = 1, sec_count do
    local sx = 24 + (i - 1) * sec_w
    if i == state.section_idx then
      screen.level(15)
      screen.rect(sx, 40, sec_w - 2, 3)
      screen.fill()
    else
      screen.level(4)
      screen.rect(sx, 41, sec_w - 2, 1)
      screen.fill()
    end
  end

  -- ── Lyrics line (below chord) ──
  screen.level(6)
  screen.font_face(1)
  screen.font_size(8)
  screen.move(64, 52)
  screen.text_center(section.lyrics)

  -- ── Bottom bar: octave + output ──
  screen.level(3)
  screen.font_face(1)
  screen.font_size(8)
  screen.move(2, 62)
  screen.text("oct " .. state.octave)

  if params:get("opxy_enabled") == 2 then
    screen.level(5)
    screen.move(126, 62)
    screen.text_right("XY ch" .. params:get("opxy_channel"))
  end

  screen.update()
end

function enc(n, d)
  if n == 1 then
    -- E1: scroll songs
    local old_idx = state.song_idx
    state.song_idx = clamp(state.song_idx + d, 1, #SONGS)
    if state.song_idx ~= old_idx then
      state.section_idx = 1
      stop_chord()
    end
  elseif n == 2 then
    -- E2: scroll sections
    local song = SONGS[state.song_idx]
    state.section_idx = clamp(state.section_idx + d, 1, #song.sections)
    stop_chord()
  elseif n == 3 then
    -- E3: change octave
    state.octave = clamp(state.octave + d, 0, 7)
    -- Restart chord at new octave if playing
    if state.playing_chord then
      local song = SONGS[state.song_idx]
      local section = song.sections[state.section_idx]
      play_chord(song.root, section.intervals)
    end
  end
  redraw()
end

function key(n, z)
  local song = SONGS[state.song_idx]
  local section = song.sections[state.section_idx]
  
  if n == 2 and z == 1 then
    -- K2: previous song
    state.song_idx = clamp(state.song_idx - 1, 1, #SONGS)
    state.section_idx = 1
    stop_chord()
    redraw()
  elseif n == 3 and z == 1 then
    -- K3: play/stop chord (or next song if all sections played)
    if state.playing_chord then
      stop_chord()
    else
      play_chord(song.root, section.intervals)
    end
    redraw()
  end
end

function init()
  -- MollyThePoly sound params
  MollyThePoly.add_params()
  -- Warm chord preset
  params:set("osc_wave_shape", 0.3)
  params:set("lp_filter_cutoff", 2000)
  params:set("lp_filter_resonance", 0.15)
  params:set("env_2_attack", 0.01)
  params:set("env_2_decay", 0.8)
  params:set("env_2_sustain", 0.6)
  params:set("env_2_release", 1.0)

  params:add_separator("OP-XY")
  params:add_option("opxy_enabled", "OP-XY output", {"off", "on"}, 1)
  params:add_number("opxy_device", "OP-XY MIDI device", 1, 4, 1)
  params:add_number("opxy_channel", "OP-XY channel", 1, 8, 1)
  params:set_action("opxy_device", function(v) opxy_out = midi.connect(v) end)
  opxy_out = midi.connect(params:get("opxy_device"))

  redraw()
end

function cleanup()
  stop_chord()
  engine.noteKillAll()
  if midi_out then for ch=1,16 do midi_out:cc(123,0,ch) end end
  if opxy_out then for ch=1,16 do opxy_out:cc(123,0,ch) end end
end