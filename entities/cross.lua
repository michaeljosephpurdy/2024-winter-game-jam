Cross = class("Cross", BaseEntity)
Cross.static._inactive = love.graphics.newImage("assets/enter-inactive.png")
Cross.static._active = love.graphics.newImage("assets/enter-active.png")
Cross.static._completed = love.graphics.newImage("assets/enter-completed.png")

local STATE = {
	INACTIVE = "INACTIVE",
	ACTIVE = "ACTIVE",
	COMPLETED = "COMPLETED",
}
function Cross:initialize(props)
	self.active = 0
	BaseEntity.initialize(self, props)
	self.is_passable = true
	self.state = STATE.INACTIVE
end

function Cross:update()
	self.state = STATE.INACTIVE
	if GAME_STATE.offerings >= self.active then
		self.state = STATE.ACTIVE
	end
end

function Cross:can_enter()
	return self:is_active()
end

function Cross:is_active()
	return self.state ~= STATE.INACTIVE
end

function Cross:draw()
	if self.state == STATE.INACTIVE then
		love.graphics.draw(Cross._inactive, self.x, self.y)
	elseif self.state == STATE.ACTIVE then
		love.graphics.draw(Cross._active, self.x, self.y)
	elseif self.state == STATE.COMPLETED then
		love.graphics.draw(Cross._completed, self.x, self.y)
	end
end
