Box = class("Box", BaseEntity)
Box:include(Collides)
local image = love.graphics.newImage("assets/box.png")

function Box:initialize(props)
	BaseEntity.initialize(self, props)
	self.image = image
end

function Box:push(dx, dy)
	local new_x, new_y = self.x + dx, self.y + dy
end

function Box:draw()
	love.graphics.draw(self.image, self.x, self.y)
end
