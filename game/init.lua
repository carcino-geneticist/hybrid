local system = require 'system/init'
local display = require 'display/init'
local gameboard = require 'game/gameboard'

local debug = system.debug
local game = {}


function game:init()
	debug {"game init()"}
	gameboard:init()
end

local tick_time = 0
local tick_interval = .3
function game:update(dt)
	local tick = false
	tick_time = tick_time + dt
	if tick_time >= tick_interval then
		tick = true  
		tick_time = tick_time - tick_interval
	end
	gameboard:update(dt, tick)
end

return game
