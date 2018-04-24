--[[
This makes an object a trigger, that causes an explosion force
]]
local ExplosionTrigger = heartbeat.class("ExplosionTrigger", heartbeat.ECS.Component)

-- The amount of time (in seconds) until the explosion is triggered after something entered
local MAX_TIME = 2

-- Initializes the explosion trigger
function ExplosionTrigger:initialize()
	local colliders = self.entity:getComponents("Collider")

	for i=1, #colliders do
		colliders[i]:setSensor(true)
	end

	self._activated = false
	self._timeLeft = 0
end

-- This is called when something enters the sensor area
function ExplosionTrigger:onSensorBegin(collision)
	if not self._activated and not collision.otherCollider:isSensor() then
		self._activated = true
		self._timeLeft = MAX_TIME
	end
end

-- Called after the physics update
function ExplosionTrigger:postUpdate()
	if self._activated then
		self._timeLeft = self._timeLeft - self.ecs.deltaTime

		if self._timeLeft < 0 then
			self._activated = false

			self:explode()
		end
	end
end

-- The explosion itself.
function ExplosionTrigger:explode()
	-- TODO
end

return ExplosionTrigger
