--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

require("table")
local Utils    =  require("GUI/utils")
local Version  =  require("GUI/version")
local Button   =  require("GUI/button")
local Group    =  require("GUI/group")
local Progress =  require("GUI/progress")
local Tiles    =  require("GUI/tiles")

GUI_MONITOR = nil
GUI_BUTTONS = {}
GUI_GROUPS = {}
GUI_PROGRESS = {}
GUI_TILES = {}
GUI_CONFIG = {}

local catchEvents = function (x,y)
    Button.waitForClick(x, y)
end

local setMonitor = function (monitor)
    GUI_MONITOR = peripheral.wrap(monitor)
end

local welcomeTerm = function ()
    term.setCursorPos(13,1)
    term.setTextColor(colors.yellow)
    term.write("| GUI v"..Version.get())
    term.setCursorPos(1,2)
end

local init = function (e_callback)
    if GUI_MONITOR == nil then
        Utils.printErr("[GUI] Error %s %s: No monitor setup\n", debug.getinfo(2).source, debug.getinfo(2).currentline)
        return
    end
    welcomeTerm()
    Version.checkUpdate()
    Utils.clearAll()
    Button.drawAll()
    Group.drawAll()
    Progress.drawAll()
    Tiles.drawAll()
    if e_callback ~= nil then
        if type(e_callback) == "function" then
            e_callback()
        else
            Utils.printErr("[GUI] Error %s %s: argument give to GUI.init() is not a function\n", debug.getinfo(2).source, debug.getinfo(2).currentline)
        end
    end
end

return {
    init = init,
    setMonitor = setMonitor,
    Button = Button,
    Group = Group,
    Progress = Progress,
    Tiles = Tiles,
    catchEvents = catchEvents
}
