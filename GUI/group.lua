--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

local Utils = require("GUI/utils")

local drawLabel = function (grp)
    local Y = grp.ymin
    local X = math.floor((grp.xmax + grp.xmin - string.len(grp.label)) / 2)
    GUI_MONITOR.setBackgroundColor(colors.black)
    GUI_MONITOR.setCursorPos(X, Y)
    GUI_MONITOR.write(" " .. grp.label .. " ")
end

local draw = function (grp)
    GUI_MONITOR.setBackgroundColor(grp.color)
    Utils.drawShapeOut(grp)
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local drawAll = function ()
    table.foreach(GUI_GROUPS, function (key, grp)
        Utils.printInfo("[GUI] Draw group '%s' (id:%s)\n", grp.label, key)
        draw(grp)
        drawLabel(grp)
    end)
end

local refresh = function ()
    table.foreach(GUI_GROUPS, function (key, grp)
        draw(grp)
        drawLabel(grp)
    end)
end

local label = function(id, label)
    table.foreach(GUI_GROUPS, function (key, grp)
        if id == key then
            grp.label = label
        end
        drawLabel(grp)
    end)
end

local new = function(label, pos, size, color)
    local xmin, xmax, ymin, ymax = Utils.getCoordonate(pos, size)
    local Group = {
        label = label,
        xmin = xmin,
        xmax = xmax,
        ymin = ymin,
        ymax = ymax,
        color = color
    }

    local setLabel = function (label)
        Group.label = label
        refresh()
    end

    table.insert(GUI_GROUPS, Group)
    return {
        setLabel = setLabel
    }
end

return {
    new = new,
    label = label,
    drawAll = drawAll
}