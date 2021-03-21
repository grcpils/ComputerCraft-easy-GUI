--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

local Utils = require("GUI/utils")

local drawLabel = function(btn, state)
    local Y = math.floor((btn.ymin + btn.ymax) / 2)
    local X = math.floor((btn.xmax + btn.xmin - string.len(btn.label)) / 2) + 1
    GUI_MONITOR.setBackgroundColor(btn.color[state])
    GUI_MONITOR.setCursorPos(X, Y)
    GUI_MONITOR.write(btn.label)
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local draw = function(btn, state)
    GUI_MONITOR.setBackgroundColor(btn.color[state])
    Utils.drawShape(btn)
    drawLabel(btn, state)
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local drawAll = function()
    table.foreach(GUI_BUTTONS, function (key, btn)
        Utils.printInfo("[GUI] Draw button '%s' (id:%s)\n", btn.label, key)
        draw(btn, "idle")
    end)
end

local flash = function(btn)
    draw(btn, "active")
    sleep(0.2)
    draw(btn, "idle")
end

local waitForClick = function(x, y)
    table.foreach(GUI_BUTTONS, function (key, btn)
        if y >= btn.ymin and y <= btn.ymax then
            if x >= btn.xmin and x <= btn.xmax then
                flash(btn)
                btn.callback()
                return
            end
        end
    end)
end

local new = function(label, callback, pos, size, color)
    local xmin, xmax, ymin, ymax = Utils.getCoordonate(pos, size)
    local button = {
        label = label,
        callback = callback,
        xmin = xmin,
        xmax = xmax,
        ymin = ymin,
        ymax = ymax,
        color = color
    }
    table.insert(GUI_BUTTONS, button)
    return
end

return {
    new = new,
    flash = flash,
    waitForClick = waitForClick,
    drawAll = drawAll
}