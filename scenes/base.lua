BaseScene = class("BaseScene")

function BaseScene:initialize()
	self.clear_color = love.math.colorFromBytes(26, 28, 44)
	-- pass
end

function BaseScene:update()
	-- pass
end

function BaseScene:draw()
	-- pass
	love.graphics.clear(self.clear_color)
end
