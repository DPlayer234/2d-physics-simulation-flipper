--[[
This is a circular bumper
]]
local Bumper = heartbeat.class("Bumper", heartbeat.ECS.Entity)

-- Creates a new Bumper
function Bumper:new(radius)
	self:Entity()

	self._radius = radius
	self._power = 75

	self._drawRadius = radius
	self._bumpRadiusAdd = 1
	self._bumpRadiusDecrementRate = 6
end

-- Initializes the Bumper
function Bumper:initialize()
	self:addComponent(heartbeat.components.Rigidbody("static"))
	self:addComponent(heartbeat.components.Collider("Circle", self._radius))

	local renderer = self:addComponent(heartbeat.components.ShapeRenderer("fill", "circle", self._drawRadius))
	renderer:setColor(heartbeat.Color(0.9, 0.2, 0.1))

	-- Set a tag
	self:tagAs("Bumper")
end

-- Called when a collision occurs
function Bumper:onCollisionBegin(collision)
	local otherRigidbody = collision.otherCollider:getRigidbody()

	local point, otherPoint = collision:getPoints()
	if otherPoint then
		-- Average out the points if there are two
		point = (point + otherPoint) * 0.5
	end

	-- Apply an impulse in the collision's normal direction at the collision point
	otherRigidbody:applyImpulse(collision:getNormal() * self._power, point)

	self._drawRadius = self._radius + self._bumpRadiusAdd
end

-- Updates the bumper
function Bumper:update()
	-- Reduce the draw radius if larger than the collision radius
	self._drawRadius = math.max(self._radius, self._drawRadius - self.ecs.deltaTime * self._bumpRadiusDecrementRate)
end

-- Updates the bumper after the physics update
function Bumper:postUpdate()
	self:getComponent("ShapeRenderer"):setShape("circle", self._drawRadius)
end

return Bumper
