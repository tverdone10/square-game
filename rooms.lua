local rooms = {}

-- Define rooms with their background colors and open doors
local roomList = {
    { color = { 0.1, 0.8, 0.1 }, doors = { "top", "bottom", "left", "right" } }, -- Green Room
    { color = { 0.8, 0.1, 0.1 }, doors = { "top", "bottom" } },                  -- Red Room
    { color = { 0.1, 0.1, 0.8 }, doors = { "left", "right" } },                  -- Blue Room
    { color = { 0.8, 0.8, 0.1 }, doors = { "top", "right" } },                   -- Yellow Room
}

local currentRoomIndex = 1

local function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end


function rooms.load()
    currentRoomIndex = 1
end

function rooms.draw()
    -- Draw the current room's background
    local room = roomList[currentRoomIndex]
    love.graphics.clear(unpack(room.color))

    -- Draw the room border
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", 50, 50, love.graphics.getWidth() - 100, love.graphics.getHeight() - 100)

    -- Draw open doors
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    for _, door in ipairs(room.doors) do
        love.graphics.setColor(room.color)
        if door == "top" then
            love.graphics.rectangle("fill", width / 2 - 50, 40, 100, 20)
        elseif door == "bottom" then
            love.graphics.rectangle("fill", width / 2 - 50, height - 60, 100, 20)
        elseif door == "left" then
            love.graphics.rectangle("fill", 40, height / 2 - 50, 20, 100)
        elseif door == "right" then
            love.graphics.rectangle("fill", width - 60, height / 2 - 50, 20, 100)
        end
    end
end

function rooms.checkCollision(player, wall)
    local room = roomList[currentRoomIndex]
    local width, height = love.graphics.getWidth(), love.graphics.getHeight()

    if wall == "top" then
        if player.y < 50 and not contains(room.doors, "top") then
            player.y = 50
            player.velocityY = -player.velocityY -- Bounce back
        end
    elseif wall == "bottom" then
        if player.y + player.size > height - 50 and not contains(room.doors, "bottom") then
            player.y = height - 50 - player.size
            player.velocityY = -player.velocityY -- Bounce back
        end
    elseif wall == "left" then
        if player.x < 50 and not contains(room.doors, "left") then
            player.x = 50
            player.velocityX = -player.velocityX -- Bounce back
        end
    elseif wall == "right" then
        if player.x + player.size > width - 50 and not contains(room.doors, "right") then
            player.x = width - 50 - player.size
            player.velocityX = -player.velocityX -- Bounce back
        end
    end
end

function rooms.checkTransition(player)
    local x, y = player.x, player.y
    local width, height = love.graphics.getWidth(), love.graphics.getHeight()
    local room = roomList[currentRoomIndex]

    if y < 50 and roomHasDoor(room, "top") then
        return math.max(1, currentRoomIndex - 1)         -- Move to the previous room
    elseif y > height - 50 - player.size and roomHasDoor(room, "bottom") then
        return math.min(#roomList, currentRoomIndex + 1) -- Move to the next room
    elseif x < 50 and roomHasDoor(room, "left") then
        return (currentRoomIndex == 1) and #roomList or currentRoomIndex - 1
    elseif x > width - 50 - player.size and roomHasDoor(room, "right") then
        return (currentRoomIndex == #roomList) and 1 or currentRoomIndex + 1
    end

    return nil -- No transition
end

function roomHasDoor(room, direction)
    for _, door in ipairs(room.doors) do
        if door == direction then
            return true
        end
    end
    return false
end

function rooms.setCurrentRoom(index)
    currentRoomIndex = index
end

return rooms
