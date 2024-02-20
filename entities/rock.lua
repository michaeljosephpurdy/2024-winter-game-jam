Rock = class("Rock", BaseEntity)
Rock:include(Collides)
Rock:include(Rewindable)
Rock.static._movable_image = love.graphics.newImage("assets/rock-movable.png")
Rock.static._passable_image = love.graphics.newImage("assets/rock-passable.png")
local STATE = {
	MOVABLE = "MOVABLE",
	PASSABLE = "PASSABLE",
}

function Rock:initialize(props)
	BaseEntity.initialize(self, props)
	self.state = STATE.MOVABLE
	self.weight = 1
end

function Rock:draw()
	if self.state == STATE.MOVABLE then
		love.graphics.draw(Rock._movable_image, self.x, self.y)
	elseif self.state == STATE.PASSABLE then
		love.graphics.draw(Rock._passable_image, self.x, self.y)
	end
end
