Text = class("Text", BaseEntity)
Text.static._font = love.graphics.newFont("assets/MajorMonoDisplay-Regular.ttf", 20)
Text.static._font:setFilter("nearest", "nearest")

function Text:initialize(props)
	BaseEntity.initialize(self, props)
	self.offset = Text._font:getWidth(self.text) / 2
	self.x = self.x + self.w / 2
	self.r = 26 / 255
	self.g = 28 / 255
	self.b = 44 / 255
end

function Text:draw()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.r, self.g, self.b)
	love.graphics.print(self.text, Text._font, self.x - self.offset, self.y)
	love.graphics.setColor(r, g, b, a)
end
