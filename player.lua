local player = {
    x = 400,
    y = 300,
    size = 50,
    speed = 200,
}

function player.update(dt)
    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end
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
