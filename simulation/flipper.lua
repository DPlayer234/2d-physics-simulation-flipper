--[[
This is a flipper.
It adds its trigger-volumes itself.
]]
local Vector2 = heartbeat.Vector2

local FlipperTrigger = require(miscMod.getModule(..., false) .. ".flipper_trigger")

local Flipper = heartbeat.class("Flipper", heartbeat.ECS.Entity)

-- Creates a new flipper
-- Main the is the main machine entity
-- Pivot is the rotation point in world space
function Flipper:new(main, pivot)
	self:Entity()

	self._main = main
	self._pivot = pivot
end

-- Initializes the flipper
function Flipper:initialize()
	local rigidbody = self:addComponent(heartbeat.components.Rigidbody("dynamic"))
	rigidbody:setMass(100)
	rigidbody:setMaterial(heartbeat.Material() {
		friction = 0.0,
		bounciness = 0.4
	})

	self:addComponent(heartbeat.components.Collider("Rectangle", Vector2(12, 1)))

	-- Add a joint to rotate around
	local myJoint = self:addComponent(heartbeat.components.Joint("Revolute"))
	myJoint:setAnchor(self._pivot)

	local otherJoint = self._main:addComponent(heartbeat.components.Joint("Revolute"))
	myJoint:connect(otherJoint, true)

	-- Add the trigger volumes
	self._triggerHigh = self.ecs:addEntity(FlipperTrigger(self, Vector2(13, 5)))
	self._triggerHigh.transform:setPosition(self.transform:getPosition() + Vector2(0, 2))

	self._triggerLow = self.ecs:addEntity(FlipperTrigger(self, Vector2(14, 2)))
	self._triggerLow.transform:setPosition(self.transform:getPosition() + Vector2(0, 4))

	-- Set a tag
	self:tagAs("Flipper")
end

function Flipper:onCollisionBegin(collision)
	if collision.otherCollider.entity == self._main and math.abs(self.transform:getAngle()) < 0.2 * math.pi then
		collision:setBounciness(0)
	end
end

-- This is called by the flipper's trigger to move it
function Flipper:triggerMe()
	-- Setting the velocity is more consistent than adding an impulse
	self:getComponent("Rigidbody"):setVelocity(Vector2(0, -50))
end

return Flipper
