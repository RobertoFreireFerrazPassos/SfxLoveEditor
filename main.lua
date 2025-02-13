-- alt + l
-- compact all files in same level as file main.lua to zip file and rename to .love extension

local sfx = require("sfx")
local Sound = sfx.Sound
local pitches = sfx.Pitches
local Waveforms = sfx.Waveforms
local Effects = sfx.Effects
local Pentatonic = sfx.Pentatonic

function love.load()
    soundPlayer = Sound:new()
    local wave = Waveforms.square

    melody = {
        { wave = wave, freq = pitches.C4, volume = 1.0 },
        { wave = wave, freq = pitches.C4, volume = 1.0 },
        { wave = wave, freq = pitches.G4, volume = 1.0 },
        { wave = wave, freq = pitches.G4, volume = 0.6, effect = Effects.FadeOut },
        { wave = wave, freq = pitches.A4, volume = 0.6, effect = Effects.None },
        { wave = wave, freq = pitches.A4, volume = 0.4 },
        { wave = wave, freq = pitches.G4, volume = 0.4 },
    
        { wave = wave, freq = pitches.F4, volume = 1.0 },
        { wave = wave, freq = pitches.F4, volume = 0.2 }, 
        { wave = wave, freq = pitches.E4, volume = 0.2, effect = Effects.Drop },
        { wave = wave, freq = pitches.E4, volume = 1.0 },
        { wave = wave, freq = pitches.D4, volume = 1.0, effect = Effects.Slide },
        { wave = wave, freq = pitches.D4, volume = 1.0 },
        { wave = wave, freq = pitches.C4, volume = 1.0, effect = Effects.Arpeggio },
    }
    
    jump_sfx = {
        { wave = wave, freq = pitches.G3, volume = 1.0},
        { wave = wave, freq = pitches.D4, volume = 1.0 },
        { wave = wave, freq = pitches.F4, volume = 0.2 },
        { wave = wave, freq = pitches.A4, volume = 0.2 }
    }
    
    die_sfx = {
        { wave = wave, freq = pitches.B2, volume = 1.0, effect = Effects.None },
        { wave = wave, freq = pitches.A2, volume = 1.0, effect = Effects.Vibrato },
        { wave = wave, freq = pitches.F2, volume = 1.0, effect = Effects.Vibrato },
        { wave = wave, freq = pitches.D2, volume = 1, effect = Effects.Arpeggio },
        { wave = wave, freq = pitches.G2, volume = 1, effect = Effects.Arpeggio }
    }
    
    coin_sfx = {
        { wave = wave, freq = pitches.A4, volume = 1.0 },
        { wave = wave, freq = pitches.B4, volume = 1.0 }
    }    

    soundPlayer:add("die", die_sfx, 1)
    soundPlayer:add("die2", die_sfx, 3)
    soundPlayer:add("die3", die_sfx, 6)
    soundPlayer:add("die4", die_sfx, 10)
end

function love.keypressed(key)
    if key == "q" then
        soundPlayer:play("die")
    elseif key == "w" then
        soundPlayer:play("die2")
    elseif key == "a" then
        local sfx = createSoundEffect()
        soundPlayer:add("random_sfx", sfx, 1) -- Assuming you have a Sound:add function
        soundPlayer:play("random_sfx")
    elseif key == "s" then
        soundPlayer:play("die4")
    end
end

function love.update(dt)
end

function getRandomPentatonic()
    local keys = {}
    for key in pairs(Pentatonic) do
        table.insert(keys, key)
    end
    local randomScale = Pentatonic[keys[love.math.random(#keys)]]
    return randomScale
end

function createSoundEffect()
    local scale = getRandomPentatonic()
    local wave = Waveforms.square
    local soundEffect = {}

    for i = 1, 10 do
        local note = scale[love.math.random(#scale)]
        local freq = pitches[note .. "4"] -- Use octave 4 notes

        table.insert(soundEffect, {
            wave = wave,
            freq = freq,
            volume = 1.0,
            effect = Effects.None
        })
    end

    return soundEffect
end