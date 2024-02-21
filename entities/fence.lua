Fence = class("Fence", BaseEntity)
Fence.static._closed_image = love.graphics.newImage("assets/fence-closed.png")
Fence.static._open_image = love.graphics.newImage("assets/fence-open.png")

function Fence:initialize(props)
	BaseEntity.initialize(self, props)
	PubSub.subscribe("calculated_offerings", function()
		self.closed = self.open > GAME_STATE.offerings
		self.is_passable = not self.closed
		self.is_solid = self.closed
		local text = GAME_STATE.offerings .. "/" .. self.open
		self.text = Text:new({ text = text, x = self.x, y = self.y })
	end)
end

function Fence:update() end

function Fence:draw()
	if self.closed then
		love.graphics.draw(Fence._closed_image, self.x, self.y)
		self.text:draw()
	else
		love.graphics.draw(Fence._open_image, self.x, self.y)
	end
end
