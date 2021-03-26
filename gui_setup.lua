--
-- Created by Grcpils
-- 03/14/2021
-- Github: https://github.com/grcpils/cc-gui_api
-- Please do not delete this header ;)
--

require("table")

local args = {...}

local GUI_API_CDN_URL = "http://cdn.grcpils.fr/cc-files/GUI_API/"
local GUI_API_VERSION_FILE = "version.lua"
local GUI_API_DIRECTORY = "GUI"
local GUI_API_DIRECTORY_TEMP = "GUI/tmp"
local GUI_API_FILES = {
    "init.lua",
    "button.lua",
    "group.lua",
    "progress.lua",
    "utils.lua",
    "version.lua"
}
local GUI_API_HELP_MESSAGE = "Use one of the following argument:\n    -i or --install  Install the current version of the GUI_API\n    -f or --force    Force reinstall current version of the GUI_API\n    -u or --update   Check update\n    -r or --remove   Remove GUI_API from the computer"

local printf = function(s,...)
    return io.write(s:format(...))
end

function download(url, file)
    local content = http.get(url).readAll()
    if not content then
      error("Could not connect to website")
    end
    f = fs.open(file, "w")
    f.write(content)
    f.close()
end

function exist ()
    if fs.exists(GUI_API_DIRECTORY) then
        return false
    elseif fs.exists(GUI_API_DIRECTORY.."/version.lua") then
        return false
    else
        return true
    end
end

function install ()
    if not exist() then
        term.setTextColor(colors.red)
        printf("[GUI] GUI already installed\n")
        term.setTextColor(colors.white)
        return
    end
    table.foreach(GUI_API_FILES, function(k,f)
        printf("[GUI] Downloading %s ... ", f)
        download(GUI_API_CDN_URL..f, GUI_API_DIRECTORY.."/"..f)
        printf("done\n")
    end)
    if exist() then
        term.setTextColor(colors.red)
        printf("[GUI] Error with installation, please retry\n")
        term.setTextColor(colors.white)
        return
    end
    printf("[GUI] Install finished :)\n")
end

function update ()
    if not exist() then
        download(GUI_API_CDN_URL.."version.lua", GUI_API_DIRECTORY_TEMP.."/version.lua")
        local version = require(GUI_API_DIRECTORY.."/version")
        local nversion = require(GUI_API_DIRECTORY_TEMP.."/version")
        if version.get() == nversion.get() then
            fs.delete(GUI_API_DIRECTORY_TEMP)
            printf("[GUI] GUI is up-to-date ;)\n")
        else
            printf("[GUI] new version is available (%s)\n[GUI] Do you want download this update ? (y, n)\n", nversion.get())
            input = read()
            if input == "y" or input == "Y" then
                printf("[GUI] Starting update :)\n")
                remove()
                install()
            else
                fs.delete(GUI_API_DIRECTORY_TEMP)
                printf("[GUI] Update canceled :(\n")
                return
            end
        end
    end
end

function version()
    local version = require(GUI_API_DIRECTORY.."/version")
    printf("[GUI] Version: %s\n", version.get())
end

function remove()
    if not exist() then
        fs.delete(GUI_API_DIRECTORY)
        printf("[GUI] gui_api succesfully removed\n")
    else
        term.setTextColor(colors.red)
        printf("[GUI] Error: no GUI_API installation found\n")
        term.setTextColor(colors.white)
    end
end

function init ()
    if args[1] == "-i" or args[1] == "--install" then
        install()
    elseif args[1] == "-f" or args[1] == "--force" then
        remove()
        install()
    elseif args[1] == "-u" or args[1] == "--update" then
        update()
    elseif args[1] == "-r" or args[1] == "--remove" then
        remove()
    elseif args[1] == "-v" or args[1] == "--version" then
        version()
    else
        print(GUI_API_HELP_MESSAGE)
    end
end

init()