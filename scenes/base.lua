BaseScene = class("BaseScene")

function BaseScene:initialize()
	love.graphics.setBackgroundColor(115, 239, 247)
	self.entities = {}
end

function BaseScene:update()
	-- pass
end

function BaseScene:draw()
	love.graphics.clear(115 / 255, 239 / 255, 247 / 255)
end
