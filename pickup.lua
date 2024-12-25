local pickup = {}

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
        speed = 200,
        active = false,
    }
end

function pickup.update(dt, player)
    if pickup.spinningCircle.active then
        pickup.spinningCircle.angle = pickup.spinningCircle.angle + pickup.spinningCircle.speed * dt
        pickup.spinningCircle.x = player.x + math.cos(pickup.spinningCircle.angle) * 30
        pickup.spinningCircle.y = player.y + math.sin(pickup.spinningCircle.angle) * 30

        -- Check for wall collisions and bounce
        if pickup.spinningCircle.x < 0 or pickup.spinningCircle.x > love.graphics.getWidth() then
            pickup.spinningCircle.speed = -pickup.spinningCircle.speed
        end
        if pickup.spinningCircle.y < 0 or pickup.spinningCircle.y > love.graphics.getHeight() then
            pickup.spinningCircle.speed = -pickup.spinningCircle.speed
        end
    end
end

function pickup.draw()
    if not pickup.collected then
        -- Draw the pickup
        love.graphics.setColor(1, 1, 0) -- Yellow color
        love.graphics.circle("fill", pickup.x, pickup.y, pickup.radius)
    elseif pickup.spinningCircle.active then
        -- Draw the spinning circle
        love.graphics.setColor(0, 1, 0) -- Green color
        love.graphics.circle("fill", pickup.spinningCircle.x, pickup.spinningCircle.y, pickup.spinningCircle.radius)
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
