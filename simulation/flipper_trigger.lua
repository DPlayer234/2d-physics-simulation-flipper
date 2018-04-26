--[[
This is a flipper's trigger volume
]]
local Vector2 = heartbeat.Vector2

local FlipperTrigger = heartbeat.class("FlipperTrigger", heartbeat.ECS.Entity)

-- Creates a new FlipperTrigger
-- flipper: The flipper this should trigger
-- size: (Vector2) The dimensions of the trigger volume
function FlipperTrigger:new(flipper, size)
	self:Entity()

	self._flipper = flipper
	self._size = size
end

-- Initializes the FlipperTrigger
function FlipperTrigger:initialize()
	self:addComponent(heartbeat.components.Rigidbody("static"))

	local collider = self:addComponent(heartbeat.components.Collider("Rectangle", self._size))
	collider:setSensor(true)

	-- Set a tag
	self:tagAs("FlipperTrigger")
end

-- Triggered when something enters the sensor
function FlipperTrigger:onSensorBegin(collision)
	if collision.otherCollider.entity:isTagged("Ball") then
		self._flipper:triggerMe()
	end
end

return FlipperTrigger
