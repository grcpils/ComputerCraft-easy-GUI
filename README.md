# GUI API for ComputerCraft (OS 1.8)

Download the api file with this command:
```
wget https://raw.githubusercontent.com/grcpils/cc-gui_api/master/gui_api.lua
```

After that, create new file for your project:
```
edit my_project
```

## Features
- [ ] Monitor title
- [ ] Label
- [x] Groups
- [x] Buttons
- [ ] Vertical charts
- [ ] Horizontal charts

## Usage

Add gui_api to your project:
```lua
GUI = require('gui_api)
```

Create new GUI:
```lua
gui = GUI.newGUI("position_of_your_monitor") -- Top, Bottom, Left, Right
```

Init the GUI with this line:
```lua
gui.init()
```

### Buttons

Create new button:
```lua
gui.newButton{label="button_name", callback=function_callback, Position={x,y}, Size={height,width}, Colors={idle_color,active_color}}

-- exemple

function sayHello()
    print("Hello World !")
end

gui.newButton{label="Button_A", callback=sayHello, Position={2,2}, Size={2,8}, Colors={colors.green,colors.lime}}
```

When Button_A is clicked it print `Hello World !` in your computer terminal

### Groups

Create new group:
```lua
gui.newGroup{label="group_name", Position={x,y}, Size={height,width}, Color=outline_color}

-- exemple

gui.newGroup{label="Group_A", Position={1,1}, Size={10,14}, Color=colors.gray}

```

## Full interface exemple

```lua
-- import gui_api
GUI = require('gui_api')

-- create gui tools
gui = GUI.newGUI("right")

-- callback functions declaration
function sayHello () print("Hello") end
function sayWorld () print("World") end

-- adding buttons
gui.newButton{label="Hello", callback=sayHello, Position={4,4}, Size={2,10}, Colors={colors.green,colors.lime}}
gui.newButton{label="World", callback=sayWorld, Position={4,16}, Size={2,10}, Colors={colors.red,colors.orange}}

-- adding group
gui.newGroup{label="Buttons Group", Position={2,2}, Size={16,26}, Color=colors.gray}

-- start the GUI
gui.init()
```

## Screenshot

![gui_api]()