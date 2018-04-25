--[[
This is a flipper.
It adds its trigger-volumes itself.
]]
local Vector2 = heartbeat.Vector2

local FlipperTrigger = require(miscMod.getModule(..., false) .. ".flipper_trigger")

local Flipper = heartbeat.class("Flipper", heartbeat.ECS.Entity)

local FLIPPER_SIZE = Vector2(12, 1)

-- Creates a new flipper
-- Pivot is the rotation point in world space
function Flipper:new(pivot)
	self:Entity()

	self._pivot = pivot
end

-- Initializes the flipper
function Flipper:initialize()
	-- Find the machine
	self._main = assert(self.ecs:findEntityByTag("Machine"), "There is no machine.")

	-- Create and attach a Rigidbody
	local rigidbody = self:addComponent(heartbeat.components.Rigidbody("dynamic"))
	rigidbody:setMass(100)
	rigidbody:setMaterial(heartbeat.Material() {
		friction = 0.0,
		bounciness = 0.4
	})

	self:addComponent(heartbeat.components.Collider("Rectangle", FLIPPER_SIZE))

	self:_addJoint()
	self:_addTriggers()
	self:_addRenderers()

	-- Set a tag
	self:tagAs("Flipper")
end

-- Called when something collides with the flipper
function Flipper:onCollisionBegin(collision)
	if collision.otherCollider.entity == self._main and math.abs(self.transform:getAngle()) < 0.2 * math.pi then
		-- This is supposed to be called when the flipper hits the bottom of the machine so it doesn't bounce of it
		collision:setBounciness(0)
	end
end

-- Updates the flipper once a frame
function Flipper:update()
	local rigidbody = self:getComponent("Rigidbody")
	if self.transform:getPosition().x < self._pivot.x then
		rigidbody:applyForce(Vector2(-50, 0))
	else
		rigidbody:applyForce(Vector2(50, 0))
	end
end

-- This is called by the flipper's trigger to move it
function Flipper:triggerMe()
	-- Setting the velocity is more consistent than adding an impulse
	self:getComponent("Rigidbody"):setVelocity(Vector2(0, -50))
end

-- Adds the trigger volumes
function Flipper:_addTriggers()
	-- Add the trigger volumes
	self._triggerHigh = self.ecs:addEntity(FlipperTrigger(self, Vector2(13, 5)))
	self._triggerHigh.transform:setPosition(self.transform:getPosition() + Vector2(0, 2))

	self._triggerLow = self.ecs:addEntity(FlipperTrigger(self, Vector2(14, 2)))
	self._triggerLow.transform:setPosition(self.transform:getPosition() + Vector2(0, 4))
end

-- Add a joint to rotate around
function Flipper:_addJoint()
	local myJoint = self:addComponent(heartbeat.components.Joint("Revolute"))
	myJoint:setAnchor(self._pivot)

	local otherJoint = self._main:addComponent(heartbeat.components.Joint("Revolute"))
	myJoint:connect(otherJoint, true)
end

function Flipper:_addRenderers()
	-- Attach Renderers
	local renderer = self:addComponent(heartbeat.components.ShapeRenderer("fill", "rectangle", FLIPPER_SIZE))
	renderer:setColor(heartbeat.Color(0.2, 0.5, 1))

	local jointRenderer = self:addComponent(heartbeat.components.ShapeRenderer("fill", "circle", 1))
	jointRenderer:setColor(heartbeat.Color(0.6, 1, 0.2))
	jointRenderer:setCenter(self.transform:getPosition() - self._pivot)
end

return Flipper
