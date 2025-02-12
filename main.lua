-- alt + l
-- compact all files in same level as file main.lua to zip file and rename to .love extension

local Sound = require("sound")

function love.load()
    soundPlayer = Sound:new()
    
    -- Define a simple melody using {wave, frequency, duration}
    melody = {
        { wave = "sine", freq = 261.63, duration = 0.4 }, -- C4
        { wave = "sine", freq = 261.63, duration = 0.4 }, -- C4
        { wave = "sine", freq = 392.00, duration = 0.4 }, -- G4
        { wave = "sine", freq = 392.00, duration = 0.4 }, -- G4
        { wave = "sine", freq = 440.00, duration = 0.4 }, -- A4
        { wave = "sine", freq = 440.00, duration = 0.4 }, -- A4
        { wave = "sine", freq = 392.00, duration = 0.8 }, -- G4 (longer)
    
        { wave = "sine", freq = 349.23, duration = 0.4 }, -- F4
        { wave = "sine", freq = 349.23, duration = 0.4 }, -- F4
        { wave = "sine", freq = 330.00, duration = 0.4 }, -- E4
        { wave = "sine", freq = 330.00, duration = 0.4 }, -- E4
        { wave = "sine", freq = 293.66, duration = 0.4 }, -- D4
        { wave = "sine", freq = 293.66, duration = 0.4 }, -- D4
        { wave = "sine", freq = 261.63, duration = 0.8 }, -- C4 (longer)
    }

    jump_sfx = {
        { wave = "sine", freq = 200.00, duration = 0.05 },
        { wave = "sine", freq = 300.00, duration = 0.05 },
        { wave = "sine", freq = 400.00, duration = 0.05 },
        { wave = "sine", freq = 500.00, duration = 0.05 }
    }

    die_sfx = {
        { wave = "sine", freq = 600.00, duration = 0.1 },
        { wave = "sine", freq = 500.00, duration = 0.1 },
        { wave = "sine", freq = 400.00, duration = 0.1 },
        { wave = "sine", freq = 300.00, duration = 0.1 },
        { wave = "sine", freq = 200.00, duration = 0.1 }
    }    
    
    coin_sfx = {
        { wave = "sine", freq = 800.00, duration = 0.05 },
        { wave = "sine", freq = 1000.00, duration = 0.05 }
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
        soundPlayer:stop() -- Stop playing
    end
end

function love.update(dt)
end