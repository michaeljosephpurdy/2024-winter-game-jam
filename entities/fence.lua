Fence = class("Fence", BaseEntity)
Fence.static._closed_image = love.graphics.newImage("assets/fence-closed.png")
Fence.static._open_image = love.graphics.newImage("assets/fence-open.png")

function Fence:initialize(props)
	BaseEntity.initialize(self, props)
end

function Fence:update()
	self.closed = self.open >= GAME_STATE.offerings
	self.is_passable = not self.closed
	self.is_solid = self.closed
end

function Fence:draw()
	if self.closed then
		love.graphics.draw(Fence._closed_image, self.x, self.y)
	else
		love.graphics.draw(Fence._open_image, self.x, self.y)
	end
end
