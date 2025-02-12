-- alt + l
-- compact all files in same level as file main.lua to zip file and rename to .love extension

local sfx = require("sfx")
local Sound = sfx.Sound
local pitches = sfx.Pitches
local Waveforms = sfx.Waveforms
local Effects = sfx.Effects

function love.load()
    soundPlayer = Sound:new()
    local wave = Waveforms.square

    melody = {
        { wave = wave, freq = pitches.C4, volume = 1.0 },
        { wave = wave, freq = pitches.C4, volume = 1.0 },
        { wave = wave, freq = pitches.G4, volume = 1.0 },
        { wave = wave, freq = pitches.G4, volume = 0.6 },
        { wave = wave, freq = pitches.A4, volume = 0.6 },
        { wave = wave, freq = pitches.A4, volume = 0.4 },
        { wave = wave, freq = pitches.G4, volume = 0.4 },
    
        { wave = wave, freq = pitches.F4, volume = 1.0 },
        { wave = wave, freq = pitches.F4, volume = 0.2 }, 
        { wave = wave, freq = pitches.E4, volume = 0.2 },
        { wave = wave, freq = pitches.E4, volume = 1.0 },
        { wave = wave, freq = pitches.D4, volume = 1.0 },
        { wave = wave, freq = pitches.D4, volume = 1.0 },
        { wave = wave, freq = pitches.C4, volume = 1.0 },
    }
    
    jump_sfx = {
        { wave = wave, freq = pitches.G3, volume = 1.0},
        { wave = wave, freq = pitches.D4, volume = 1.0 },
        { wave = wave, freq = pitches.F4, volume = 0.2 },
        { wave = wave, freq = pitches.A4, volume = 0.2 }
    }
    
    die_sfx = {
        { wave = wave, freq = pitches.B4, volume = 1.0, effect = Effects.None },
        { wave = wave, freq = pitches.A4, volume = 1.0, effect = Effects.Slide },
        { wave = wave, freq = pitches.F4, volume = 1.0, effect = Effects.Slide },
        { wave = wave, freq = pitches.D4, volume = 1, effect = Effects.None },
        { wave = wave, freq = pitches.G3, volume = 1, effect = Effects.None }
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
        soundPlayer:play("die3")
    elseif key == "s" then
        soundPlayer:play("die4")
    end
end

function love.update(dt)
end