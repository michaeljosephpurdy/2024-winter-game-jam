Image = class("Image", BaseEntity)

function Image:initialize(props)
	self.image = love.graphics.newImage(props.image)
	self.x, self.y = props.x, props.y
	self.width, self.height = self.image:getDimensions()
end

function Image:draw()
	love.graphics.draw(self.image, self.x, self.y)
end
