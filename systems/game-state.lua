GameState = class("GameState")

function GameState:initialize()
	self.offerings = 0
	self.progress = {}
end

function GameState:transition(new_scene)
	local old_scene = self.current_scene
	self.current_scene = new_scene
	old_scene = nil
	collectgarbage("collect")
	MemoryPrinter:log("GameState:transition")
end

function GameState:save_progress(level_id, data)
	if not self.progress[level_id] then
		self.progress[level_id] = {}
	end
	local progress = self.progress[level_id]
	progress.times_played = (progress.times_played or 0) + 1
	progress.offerings = data.offerings
	print("progress for " .. level_id)
	for k, v in pairs(progress) do
		print(k)
		print(v)
	end
	self:calculate_offerings()
end

function GameState:calculate_offerings()
	self.offerings = 0
	for level_id, progress in pairs(self.progress) do
		self.offerings = progress.offerings
	end
end

function GameState:draw()
	love.graphics.push()
	love.graphics.translate(0, 0)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("offerings: " .. self.offerings, 20, 20)
	love.graphics.pop()
end
