Animal = class("Animal", BaseEntity)
Animal:include(Collides)
Animal:include(Killable)
Animal:include(Rewindable)
Animal.static._alive_image = love.graphics.newImage("assets/animal-alive.png")
Animal.static._dead_image = love.graphics.newImage("assets/animal-dead.png")
local STATE = {
	ALIVE = "ALIVE",
	DEAD = "DEAD",
}

function Animal:initialize(props)
	BaseEntity.initialize(self, props)
	self.state = STATE.ALIVE
end

function Animal:draw()
	if self.state == STATE.DEAD then
		love.graphics.draw(Animal._dead_image, self.x, self.y)
	else
		love.graphics.draw(Animal._alive_image, self.x, self.y)
	end
end
