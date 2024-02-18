Player = class("Player", BaseEntity)
Player.static._image = love.graphics.newImage("assets/player.png")
Player.static._target_image = love.graphics.newImage("assets/target.png")
Player:include(Collides)
Player:include(Rewindable)
local STATE = {
	MOVING = "MOVING",
	KILL_MODE = "KILL_MODE",
}

function Player:initialize(props)
	BaseEntity.initialize(self, props)
	self.dx = 0
	self.dy = 0
	self.target_x = 0
	self.target_y = 0
	self.released_keys = {}
	self.lives = 3
	self.state = STATE.MOVING
	PubSub.subscribe("keyrelease", function(key)
		table.insert(self.released_keys, key)
	end)
end

function Player:input()
	self.dx = 0
	self.dy = 0
	while #self.released_keys > 0 do
		local key = table.remove(self.released_keys)
		if key == "left" or key == "a" then
			if self.state == STATE.MOVING then
				self.dx = -1
			elseif self.state == STATE.KILL_MODE then
				self.target_x = self.x - self.w
				self.target_y = self.y
			end
		end
		if key == "right" or key == "d" then
			if self.state == STATE.MOVING then
				self.dx = 1
			elseif self.state == STATE.KILL_MODE then
				self.target_x = self.x + self.w
				self.target_y = self.y
			end
		end
		if key == "up" or key == "w" then
			if self.state == STATE.MOVING then
				self.dy = -1
			elseif self.state == STATE.KILL_MODE then
				self.target_x = self.x
				self.target_y = self.y - self.h
			end
		end
		if key == "down" or key == "s" then
			if self.state == STATE.MOVING then
				self.dy = 1
			elseif self.state == STATE.KILL_MODE then
				self.target_x = self.x
				self.target_y = self.y + self.h
			end
		end
		if key == "x" or key == "l" then
			if self.state == STATE.KILL_MODE then
				self.parent:on_each_entity(function(other)
					if other.kill and other.x == self.target_x and other.y == self.target_y then
						other:kill()
						self.state = STATE.MOVING
					end
				end)
			-- perform kill
			else
				self.state = STATE.KILL_MODE
				self.target_x = self.x
				self.target_y = self.y
			end
		end
		if key == "z" or key == "k" then
			if self.state == STATE.KILL_MODE then
				-- back out of kill mode
				self.state = STATE.MOVING
			elseif self.state == STATE.MOVING then
				-- undo last move
				self.dx = 0
				self.dy = 0
				self.parent:rewind()
			end
		end
	end
end

function Player:update(dt)
	BaseEntity.update(self, dt)
	self:input()
	if self.dx == 0 and self.dy == 0 then
		return
	end
	self:move(self.dx, self.dy)
	self.parent:tick()
end

function Player:draw()
	BaseEntity.draw(self)
	love.graphics.draw(Player._image, self.x, self.y)
	love.graphics.print(self.state, self.x - 10, self.y + 20)
	if self.state == STATE.KILL_MODE then
		love.graphics.draw(Player._target_image, self.target_x, self.target_y)
	end
end
