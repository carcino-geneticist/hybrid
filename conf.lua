-- the actual configuration
local grid_width = 28
local grid_height = 14
local grid_cell_width = 19
local grid_cell_height = 32





-- love2d configuration method
function love.conf(t)
	t.title = "hybrid"

	t.window.height = grid_height * grid_cell_height
	t.window.width = grid_cell_width * grid_width + (grid_cell_width * grid_width / 2)
end

-- my configuration method
local conf = {}
function conf.configure(t)
	t.debug = true 		-- turn on debug messages
	t.grid_width = grid_width
	t.grid_height = grid_height
	t.grid_cell_width = grid_cell_width
	t.grid_cell_height = grid_cell_height
end
return conf
