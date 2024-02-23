BaseScene = class("BaseScene")
BaseScene.static._clear_color = { 51 / 255, 60 / 255, 87 / 255, 1 }

function BaseScene:initialize()
	self.entities = {}
end

function BaseScene:update()
	-- pass
end

function BaseScene:draw()
	love.graphics.clear(BaseScene._clear_color)
end
