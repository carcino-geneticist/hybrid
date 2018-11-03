local system = require 'system/init'
local display = require 'display/init'

function love.load()
	system.debug {"love.load() started"}
	display:init()

	local hone = {
		id = "one",
		main = function(arg)
			system.debug {"Counter: ", arg}
		end
	}

	local htwo = {
		id = "two",
		main = function(arg)
			system.debug {"Counter: ", arg}
		end
	}

	display:setGridEventHandler(2, 2, display.events.grid.click, hone)
	display:setGridEventHandler(4, 4, display.events.grid.click, htwo)

	system.debug {"love.load() finished"}
end

function love.update(dt)
	display:update(dt)
end

function love.draw()
	display:draw()
end

function love.mousemoved(x, y, dx, dy)
	display:mouseMoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button)
	display:mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
	display:mouseReleased(x, y, button)
end
