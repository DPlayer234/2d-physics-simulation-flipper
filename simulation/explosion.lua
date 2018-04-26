--[[
The Explosion effect
]]
local Vector2 = heartbeat.Vector2

local Explosion = heartbeat.class("Explosion", heartbeat.ECS.Entity)

local MAX_ACTIVE_TIME = 0.1

-- Creates a new explosion. Immediately deactivates itself.
-- bomb: The bomb that triggers this explosion.
function Explosion:new(bomb)
	self:Entity()

	self._bomb = bomb
	self._activeFor = 0
	self:setActive(false)

	-- Variables for the explosion itself
	self._range = 15
	self._power = 25
end

-- Initializes the Explosion
function Explosion:initialize()
	local circleRenderer = self:addComponent(heartbeat.components.ShapeRenderer("fill", "circle", self._range))
	circleRenderer:setColor(heartbeat.Color.yellow)
end

-- Updates the explosion and deactives it once the time runs out
function Explosion:update()
	self._activeFor = self._activeFor - self.ecs.deltaTime
	self:getComponent("ShapeRenderer"):setShape("circle", (MAX_ACTIVE_TIME - self._activeFor) / MAX_ACTIVE_TIME * self._range)

	if self._activeFor < 0 then
		self:setActive(false)
	end
end

-- Causes an explosion and temporarily actives this entity
-- refFixture: The fixture to get the distance from to the other entities.
function Explosion:explode(refFixture)
	self.transform:setPosition(self._bomb.transform:getPosition())

	self._activeFor = MAX_ACTIVE_TIME
	self:setActive(true)

	-- Get all entities
	local entities = self.ecs:findEntitiesByType("Entity")

	-- Iterate over all entitites
	for i=1, #entities do
		self:_explodeEntity(refFixture, entities[i])
	end
end

-- Explodes a single entity
-- refFixture: The fixture to get the distance from to the other entities.
-- entity: The entity to apply the impulse to.
function Explosion:_explodeEntity(refFixture, entity)
	-- Do not explode yourself or the bomb entity
	if entity == self or entity == self._bomb then return end

	local rigidbody = entity:getComponent("Rigidbody")

	-- Ignore if there is no rigidbody
	if rigidbody == nil then return end

	local colliders = entity:getComponents("Collider")

	for i=1, #colliders do
		-- Iterate over colliders, get distances and closest points
		local fixture = colliders[i]:getLFixture()
		local distance, x1, y1, x2, y2 = love.physics.getDistance(refFixture, fixture)

		if distance < self._range then
			-- Impulse if in range
			local normal = ((x1 == x2 and y1 == y2) and
				(entity.transform:getPosition() - self.transform:getPosition()) or
				Vector2(x2 - x1, y2 - y1))

			if normal ~= Vector2.zero then
				rigidbody:applyImpulse(
					self._power * (self._range - distance) * normal:getNormalized(),
					Vector2(x2, y2))
			end
		end
	end
end

return Explosion
