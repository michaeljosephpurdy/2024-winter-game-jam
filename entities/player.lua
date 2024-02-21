Player = class("Player", BaseEntity)
Player.static._alive_image = love.graphics.newImage("assets/player-alive.png")
Player.static._dead_image = love.graphics.newImage("assets/player-dead.png")
Player.static._target_image = love.graphics.newImage("assets/target.png")
Player.static._kill_spotlight = love.graphics.newImage("assets/spotlight-kill.png")
Player.static._atone_spotlight = love.graphics.newImage("assets/spotlight-atone.png")
Player.static._spotlight_offset = 320 - 16
Player:include(Collides)
Player:include(Rewindable)
Player:include(Killable)
local STATE = {
	MOVING = "MOVING",
	KILL_MODE = "KILL_MODE",
	DEAD = "DEAD",
}

function Player:initialize(props)
	BaseEntity.initialize(self, props)
	self.select_sacrific_text = Text:new({ text = "select a sacrific", x = self.x, y = self.y })
	self.you_must_atone_text = Text:new({ text = "atone for your sins", x = self.x, y = self.y })
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
	print("player created x: " .. self.x .. " y: " .. self.y)
end

function Player:input()
	self.dx = 0
	self.dy = 0
	while #self.released_keys > 0 do
		local key = table.remove(self.released_keys)
		if key == "left" then
			if self.state == STATE.MOVING then
				self.dx = -1
			elseif self.state == STATE.KILL_MODE then
				self.target_x = self.target_x - self.w
				if self.target_x < self.x - self.w then
					self.target_x = self.x - self.w
				end
				self.target_y = self.y
			end
		end
		if key == "right" then
			if self.state == STATE.MOVING then
				self.dx = 1
			elseif self.state == STATE.KILL_MODE then
				self.target_x = self.target_x + self.w
				if self.target_x > self.x + self.w then
					self.target_x = self.x + self.w
				end
				self.target_y = self.y
			end
		end
		if key == "up" then
			if self.state == STATE.MOVING then
				self.dy = -1
			elseif self.state == STATE.KILL_MODE then
				self.target_x = self.x
				self.target_y = self.target_y - self.h
				if self.target_y < self.y - self.h then
					self.target_y = self.y - self.h
				end
			end
		end
		if key == "down" then
			if self.state == STATE.MOVING then
				self.dy = 1
			elseif self.state == STATE.KILL_MODE then
				self.target_x = self.x
				self.target_y = self.target_y + self.h
				if self.target_y > self.y + self.h then
					self.target_y = self.y + self.h
				end
			end
		end
		if key == "x" then
			if self.state == STATE.KILL_MODE then
				self.parent:on_each_entity(function(other)
					if other.kill and other.x == self.target_x and other.y == self.target_y then
						self.state = STATE.MOVING
						other:kill()
						return
					end
				end)
				-- if we are still in kill mode at this point
				-- then that means that we found now valid targets
				-- so we should just go back to move mode
				if self.state == STATE.KILL_MODE then
					self.state = STATE.MOVING
				end
			elseif not self.no_killing and self.state ~= STATE.DEAD then
				self.state = STATE.KILL_MODE
				self.target_x = self.x
				self.target_y = self.y
			end
		end
		if key == "z" then
			if self.state == STATE.KILL_MODE then
				-- back out of kill mode
				self.state = STATE.MOVING
			elseif self.state == STATE.DEAD then
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
	self.select_sacrific_text.x = self.x
	self.select_sacrific_text.y = self.y + 64
	self.you_must_atone_text.x = self.x
	self.you_must_atone_text.y = self.x + 64
end

function Player:sacrificing()
	return self.state == STATE.KILL_MODE
end

function Player:must_atone()
	return self.state == STATE.DEAD and not self.is_on_altar
end

function Player:draw()
	BaseEntity.draw(self)
	if self.state == STATE.DEAD then
		love.graphics.draw(Player._dead_image, self.x, self.y)
		love.graphics.draw(
			Player._atone_spotlight,
			self.x - Player._spotlight_offset,
			self.y - Player._spotlight_offset
		)
	else
		love.graphics.draw(Player._alive_image, self.x, self.y)
	end
	if self:must_atone() then
		self.you_must_atone_text:draw()
	end
	if self.state == STATE.KILL_MODE then
		self.select_sacrific_text:draw()
		love.graphics.draw(Player._target_image, self.target_x, self.target_y)
		love.graphics.draw(Player._kill_spotlight, self.x - Player._spotlight_offset, self.y - Player._spotlight_offset)
	end
	if DEBUG then
		love.graphics.print(self.state, self.x - 10, self.y + 40)
	end
	if self:must_atone() then
	end
end
