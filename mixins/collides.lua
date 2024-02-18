Collides = {}

function Collides:collides_on_grid(other)
	return self.x == other.x and self.y == other.y
end
