PuzzleScene = class("PuzzleScene", BaseScene)

local STATE = {
	IN_PROGRESS = "IN_PROGRESS",
	OVER = "OVER",
}
function PuzzleScene:initialize(level_id, from)
	BaseScene.initialize(self)
	self.level_id = level_id
	self.from = from
	self.try_again_text = Text:new({ text = "Atone for your\nsins", x = GAME_WIDTH / 2, y = GAME_HEIGHT / 2 })
	self.won_text = Text:new({ text = "", x = GAME_WIDTH / 2, y = GAME_HEIGHT / 2 })
	self.is_overworld = level_id == "Overworld"
	self.camera = Camera:new()
	self.tiles = {}
	self.upper_layer = {}
	self.altars = {}
	self.crosses = {}
	self.current_turn = 0
	self.sacrifices = 0
	function on_image(payload)
		self.bg = Image:new(payload)
	end
	function on_tile(payload)
		if payload.value == "1" then
			return
		end
		table.insert(self.entities, Collider:new({ x = payload.x, y = payload.y }))
	end
	function on_entity(payload)
		payload.parent = self
		if payload.id == "Player_Spawn" then
			self.player = Player:new(payload)
			table.insert(self.entities, self.player)
		elseif payload.id == "Rock" then
			table.insert(self.entities, Rock:new(payload))
		elseif payload.id == "Animal" then
			table.insert(self.entities, Animal:new(payload))
		elseif payload.id == "Altar" then
			local altar = Altar:new(payload)
			table.insert(self.altars, altar)
		elseif payload.id == "Box" then
			table.insert(self.entities, Box:new(payload))
		elseif payload.id == "Cross" then
			local cross = Cross:new(payload)
			table.insert(self.entities, cross)
			print("cross " .. cross.to_level)
			print("cross x: " .. cross.x .. " y: " .. cross.y)
			if from and from == cross.to_level then
				print("found player position " .. cross.x .. ", " .. cross.y)
				self.player_start = { x = cross.x, y = cross.y }
			end
			table.insert(self.crosses, cross)
		elseif payload.id == "Text" then
			table.insert(self.upper_layer, Text:new(payload))
		elseif payload.id == "Fence" then
			local fence = Fence:new(payload)
			table.insert(self.entities, fence)
			table.insert(self.upper_layer, fence)
		elseif payload.id == "Exit" then
			self.exit = Exit:new(payload)
		end
	end
	local level = ldtk:load(level_id, on_image, on_tile, on_entity)
	self.no_killing = level.no_killing
	PubSub.subscribe("keyrelease", function(key)
		if #self.crosses > 0 and (key == "x" or key == "l") then
			for _, cross in pairs(self.crosses) do
				if cross.x == self.player.x and cross.y == self.player.y and cross:can_enter() then
					PubSub:purge()
					GAME_STATE:transition(PuzzleScene:new(cross.to_level, level_id))
					return
				end
			end
		end
		-- restart the level?
		if not self.no_killing and key == "enter" then
			PubSub:purge()
			GAME_STATE:transition(PuzzleScene:new(level_id, from))
			return
		end
	end)
	if self.player_start and self.player then
		self.player.x = self.player_start.x
		self.player.y = self.player_start.y
	end
	self.player.no_killing = self.no_killing
	print("player x: " .. self.player.x .. " y: " .. self.player.y)
	print("#entities: " .. #self.entities)
	self.camera:update(self.player, 0)
	GAME_STATE:set_steps(self.current_turn)
	self.fade_in = 1
end

function PuzzleScene:on_each_entity(fn)
	for i, entity in ipairs(self.entities) do
		fn(entity)
	end
end

function PuzzleScene:rewind()
	self.current_turn = self.current_turn - 1
	if self.current_turn < 0 then
		self.current_turn = 0
	end
	self:on_each_entity(function(entity)
		if entity.rewind then
			entity:rewind(self.current_turn)
		end
	end)
	GAME_STATE:set_steps(self.current_turn)
end

function PuzzleScene:tick()
	-- save the current turn
	-- then advance
	self:on_each_entity(function(entity)
		if entity.save and entity.dump_state then
			entity:save(self.current_turn, entity:dump_state())
		end
	end)
	self.current_turn = self.current_turn + 1
	GAME_STATE:set_steps(self.current_turn)
end

function PuzzleScene:update(dt)
	-- fade into the scene at start up
	self.fade_in = self.fade_in - dt
	if self.fade_in < 0 then
		self.fade_in = 0
	end
	-- if we are transi
	if self.transition_coroutine then
		coroutine.resume(self.transition_coroutine, dt)
		return
	end
	BaseScene.update(self)
	self.sacrifices = 0
	for _, entity in pairs(self.entities) do
		entity:update()
	end
	for _, altar in pairs(self.altars) do
		for _, entity in pairs(self.entities) do
			if altar.x == entity.x and altar.y == entity.y then
				self.player.is_on_altar = true
				if entity.is_dead and entity:is_dead() then
					self.sacrifices = self.sacrifices + 1
				end
			end
		end
	end
	if self.exit and not self.no_killing and self.sacrifices == #self.altars then
		self.state = STATE.OVER
		self.transition_coroutine = coroutine.create(function(elapsed)
			local time = 2
			while time > 0 do
				time = time - elapsed
				print("yielding: " .. tostring(time))
				coroutine.yield()
			end
			GAME_STATE:save_progress(self.level_id, {
				offerings = self.sacrifices,
			})
			PubSub:purge()
			GAME_STATE:transition(PuzzleScene:new(self.exit.next_level, self.level_id))
		end)
	end
	self.camera:update(self.player, dt)
end

function PuzzleScene:all_sacrifices_made()
	return self.state == STATE.OVER
end

function PuzzleScene:draw()
	BaseScene.draw(self)
	self.camera:apply()
	self.bg:draw()
	for _, altar in pairs(self.altars) do
		altar:draw()
	end
	for _, entity in pairs(self.entities) do
		entity:draw()
	end
	for _, entity in pairs(self.upper_layer) do
		entity:draw()
	end
	self.player:draw()
	if self.fade_in > 0 then
		love.graphics.push()
		love.graphics.origin()
		local r = 26 / 255
		local g = 28 / 255
		local b = 44 / 255
		love.graphics.setColor(r, g, b, self.fade_in)
		love.graphics.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
		love.graphics.pop()
	end
end
