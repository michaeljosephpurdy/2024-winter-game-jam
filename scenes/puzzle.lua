PuzzleScene = class("PuzzleScene", BaseScene)

function PuzzleScene:initialize(level_id)
	self.entities = {}
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

function PuzzleScene:update()
	-- pass
	BaseScene.update(self)
	for _, entity in pairs(self.entities) do
		entity:update()
	end
end

function PuzzleScene:draw()
	-- pass
	BaseScene.draw(self)
	self.bg:draw()
	for _, entity in pairs(self.entities) do
		entity:draw()
	end
end
