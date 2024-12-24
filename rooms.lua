local rooms = {}

local roomList = {
    {
        color = { 0.1, 0.8, 0.1 },
        doors = {
            top = { x = 300, width = 100 },
            bottom = { x = 300, width = 100 },
            left = { y = 200, height = 100 },
            right = { y = 200, height = 100 },
        },
    },
    {
        color = { 0.8, 0.1, 0.1 },
        doors = {
            top = { x = 300, width = 100 },
            bottom = { x = 300, width = 100 },
        },
    },
    {
        color = { 0.1, 0.1, 0.8 }, -- Blue Room
        doors = {
            left = { y = 200, height = 100 },
            right = { y = 200, height = 100 },
        },
    },
    {
        color = { 0.8, 0.8, 0.1 }, -- Yellow Room
        doors = {
            top = { x = 300, width = 100 },
        },
    },
}


local currentRoomIndex = 1

local function validateRoomIndex()
    if currentRoomIndex < 1 then
        currentRoomIndex = 1
    elseif currentRoomIndex > #roomList then
        currentRoomIndex = #roomList
    end
end

function rooms.load()
    currentRoomIndex = 1
end

function rooms.draw()
    validateRoomIndex()

    local room = roomList[currentRoomIndex]
    love.graphics.clear(unpack(room.color))

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", 50, 50, love.graphics.getWidth() - 100, love.graphics.getHeight() - 100)

    local width, height = love.graphics.getWidth(), love.graphics.getHeight()
    for direction, door in pairs(room.doors) do
        love.graphics.setColor(room.color)
        if direction == "top" then
            love.graphics.rectangle("fill", door.x, 40, door.width, 20)
        elseif direction == "bottom" then
            love.graphics.rectangle("fill", door.x, height - 60, door.width, 20)
        elseif direction == "left" then
            love.graphics.rectangle("fill", 40, door.y, 20, door.height)
        elseif direction == "right" then
            love.graphics.rectangle("fill", width - 60, door.y, 20, door.height)
        end
    end
end

function rooms.checkCollision(player)
    local room = roomList[currentRoomIndex]
    local width, height = love.graphics.getWidth(), love.graphics.getHeight()

    if player.y < 50 then
        local door = room.doors.top
        if not (door and player.x + player.size > door.x and player.x < door.x + door.width) then
            player.y = 50
            player.velocityY = -player.velocityY -- Bounce back
        end
    end

    -- Bottom wall
    if player.y + player.size > height - 50 then
        local door = room.doors.bottom
        if not (door and player.x + player.size > door.x and player.x < door.x + door.width) then
            player.y = height - 50 - player.size
            player.velocityY = -player.velocityY -- Bounce back
        end
    end

    -- Left wall
    if player.x < 50 then
        local door = room.doors.left
        if not (door and player.y + player.size > door.y and player.y < door.y + door.height) then
            player.x = 50
            player.velocityX = -player.velocityX -- Bounce back
        end
    end

    -- Right wall
    if player.x + player.size > width - 50 then
        local door = room.doors.right
        if not (door and player.y + player.size > door.y and player.y < door.y + door.height) then
            player.x = width - 50 - player.size
            player.velocityX = -player.velocityX -- Bounce back
        end
    end
end

function rooms.checkTransition(player)
    local room = roomList[currentRoomIndex]
    local width, height = love.graphics.getWidth(), love.graphics.getHeight()

    -- Top wall transition
    if player.y < 50 then
        local door = room.doors.top
        if door and player.x + player.size > door.x and player.x < door.x + door.width then
            return math.random(1, #roomList)
        end
    end

    -- Bottom wall transition
    if player.y + player.size > height - 50 then
        local door = room.doors.bottom
        if door and player.x + player.size > door.x and player.x < door.x + door.width then
            return math.random(1, #roomList)
        end
    end

    -- Left wall transition
    if player.x < 50 then
        local door = room.doors.left
        if door and player.y + player.size > door.y and player.y < door.y + door.height then
            return math.random(1, #roomList)
        end
    end

    -- Right wall transition
    if player.x + player.size > width - 50 then
        local door = room.doors.right
        if door and player.y + player.size > door.y and player.y < door.y + door.height then
            return math.random(1, #roomList)
        end
    end

    return nil
end

function rooms.setCurrentRoom(index)
    currentRoomIndex = index
end

return rooms
