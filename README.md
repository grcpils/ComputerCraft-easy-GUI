# GUI API for ComputerCraft (OS 1.8)

Download the api file with this command:
```
wget gui_api.lua https://raw.githubusercontent.com/grcpils/cc-gui_api/master/gui_api.lua
```

After that, create new file for your project:
```
edit my_project
```

## Features
- [ ] Monitor title
- [ ] label
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