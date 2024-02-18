PuzzleScene = class("PuzzleScene", BaseScene)

function PuzzleScene:initialize(level_id)
	BaseScene.initialize(self)
	self.current_turn = 1
	function on_image(payload)
		self.bg = Image:new(payload)
	end
	function on_tile(payload)
		--pass
	end
	function on_entity(payload)
		payload.parent = self
		if payload.id == "Player_Spawn" then
			self.player = Player:new(payload)
			table.insert(self.entities, self.player)
		elseif payload.id == "Animal" then
			table.insert(self.entities, Animal:new(payload))
		elseif payload.id == "Altar" then
			table.insert(self.entities, Altar:new(payload))
		elseif payload.id == "Box" then
			table.insert(self.entities, Box:new(payload))
		elseif payload.id == "Exit" then
			table.insert(self.entities, Exit:new(payload))
		end
	end
	ldtk:load(level_id, on_image, on_tile, on_entity)
end

function PuzzleScene:on_each_entity(fn)
	for i, entity in ipairs(self.entities) do
		fn(entity)
	end
end

function PuzzleScene:rewind()
	self.current_turn = self.current_turn - 1
	if self.current_turn < 1 then
		self.current_turn = 1
	end
	self:on_each_entity(function(entity)
		if entity.rewind then
			entity:rewind(self.current_turn)
		end
	end)
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
end

function PuzzleScene:update()
	-- pass
	BaseScene.update(self)
	for _, entity in pairs(self.entities) do
		entity:update()
	end
end

function PuzzleScene:draw()
	BaseScene.draw(self)
	self.bg:draw()
	for _, entity in pairs(self.entities) do
		entity:draw()
	end
	self.player:draw()
	love.graphics.print(self.current_turn, 40, 40)
end
