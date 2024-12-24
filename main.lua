local menu = require("menu")
local player = require("player")
local rooms = require("rooms")

local gameState = "menu"

function love.load()
    love.window.setTitle("Room Transition Game")
    love.graphics.setFont(love.graphics.newFont(20))
    rooms.load()

    backgroundAudio = love.audio.newSource("assets/sounds/bgm.mp3", "stream")
end

function love.update(dt)
    if gameState == "game" then
        player.update(dt)

        -- Check if the player enters a "door" and switch rooms
        local newRoom = rooms.checkTransition(player)
        if newRoom then
            rooms.setCurrentRoom(newRoom)
            player.resetPosition() -- Reset the player's position
        end
    end
end

function love.draw()
    if gameState == "menu" then
        menu.draw()
    elseif gameState == "game" then
        rooms.draw()  -- Draw the current room
        player.draw() -- Draw the player
    end
end

function love.keypressed(key)
    if gameState == "menu" then
        menu.keypressed(key, function(selectedOption)
            if selectedOption == "Start" then
                gameState = "game"
                love.audio.play(backgroundAudio)
            elseif selectedOption == "Quit" then
                love.event.quit()
            end
        end)
    end
end
