local Sound = {}

function Sound:new()
    local obj = {
        sources = {},
        currentSound = nil
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Sound:generateSound(waveType, freq, duration)
    local rate = 44100
    local length = duration or 0.25
    local numSamples = math.floor(rate * length)
    local soundData = love.sound.newSoundData(numSamples, rate, 16, 1)
    
    for i = 0, numSamples - 1 do
        local t = i / rate
        local sample = 0
        
        if waveType == "sine" then
            sample = math.sin(2 * math.pi * freq * t)
        elseif waveType == "square" then
            sample = (math.sin(2 * math.pi * freq * t) >= 0) and 1 or -1
        elseif waveType == "saw" then
            sample = 2 * (t * freq - math.floor(t * freq + 0.5))
        elseif waveType == "noise" then
            sample = love.math.random() * 2 - 1
        end
        
        soundData:setSample(i, sample * 0.5) -- Volume control
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
end

return Sound
