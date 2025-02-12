local Sound = {}

local Waveforms = {
    sine = "sine",
    square = "square",
    saw = "saw",
    noise = "noise",
    pulse =  "pulse",
    organ = "organ",
    phaser = "phaser",
}

local Pitches = {
    -- Octave 2
    C2 = 65,    -- C-2
    Cs2 = 69,   -- C#2/Db2
    D2 = 73,    -- D-2
    Ds2 = 78,   -- D#2/Eb2
    E2 = 82,    -- E-2
    F2 = 87,    -- F-2
    Fs2 = 93,   -- F#2/Gb2
    G2 = 98,    -- G-2
    Gs2 = 104,  -- G#2/Ab2
    A2 = 110,   -- A-2
    As2 = 117,  -- A#2/Bb2
    B2 = 123,   -- B-2

    -- Octave 3
    C3 = 131,   -- C-3
    Cs3 = 139,  -- C#3/Db3
    D3 = 147,   -- D-3
    Ds3 = 156,  -- D#3/Eb3
    E3 = 165,   -- E-3
    F3 = 175,   -- F-3
    Fs3 = 185,  -- F#3/Gb3
    G3 = 196,   -- G-3
    Gs3 = 208,  -- G#3/Ab3
    A3 = 220,   -- A-3
    As3 = 233,  -- A#3/Bb3
    B3 = 247,   -- B-3

    -- Octave 4
    C4 = 262,   -- C-4
    Cs4 = 277,  -- C#4/Db4
    D4 = 294,   -- D-4
    Ds4 = 311,  -- D#4/Eb4
    E4 = 330,   -- E-4
    F4 = 349,   -- F-4
    Fs4 = 370,  -- F#4/Gb4
    G4 = 392,   -- G-4
    Gs4 = 415,  -- G#4/Ab4
    A4 = 440,   -- A-4
    As4 = 466,  -- A#4/Bb4
    B4 = 494,   -- B-4
}

function Sound:new()
    local obj = {
        sounds = {},
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Sound:add(id, noteSequence, multiplier)
    if #noteSequence == 0 then return end

    local speedMultiplier = math.max(0.5, math.min(multiplier, 5.0))
    local rate = 44100
    local totalSamples = 0
    local sequence = {}

    -- Preprocess each note: adjust duration to full cycles and compute effective duration.
    for _, note in ipairs(noteSequence) do
        local cycleDuration = 1 / note.freq
        local adjustedDuration = math.floor(note.duration / cycleDuration) * cycleDuration
        if adjustedDuration == 0 then adjustedDuration = cycleDuration end
        -- Scale the note duration by the speed multiplier (playing faster if multiplier > 1)
        local effectiveDuration = adjustedDuration / speedMultiplier
        local numSamples = math.floor(rate * effectiveDuration)
        totalSamples = totalSamples + numSamples
        table.insert(sequence, {
            wave = note.wave,
            freq = note.freq,
            duration = effectiveDuration,
            numSamples = numSamples,
            volume = note.volume or 1.0  -- Set the volume for the note (default 1.0)
        })
    end

    -- Create a new SoundData buffer for the whole melody.
    local soundData = love.sound.newSoundData(totalSamples, rate, 16, 1)
    local sampleIndex = 0

    -- For each note, generate its samples and append them into the overall SoundData.
    for _, note in ipairs(sequence) do
        for i = 0, note.numSamples - 1 do
            local t = i / rate  -- time (in seconds) within this note
            local sample = 0
            
            -- Waveform generation
            if note.wave == "sine" then
                sample = math.sin(2 * math.pi * note.freq * t)
            elseif note.wave == "square" then
                sample = (math.sin(2 * math.pi * note.freq * t) >= 0) and 1 or -1
            elseif note.wave == "saw" then
                sample = 2 * (t * note.freq - math.floor(t * note.freq + 0.5))
            elseif note.wave == "noise" then
                sample = love.math.random() * 2 - 1
            elseif note.wave == "pulse" then
                local duty = note.duty or 0.5
                local phase = (t * note.freq) % 1
                sample = (phase < duty) and 1 or -1
            elseif note.wave == "organ" then
                local fundamental = math.sin(2 * math.pi * note.freq * t)
                local secondHarmonic = 0.5 * math.sin(2 * math.pi * note.freq * 2 * t)
                local thirdHarmonic = 0.33 * math.sin(2 * math.pi * note.freq * 3 * t)
                sample = (fundamental + secondHarmonic + thirdHarmonic) / (1 + 0.5 + 0.33)
            elseif note.wave == "phaser" then
                local phaserSpeed = note.phaserSpeed or 0.5   -- LFO frequency in Hz
                local phaserDepth = note.phaserDepth or 0.5     -- Maximum phase offset (0-1)
                local lfo = math.sin(2 * math.pi * phaserSpeed * t)
                local phaseOffset = lfo * phaserDepth * math.pi -- Scale offset by pi
                sample = math.sin(2 * math.pi * note.freq * t + phaseOffset)
            end

            -- Optionally apply a very short fade-out at the end of each note
            local fadeSamples = math.floor(rate * 0.005)  -- 5ms fade-out
            local fadeFactor = 1
            if i >= note.numSamples - fadeSamples then
                fadeFactor = 1 - ((i - (note.numSamples - fadeSamples)) / fadeSamples)
            end

            -- Multiply sample by note.volume (and a constant factor 0.5 and fade factor)
            soundData:setSample(sampleIndex, sample * note.volume * 0.5 * fadeFactor)
            sampleIndex = sampleIndex + 1
        end
    end

    self.sounds[id] = love.audio.newSource(soundData, "static")
end

function Sound:play(id)    
    self.sounds[id]:play()
end

function Sound:stop(id)
    self.sounds[id]:stop()
end

return {
    Sound = Sound,
    Pitches = Pitches,
    Waveforms = Waveforms,
}