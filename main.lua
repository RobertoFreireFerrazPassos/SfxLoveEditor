-- alt + l
-- compact all files in same level as file main.lua to zip file and rename to .love extension

local sfx = require("sfx")
local Sound = sfx.Sound
local pitches = sfx.Pitches
local Waveforms = sfx.Waveforms

function love.load()
    soundPlayer = Sound:new()
    local wave 

    melody = {
        { wave = "sine", freq = pitches.C4, duration = 0.4, volume = 1.0 },
        { wave = "sine", freq = pitches.C4, duration = 0.4, volume = 1.0 },
        { wave = "sine", freq = pitches.G4, duration = 0.4, volume = 1.0 },
        { wave = "sine", freq = pitches.G4, duration = 0.4, volume = 0.6 },
        { wave = "sine", freq = pitches.A4, duration = 0.4, volume = 0.6 },
        { wave = "sine", freq = pitches.A4, duration = 0.4, volume = 0.4 },
        { wave = "sine", freq = pitches.G4, duration = 0.8, volume = 0.4 },
    
        { wave = "sine", freq = pitches.F4, duration = 0.4, volume = 1.0 },
        { wave = "sine", freq = pitches.F4, duration = 0.4, volume = 0.2 }, 
        { wave = "sine", freq = pitches.E4, duration = 0.4, volume = 0.2 },
        { wave = "sine", freq = pitches.E4, duration = 0.4, volume = 1.0 },
        { wave = "sine", freq = pitches.D4, duration = 0.4, volume = 1.0 },
        { wave = "sine", freq = pitches.D4, duration = 0.4, volume = 1.0 },
        { wave = "sine", freq = pitches.C4, duration = 0.8, volume = 1.0 },
    }
    
    jump_sfx = {
        { wave = "sine", freq = pitches.G3, duration = 0.05, volume = 1.0 },
        { wave = "sine", freq = pitches.D4, duration = 0.05, volume = 1.0 },
        { wave = "sine", freq = pitches.F4, duration = 0.05, volume = 0.2 },
        { wave = "sine", freq = pitches.A4, duration = 0.05, volume = 0.2 }
    }
    
    die_sfx = {
        { wave = "sine", freq = pitches.B4, duration = 0.1, volume = 1.0 },
        { wave = "sine", freq = pitches.A4, duration = 0.1, volume = 1.0 },
        { wave = "sine", freq = pitches.F4, duration = 0.1, volume = 1.0 },
        { wave = "sine", freq = pitches.D4, duration = 0.1, volume = 0.2 },
        { wave = "sine", freq = pitches.G3, duration = 0.1, volume = 0.2 }
    }
    
    coin_sfx = {
        { wave = "sine", freq = pitches.A4, duration = 0.05, volume = 1.0 },
        { wave = "sine", freq = pitches.B4, duration = 0.05, volume = 1.0 }
    }    

    soundPlayer:add("die", die_sfx, 1)
    soundPlayer:add("melody", melody, 1)
    soundPlayer:add("die2", die_sfx, 5)
    soundPlayer:add("melody2", melody, 5)
end

function love.keypressed(key)
    if key == "q" then
        soundPlayer:play("die")
    elseif key == "w" then
        soundPlayer:play("melody")
    elseif key == "a" then
        soundPlayer:play("die2")
    elseif key == "s" then
        soundPlayer:play("melody2")
    elseif key == "e" then
        soundPlayer:stop("melody") -- Stop playing "melody"
    end
end

function love.update(dt)
end