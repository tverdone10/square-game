local rooms = require("rooms")

local player = {
    x = 400,
    y = 300,
    size = 50,
    speed = 200,
    sprintSpeed = 500,
    acceleration = 500,
    sprintAcceleration = 1000,
    friction = 300,
    velocityX = 0,
    velocityY = 0,
    roomBounds = {                             -- Room boundaries
        xMin = 50,                             -- Left wall
        xMax = love.graphics.getWidth() - 50,  -- Right wall
        yMin = 50,                             -- Top wall
        yMax = love.graphics.getHeight() - 50, -- Bottom wall
    },
    doorSize = 100,
}

-- Helper function to apply acceleration
local function applyAcceleration(velocity, keyNegative, keyPositive, acceleration, dt)
    if love.keyboard.isDown(keyNegative) then
        velocity = velocity - acceleration * dt
    elseif love.keyboard.isDown(keyPositive) then
        velocity = velocity + acceleration * dt
    end
    return velocity
end

local function handleCollision()
    local bounds = player.roomBounds
    local doorSize = player.doorSize
    local centerX = (bounds.xMax + bounds.xMin) / 2
    local centerY = (bounds.yMax + bounds.yMin) / 2
    if player.y < bounds.yMin and not (player.x + player.size > centerX - doorSize / 2 and player.x < centerX + doorSize / 2) then
        player.y = bounds.yMin
        player.velocityY = -player.velocityY
    end

    if player.y + player.size > bounds.yMax and not (player.x + player.size > centerX - doorSize / 2 and player.x < centerX + doorSize / 2) then
        player.y = bounds.yMax - player.size
        player.velocityY = -player.velocityY
    end

    if player.x < bounds.xMin and not (player.y + player.size > centerY - doorSize / 2 and player.y < centerY + doorSize / 2) then
        player.x = bounds.xMin
        player.velocityX = -player.velocityX
    end

    if player.x + player.size > bounds.xMax and not (player.y + player.size > centerY - doorSize / 2 and player.y < centerY + doorSize / 2) then
        player.x = bounds.xMax - player.size
        player.velocityX = -player.velocityX
    end
end

-- Helper function to apply friction
local function applyFriction(velocity, friction, dt)
    if velocity > 0 then
        return math.max(0, velocity - friction * dt)
    elseif velocity < 0 then
        return math.min(0, velocity + friction * dt)
    end
    return velocity
end

function player.update(dt)
    local isSprinting = love.keyboard.isDown("lshift", "rshift")
    local maxSpeed = isSprinting and player.sprintSpeed or player.speed
    local acceleration = isSprinting and player.sprintAcceleration or player.acceleration

    player.velocityY = applyAcceleration(player.velocityY, "w", "s", acceleration, dt)
    player.velocityX = applyAcceleration(player.velocityX, "a", "d", acceleration, dt)


    if not love.keyboard.isDown("w", "s") then
        player.velocityY = applyFriction(player.velocityY, player.friction, dt)
    end
    if not love.keyboard.isDown("a", "d") then
        player.velocityX = applyFriction(player.velocityX, player.friction, dt)
    end

    local velocity = math.sqrt(player.velocityX ^ 2 + player.velocityY ^ 2)
    if velocity > maxSpeed then
        local scale = maxSpeed / velocity
        player.velocityX = player.velocityX * scale
        player.velocityY = player.velocityY * scale
    end

    player.x = player.x + player.velocityX * dt
    player.y = player.y + player.velocityY * dt

    rooms.checkCollision(player, "top")
    rooms.checkCollision(player, "bottom")
    rooms.checkCollision(player, "left")
    rooms.checkCollision(player, "right")
end

function player.draw()
    love.graphics.setColor(0, 0, 0) -- Black player
    love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
end

function player.resetPosition()
    player.x = love.graphics.getWidth() / 2 - player.size / 2
    player.y = love.graphics.getHeight() / 2 - player.size / 2
end

return player
