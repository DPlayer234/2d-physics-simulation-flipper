--[[
This script initializes and sets up the simulation
]]
local currentModule = miscMod.getModule(..., true)

local gameState = heartbeat.GameState()
local Vector2 = heartbeat.Vector2
local Vector3 = heartbeat.Vector3

local Bomb = require(currentModule .. ".bomb")
local Bumper = require(currentModule .. ".bumper")
local ExplosionTrigger = require(currentModule .. ".explosion_trigger")
local FinishManager = require(currentModule .. ".finish_manager")
local Flipper = require(currentModule .. ".flipper")

-- This is called once added
gameState.initialize = function(self)
	-- This is the main collider for the shape of the machine
	local machine = self.ecs:addEntity(heartbeat.ECS.Entity())
	do
		local rigidbody = machine:addComponent(heartbeat.components.Rigidbody("static"))
		rigidbody:setMaterial(heartbeat.Material() {
			friction = 1,
			bounciness = 0
		})

		machine:addComponent(heartbeat.components.ImageCollider(love.image.newImageData("assets/collider/flipper_main.png"), Vector2.zero, Vector2.one))
		machine:addComponent(heartbeat.components.ImageCollider(love.image.newImageData("assets/collider/flipper_sub.png"), Vector2.zero, Vector2.one))

		machine:tagAs("Machine")
	end

	-- This adds the ball itself
	local ball = self.ecs:addEntity(heartbeat.ECS.Entity())
	do
		local rigidbody = ball:addComponent(heartbeat.components.Rigidbody("dynamic"))
		rigidbody:setMaterial(heartbeat.Material() {
			friction = 0.15,
			bounciness = 0.2
		})
		rigidbody:setBullet(true)

		ball:addComponent(heartbeat.components.Collider("Circle", 1))

		ball.transform:setPosition(Vector2(35.5, 55))

		ball:tagAs("Ball")
	end

	-- This adds a box
	local box = self.ecs:addEntity(heartbeat.ECS.Entity())
	do
		local rigidbody = box:addComponent(heartbeat.components.Rigidbody("dynamic"))
		rigidbody:setMaterial(heartbeat.Material() {
			friction = 0.0,
			bounciness = 0.1
		})
		rigidbody:setBullet(true)

		box:addComponent(heartbeat.components.Collider("Rectangle", Vector2(1, 1.5)))

		box.transform:setPosition(Vector2(20, 30))

		box:tagAs("Box")
	end

	local bomb = self.ecs:addEntity(Bomb())
	do
		bomb.transform:setPosition(Vector2(35, 60))
	end

	-- Helps finishing the game
	self.ecs:addEntity(FinishManager())

	-- Add both flippers
	local flipperLeft = Flipper(machine, Vector2(2, 50))
	do
		flipperLeft.transform:setPosition(Vector2(8, 49.5))
		self.ecs:addEntity(flipperLeft)
	end

	local flipperRight = Flipper(machine, Vector2(32, 50))
	do
		flipperRight.transform:setPosition(Vector2(26, 49.5))
		self.ecs:addEntity(flipperRight)
	end

	-- Abuse the third component of a Vector3 as the rotation
	for _, v in ipairs {
		Vector3(6, 5, 3),
		Vector3(26, 10, 2),
		Vector3(32, 32, 1.5),
		Vector3(14, 28, 4),
	} do
		local bumper = self.ecs:addEntity(Bumper(v.z))

		-- Third component is ignored when used in place of Vector2
		bumper.transform:setPosition(v)
	end
end

gameState.draw = function(self)
	self.transformation:reset()
		:translate(Vector2(love.graphics.getWidth() * 0.5, 0))
		:scale(love.graphics.getHeight() / 64)
		:translate(Vector2(-20, 0))

	self.GameState.draw(gameState)
end

return gameState
