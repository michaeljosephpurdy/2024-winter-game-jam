Text = class("Text", BaseEntity)

function Text:initialize(props)
	BaseEntity.initialize(self, props)
	self.offset = #self.text * 6.5
end

function Text:draw()
	love.graphics.print(self.text, self.x - self.offset, self.y, 0, 2, 2)
end
