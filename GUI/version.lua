local GUI_API_VERSION = "1.0.0"
local GUI_API_CDN_URL = "https://cdn.grcpils.fr/cc-files/GUI_API/"
local GUI_API_VERSION_FILE = "version.lua"
local GUI_API_DIRECTORY = "GUI"
local GUI_API_DIRECTORY_TEMP = "GUI/tmp"
local Utils    =  require("GUI/utils")

local download = function(url, file)
    local content = http.get(url).readAll()
    if not content then
      error("Could not connect to website")
    end
    f = fs.open(file, "w")
    f.write(content)
    f.close()
end

local get = function ()
    return GUI_API_VERSION
end

local checkUpdate = function ()
    download(GUI_API_CDN_URL.."version.lua", GUI_API_DIRECTORY_TEMP.."/version.lua")
    local version = require(GUI_API_DIRECTORY.."/version")
    local nversion = require(GUI_API_DIRECTORY_TEMP.."/version")
    if version.get() ~= nversion.get() then
        Utils.printWarn("[GUI] New version of GUI is available !\n")
    end
    fs.delete(GUI_API_DIRECTORY_TEMP)
end

return { get = get, checkUpdate = checkUpdate }