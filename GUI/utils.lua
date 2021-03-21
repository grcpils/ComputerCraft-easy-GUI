--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

local drawCustomShape = function (xmin, xmax, ymin, ymax, progress)
    for cY = ymin, ymax do
        for cX = xmin, progress do
            if cX <= xmax and cY <= ymax then
                GUI_MONITOR.setCursorPos(cX, cY)
                GUI_MONITOR.write(" ")
            end
        end
    end
end

local drawShapeOut = function (shape)
    for cY = shape.ymin, shape.ymax do
        for cX = shape.xmin, shape.xmax do
            GUI_MONITOR.setCursorPos(cX, cY)
            if cY == shape.ymin or cY == shape.ymax then
                GUI_MONITOR.write(" ")
            elseif cX == shape.xmin or cX == shape.xmax then
                GUI_MONITOR.write(" ")
            end
        end
    end
end

local drawShape = function(shape)
    for cY = shape.ymin, shape.ymax do
        for cX = shape.xmin, shape.xmax do
            GUI_MONITOR.setCursorPos(cX, cY)
            GUI_MONITOR.write(" ")
        end
    end
end

local getCoordonate = function(pos, size)
    local ymin = math.floor(pos.x)
    local xmin = math.floor(pos.y)
    local ymax = math.floor((pos.x + size.h))
    local xmax = math.floor((pos.y + size.w))
    return xmin, xmax, ymin, ymax
end

local printInfo = function(s,...)
    term.setTextColor(colors.white)
    return io.write(s:format(...))
end

local printErr = function(s,...)
    term.setTextColor(colors.red)
    return io.write(s:format(...))
end

local printWarn = function(s,...)
    term.setTextColor(colors.orange)
    return io.write(s:format(...))
end

local clearAll = function()
    GUI_MONITOR.clear()
end

return {
    printErr = printErr,
    printInfo = printInfo,
    printWarn = printWarn,
    getCoordonate = getCoordonate,
    drawShape = drawShape,
    drawShapeOut = drawShapeOut,
    drawCustomShape = drawCustomShape,
    clearAll = clearAll
}