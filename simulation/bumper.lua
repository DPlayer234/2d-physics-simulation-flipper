--[[
This is a circular bumper
]]
local Bumper = heartbeat.class("Bumper", heartbeat.ECS.Entity)

-- Creates a new Bumper
function Bumper:new(radius)
	self:Entity()

	self._radius = radius
end

-- Initializes the Bumper
function Bumper:initialize()
	self:addComponent(heartbeat.components.Rigidbody("static"))

	self:addComponent(heartbeat.components.Collider("Circle", self._radius))

	-- Set a tag
	self:tagAs("Bumper")
end

function Bumper:onCollisionBegin(collision)
	collision:setFriction(1)
	collision:setBounciness(1.5)
end

return Bumper
