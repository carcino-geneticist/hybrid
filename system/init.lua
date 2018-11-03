local sys = {}
local conf = require 'conf'

-- settings
sys.settings = {
	grid_width = 34,	-- (34 cells across)
	grid_height = 21,	-- (21 cells down)
	grid_cell_width = 19,	--
	grid_cell_height = 32,	-- used to determine display size

	debug = false		-- print debug messages
}
conf.configure(sys.settings)

-- room for potential abstraction
sys.graphics = love.graphics

-- logging
function sys.debug(messages)
	if not sys.settings.debug then return end
	message = "DEBUG: "
	for i,v in ipairs(messages) do
		message = message .. (v or "[nil]")
	end
	io.write(message.."\n")
end

return sys