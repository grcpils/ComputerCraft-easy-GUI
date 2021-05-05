--
-- Created by Grcpils
-- 04/03/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

local Utils = require("GUI/utils")

local drawLabel = function(tl)
    local Y = math.floor((tl.ymin + tl.ymax) / 2)
    local X = math.floor((tl.xmax + tl.xmin - string.len(tl.label)) / 2) + 1
    GUI_MONITOR.setBackgroundColor(tl.color)
    GUI_MONITOR.setCursorPos(X, Y)
    GUI_MONITOR.write(tl.label)
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local draw = function(tl)
    GUI_MONITOR.setBackgroundColor(tl.color)
    Utils.drawShape(tl)
    drawLabel(tl)
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local drawAll = function()
    table.foreach(GUI_TILES, function (key, tl)
        Utils.printInfo("[GUI] Draw tile '%s' (id:%s)\n", tl.label, key)
        draw(tl)
    end)
end

local new = function(label, pos, size, color)
    local xmin, xmax, ymin, ymax = Utils.getCoordonate(pos, size)
    local Tile = {
        label = label,
        xmin = xmin,
        xmax = xmax,
        ymin = ymin,
        ymax = ymax,
        color = color
    }

    local setColor = function(color)
        Tile.color = color
        draw(Tile)
    end

    local setLabel = function(label)
        Tile.label = label
        draw(Tile)
    end

    table.insert(GUI_TILES, Tile)
    return {
        setColor = setColor
    }
end

return {
    new = new,
    drawAll = drawAll
}