local system = require 'system/init'
local grid = require 'display/grid'
local g = system.graphics
local debug = system.debug

local display = {}

--------------
-- EXPORTED --
--------------


-------------
function display:init()
	debug {"display init()"}
	self.font = g.newFont("assets/RobotoMono-Regular.ttf",24)

	-- callback containers
	display.mouseMovedCB = {}
	display.mousePressedCB = {}
	display.mouseReleasedCB = {}
	display.keyPressedCB = {}
	display.keyReleasedCB = {}

	-- exported events
	display.events = {
		grid = {}
	}

	-- register events in grid in display
	for _, ev in pairs(grid.events) do
		self.events.grid[ev.name] = ev.name
	end

	-- init grid (duh)
	grid:init()

	-- some misc config 
	system.keyboard.setTextInput(false)
	system.keyboard.setKeyRepeat(false)

end

function display:update(dt)
	grid:update(dt)
end

function display:draw()
	grid:draw(self.font)
end
-------------

-------------
function display:mouseMoved(x, y, dx, dy)
	grid:mouseMoved(x, y, dx, dy)
	for k, v in pairs(self.mouseMovedCB) do
		v(x, y, dx, dy)
	end
end

function display:setMouseMoved(key, func)
	self.mouseMovedCB[key] = func
end

function display:rmMouseMoved(key)
	self.mouseMovedCB[key] = nil
end
-------------

-------------
function display:mousePressed(x, y, button)
	grid:mousePressed(x, y, button)
	for k, v in pairs(self.mousePressedCB) do
		v(x, y, button)
	end
end

function display:setMousePressed(key, func)
	self.mousePressedCB[key] = func
end

function display:rmMousePressed(key)
	self.mousePressedCB[key] = nil
end
-------------

-------------
function display:mouseReleased(x, y, button)
	if 
		x > grid.x
		and y > grid.y
		and x < grid.x + grid.width * grid.cell_width
		and y < grid.y + grid.height * grid.cell_height
	then
		grid:mouseReleased(x, y, button)
	end
	for k, v in pairs(self.mouseReleasedCB) do
		v(x, y, button)
	end
end

function display:setMouseReleased(key, func)
	self.mouseReleasedCB[key] = func
end

function display:rmMouseReleased(key)
	self.mouseReleasedCB[key] = nil
end
-------------

-------------
function display:keyPressed(key)
	if key == 'q' then system.quit() end
	for k,v in pairs(self.keyPressedCB) do
		v(key)
	end
end

function display:setKeyPressed(key, func)
	self.keyPressedCB[key] = func
end

function display:rmKeyPressed(key)
	self.keyPressedCB[key] = nil
end

function display:keyReleased(key)
	for k,v in pairs(self.keyReleasedCB) do
		v(key)
	end
end

function display:setKeyReleased(key, func)
	io.write(key)
	self.keyReleasedCB[key] = func
end

function display:rmKeyReleased(key)
	self.keyReleasedCB[key] = nil
end
-------------

-------------
function display:getMouseX()
	local x = system.mouse.getX()
	local gridx = math.floor(x / system.settings.grid_cell_width) + 1
	return gridx
end

function display:getMouseY()
	local y = system.mouse.getY()
	local gridy = math.floor(y / system.settings.grid_cell_height) + 1
	return gridy
end

function display: getMousePos()
	return self:getMouseX(), self:getMouseY()
end
-------------

-------------
function display:setGridCell(x, y, cell)
	debug {"display setGridCell()"}
	grid:setCell(x, y, {char=cell.char, color=cell.color})
	grid:setEventHandler(x, y, cell.eventId, cell.handler)
end

function display:rmGridCell(x, y, handlerId)
	debug {"display removeGridCell()"}
	grid:setCell(x, y, {})
	grid:setEventHandler(1, 1, " fucking delet ", { id = handlerId })
end
-------------

return display
