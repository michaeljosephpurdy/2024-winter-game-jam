Rewindable = {}
Rewindable.is_rewindable = true

function Rewindable:save(turn)
	if not self.turns then
		self.turns = {}
	end
	self.turns[turn] = self:dump_state()
end

function Rewindable:dump_state()
	return { x = self.old_x, y = self.old_y, state = self.state }
end

function Rewindable:rewind(turn)
	if not self.turns then
		return
	end
	local state = self.turns[turn]
	if not state then
		print("failed to rewind " .. turn)
		return
	end
	for k, v in pairs(state) do
		self[k] = v
	end
	self.turns[turn] = nil
end
