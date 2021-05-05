--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

local Utils = require("GUI/utils")

local drawHorizontalFill = function (xmin, xmax, ymin, ymax, progress)
    for cY = ymin, ymax do
        for cX = xmin, progress do
            if cX <= xmax and cY <= ymax then
                GUI_MONITOR.setCursorPos(cX, cY)
                GUI_MONITOR.write(" ")
            end
        end
    end
end

local drawPercentHorizontal = function(prg, percent, progress)
    local percentText = percent.."%"
    local Y = math.floor((prg.ymin + prg.ymax) / 2)
    local X = math.floor((prg.xmax + prg.xmin - string.len(percentText)) / 2) + 1

    for i = 1, #percentText do
        local c = percentText:sub(i,i)
        GUI_MONITOR.setCursorPos(X, Y)
        if X - 1 < progress then
            GUI_MONITOR.setBackgroundColor(prg.color)
        else
            GUI_MONITOR.setBackgroundColor(colors.gray)
        end
        GUI_MONITOR.write(c)
        GUI_MONITOR.setBackgroundColor(colors.black)
        X = X + 1
    end
end

local drawLabelHorizontal = function(prg, percent, progress)
    local Y = math.floor(prg.ymin - 1)
    local X = math.floor((prg.xmax + prg.xmin - string.len(prg.label)) / 2) + 1
    GUI_MONITOR.setBackgroundColor(colors.black)
    GUI_MONITOR.setCursorPos(X, Y)
    GUI_MONITOR.write(prg.label)
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local fill = function (prg)
    GUI_MONITOR.setBackgroundColor(prg.color)
    if prg.type == "horizontal" then
        local percentStep = prg.xmax / 100
        local percent = math.floor((prg.value / prg.max) * 100)
        local progress = math.floor(percentStep * percent)
        if prg.colored == true then
            if percent < prg.coloredStep.low then
                prg.color = prg.coloredColors.low
            elseif percent >= prg.coloredStep.low and percent < prg.coloredStep.medium then
                prg.color = prg.coloredColors.medium
            else
                prg.color = prg.coloredColors.high
            end
        end
        drawHorizontalFill(prg.xmin, prg.xmax, prg.ymin, prg.ymax, progress)
        drawPercentHorizontal(prg, percent, progress)
        if prg.viewLabel == true then
            drawLabelHorizontal(prg)
        end
    else
        Utils.printErr("[GUI] Error: %s type unknown (%s)\n", prg.label, prg.type)
    end
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local draw = function (prg)
    GUI_MONITOR.setBackgroundColor(colors.gray)
    Utils.drawShape(prg)
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local drawColor = function (prg)
    GUI_MONITOR.setBackgroundColor(prg.color)
    Utils.drawShape(prg)
    GUI_MONITOR.setBackgroundColor(colors.black)
end

local drawAll = function ()
    table.foreach(GUI_PROGRESS, function (key, prg)
        Utils.printInfo("[GUI] Draw %s progress '%s' (id:%d)\n", prg.type, prg.label, key)
        draw(prg)
        fill(prg)
    end)
end

local new = function (label, type, max, pos, size, color)
    local xmin, xmax, ymin, ymax = Utils.getCoordonate(pos, size)
    if type ~= "horizontal" then
        Utils.printErr("[GUI] Error %s %s: %s type unknown (%s)\n", debug.getinfo(2).source, debug.getinfo(2).currentline, label, type)
        return
    end
    local Progress = {
        type = type,
        label = label,
        xmin = xmin,
        xmax = xmax,
        ymin = ymin,
        ymax = ymax,
        max = max,
        value = 0,
        color = color,
        colored = false,
        viewLabel = true,
        coloredStep = {
            low = 30,
            medium = 50
        },
        coloredColors = {
            low = colors.red,
            medium = colors.orange,
            high = colors.green
        }
    }

    local setValue = function (value)
        Progress.value = value
        draw(Progress)
        fill(Progress)
    end

    local getValue = function ()
        return Progress.value
    end

    local setColored = function(bool)
        Progress.colored = bool
    end

    local setColoredStep = function(low, medium)
        Progress.coloredStep = {
            low = low,
            medium = medium
        }
    end

    local setColoredColors = function(low, medium, high)
        Progress.coloredColors = {
            low = low,
            medium = medium,
            high = high
        }
    end

    local viewLabel = function (bool)
        Progress.viewLabel = bool
    end

    local setMax = function (value)
        Progress.max = value
    end

    local getMax = function ()
        return Progress.max
    end

    local setColor = function (color)
        Progress.color = color
    end

    table.insert(GUI_PROGRESS, Progress)
    return {
        setValue = setValue,
        getValue = getValue,
        setMax = setMax,
        getMax = getMax,
        setColor = setColor,
        viewLabel = viewLabel,
        setColored = setColored,
        setColoredStep = setColoredStep,
        setColoredColors = setColoredColors
    }
end

return {
    new = new,
    drawAll = drawAll
}