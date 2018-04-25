-- Load general files
require "r_redirect"

local physicsWorldDraw

-- Loads the game content
function love.load()
	do
		-- Creating the window
		local width, height = love.window.getDesktopDimensions()

		love.window.setMode(width*(2/3), height*(2/3), {
			fullscreen     = false,
			fullscreentype = "desktop",
			vsync          = true,
			resizable      = true,
			borderless     = false,
			minwidth       = 640,
			minheight      = 360,
			msaa           = 0
		})

		love.window.setIcon(love.image.newImageData("assets/textures/icon.png"))
	end

	-- Load and initialize the engine
	heartbeat = require "heartbeat"

	-- Load libraries
	ffi = require "ffi"

	miscMod = require "libs.misc_mod"
	sounds  = require "libs.sounds2"

	physicsWorldDraw = require "dev.physics_world_draw"

	-- Initialize and stuff
	heartbeat:initialize { meter = 2 }

	require "dev" --#exclude line

	local state = require "simulation"

	heartbeat:pushGameState(state)
end

-- Updates the game
function love.update(dt)
	heartbeat:update(dt)
	sounds.update(dt)
end

-- Draws the game
function love.draw()
	heartbeat:draw()

	if _arg.debug then
		local gameState = heartbeat:getActiveGameState()
		if gameState then
			physicsWorldDraw(gameState.world, 0, 0, love.graphics.getDimensions())
		end
	end
end
