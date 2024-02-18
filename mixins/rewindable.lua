Rewindable = {}
Rewindable.is_rewindable = true

function Rewindable:save(turn)
	if not self.turns then
		self.turns = {}
	end
	print("saving " .. turn)
	self.turns[turn] = self:dump_state()
end

function Rewindable:dump_state()
	return { x = self.old_x, y = self.old_y, state = self.state }
end

function Rewindable:rewind(turn)
	local state = self.turns[turn]
	if not state then
		print("failed to rewind " .. turn)
		return
	end
	print("rewinding " .. turn)
	for k, v in pairs(state) do
		self[k] = v
	end
end
