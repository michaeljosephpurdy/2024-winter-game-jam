Camera = class("Camera")

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function clamp(low, n, high)
	return math.min(math.max(n, low), high)
end

function Camera:initialize()
	self.levels = {}
	self.focal_point = 0
	self.position = { x = 0, y = 0 }
	self.old_position = { x = 0, y = 0 }
	self.offset_position = { x = -GAME_WIDTH / 2, y = -GAME_HEIGHT / 2 }
	PubSub.subscribe("ldtk.level.load", function(level)
		self.levels[level.level_id] = {
			left_boundary = level.x,
			right_boundary = level.xx,
			top_boundary = level.y,
			bot_boundary = level.yy,
			width = level.width,
			height = level.height,
		}
	end)
end

function Camera:update(e, dt)
	if not e.level_id then
		return
	end
	local level = self.levels[e.level_id]
	self.old_position.x = self.position.x
	self.old_position.y = self.position.y
	self.position.x = e.x + self.offset_position.x
	self.position.y = e.y + self.offset_position.y
	local camera_offset = 0
	self.position.x = self.position.x + camera_offset
	if e.x + camera_offset >= level.right_boundary - GAME_WIDTH / 2 then
		self.position.x = level.right_boundary - GAME_WIDTH
	elseif e.x + camera_offset <= level.left_boundary + GAME_WIDTH / 2 then
		self.position.x = level.left_boundary
	end
	self.position.x = lerp(self.old_position.x, self.position.x, 4 * dt)
	if e.y >= level.bot_boundary - GAME_HEIGHT / 2 then
		self.position.y = level.bot_boundary - GAME_HEIGHT
	elseif e.y <= level.top_boundary + GAME_HEIGHT / 2 then
		self.position.y = level.top_boundary
	end
	self.position.y = lerp(self.old_position.y, self.position.y, 25 * dt)
end

function Camera:apply()
	love.graphics.translate(-self.position.x, -self.position.y)
end
