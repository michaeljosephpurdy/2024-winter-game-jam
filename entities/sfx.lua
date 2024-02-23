Sfx = class("Sfx")

function Sfx:initialize(source)
	self.is_audio = true
	self.one_shot = true
	self.source = love.audio.newSource(source, "static")
	self.source:setVolume(0.125)
end

function Sfx:play()
	love.audio.play(self.source)
end
