local menu = {
    options = { "Start", "Quit" },
    selected = 1,
}

function menu.draw()
    love.graphics.clear(0.1, 0.1, 0.1) -- Dark background
    for i, option in ipairs(menu.options) do
        if i == menu.selected then
            love.graphics.setColor(1, 1, 0) -- Highlight selected option
        else
            love.graphics.setColor(1, 1, 1) -- Normal option color
        end
        love.graphics.printf(option, 0, 200 + (i - 1) * 40, love.graphics.getWidth(), "center")
    end
end

function menu.keypressed(key, onSelect)
    if key == "w" then
        menu.selected = menu.selected - 1
        if menu.selected < 1 then
            menu.selected = #menu.options
        end
    elseif key == "s" then
        menu.selected = menu.selected + 1
        if menu.selected > #menu.options then
            menu.selected = 1
        end
    elseif key == "return" or key == "enter" then
        onSelect(menu.options[menu.selected])
    end
end

return menu
