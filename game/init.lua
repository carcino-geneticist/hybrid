local system = require 'system/init'
local display = require 'display/init'
--local map = require 'game/map'

local debug = system.debug
local game = {}


function game:init()
	debug {"game init()"}
	local counter = 0
	display:setMouseReleased("spawner", function(x, y, button)
		if (button == 2) then
			local x = display:getMouseX()
			debug {x}
			local y = display:getMouseY()
			local _id = "spawn"..counter
			display:setGridCell(x, y, {
				cell = {char = '#', color={1,0,0,1}},
				eventId = display.events.grid.click,
				handler = {
					id = _id,
					main = function(arg)
						display:rmGridCell(x, y, _id)
					end
				}
			})
			counter = counter + 1
		end
	end)
end

function game:update(dt)
end

return game
