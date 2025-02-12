local Sound = require("sound")

function love.load()
    soundPlayer = Sound:new()
end

function love.keypressed(key)
    if key == "1" then
        soundPlayer:play("sine", 440, 0.3)  -- A4 note
    elseif key == "2" then
        soundPlayer:play("square", 523.25, 0.3)  -- C5 note
    elseif key == "3" then
        soundPlayer:play("saw", 659.25, 0.3)  -- E5 note
    elseif key == "4" then
        soundPlayer:play("noise", 0, 0.3)  -- Noise burst
    elseif key == "space" then
        soundPlayer:stop()  -- Stop current sound
    end
end
