--[[
The static object serving as the static surroundings
]]
local Vector2 = heartbeat.Vector2
local ImageCollider = heartbeat.components.ImageCollider
local ShapeRenderer = heartbeat.components.ShapeRenderer
local ImageColliderRenderer = heartbeat.components.ImageColliderRenderer

local Machine = heartbeat.class("Machine", heartbeat.ECS.Entity)

-- Initializes the Machine
function Machine:initialize()
	-- Add a rigidbody
	local rigidbody = self:addComponent(heartbeat.components.Rigidbody("static"))
	rigidbody:setMaterial(heartbeat.Material() {
		friction = 1,
		bounciness = 0
	})

	-- Add two colliders based off of images
	local outside = self:addComponent(ImageCollider(love.image.newImageData("assets/collider/flipper_main.png"), Vector2.zero, Vector2.one))
	local inside  = self:addComponent(ImageCollider(love.image.newImageData("assets/collider/flipper_sub.png"), Vector2.zero, Vector2.one))

	-- Add the Renderers
	local mainColor = heartbeat.Color(0.3, 0.5, 0.8)
	local subColor = heartbeat.Color(0.0, 0.2, 0.4)

	local renderer = self:addComponent(ShapeRenderer("fill", "rectangle", Vector2(40, 64)))
	renderer:setColor(mainColor)
	renderer:setCenter(Vector2.zero)

	self:addComponent(ImageColliderRenderer("fill", outside)):setColor(subColor)
	self:addComponent(ImageColliderRenderer("fill", inside)):setColor(mainColor)

	-- Tag appropriately
	self:tagAs("Machine")
end

return Machine
