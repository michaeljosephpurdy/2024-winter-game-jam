BaseScene = class("BaseScene")

function BaseScene:initialize()
	love.graphics.setBackgroundColor(26, 28, 44)
	self.entities = {}
end

function BaseScene:update()
	-- pass
end

function BaseScene:draw()
	love.graphics.clear()
end
