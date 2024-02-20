BaseEntity = class("BaseEntity")

function BaseEntity:initialize(props)
	for k, v in pairs(props) do
		self[k] = v
	end
	self.w = 32
	self.h = 32
end

function BaseEntity:update(dt)
	self.old_x = self.x
	self.old_y = self.y
end

function BaseEntity:move(dx, dy, depth)
	depth = depth or 1
	self.x = self.x + dx * self.h
	self.y = self.y + dy * self.h
	self.new_x = self.x
	self.new_y = self.y
	if self.old_x == self.x and self.old_y == self.y then
		return false
	end
	-- if you collide with another entity, do these things:
	-- 1. rollback movement
	-- 2. check if other is solid, if it is, then stop
	-- 3. attempt to move other entity
	--    if they can move, then you can move and rollforward movement
	local moved = true
	self.is_on_altar = false
	self.parent:on_each_entity(function(other)
		if self == other then
			return
		end
		-- if we didnt collide with the entity then were fine
		if not self:collides_on_grid(other) then
			return
		end
		if other.is_passable then
			if other.is_altar then
				self.is_on_altar = true
			end
			return
		end
		-- we have a collision, so we need to rollback
		-- rollback
		self.x = self.old_x
		self.y = self.old_y
		if other.is_solid then
			moved = false
			return
		end
		-- some objects, like rocks, can only be pushed so hard
		if other.max_depth and other.max_depth < depth then
			moved = false
			return
		end
		if other.is_dead and other:is_dead() then
			moved = false
			return
		end
		if not other:move(dx, dy, depth + 1) then
			moved = false
		end
	end)
	-- we can rollforward if moved is true
	if moved then
		self.x = self.new_x
		self.y = self.new_y
	end
	return moved
end

function BaseEntity:draw()
	-- pass
end
