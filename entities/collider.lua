Collider = class("Collider", BaseEntity)

function Collider:initialize(props)
	BaseEntity.initialize(self, props)
	Collider.is_solid = true
end
