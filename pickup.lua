local pickup = {}
local player = require("player")

function pickup.load()
    print("Loading pickup...")
    print("Screen dimensions:", love.graphics.getWidth(), love.graphics.getHeight())

    pickup.x = math.random(50, love.graphics.getWidth() - 50)
    pickup.y = math.random(50, love.graphics.getHeight() - 50)
    print("Pickup coordinates:", pickup.x, pickup.y)

    pickup.radius = 10
    pickup.collected = false
    pickup.spinningCircle = {
        x = 0,
        y = 0,
        radius = 5,
        angle = 0,
        numCircles = 10,
        speed = 200,
        active = false,
        circles = {},
    }
end

function pickup.update(dt)
    if pickup.spinningCircle.active then
        -- Increment the spinning angle
        pickup.spinningCircle.angle = pickup.spinningCircle.angle + dt * pickup.spinningCircle.speed

        -- Calculate the center of the player
        local playerCenterX = player.x + player.size / 2
        local playerCenterY = player.y + player.size / 2

        -- Ensure the spinning circle radius is large enough to encircle the character
        local circleOrbitRadius = 50 -- Adjust this value as needed

        -- Update positions of the rotating circles
        for i = 1, pickup.spinningCircle.numCircles do
            local angleOffset = (i - 1) * (2 * math.pi / pickup.spinningCircle.numCircles)
            local circleX = playerCenterX +
                math.cos(pickup.spinningCircle.angle + angleOffset) * circleOrbitRadius
            local circleY = playerCenterY +
                math.sin(pickup.spinningCircle.angle + angleOffset) * circleOrbitRadius

            pickup.spinningCircle.circles[i] = { x = circleX, y = circleY }
        end
    end
end

function pickup.draw()
    if not pickup.collected then
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", pickup.x, pickup.y, pickup.radius)
    elseif pickup.spinningCircle.active then
        love.graphics.setColor(0, 1, 0)
        for _, circle in ipairs(pickup.spinningCircle.circles) do
            love.graphics.circle("fill", circle.x, circle.y, pickup.spinningCircle.radius)
        end
    end
end

function pickup.checkCollision(player)
    local distance = math.sqrt((pickup.x - player.x) ^ 2 + (pickup.y - player.y) ^ 2)
    if distance < pickup.radius + player.radius then
        pickup.collected = true
        return true
    end
    return false
end

return pickup
