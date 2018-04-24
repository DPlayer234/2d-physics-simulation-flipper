--[[
This will allow quiting the game via escape
]]
local FinishManager = heartbeat.class("FinishManager", heartbeat.ECS.Entity)

-- Initializes the FinishManager
function FinishManager:initialize()
	local input = heartbeat.input.KeyboardInput({})

	input:bindKey("escape", "quit")

	input:bindDownEvent("quit", function()
		love.event.quit()
	end)

	self:registerInput(input)
end

return FinishManager
