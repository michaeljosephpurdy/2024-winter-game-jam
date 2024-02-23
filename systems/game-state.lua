GameState = class("GameState")

function GameState:initialize()
	self.offerings = 0
	self.progress = {}
	self.r = 26 / 255
	self.g = 28 / 255
	self.b = 44 / 255
	self.steps_text = Text:new({ text = "steps:", x = 0, y = 270, left_align = true })
	self.offerings_text = Text:new({ text = "offerings:", x = 0, y = 290, left_align = true })
end

function GameState:transition(new_scene)
	MemoryPrinter:log("GameState:transition - before")
	self.current_scene = new_scene
	collectgarbage("collect")
	MemoryPrinter:log("GameState:transition -  after")
	self:calculate_offerings()
end

function GameState:set_steps(steps)
	self.steps = steps
	self.steps_text.text = "steps:" .. tostring(steps)
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
	self.offerings_text.text = "offerings:" .. tostring(self.offerings)
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
	love.graphics.setColor(self.r, self.g, self.b)
	if self.offerings > 0 then
		self.offerings_text:draw()
	end
	self.steps_text:draw()
	love.graphics.pop()
end
