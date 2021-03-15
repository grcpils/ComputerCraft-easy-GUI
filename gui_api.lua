--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

table = require 'table'

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

function newGUI (opt)
    local self = { monitor = peripheral.wrap(opt.monitorSide), buttons = {}, charts = {}, groups = {} }

    local Position = { x = 0, y = 0 }
    local Size = { h = 0, w = 0 }
    local Colors = { idle, active }
    self.monitor.setTextScale(1)

    if opt.uiSize ~= nil then
        if opt.uiSize == "small" then
            self.monitor.setTextScale(0.5)
        elseif opt.uiSize == "normal" then
            self.monitor.setTextScale(1)
        elseif opt.uiSize == "big" then
            self.monitor.setTextScale(1.5)
        else
            printWarn("[GUI] Warning: uiSize '%s' not found (default=normal)\n", opt.uiSize)
            self.monitor.setTextScale(1)
        end
    else
        printWarn("[GUI] Warning: no uiSize set (default=normal)\n", nil)
        self.monitor.setTextScale(1)
    end


    --
    -- PRIVATE
    --

    -- draw a simple Shape with Xmin, Xmax, Ymin, Ymax values
    local drawShape = function (shape)
        for cY = shape.Ymin, shape.Ymax do
            for cX = shape.Xmin, shape.Xmax do
                self.monitor.setCursorPos(cX, cY)
                self.monitor.write(" ")
            end
        end
    end

    -- draw a simple Shape with Xmin, Xmax, Ymin, Ymax values
    local drawCustomShape = function (xmin, xmax, ymin, ymax, progress)
        for cY = ymin, ymax do
            for cX = xmin, progress do
                if cX <= xmax and cY <= ymax then
                    self.monitor.setCursorPos(cX, cY)
                    self.monitor.write(" ")
                end
            end
        end
    end

    -- draw outline of Shape with Xmin, Xmax, Ymin, Ymax values
    local drawShapeOut = function (shape)
        for cY = shape.Ymin, shape.Ymax do
            for cX = shape.Xmin, shape.Xmax do
                self.monitor.setCursorPos(cX, cY)
                if cY == shape.Ymin or cY == shape.Ymax then
                    self.monitor.write(" ")
                elseif cX == shape.Xmin or cX == shape.Xmax then
                    self.monitor.write(" ")
                end
            end
        end
    end

    local fillProgress = function (prg)
        self.monitor.setBackgroundColor(prg.Color)
        if prg.Type == "horizontal" then
            local percentStep = prg.Xmax / 100
            local percent = (prg.Value / prg.ValueMax) * 100
            local progress = percentStep * percent
            drawCustomShape(prg.Xmin, prg.Xmax, prg.Ymin, prg.Ymax, progress)
        elseif prg.Type == "vertical" then
        else
            printErr("[GUI] Error: %s type unknown (%s)\n", prg.label, prg.Type)
        end
        self.monitor.setBackgroundColor(colors.black)
    end

    local drawProgress = function (prg)
        self.monitor.setBackgroundColor(colors.gray)
        drawShape(prg)
        self.monitor.setBackgroundColor(colors.black)
    end

    local drawAllProgress = function ()
        table.foreach(self.charts, function (key, prg)
            printErr("[GUI] WIP: Draw %s progress '%s'\n", prg.Type, prg.label)
            drawProgress(prg)
            fillProgress(prg)
        end)
    end

    -- draw group label
    local drawGroupLabel = function (grp)
        local Y = grp.Ymin
        local X = math.floor((grp.Xmax + grp.Xmin - string.len(grp.label)) / 2)
        self.monitor.setBackgroundColor(colors.black)
        self.monitor.setCursorPos(X, Y)
        self.monitor.write(" " .. grp.label .. " ")
    end

    -- draw a group
    local drawGroup = function (grp)
        self.monitor.setBackgroundColor(grp.Color)
        drawShapeOut(grp)
        self.monitor.setBackgroundColor(colors.black)
    end

    -- foreach in groups table for draw all group
    local drawAllGroups = function ()
        table.foreach(self.groups, function (key, grp)
            printInfo("[GUI] Draw group '%s'\n", grp.label)
            drawGroup(grp)
            drawGroupLabel(grp)
        end)
    end

    -- draw a button label in center of 'btn' instance
    local drawBtnLabel = function (btn, state)
        local Y = math.floor((btn.Ymin + btn.Ymax) / 2)
        local X = math.floor((btn.Xmax + btn.Xmin - string.len(btn.label)) / 2) + 1
        self.monitor.setBackgroundColor(btn.Colors[state])
        self.monitor.setCursorPos(X, Y)
        self.monitor.write(btn.label)
        self.monitor.setBackgroundColor(colors.black)
    end

    -- draw a button with this current state [idle, active]
    local drawButton = function (btn, state)
        self.monitor.setBackgroundColor(btn.Colors[state])
        drawShape(btn)
        drawBtnLabel(btn, state)
        self.monitor.setBackgroundColor(colors.black)
    end

    -- foreach in buttons table for draw all button
    local drawAllButtons = function ()
        table.foreach(self.buttons, function (key, btn)
            printInfo("[GUI] Draw button '%s'\n", btn.label)
            drawButton(btn, "idle")
        end)
    end

    -- flash the button when click on it
    local flashButton = function (btn)
        drawButton(btn, "active")
        sleep(0.2)
        drawButton(btn, "idle")
    end

    -- wait for click action on a button
    local buttonWaitForClick = function (x, y)
        table.foreach(self.buttons, function (key, btn)
            if y >= btn.Ymin and y <= btn.Ymax then
                if x >= btn.Xmin and x <= btn.Xmax then
                    btn.callback()
                    flashButton(btn)
                    return
                end
            end
        end)
    end

    -- start a loop for catch events
    local waitForEvents = function ()
       while true do
            event, side, x, y = os.pullEvent("monitor_touch")
            buttonWaitForClick(x, y)
        end
    end

    -- get Xmin, Xmax, Ymin, Ymax with Position and Size
    local getCoordonate = function (Position, Size)
        if opt.uiSize == "small" then x=2 elseif opt.uiSize == "big" then x=3 else x=1 end
        local ymin = math.floor(Position[1]) * x
        local xmin = math.floor(Position[2]) * x
        local ymax = math.floor((Position[1] + Size[1])) * x
        local xmax = math.floor((Position[2] + Size[2])) * x
        return xmin, xmax, ymin, ymax
    end

    --
    -- PUBLIC
    --

    local updateProgress = function (Opt)
        table.foreach(self.charts, function (key, prg)
            if prg.label == Opt.label then
                prg.Value = Opt.Value
                drawProgress(prg)
                fillProgress(prg)
                return
            end
            printErr("[GUI] Error: progress '%s' not found\n", Opt.label)
        end)
    end

    local getProgressValue = function (Opt)
        local value
        table.foreach(self.charts, function (key, prg)
            if prg.label == Opt.label then
                value = prg.Value
                return
            end
            printErr("[GUI] Error: progress '%s' not found\n", Opt.label)
        end)
        return value
    end

    local newProgress = function (Opt)
        local xmin, xmax, ymin, ymax = getCoordonate(Opt.Position, Opt.Size)
        local Progress = {
            Type = Opt.Type,
            label = Opt.label,
            Xmin = xmin,
            Xmax = xmax,
            Ymin = ymin,
            Ymax = ymax,
            ValueMax = Opt.Max,
            Value = Opt.Value,
            Color = Opt.Color
        }
        table.insert(self.charts, Progress)
        return
    end

    -- create new group
    local newGroup = function (Opt)
        local xmin, xmax, ymin, ymax = getCoordonate(Opt.Position, Opt.Size)
        local group = {
            label = Opt.label,
            Xmin = xmin,
            Xmax = xmax,
            Ymin = ymin,
            Ymax = ymax,
            Color = Opt.Color
        }
        table.insert(self.groups, group)
        return
    end

    -- create new button
    local newButton = function (Opt)
        local colors = {}
        local xmin, xmax, ymin, ymax = getCoordonate(Opt.Position, Opt.Size)
        colors["idle"] = Opt.Colors[1]
        colors["active"] = Opt.Colors[2]
        local button = {
            label = Opt.label,
            callback = Opt.callback,
            Xmin = xmin,
            Xmax = xmax,
            Ymin = ymin,
            Ymax = ymax,
            Colors = colors
        }
        table.insert(self.buttons, button)
        return
    end

    -- init GUI (Draw all logged elements and start events loop)
    local init = function ()
        self.monitor.clear()
        drawAllGroups()
        drawAllProgress()
        drawAllButtons()
        waitForEvents()
    end

    return {
        newButton = newButton,
        newGroup = newGroup,
        newProgress = newProgress,
        updateProgress = updateProgress,
        getProgressValue = getProgressValue,
        init = init
    }
end

return { newGUI = newGUI }