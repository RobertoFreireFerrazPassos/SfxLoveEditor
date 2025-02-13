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

local Pentatonic = {
    CMajor = {"C", "D", "E", "G", "A"},
    CsMajor = {"Cs", "Ds", "F", "Gs", "As"},
    DMajor = {"D", "E", "Fs", "A", "B"},
    DsMajor = {"Ds", "F", "G", "As", "C"},
    EMajor = {"E", "Fs", "Gs", "B", "Cs"},
    FMajor = {"F", "G", "A", "C", "D"},
    FsMajor = {"Fs", "Gs", "As", "Cs", "Ds"},
    GMajor = {"G", "A", "B", "D", "E"},
    GsMajor = {"Gs", "As", "C", "Ds", "F"},
    AMajor = {"A", "B", "Cs", "E", "Fs"},
    AsMajor = {"As", "C", "D", "F", "G"},
    BMajor = {"B", "Cs", "Ds", "Fs", "Gs"},
    CMinor = {"C", "Ds", "F", "G", "As"},
    CsMinor = {"Cs", "E", "Fs", "A", "B"},
    DMinor = {"D", "F", "G", "A", "C"},
    DsMinor = {"Ds", "Fs", "Gs", "As", "Cs"},
    EMinor = {"E", "G", "A", "B", "D"},
    FMinor = {"F", "Gs", "As", "C", "Ds"},
    FsMinor = {"Fs", "A", "B", "Cs", "E"},
    GMinor = {"G", "As", "C", "D", "F"},
    GsMinor = {"Gs", "B", "Cs", "Ds", "Fs"},
    AMinor = {"A", "C", "D", "E", "G"},
    AsMinor = {"As", "Cs", "Ds", "F", "Gs"},
    BMinor = {"B", "D", "E", "Fs", "A"}  
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

    -- Octave 5
    C5 = 523,   -- C-5
    Cs5 = 554,  -- C#5/Db5
    D5 = 587,   -- D-5
    Ds5 = 622,  -- D#5/Eb5
    E5 = 659,   -- E-5
    F5 = 698,   -- F-5
    Fs5 = 740,  -- F#5/Gb5
    G5 = 784,   -- G-5
    Gs5 = 831,  -- G#5/Ab5
    A5 = 880,   -- A-5
    As5 = 932,  -- A#5/Bb5
    B5 = 988    -- B-5
}

local Effects = {
    None = "None",
    Slide = "Slide",
    Vibrato = "Vibrato",
    Drop = "Drop",
    FadeIn = "FadeIn",
    FadeOut = "FadeOut",
    Arpeggio = "Arpeggio",
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

    local speedMultiplier = math.max(1, math.min(multiplier, 10))
    local rate = 44100
    local totalSamples = 0
    local sequence = {}

    for i, note in ipairs(noteSequence) do
        local prevNote = noteSequence[i - 1]  -- Get the previous note (if it exists)
        local nextNote = (i < #noteSequence) and noteSequence[i + 1] or note
        local cycleDuration = 1 / note.freq
        local adjustedDuration = math.floor(0.5 / cycleDuration) * cycleDuration
        if adjustedDuration == 0 then adjustedDuration = cycleDuration end
        local effectiveDuration = adjustedDuration / speedMultiplier
        local numSamples = math.floor(rate * effectiveDuration)
        totalSamples = totalSamples + numSamples

        table.insert(sequence, {
            wave = note.wave,
            freq = note.freq,
            duration = effectiveDuration,
            numSamples = numSamples,
            volume = note.volume or 1,
            effect = note.effect or 0,
            prevFreq = prevNote and prevNote.freq or note.freq,
            nextFreq = nextNote.freq,
        })
    end

    -- Create a new SoundData buffer
    local soundData = love.sound.newSoundData(totalSamples, rate, 16, 1)
    local sampleIndex = 0

    -- Generate samples for each note
    for _, note in ipairs(sequence) do
        for i = 0, note.numSamples - 1 do
            local t = i / rate
            local sample = 0
            local sampleVolume = note.volume
            local currentFreq = note.freq

            -- Apply effects
            if note.effect == Effects.Slide then
                currentFreq = note.prevFreq + (note.freq - note.prevFreq) * (i / note.numSamples)
            elseif note.effect == Effects.Vibrato then
                currentFreq = note.freq * (1 + 0.02 * math.sin(20 * math.pi * t))
            elseif note.effect == Effects.Drop then
                currentFreq = note.freq * (1 - (i / note.numSamples))
            elseif note.effect == Effects.FadeIn then
                sampleVolume = note.volume * (i / note.numSamples)
            elseif note.effect == Effects.FadeOut then
                sampleVolume = note.volume * (1 - (i / note.numSamples))
            elseif note.effect == Effects.Arpeggio then
                local arpCycle = (i / (note.numSamples / 3)) % 3
                if arpCycle < 1 then
                    currentFreq =  note.prevFreq
                elseif arpCycle < 2 then
                    currentFreq = note.freq
                else
                    currentFreq = note.nextFreq
                end
            end

            -- Waveform generation
            if note.wave == "sine" then
                sample = math.abs(math.sin(2 * math.pi * currentFreq * t))
                local step_size = 0.2
                sample = math.floor(sample / step_size + 0.5) * step_size
            elseif note.wave == "square" then
                sample = (math.sin(2 * math.pi * currentFreq * t) >= 0) and 1 or -1
            elseif note.wave == "saw" then
                sample = 2 * (t * currentFreq - math.floor(t * currentFreq + 0.5))
            elseif note.wave == "noise" then
                sample = love.math.random() * 2 - 1
            elseif note.wave == "pulse" then
                local duty = note.duty or 0.5
                local phase = (t * currentFreq) % 1
                sample = (phase < duty) and 1 or -1
            elseif note.wave == "organ" then
                local fundamental = math.sin(2 * math.pi * currentFreq * t)
                local secondHarmonic = 0.5 * math.sin(2 * math.pi * currentFreq * 2 * t)
                local thirdHarmonic = 0.33 * math.sin(2 * math.pi * currentFreq * 3 * t)
                sample = (fundamental + secondHarmonic + thirdHarmonic) / (1 + 0.5 + 0.33)
            elseif note.wave == "phaser" then
                local phaserSpeed = note.phaserSpeed or 0.5
                local phaserDepth = note.phaserDepth or 0.5
                local lfo = math.sin(2 * math.pi * phaserSpeed * t)
                local phaseOffset = lfo * phaserDepth * math.pi
                sample = math.sin(2 * math.pi * currentFreq * t + phaseOffset)
            end

            -- Fade out at the end of the note
            local fadeSamples = math.floor(rate * 0.005)
            local fadeFactor = 1
            if i >= note.numSamples - fadeSamples then
                fadeFactor = 1 - ((i - (note.numSamples - fadeSamples)) / fadeSamples)
            end

            -- Apply volume and fade effect
            soundData:setSample(sampleIndex, sample * sampleVolume * 0.5 * fadeFactor)
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
    Effects = Effects,
    Pentatonic = Pentatonic,
}