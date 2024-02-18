Altar = class("Altar", BaseEntity)
Altar.static._image = love.graphics.newImage("assets/altar.png")

function Altar:initialize(props)
	BaseEntity.initialize(self, props)
	self.is_passable = true
end

function Altar:draw()
	love.graphics.draw(Altar._image, self.x, self.y)
end
