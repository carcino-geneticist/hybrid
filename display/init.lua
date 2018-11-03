local system = require 'system/init'
local g = system.graphics
local debug = system.debug


local grid = {
	-- events stuff
	events = {
		click = {
			name = "click",
			counter = 0
		}
	},
	eventHandlers = {}, 
	eventHandlerIds = {}, 
	-- drawing stuff
	x = 0, y = 0,
	width = system.settings.grid_width,
	height = system.settings.grid_height,
	cell_width = system.settings.grid_cell_width,
	cell_height = system.settings.grid_cell_height,
	color = {1,1,1,.2}
}

function grid:init()
	debug({"grid init()"})
	-- initialize events
	for index = 1, self.height * self.width, 1 do
		for eventName, event in pairs(self.events) do
			local key = index..eventName
			self.eventHandlers[key] = {}
		end
	end
end

function grid:update(dt)

end

function grid:draw()
	g.setColor(self.color)
	for i = 0, self.width, 1 do
		local x = i * self.cell_width
		local y = self.height * self.cell_height
		g.line(x, 0, x, y)
	end
	for i = 0, self.height , 1 do
		local x = self.width * self.cell_width
		local y = i * self.cell_height
		g.line(0, y, x, y)
	end
end

function grid:mouseMoved(x, y, dx, dy)
end

function grid:mousePressed(x, y, button)
end

function grid:mouseReleased(x, y, button)
	local gridx = math.floor(x / self.cell_width) + 1
	local gridy = math.floor(y / self.cell_height) + 1
	self.events.click.counter = self.events.click.counter + 1
	self:propagateEvent(gridx, gridy, self.events.click.name, self.events.click.counter)
end

function grid:propagateEvent(x, y, eventId, args)
	local index = (y-1) * self.width + x
	local eventKey = index..eventId
	debug {"propagate event: ", eventKey}
	for id, handler in pairs(self.eventHandlers[eventKey]) do
		-- only fire event if it's still the most recent registration
		if self.eventHandlerIds[id] == eventKey then 
			handler.main(args)
		else 
			debug({"Expired Handler: " .. handler.id})
		end
	end
end

function grid:setEventHandler(x, y, eventId, handler)
	local index = (y-1) * self.width + x
	local key = index .. eventId
	debug({"grid setEventHandler(): ", key})
	if self.eventHandlerIds[handler.id] then
		-- set the existing reference to nil ( i think that deletes it )
		self.eventHandlers[self.eventHandlerIds[handler.id]][handler.id] = nil
	end
	self.eventHandlerIds[handler.id] = key
	if (self.eventHandlers[key]) then 
		self.eventHandlers[key][handler.id] = handler
	end
end

--------------
-- EXPORTED --
--------------
local display = {}
display.events = {
	grid = {}
}

function display:init()
	debug({"display init()"})
	grid:init()

	-- register events in grid in display
	for _, ev in pairs(grid.events) do
		self.events.grid[ev.name] = ev.name
	end
end

function display:update(dt)
	grid:update(dt)
end

function display:draw()
	grid:draw()
end

function display:mouseMoved(x, y, dx, dy)
	grid:mouseMoved(x, y, dx, dy)
end

function display:mousePressed(x, y, button)
	grid:mousePressed(x, y, button)
end

function display:mouseReleased(x, y, button)
	if 
		x > grid.x
		and y > grid.y
		and x < grid.x + grid.width * grid.cell_width
		and y < grid.y + grid.height * grid.cell_height
	then
		grid:mouseReleased(x, y, button)
	end
end

function display:setGridEventHandler(x, y, eventId, eventHandler)
	debug({"display setGridEventHandler()"})
	grid:setEventHandler(x, y, eventId, eventHandler)
end

return display
