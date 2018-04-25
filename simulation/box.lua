--[[
The Box(es) in the machine
]]
local Vector2 = heartbeat.Vector2

local Box = heartbeat.class("Box", heartbeat.ECS.Entity)

local BOX_SIZE = Vector2(2, 2)

-- Initializes the Ball
function Box:initialize()
	-- Add a rigidbody and collider
	local rigidbody = self:addComponent(heartbeat.components.Rigidbody("dynamic"))
	rigidbody:setMaterial(heartbeat.Material() {
		friction = 0.0,
		bounciness = 0.1
	})
	rigidbody:setBullet(true)

	self:addComponent(heartbeat.components.Collider("Rectangle", BOX_SIZE))

	-- Add a renderer
	local boxRenderer = self:addComponent(heartbeat.components.ShapeRenderer("fill", "rectangle", BOX_SIZE))
	boxRenderer:setColor(heartbeat.Color.fromBrightness(0.6))

	-- Some tags for identification
	self:tagAs("Box")
	self:tagAs("BombTrigger")
end

return Box
