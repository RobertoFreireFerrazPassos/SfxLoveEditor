local Sound = {}

function Sound:new()
    local obj = {
        sources = {},
        currentSound = nil,
        sequence = {},
        currentIndex = 1,
        timer = 0,
        isPlayingSequence = false,
        speedMultiplier = 1.0  -- Default playback speed
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Sound:generateSound(waveType, freq, duration)
    local rate = 44100
    local numSamples = math.floor(rate * duration)
    local soundData = love.sound.newSoundData(numSamples, rate, 16, 1)

    for i = 0, numSamples - 1 do
        local t = i / rate
        local sample = 0
        
        -- Waveform generation
        if waveType == "sine" then
            sample = math.sin(2 * math.pi * freq * t)
        elseif waveType == "square" then
            sample = (math.sin(2 * math.pi * freq * t) >= 0) and 1 or -1
        elseif waveType == "saw" then
            sample = 2 * (t * freq - math.floor(t * freq + 0.5))
        elseif waveType == "noise" then
            sample = love.math.random() * 2 - 1
        end

        -- Apply fade-out effect: volume decreases towards the end of the sound
        local fadeOutStart = numSamples - (rate * 0.1)  -- Start fading out 0.1 seconds before the end
        local fadeFactor = 1
        
        if i >= fadeOutStart then
            fadeFactor = 1 - ((i - fadeOutStart) / (numSamples - fadeOutStart))
        end
        
        soundData:setSample(i, sample * 0.5 * fadeFactor) -- Volume control with fade-out
    end
    
    return soundData
end

function Sound:play(waveType, freq, duration, loop)
    local soundData = self:generateSound(waveType, freq, duration)
    local source = love.audio.newSource(soundData, "static")
    source:setLooping(loop or false)
    source:play()
    
    self.currentSound = source
    table.insert(self.sources, source)
end

function Sound:stop()
    if self.currentSound then
        self.currentSound:stop()
    end
    self.isPlayingSequence = false
    self.currentIndex = 1
    self.sequence = {}
end

function Sound:playSequence(noteSequence, multiplier)
    if #noteSequence == 0 then return end

    self.sequence = {}
    self.speedMultiplier = math.max(0.5, math.min(multiplier, 5.0))

    -- Adjust each note's duration to fit full cycles
    for _, note in ipairs(noteSequence) do
        local cycleDuration = 1 / note.freq
        local adjustedDuration = math.floor(note.duration / cycleDuration) * cycleDuration
        if adjustedDuration == 0 then adjustedDuration = cycleDuration end  -- Ensure at least one cycle

        table.insert(self.sequence, {
            wave = note.wave,
            freq = note.freq,
            duration = adjustedDuration
        })
    end

    self.currentIndex = 1
    self.timer = 0
    self.isPlayingSequence = true
end

function Sound:update(dt)
    if self.isPlayingSequence and #self.sequence > 0 then
        self.timer = self.timer - (dt * self.speedMultiplier)  -- Adjust timing by speed
        if self.timer <= 0 then
            local note = self.sequence[self.currentIndex]
            self:play(note.wave, note.freq, note.duration)
            self.timer = note.duration / self.speedMultiplier  -- Adjust duration by speed
            self.currentIndex = self.currentIndex + 1

            if self.currentIndex > #self.sequence then
                self.isPlayingSequence = false
            end
        end
    end
end

return Sound