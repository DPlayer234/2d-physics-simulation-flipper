--[[
This is an endless bomb, that launches anything tagged as a BombTrigger
]]
local Color = heartbeat.Color
local Vector2 = heartbeat.Vector2

local Explosion = require(miscMod.getModule(..., false) .. ".explosion")

local Bomb = heartbeat.class("Bomb", heartbeat.ECS.Entity)

local BOMB_RADIUS = 1.25

-- Creates a new Bomb
function Bomb:new()
	self:Entity()

	self._ticking = false

	-- Set the timer
	self._maxTime = 1
	self._time = -self._maxTime
end

-- Initializes a Bomb
function Bomb:initialize()
	-- Rigidbody and collider
	local rigidbody = self:addComponent(heartbeat.components.Rigidbody("dynamic"))
	rigidbody:setMaterial(heartbeat.Material() {
		bounciness = 0.05,
		friction = 0.6
	})

	self:addComponent(heartbeat.components.Collider("Circle", BOMB_RADIUS))

	-- Adds a renderer
	local circleRenderer = self:addComponent(heartbeat.components.ShapeRenderer("fill", "circle", BOMB_RADIUS))
	circleRenderer:setColor(Color.black)

	self._explosion = self.ecs:addEntity(Explosion(self))

	-- Bombs can trigger each other
	self:tagAs("BombTrigger")
end

-- Calle when something collides with the bomb
function Bomb:onCollisionStay(collision)
	if collision.otherCollider.entity:isTagged("BombTrigger") and not self._ticking and self._time < -self._maxTime then
		self._time = self._maxTime
		self._ticking = true
	end
end

-- Updates the bomb once a frame
function Bomb:update()
	self._time = self._time - self.ecs.deltaTime

	local renderer = self:getComponent("ShapeRenderer")

	-- Explode if it is ticking and the time has dropped low
	if self._ticking and self._time < 0 then
		self:explode()
		self._ticking = false

		renderer:setColor(Color.black)
	elseif self._ticking then
		renderer:setColor(renderer:getColor() == Color.black and Color.white or Color.black)
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
	self._explosion:explode(self:getComponent("Collider"):getLFixture())
end

return Bomb
