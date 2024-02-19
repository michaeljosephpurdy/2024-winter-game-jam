Exit = class("Exit", BaseEntity)
--local image = love.graphics.newImage("assets/exit.png")

function Exit:initialize(props)
	BaseEntity.initialize(self, props)
	self.is_solid = true
end

function Exit:trigger(other)
	--pass
	--print("exit riggered")
end

function Exit:draw()
	--love.graphics.draw(self.image, self.x, self.y)
end
