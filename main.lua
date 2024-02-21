love.graphics.setDefaultFilter("nearest", "nearest")
require("plugins.memory-printer")
class = require("plugins.middleclass")
push = require("plugins.push")
ldtk = require("plugins.super-simple-ldtk")
require("systems.game-state")
require("systems.screen-transition")
require("systems.camera")
require("mixins.reacts")
require("mixins.collides")
require("mixins.killable")
require("mixins.rewindable")
require("plugins.pubsub")
require("plugins.super-simple-ldtk")
require("entities.base")
require("scenes.base")
require("scenes.puzzle")
require("entities.collider")
require("entities.cross")
require("entities.player")
require("entities.image")
require("entities.box")
require("entities.exit")
require("entities.animal")
require("entities.altar")
require("entities.fence")
require("entities.text")
require("entities.rock")

GAME_WIDTH = 320
GAME_HEIGHT = 320
DEBUG = false
--DEBUG_LEVEL = "Level_2_2"

function love.load()
	local windowWidth, windowHeight = love.window.getDesktopDimensions()
	push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, {
		fullscreen = false,
		resizable = true,
	})
	push:resize(windowWidth, windowHeight)
	ldtk:init("world")
	push:setBorderColor(love.math.colorFromBytes(115, 239, 247))
	push:setBorderColor(love.math.colorFromBytes(26, 28, 44))
	GAME_STATE = GameState:new()
	ScreneTransitionSingleton = ScreenTransition:new()
	if DEBUG_LEVEL then
		GAME_STATE:transition(PuzzleScene:new(DEBUG_LEVEL))
	else
		GAME_STATE:transition(PuzzleScene:new("Tutorial_0"))
	end
end

function love.update(dt)
	GAME_STATE.current_scene:update(dt)
end

function love.draw()
	push:start()
	GAME_STATE.current_scene:draw()
	GAME_STATE:draw()
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

function transition(new_scene) end
