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

GUI_MONITOR = nil
GUI_BUTTONS = {}
GUI_PROGRESS = {}
GUI_GROUPS = {}

local waitForEvents = function ()
    Utils.printInfo("[GUI] Waiting for events ...\n")
    while true do
        event, side, x, y = os.pullEvent("monitor_touch")
        Button.waitForClick(x, y)
    end
end

local setMonitor = function (monitor)
    GUI_MONITOR = peripheral.wrap(monitor)
end

local init = function()
    if GUI_MONITOR == nil then
        Utils.printErr("[GUI] Error %s %s: No monitor setup\n", debug.getinfo(2).source, debug.getinfo(2).currentline)
        return
    end
    Version.checkUpdate()
    Utils.clearAll()
    Button.drawAll()
    Group.drawAll()
    Progress.drawAll()
    waitForEvents()
end

return {
    init = init,
    setMonitor = setMonitor,
    Button = Button,
    Group = Group,
    Progress = Progress
}