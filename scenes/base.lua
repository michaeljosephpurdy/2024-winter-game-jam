BaseScene = class("BaseScene")

function BaseScene:initialize()
	love.graphics.setBackgroundColor(115, 239, 247)
	self.entities = {}
end

function BaseScene:update()
	-- pass
end

function BaseScene:draw()
	love.graphics.clear()
end
