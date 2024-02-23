Player = class("Player", BaseEntity)
Player.static._alive_image = love.graphics.newImage("assets/player-alive.png")
Player.static._dead_image = love.graphics.newImage("assets/player-dead.png")
Player.static._target_image = love.graphics.newImage("assets/target.png")
Player.static._kill_spotlight = love.graphics.newImage("assets/spotlight-kill.png")
Player.static._dead_spotlight = love.graphics.newImage("assets/spotlight-dead.png")
Player.static._atone_spotlight = love.graphics.newImage("assets/spotlight-atone.png")
Player.static._move_sfx = Sfx:new("assets/move.wav")
Player.static._rewind_sfx = Player.static._move_sfx
Player.static._sacrifice_sfx = Sfx:new("assets/sacrifice.wav")
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
						Player._sacrifice_sfx:play()
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
				local rewound = self.parent:rewind()
				if rewound then
					Player._rewind_sfx:play()
				end
			end
		end
	end
end

function Player:update(dt)
	BaseEntity.update(self, dt)
	self:input()
	if self.dx == 0 and self.dy == 0 then
		-- didn't move
		return
	end
	self:move(self.dx, self.dy)
	if self.x == self.old_x and self.y == self.old_y then
		-- moved but was stopped
		return
	end
	Player._move_sfx:play()
	self.parent:tick()
end

function Player:sacrificing()
	return self.state == STATE.KILL_MODE
end

function Player:must_atone()
	return self.state == STATE.DEAD and (not self.is_on_altar or not self.parent:all_sacrifices_made())
end

function Player:draw()
	BaseEntity.draw(self)
	if self:must_atone() then
		love.graphics.draw(Player._dead_image, self.x, self.y)
		love.graphics.draw(
			Player._atone_spotlight,
			self.x - Player._spotlight_offset,
			self.y - Player._spotlight_offset
		)
	elseif self.state == STATE.DEAD then
		love.graphics.draw(Player._dead_image, self.x, self.y)
		love.graphics.draw(Player._dead_spotlight, self.x - Player._spotlight_offset, self.y - Player._spotlight_offset)
	else
		love.graphics.draw(Player._alive_image, self.x, self.y)
	end
	if self.state == STATE.KILL_MODE then
		love.graphics.draw(Player._target_image, self.target_x, self.target_y)
		love.graphics.draw(Player._kill_spotlight, self.x - Player._spotlight_offset, self.y - Player._spotlight_offset)
	end
	if DEBUG then
		love.graphics.print(self.state, self.x - 10, self.y + 40)
	end
end
