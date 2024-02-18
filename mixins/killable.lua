Killable = {}
Killable.is_killable = true
function Killable:kill()
	self.state = "DEAD"
end
