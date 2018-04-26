--[[
This script initializes and sets up the simulation by defining a new GameState class.
]]
local currentModule = miscMod.getModule(..., true)

local Vector2 = heartbeat.Vector2
local Vector3 = heartbeat.Vector3

local Ball          = require(currentModule .. ".ball")
local Bomb          = require(currentModule .. ".bomb")
local Box           = require(currentModule .. ".box")
local Bumper        = require(currentModule .. ".bumper")
local FinishManager = require(currentModule .. ".finish_manager")
local Flipper       = require(currentModule .. ".flipper")
local Machine       = require(currentModule .. ".machine")

local Simulation = heartbeat.class("Simulation", heartbeat.GameState)

-- This is called once the GameState is pushed
function Simulation:initialize()
	-- Add the machine
	self.ecs:addEntity(Machine())

	-- Add a ball and set its position
	self.ecs:addEntity(Ball()).transform:setPosition(Vector2(35.5, 55))

	-- This adds a box
	self.ecs:addEntity(Box()).transform:setPosition(Vector2(20, 30))

	-- Add two bombs and set their positions
	self.ecs:addEntity(Bomb()).transform:setPosition(Vector2(35, 60))
	self.ecs:addEntity(Bomb()).transform:setPosition(Vector2(10, 16))

	-- Add both flippers
	do
		local flipperLeft = Flipper(Vector2(2, 50))
		flipperLeft.transform:setPosition(Vector2(8, 49.5))
		self.ecs:addEntity(flipperLeft)
	end

	do
		local flipperRight = Flipper(Vector2(32, 50))
		flipperRight.transform:setPosition(Vector2(26, 49.5))
		self.ecs:addEntity(flipperRight)
	end

	-- Add a couple bumpers
	-- Abuse the third component of a Vector3 as the rotation
	for _, v in ipairs {
		Vector3(6, 5, 3),
		Vector3(26, 10, 2),
		Vector3(32, 32, 1.5),
		Vector3(14, 28, 4),
	} do
		-- Third component is ignored when used in place of Vector2
		self.ecs:addEntity(Bumper(v.z)).transform:setPosition(v)
	end

	-- Helps finishing the game
	self.ecs:addEntity(FinishManager())
end

-- This is called once drawn.
function Simulation:draw()
	-- Add some screen transformations
	self.transformation:reset()
		:translate(Vector2(love.graphics.getWidth() * 0.5, 0))
		:scale(love.graphics.getHeight() / 64)
		:translate(Vector2(-20, 0))

	self.GameState.draw(self)
end

return Simulation
