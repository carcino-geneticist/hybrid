local system = require 'system/init'
local display = require 'display/init'

local debug = system.debug
local tiles = {}
tiles.wall = require 'tiles/wall'
tiles.floor = require 'tiles/floor'


local board = {}
local gameboard = {}

function gameboard:init()
	debug{"gameboard init()"}
	for x = 1, system.settings.grid_width, 1 do
		for y = 1, system.settings.grid_height, 1 do
			local tile = tiles.floor
			if 
				x == 1 or x == system.settings.grid_width
				or y == 1 or y == system.settings.grid_height
			then
				tile = tiles.wall
			end
			self:setTile(x, y, tile)
		end
	end
end

function gameboard:setTile(x, y, tile)
		display:setGridCell(x,y,{char=tile.char, color=tile.color})
end

function gameboard:update(dt)

end

return gameboard
