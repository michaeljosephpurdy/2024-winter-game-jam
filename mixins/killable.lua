Killable = {}

function Killable:kill()
	self.state = "DEAD"
end

function Killable:is_dead()
	return self.state == "DEAD"
end
