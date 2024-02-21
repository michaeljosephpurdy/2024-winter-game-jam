GameState = class("GameState")

function GameState:initialize()
	self.offerings = 0
	self.progress = {}
end

function GameState:transition(new_scene)
	MemoryPrinter:log("GameState:transition - before")
	self.current_scene = new_scene
	collectgarbage("collect")
	MemoryPrinter:log("GameState:transition -  after")
	self:calculate_offerings()
end

function GameState:save_progress(level_id, data)
	self.progress[level_id] = {
		played = true,
	}
	for k, v in pairs(data) do
		self.progress[level_id][k] = v
	end
	self:calculate_offerings()
end

function GameState:calculate_offerings()
	self.offerings = 0
	for level_id, progress in pairs(self.progress) do
		print(level_id)
		print(progress.offerings)
		self.offerings = self.offerings + progress.offerings
	end
	PubSub.publish("calculated_offerings")
end

function GameState:is_completed(level_id)
	local progress = self.progress[level_id]
	print("level_id " .. level_id .. " progress " .. tostring(progress))
	return progress and progress.played
end

function GameState:draw()
	love.graphics.push()
	love.graphics.origin()
	love.graphics.setColor(0, 0, 0)
	if self.offerings > 0 then
		love.graphics.print("offerings: " .. self.offerings, 20, 20)
	end
	love.graphics.pop()
end
