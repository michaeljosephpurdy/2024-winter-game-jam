Player = class("Player", BaseEntity)
Player:include(Collides)
local image = love.graphics.newImage("assets/player.png")

function Player:initialize(props)
	BaseEntity.initialize(self, props)
	self.dx = 0
	self.dy = 0
	self.released_keys = {}
	self.lives = 3
	self.image = image
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
			self.dx = -1
		end
		if key == "right" or key == "d" then
			self.dx = 1
		end
		if key == "up" or key == "w" then
			self.dy = -1
		end
		if key == "down" or key == "s" then
			self.dy = 1
		end
	end
end

function Player:update(dt)
	BaseEntity.update(self, dt)
	self:input()
	self:move(self.dx, self.dy)
end

function Player:draw()
	BaseEntity.draw(self)
	love.graphics.draw(self.image, self.x, self.y)
end
