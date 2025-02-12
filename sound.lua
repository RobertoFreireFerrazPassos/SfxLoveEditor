local Sound = {}

function Sound:new()
    local obj = {
        sounds = {},
        currentSound = nil,
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
    self.currentSound = id
end

function Sound:stop()
    if self.currentSound then
        self.sounds[self.currentSound]:stop()
    end
    self.currentSound = nil
end

return Sound