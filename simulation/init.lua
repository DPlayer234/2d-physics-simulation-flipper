--[[
This script initializes and sets up the simulation
]]
local currentModule = miscMod.getModule(..., true)

local gameState = heartbeat.GameState()
local Vector2 = heartbeat.Vector2
local Vector3 = heartbeat.Vector3

local Bumper = require(currentModule .. ".bumper")
local ExplosionTrigger = require(currentModule .. ".explosion_trigger")
local FinishManager = require(currentModule .. ".finish_manager")
local Flipper = require(currentModule .. ".flipper")

-- This is called once added
gameState.initialize = function(self)
	-- This is the main collider for the shape of the machine
	local machine = self.ecs:addEntity(heartbeat.ECS.Entity())
	do
		machine:addComponent(heartbeat.components.Rigidbody("static"))

		machine:addComponent(heartbeat.components.ImageCollider(love.image.newImageData("assets/collider/flipper_main.png"), Vector2.zero, Vector2.one))
		machine:addComponent(heartbeat.components.ImageCollider(love.image.newImageData("assets/collider/flipper_sub.png"), Vector2.zero, Vector2.one))
	end

	-- This adds the ball itself
	local ball = self.ecs:addEntity(heartbeat.ECS.Entity())
	do
		local rigidbody = ball:addComponent(heartbeat.components.Rigidbody("dynamic"))
		rigidbody:setMaterial(heartbeat.Material() {
			friction = 0.15,
			bounciness = 0.2
		})
		rigidbody:setVelocity(Vector2(0, -100))
		rigidbody:setBullet(true)

		ball:addComponent(heartbeat.components.Collider("Circle", 1))

		ball.transform:setPosition(Vector2(35.5, 55))

		ball:tagAs("Ball")
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

		-- Third component is ignored
		bumper.transform:setPosition(v)
	end
end

gameState.transformation:scale(10)

return gameState
