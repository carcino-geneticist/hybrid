local system = require 'system/init'
local g = system.graphics
local debug = system.debug

local grid = {
	-- the grid
	grid = {},
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
	color = {1,1,1,0}
}

function grid:init()
	debug {"grid init()"}
	-- initialize grid
	for index = 1, self.height * self.width, 1 do
		self.grid[index] = {char = ' '}
	end
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

function grid:draw(font)
	-- draw the grid
	--[[g.setColor(self.color)
	for i = 0, self.width, 1 do
		local x = i * self.cell_width
		local y = self.height * self.cell_height
		g.line(x, 0, x, y)
	end
	for i = 0, self.height , 1 do
		local x = self.width * self.cell_width
		local y = i * self.cell_height
		g.line(0, y, x, y)
	end]]

	-- draw each cell
	local x_adj = 2
	local y_adj = -4
	g.setFont(font)
	for index, cell in ipairs(self.grid) do
		local i = index - 1
		local x = math.floor(i % self.width)
		local y = math.floor(i / self.width)
		-- adj in pixels
		g.setColor(cell.color or system.settings.color.default)
		g.print(cell.char or ' ', x * self.cell_width + x_adj, y * self.cell_height + y_adj)
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
	if not eventId or not handler then return end

	local index = (y-1) * self.width + x
	local key = index .. eventId
	debug {"grid setEventHandler(): ", key, handler.id}
	if self.eventHandlerIds[handler.id] then
		-- set the existing reference to nil ( i think that deletes it )
		self.eventHandlers[self.eventHandlerIds[handler.id]][handler.id] = nil
		self.eventHandlerIds[handler.id] = nil
	end

	if not handler.main then return end	-- no main func, no handler

	self.eventHandlerIds[handler.id] = key
	if (self.eventHandlers[key]) then 
		self.eventHandlers[key][handler.id] = handler
	end
end

function grid:setCell(x, y, cell)
	local index = (y-1) * self.width + x	
	self.grid[index] = cell 
end

return grid
