class = require("plugins/middleclass")
push = require("plugins.push")
ldtk = require("plugins.super-simple-ldtk")
require("systems.screen-transition")
require("systems.camera")
require("mixins.reacts")
require("mixins.collides")
require("plugins.pubsub")
require("plugins.super-simple-ldtk")
require("entities.base")
require("scenes.base")
require("scenes.puzzle")
require("entities.player")
require("entities.image")
require("entities.box")
require("entities.exit")

GAME_WIDTH = 640
GAME_HEIGHT = 640

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	local windowWidth, windowHeight = love.window.getDesktopDimensions()
	push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, { fullscreen = false, resizable = true })
	push:setBorderColor(love.math.colorFromBytes(0, 0, 0))
	ldtk:init("world")
	ScreneTransitionSingleton = ScreenTransition:new()
	current_scene = PuzzleScene:new("71c32692-b0a0-11ee-8b58-9544504138ba")
end

function love.update()
	current_scene:update()
	old_scene = current_scene
end

function love.draw()
	push:start()
	current_scene:draw()
	push:finish()
end

function love.keypressed(k)
	PubSub.publish("keypress", k)
end

function love.keyreleased(k)
	PubSub.publish("keyrelease", k)
end

function love.resize(w, h)
	push:resize(w, h)
end
