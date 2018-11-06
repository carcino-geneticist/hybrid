local system = require 'system/init'
local display = require 'display/init'
local game = require 'game/init'

function love.load()
	system.debug {"love.load() started"}

	math.randomseed(os.time())
	display:init()
	game:init()

	system.debug {"love.load() finished"}
end

function love.update(dt)
	display:update(dt)
	game:update(dt)
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

function love.keypressed(key)
	display:keyPressed(key)
end

function love.keyreleased(key)
	display:keyReleased(key)
end
