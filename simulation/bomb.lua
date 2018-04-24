--[[
This is the endless bomb, that launches the ball
]]
local Vector2 = heartbeat.Vector2

local Bomb = heartbeat.class("Bomb", heartbeat.ECS.Entity)

-- Initializes a Bomb
function Bomb:initialize()
	self._ticking = false

	self._maxTime = 1
	self._time = -self._maxTime

	self._range = 20
	self._power = 40

	local rigidbody = self:addComponent(heartbeat.components.Rigidbody("dynamic"))
	rigidbody:setMaterial(heartbeat.Material() {
		bounciness = 0,
		friction = 0.8
	})

	self:addComponent(heartbeat.components.Collider("Circle", 1.25))
end

-- Calle when something collides with the bomb
function Bomb:onCollisionStay(collision)
	if not collision.otherCollider.entity:isTagged("Machine")
	and not self._ticking and self._time < -self._maxTime then
		self._time = self._maxTime
		self._ticking = true
	end
end

-- Updates the bomb once a frame
function Bomb:update()
	self._time = self._time - self.ecs.deltaTime

	if self._ticking and self._time < 0 then
		self:explode()
		self._ticking = false
	end
end

-- Updates the bomb once a frame after the physics simulation
function Bomb:postUpdate()
	if self._time < 0 and self._time > -self._maxTime then
		self.ecs.transformation:translate(Vector2(love.math.random(), love.math.random()))
	end
end

-- Call to cause an explosion
function Bomb:explode()
	-- Get own fixture
	local myFixture = self:getComponent("Collider"):getLFixture()

	-- Get all entities
	local entities = self.ecs:findEntitiesByType("Entity")

	-- Iterate over all entitites
	for _, v in ipairs(entities) do
		local rigidbody = v:getComponent("Rigidbody")

		if rigidbody ~= nil then
			-- Needs to have Rigidbody
			local colliders = v:getComponents("Collider")

			for i=1, #colliders do
				-- Iterate over colliders, get distances and closest points
				local fixture = colliders[i]:getLFixture()
				local distance, x1, y1, x2, y2 = love.physics.getDistance(myFixture, fixture)

				if distance < self._range then
					-- Impulse if in range
					local normal = ((x1 == x2 and y1 == y2) and
						(v.transform:getPosition() - self.transform:getPosition()) or
						Vector2(x2 - x1, y2 - y1))

					if normal ~= Vector2.zero then
						rigidbody:applyImpulse(
							self._power * (self._range - distance) * normal:getNormalized(),
							Vector2(x2, y2))
					end
				end
			end
		end
	end
end

return Bomb
