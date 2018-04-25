--[[
The Ball(s) in the machine
]]
local Ball = heartbeat.class("Ball", heartbeat.ECS.Entity)

local BALL_RADIUS = 1

-- Initializes the Ball
function Ball:initialize()
	-- Add a Rigidbody and Collider
	local rigidbody = self:addComponent(heartbeat.components.Rigidbody("dynamic"))
	rigidbody:setMaterial(heartbeat.Material() {
		friction = 0.15,
		bounciness = 0.2
	})
	rigidbody:setBullet(true)

	self:addComponent(heartbeat.components.Collider("Circle", BALL_RADIUS))

	-- Adds a renderer
	local circleRenderer = self:addComponent(heartbeat.components.ShapeRenderer("fill", "circle", BALL_RADIUS))
	circleRenderer:setColor(heartbeat.Color.white)

	local boxRenderer = self:addComponent(heartbeat.components.ShapeRenderer("fill", "rectangle", heartbeat.Vector2(BALL_RADIUS, BALL_RADIUS)))
	boxRenderer:setColor(heartbeat.Color.black)

	-- Add some tags
	self:tagAs("Ball")
	self:tagAs("BombTrigger")
end

return Ball
