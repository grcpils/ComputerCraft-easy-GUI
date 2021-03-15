--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

table = require 'table'

function newGUI (monitorSide)
    local self = { monitor = peripheral.wrap(monitorSide), buttons = {}, charts = {}, groups = {} }

    local Position = { x = 0, y = 0 }
    local Size = { h = 0, w = 0 }
    local Colors = { idle, active }

    --
    -- PRIVATE
    --

    -- printf function like C
    local printf = function(s,...)
        return io.write(s:format(...))
    end

    -- draw a simple Shape with Xmin, Xmax, Ymin, Ymax values
    local drawShape = function (shape)
        for cY = shape.Ymin, shape.Ymax do
            for cX = shape.Xmin, shape.Xmax do
                self.monitor.setCursorPos(cX, cY)
                self.monitor.write(" ")
            end
        end
    end

    -- draw outline of Shape with Xmin, Xmax, Ymin, Ymax values
    local drawShapeOut = function (shape)
        for cY = shape.Ymin, shape.Ymax do
            for cX = shape.Xmin, shape.Xmax do
                self.monitor.setCursorPos(cX, cY)
                if cY == Ymin or cY == Ymax then
                    self.monitor.write(" ")
                elseif cX == Xmin or cX == Xmax then
                    self.monitor.write(" ")
                end
            end
        end
    end

    -- draw group label
    local drawGroupLabel = function (grp)
        local Y = Ymin
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
            printf("[GUI] Draw group '%s' with ID: %s\n", grp.label, key)
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
            printf("[GUI] Draw button '%s' with ID: %s\n", btn.label, key)
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
        Ymin = math.floor(Position[1])
        Xmin = math.floor(Position[2])
        Ymax = math.floor((Position[1] + Size[1]))
        Xmax = math.floor((Position[2] + Size[2]))
        return Xmin, Xmax, Ymin, Ymax
    end

    --
    -- PUBLIC
    --

    -- create new group
    local newGroup = function (Opt)
        Xmin, Xmax, Ymin, Ymax = getCoordonate(Opt.Position, Opt.Size)
        local group = {
            label = Opt.label,
            Xmin = Xmin,
            Xmax = Xmax,
            Ymin = Ymin,
            Ymax = Ymax,
            Color = Opt.Color
        }
        table.insert(self.groups, group)
        return
    end

    -- create new button
    local newButton = function (Opt)
        local colors = {}
        Xmin, Xmax, Ymin, Ymax = getCoordonate(Opt.Position, Opt.Size)
        colors["idle"] = Opt.Colors[1]
        colors["active"] = Opt.Colors[2]
        local button = {
            label = Opt.label,
            callback = Opt.callback,
            Ymin = Ymin,
            Xmin = Xmin,
            Ymax = Ymax,
            Xmax = Xmax,
            Colors = colors
        }
        table.insert(self.buttons, button)
        return
    end

    -- print all logged buttons in terminal
    local logAllButtons = function ()
        table.foreach(self.buttons, function (key, value)
            printf("[GUI] button '%s' ID: %s\n", key, value.label)
        end)
    end

    -- init GUI (Draw all logged elements and start events loop)
    local init = function ()
        self.monitor.clear()
        drawAllGroups()
        drawAllButtons()
        waitForEvents()
    end

    return {
        newButton = newButton,
        newGroup = newGroup,
        logAllButtons = logAllButtons,
        init = init
    }
end

return { newGUI = newGUI }