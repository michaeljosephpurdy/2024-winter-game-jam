PuzzleScene = class("PuzzleScene", BaseScene)

function PuzzleScene:initialize()
	--pass
end

function PuzzleScene:update()
	-- pass
	BaseScene.update(self)
end

function PuzzleScene:draw()
	-- pass
	BaseScene.draw(self)
	love.graphics.print("hi", 20, 20)
end
