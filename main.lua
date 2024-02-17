class = require("plugins/middleclass")
require("scenes.base")

require("scenes.puzzle")

function love.load()
	--pass
	current_scene = PuzzleScene:new()
end

function love.update()
	--pass
	current_scene:update()
end

function love.draw()
	--pass
	current_scene:draw()
end
