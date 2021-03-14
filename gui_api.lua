--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

table = require 'table'

function newGUI (monitorSide)
    local self = { monitor = peripheral.wrap(monitorSide), buttons = {}, charts = {}, }

    local Position = { x = 0, y = 0 }
    local Size = { h = 0, w = 0 }
    local Colors = { idle, active }

    --
    -- PRIVATE
    --

    local printf = function(s,...)
        return io.write(s:format(...))
    end

    local drawShape = function (shape)
        for cY = shape.Ymin, shape.Ymax do
            self.monitor.setCursorPos(shape.Xmin, cY)
            self.monitor.write(" ")
            for cX = shape.Xmin, shape.Xmax do
                self.monitor.write(" ")
            end
        end
    end

    local drawBtnLabel = function (btn, state)
        local Y = math.floor((btn.Ymin + btn.Ymax) / 2)
        local X = math.floor((btn.Xmax + btn.Xmin) / 2) - 1
        self.monitor.setBackgroundColor(btn.Colors[state])
        self.monitor.setCursorPos(X, Y)
        self.monitor.write(btn.label)
        self.monitor.setBackgroundColor(colors.black)
    end

    local drawButton = function (btn, state)
        self.monitor.setBackgroundColor(btn.Colors[state])
        drawShape(btn)
        drawBtnLabel(btn, state)
        self.monitor.setBackgroundColor(colors.black)
    end

    local drawAllButtons = function ()
        table.foreach(self.buttons, function (key, btn)
            printf("[GUI] Draw '%s' with ID: %s\n", btn.label, key)
            drawButton(btn, "idle")
        end)
    end

    local flashButton = function (btn)
        drawButton(btn, "active")
        sleep(0.2)
        drawButton(btn, "idle")
    end

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

    local waitForEvents = function ()
       while true do
            event, side, x, y = os.pullEvent("monitor_touch")
            buttonWaitForClick(x, y)
        end
    end

    --
    -- PUBLIC
    --

    local newButton = function (Opt)
        Ymin = math.floor(Opt.Position[1])
        Xmin = math.floor(Opt.Position[2])
        Ymax = math.floor((Opt.Position[1] + Opt.Size[1]))
        Xmax = math.floor((Opt.Position[2] + Opt.Size[2]))
        Colors["idle"] = Opt.Colors[1]
        Colors["active"] = Opt.Colors[2]
        button = {
            label = Opt.label,
            callback = Opt.callback,
            Ymin = Ymin,
            Xmin = Xmin,
            Ymax = Ymax,
            Xmax = Xmax,
            Colors = Colors
        }
        table.insert(self.buttons, button)
        return
    end

    local logAllButtons = function ()
        table.foreach(self.buttons, function (key, value)
            printf("[GUI] button '%s' ID: %s\n", key, value.label)
        end)
    end

    local init = function ()
        drawAllButtons()
        waitForEvents()
    end

    return {
        newButton = newButton,
        logAllButtons = logAllButtons,
        init = init
    }
end

return { newGUI = newGUI }